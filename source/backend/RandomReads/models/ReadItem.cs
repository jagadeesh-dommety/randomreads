public record ReadItem : CosmosItem
{
    public readonly string Title;
    public readonly string Content;
    public string Author { get; set; } = "";
    public bool IsAiGenerated { get; set; } = true;
    public readonly string Topic;
    public readonly DateTime CreatedAt;
    public readonly DateTime UpdatedAt = DateTime.UtcNow;

    public ReadItem(
        string Id,
        string title,
        string content,
        string topic,
        DateTime createdAt)
    {
        this.Id = Id;
        Title = title;
        Content = content;
        Topic = topic;
        CreatedAt = createdAt;
    }
}
