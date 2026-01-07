using Microsoft.Azure.Cosmos;
using RandomReads.CosmosDB;

public class CosmosUserActivity : CosmosDbClientBase<UserActivityDB>
    {
        private readonly bool cosmosReadItem;

        public CosmosUserActivity(CosmosDBConfig? cosmosDBConfig, ILogger logger, IConfiguration configuration) : base(cosmosDBConfig, logger, configuration)
        {
            ArgumentNullException.ThrowIfNull(cosmosDBConfig, nameof(cosmosDBConfig));
            cosmosReadItem = this.Initialize().Result;
        }

        public override PartitionKey GetPartionKeyFromDocument(UserActivityDB document)
        {
            return new PartitionKey(document.userid);
        }
    }