using RandomReads.Models;

public class ReadService
{
    private readonly CosmosReadItem _cosmosReadItem;
    private readonly CustomRequestContext customRequestContext;

    public ReadService(CosmosReadItem cosmosReadItem, CustomRequestContext customRequestContext)
    {
        _cosmosReadItem = cosmosReadItem;
        this.customRequestContext = customRequestContext;
    }

    public async Task<ReadItem> GetReadItemByIdAsync(string id, Topic topic)
    {
        try
        {
            var readItem = await _cosmosReadItem.ReadItemByDocumentIdAsync(id, new Microsoft.Azure.Cosmos.PartitionKey((int)topic));
            return readItem;
        }
        catch (Exception ex)
        {
            throw new Exception($"Error retrieving item from Cosmos DB: {ex.Message}", ex);
        }
    }

    public async Task<IEnumerable<ReadItem>> GetAllReadItemsAsync(Topic topic, int count)
    {
        try
        {
            return await _cosmosReadItem.ReadManyByPartitionId(new Microsoft.Azure.Cosmos.PartitionKey((int)topic), count);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Exception occurred while retrieving items from Cosmos DB. {ex.Message}");
            System.Diagnostics.Trace.TraceInformation($"Exception occurred while retrieving items from Cosmos DB. {ex.Message}");
            throw new Exception($"Error retrieving items from Cosmos DB: {ex.Message}", ex);
        }
    }
}