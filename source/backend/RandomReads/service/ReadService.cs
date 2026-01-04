using System.Net;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using RandomReads.Models;

public class ReadService
{
    private readonly CosmosReadItem _cosmosReadItem;
    private readonly CosmosUserActivity _cosmosUserActivity;
    private ReadItem[] _readItems = Array.Empty<ReadItem>();

    public ReadService(CosmosReadItem cosmosReadItem, CosmosUserActivity cosmosUserActivity)
    {
        _cosmosUserActivity = cosmosUserActivity;
        _cosmosReadItem = cosmosReadItem;
        InitialLoad();
    }

    public void InitialLoad()
    {
        QueryDefinition queryDefinition = new QueryDefinition("SELECT TOP 300 * FROM c ORDER BY c._ts DESC");
        List<ReadItem> dbreaditems = _cosmosReadItem.Query<ReadItem>(queryDefinition, new QueryRequestOptions()
        {
            MaxItemCount = 300,
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
    public async Task<List<ReadItem>> GetHomeFeed(string userid)
    {
        var feedItems = new HashSet<ReadItem>();

        for (int i = 0; i < 10; i++)
        {
            var rand = Random.Shared.Next(0, _readItems.Length);
            var readItem = _readItems[rand];
            if (readItem.IsDeleted) continue;
            try
            {
               UserActivityDB useractivity = await _cosmosUserActivity.ReadItemByDocumentIdAsync(
                    readItem.Id,
                    new PartitionKey(userid));
                if (useractivity == null)
                {
                    feedItems.Add(readItem);
                }
            }
            catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
            {
                feedItems.Add(readItem);
            }
        }

        return feedItems.ToList(); 
    }


}