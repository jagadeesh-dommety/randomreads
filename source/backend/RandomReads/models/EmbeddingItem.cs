using RandomReads.Models;

public record EmbeddingItem : CosmosItem
{
    public float[] Embeddings { get; set; }
    public Topic Topic { get; set; }
    public EmbeddingItem(string id, Topic topic, float[] embedding)
    {
        this.Id = id;
        this.Topic = topic;
        this.Embeddings = embedding;
    }
}