using OpenAI.Responses;

namespace RandomReads.service;
#pragma warning disable OPENAI001 // Type is for evaluation purposes only and is subject to change or removal in future updates. Suppress this diagnostic to proceed.

class ContentGenUtils
{
    // ---------------- Helper Methods ----------------

    public static string ExtractCuratorText(OpenAIResponse response)
    {
        var msgItems = response.OutputItems
            .OfType<MessageResponseItem>()
            .ToArray();

        if (msgItems.Length < 2)
            throw new Exception("Workflow returned fewer than 2 message stages. Expected researcher + curator.");

        var curatorItem = msgItems[1];

        string fullText = string.Concat(
            curatorItem.Content
                .Where(c => c.Kind == ResponseContentPartKind.OutputText)
                .Select(c => c.Text)
        );

        return fullText.Trim();
    }
    public static (string title, string content) ParseGeneratedContent(string text)
    {
        if (string.IsNullOrWhiteSpace(text))
            return ("", "");

        // Normalize line endings (\r\n or \r -> \n)
        text = text.Replace("\r\n", "\n").Replace("\r", "\n").Trim();

        string title = "";
        string content = "";

        // Case 1: Bold title format **Title**
        if (text.StartsWith("{"))
        {
            try
            {
                var jsonDoc = System.Text.Json.JsonDocument.Parse(text);
                var root = jsonDoc.RootElement;

                if (root.TryGetProperty("title", out var titleProp))
                {
                    title = titleProp.GetString() ?? "";
                }

                if (root.TryGetProperty("content", out var contentProp))
                {
                    content = contentProp.GetString() ?? "";
                }
            }
            catch (System.Text.Json.JsonException)
            {
                // If JSON parsing fails, fallback to default parsing
                throw new Exception("Error while generating content Failed to parse generated content as JSON.");
            }
        }
        // -----------------------------
    // 2️⃣ FALLBACK: MARKDOWN / TEXT
    // -----------------------------
    if (string.IsNullOrWhiteSpace(title) || string.IsNullOrWhiteSpace(content))
    {
        // **Bold Title**
        if (text.StartsWith("**"))
        {
            int end = text.IndexOf("**", 2);
            if (end > 2)
            {
                title = text.Substring(2, end - 2).Trim();
                content = text[(end + 2)..].Trim();
            }
        }
        else
        {
            var lines = text.Split('\n')
                            .Where(l => !string.IsNullOrWhiteSpace(l))
                            .ToArray();

            if (lines.Length > 1)
            {
                title = lines[0].Trim();
                content = string.Join("\n", lines.Skip(1)).Trim();
            }
        }
    }

        // Clean content paragraphs: remove extra spaces but keep paragraphs
        content = NormalizeParagraphs(content);

        return (title, content);
    }

    // ------------------------------
    // Make paragraphs clean and readable
    // ------------------------------
    public static string NormalizeParagraphs(string content)
    {
        if (string.IsNullOrWhiteSpace(content))
            return "";

        // Split paragraphs by empty lines
        var paragraphs = content
            .Split("\n\n", StringSplitOptions.None)
            .Select(p => p.Trim())
            .Where(p => !string.IsNullOrWhiteSpace(p));

        // Rejoin using EXACT two newlines (Flutter will show a blank line)
        return string.Join("\n\n", paragraphs);
    }
     
}
