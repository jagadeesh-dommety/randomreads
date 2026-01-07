using Microsoft.Azure.Cosmos;
using RandomReads.CosmosDB;

public class CosmosEmbeddingItem : CosmosDbClientBase<EmbeddingItem>
{
    
    private readonly bool cosmosEmbeddingItem;

    public CosmosEmbeddingItem(CosmosDBConfig? cosmosDBConfig, ILogger logger, IConfiguration configuration) : base(cosmosDBConfig, logger, configuration)
    {
        ArgumentNullException.ThrowIfNull(cosmosDBConfig, nameof(cosmosDBConfig));
        cosmosEmbeddingItem = this.Initialize().Result;
    }

    public override PartitionKey GetPartionKeyFromDocument(EmbeddingItem document)
    {
        return new PartitionKey((int)document.Topic);
    }
    
}
