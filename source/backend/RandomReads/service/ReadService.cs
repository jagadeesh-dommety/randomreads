using System.Net;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using RandomReads.Models;

public class ReadService
{
    private readonly ReadCacheService _cache;
    private readonly UserActivityService _userActivity;

    public ReadService(
        ReadCacheService cache,
        UserActivityService userActivity)
    {
        _cache = cache;
        _userActivity = userActivity;
    }


    public async Task<Read> GetReadItemByIdAsync(string id, Topic topic)
    {
        try
        {
            var read = _cache.Snapshot().Where(x => x.readitem.Id == id).First();
            return read;
        }
        catch (Exception ex)
        {
            throw new Exception($"Error retrieving item from Cosmos DB: {ex.Message}", ex);
        }
    }

    public async Task<IEnumerable<Read>> GetReadItemByTopic(Topic topic, int count, string userid)
    {
        try
        {
            IEnumerable<Read> reads = _cache.Snapshot().Where(x => x.readitem.Topic == topic).Take(count);
            var tasks = reads.Select(x => GetUserReadAsync(userid, x));
            return (await Task.WhenAll(tasks)).ToList();
        }
        catch (Exception ex)
        {
            throw new Exception($"Error retrieving items from Cosmos DB: {ex.Message}", ex);
        }
    }

    private async Task<Read?> GetUserReadAsync(string userId, Read read, bool ishomefeed = false)
    {
        try
    {
        UserActivityDB ua =
            await _userActivity.GetUserActivityAsync(userId, read.readitem.Id);

        if (ishomefeed && ua != null)
        {
            return null;
        }

        if (ua != null)
        {
            read.readstats.hasliked = ua.isliked;
            read.readstats.hasreported = ua.isreported;
            read.readstats.hasshared = ua.isshared;
        }

        return read;
    }
    catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
    {
        return read;
    }
    }
    public async Task<List<Read>> GetHomeFeed(string userid, int count = 20)
    {
        var snapshot = _cache.Snapshot();
        var selected = snapshot.Take(count);

        // batch user activity reads
        var tasks = selected.Select(item =>
            GetUserReadAsync(userid, item, true)
        );
        
    var results = await Task.WhenAll(tasks);

    return results
        .Where(r => r != null)
        .Cast<Read>()
        .ToList();
    }
    public async Task<List<Read>> GetLikedReads(string userid)
    {
        IEnumerable<UserActivityDB> likedreads =  await _userActivity.GetUserLikesAsync(userid);
        List<Read> reads = new List<Read>();
        foreach (UserActivityDB userActivity in likedreads)
        {
          Read? read =  _cache.Snapshot().Where(x => x.readitem.Id == userActivity.Id).FirstOrDefault();
          if (read != null)
            {
                read.readstats.hasliked = userActivity.isliked;
                read.readstats.hasshared = userActivity.isshared;
                read.readstats.hasreported = userActivity.isreported;

                reads.Add(read);
            }
        }
        return reads;
        
    }
}
