using Microsoft.Azure.Cosmos;
using RandomReads.CosmosDB;

public class CosmosReadItem : CosmosDbClientBase<ReadItem>
    {
        private readonly bool cosmosReadItem;

        public CosmosReadItem(CosmosDBConfig? cosmosDBConfig, ILogger logger, IConfiguration configuration) : base(cosmosDBConfig, logger, configuration)
        {
            ArgumentNullException.ThrowIfNull(cosmosDBConfig, nameof(cosmosDBConfig));
            cosmosReadItem = this.Initialize().Result;
        }

        public override PartitionKey GetPartionKeyFromDocument(ReadItem document)
        {
            return new PartitionKey((int)document.Topic);
        }
    }