using Microsoft.Azure.Cosmos;

public class EmbeddingService
{
    
    private readonly CosmosEmbeddingItem _embeddingRepo;

    public EmbeddingService(CosmosEmbeddingItem embeddingRepo)
    {
        _embeddingRepo = embeddingRepo;
    }

    public async Task CreateEmbeddingIfNotSimilarAsync(ReadItem readItem, float[] embedding, double similarityThreshold = 0.80)
    {
        bool exists = await HasSimilarEmbeddingAsync(readItem, embedding, similarityThreshold);
        if (!exists)
        {
            EmbeddingItem embeddingItem = new EmbeddingItem(readItem.Id, readItem.Topic, embedding);
            await _embeddingRepo.CreateItemAsync(embeddingItem);
        }
        else
        {
            Console.WriteLine($"Similar embedding already exists for item id: {readItem.Id}, skipping.");
        }
    }

    public async Task<bool> HasSimilarEmbeddingAsync(
        ReadItem readItem,
        float[] queryEmbedding,
        double threshold = 0.80)
    {
        var query = new QueryDefinition(EmbeddingUtils.Query)
        .WithParameter("@topic", (int)readItem.Topic)
        .WithParameter("@queryEmbedding", queryEmbedding);

        var options = new QueryRequestOptions
        {
            PartitionKey = new PartitionKey((int)readItem.Topic),
            MaxItemCount = 5
        };

        var results = _embeddingRepo.Query<dynamic>(query, options);

        if (results == null || results.Count == 0)
            return false;

        foreach (var r in results)
        {
            double similarity = r.similarity;

            if (EmbeddingUtils.IsTooSimilar(similarity, threshold))
                return true;
        }

        return false;
    }
}

public static class EmbeddingUtils
{
    public const string Query = @"
            SELECT TOP 5 e,
                   VectorDistance(e.Embeddings, @queryEmbedding, false) AS similarity
            FROM e
            WHERE e.Topic = @topic
            ORDER BY VectorDistance(e.Embeddings, @queryEmbedding, false)
        ";
    // Cosmos returns distance, not similarity


    public static bool IsTooSimilar(double similarity, double threshold = 0.80)
        => similarity >= threshold;
}