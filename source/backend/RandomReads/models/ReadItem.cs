
using RandomReads.Models;

public record ReadItem : CosmosItem
{
    public readonly string Title;
    public readonly string Content;
    public double rand = new Random().Next(0,1);
    public string Author { get; set; } = "";
    public string Slug => ContentUtils.GenerateSlug(Title);
    public bool IsAiGenerated { get; set; } = true;
    public readonly Topic Topic;
    public readonly DateTime CreatedAt;
    public readonly DateTime UpdatedAt = DateTime.UtcNow;

    public ReadItem(
        string Id,
        string title,
        string content,
        Topic topic,
        DateTime createdAt)
    {
        this.Id = Id;
        Title = title;
        Content = content;
        Topic = topic;
        CreatedAt = createdAt;
    }
}
