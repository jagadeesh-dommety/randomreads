using Microsoft.Azure.Cosmos;
using RandomReads.CosmosDB;

public class CosmosUser : CosmosDbClientBase<UserDb>
    {
        private readonly bool cosmosuser;

        public CosmosUser(CosmosDBConfig? cosmosDBConfig, ILogger logger, IConfiguration configuration) : base(cosmosDBConfig, logger, configuration)
        {
            ArgumentNullException.ThrowIfNull(cosmosDBConfig, nameof(cosmosDBConfig));
            cosmosuser = this.Initialize().Result;
        }

        public override PartitionKey GetPartionKeyFromDocument(UserDb document)
        {
            return new PartitionKey(document.Id);
        }
    }