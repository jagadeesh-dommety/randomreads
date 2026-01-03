using Microsoft.Azure.Cosmos;
using RandomReads.CosmosDB;

public class CosmosReadActivity : CosmosDbClientBase<ReadActivityDB>
{
    
    private readonly bool cosmosReadActivity;

    public CosmosReadActivity(CosmosDBConfig? cosmosDBConfig, ILogger logger) : base(cosmosDBConfig, logger)
    {
        ArgumentNullException.ThrowIfNull(cosmosDBConfig, nameof(cosmosDBConfig));
        cosmosReadActivity = this.Initialize().Result;
    }

    public override PartitionKey GetPartionKeyFromDocument(ReadActivityDB document)
    {
        return new PartitionKey((int)document.Topic);
    }
    
}
