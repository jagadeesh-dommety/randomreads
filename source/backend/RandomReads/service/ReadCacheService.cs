using Microsoft.Azure.Cosmos;

public class ReadCacheService
{
    private readonly CosmosReadItem cosmosReadItem;
    private readonly CosmosReadActivity cosmosReadActivity;
    private volatile Read[] _cache = Array.Empty<Read>();

    public ReadCacheService(CosmosReadItem cosmosReadItem, CosmosReadActivity cosmosReadActivity)
    {
        this.cosmosReadActivity = cosmosReadActivity;
        this.cosmosReadItem = cosmosReadItem;
    }
    public Read[] Snapshot() => _cache;

    public async Task RefreshAsync()
    {
        var reads = cosmosReadItem.Query<ReadItem>(
            new QueryDefinition("SELECT TOP 500 * FROM c ORDER BY c._ts DESC"),
            new QueryRequestOptions()
            {
                MaxItemCount = 500
            }
        );

        var stats = cosmosReadActivity.Query<ReadActivityDB>(
            new QueryDefinition("SELECT TOP 1000 * FROM c ORDER BY c._ts DESC"),
            new QueryRequestOptions()
            {
                MaxItemCount = 1000
            }
        );

        // 3️⃣ Index stats by readId
        var statsMap = stats?.ToDictionary(
            s => s.Id,
            s => new ReadStats
            {
                readid = s.Id,
                likescount = s.TotalLikes,
                shareCount = s.TotalShares,
                reportscount = s.TotalReports
            });

        Read[]? updatedCache = reads?.Select(
            r =>
            {
                ReadStats? stat = null;
                statsMap?.TryGetValue(r.Id, out stat);
                return new Read(r, stat ?? new ReadStats()
                {
                    readid = r.Id,
                });
            }
        ).ToArray();
        if (updatedCache?.Length > 0)
        {
           Random.Shared.Shuffle(updatedCache);
           _cache = updatedCache;
        }
    }
}