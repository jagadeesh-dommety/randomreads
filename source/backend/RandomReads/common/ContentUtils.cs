public class ContentUtils
{
    public static string GenerateSlug(string title)
    {
        if (string.IsNullOrEmpty(title))
        {
            throw new ArgumentException("Title cannot be null or empty", nameof(title));
        }

        // Convert to lower case
        string slug = title.ToLowerInvariant();

        // Replace spaces with hyphens
        slug = System.Text.RegularExpressions.Regex.Replace(slug, @"\s+", "-");

        // Remove invalid characters
        slug = System.Text.RegularExpressions.Regex.Replace(slug, @"[^a-z0-9\-]", string.Empty);

        // Trim hyphens from start and end
        slug = slug.Trim('-');

        return slug;
    }
}