using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using RandomReads.Models;

public class ReadService
{
    private readonly CosmosReadItem _cosmosReadItem;
    private ReadItem[] _readItems = Array.Empty<ReadItem>();

    public ReadService(CosmosReadItem cosmosReadItem)
    {
        _cosmosReadItem = cosmosReadItem;
        InitialLoad();
    }

    public  void InitialLoad()
    {
        QueryDefinition queryDefinition = new QueryDefinition("SELECT TOP 30 * FROM c");
        List<ReadItem> dbreaditems =  _cosmosReadItem.Query<ReadItem>(queryDefinition, new QueryRequestOptions()
        {
            MaxItemCount = 30,
        })!;
        if (dbreaditems != null && dbreaditems.Count > 0)
        {
            _readItems = dbreaditems.ToArray();
            Random.Shared.Shuffle(_readItems); 
        }
        else
        {
            throw new NullReferenceException("unable to get the reads from cosmosdb");
        }

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

    public async Task<IEnumerable<ReadItem>> GetHomeFeed()
    {
        Dictionary<string, ReadItem> feeditems = new Dictionary<string, ReadItem>();
        try
        {
            for (int i = 0; i < 10; i++)
            {
                var rand = new Random().Next(0, _readItems.Length-1);
                feeditems.TryAdd(_readItems[rand].Id, _readItems[rand]);
            }
            return feeditems.Values.ToList();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Exception occurred while retrieving items from Cosmos DB. {ex.Message}");
            System.Diagnostics.Trace.TraceInformation($"Exception occurred while retrieving items from Cosmos DB. {ex.Message}");
            throw new Exception($"Error retrieving items from Cosmos DB: {ex.Message}", ex);
        }
    }
}