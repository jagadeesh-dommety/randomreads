using System.Collections.Concurrent;
using Microsoft.Azure.Cosmos;

public class ReadActivityBackground : BackgroundService
{
    private readonly IReadActivityAggregator _readActivityAggregator;
    private readonly ILogger<ReadActivityBackground> _logger;
    private readonly CosmosReadActivity _cosmosReadActivity;

    private static readonly TimeSpan FlushInterval = TimeSpan.FromMinutes(2);

    public ReadActivityBackground(
        ILogger<ReadActivityBackground> logger,
        IReadActivityAggregator readActivityAggregator,
        CosmosReadActivity cosmosReadActivity)
    {
        _logger = logger;
        _readActivityAggregator = readActivityAggregator;
        _cosmosReadActivity = cosmosReadActivity;
    }


    protected override async Task ExecuteAsync(
        CancellationToken stoppingToken)
    {
        _logger.LogInformation("ReadActivityBackground started");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await Task.Delay(FlushInterval, stoppingToken);
                var batch = _readActivityAggregator.Drain();
                foreach (var activity in batch)
                {
                    bool patched = await _cosmosReadActivity.PatchItemAsync(
                    activity.Id,
                    new PartitionKey(activity.Topic),
            AddPatchOperations(activity),
                    stoppingToken);

                    if (!patched)
                    {
                        await CreateNewItemInDB(activity);
                    }
                }
            }
            catch (TaskCanceledException)
            {
                // graceful shutdown
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Flush loop failed");
            }
        }
    }
    private static List<PatchOperation> AddPatchOperations(ReadActivityDB delta)
    {
        return new List<PatchOperation>
            {
            PatchOperation.Increment("/totalLikes", delta.TotalLikes),
            PatchOperation.Increment("/totalShares", delta.TotalShares),
            PatchOperation.Increment("/totalReports", delta.TotalReports),
            PatchOperation.Increment("/totalCompletions", delta.TotalCompletions),
            PatchOperation.Increment("/totalAttempts", delta.TotalAttempts),
            PatchOperation.Increment("/totalTimeSpent", delta.TotalTimeSpent),
            };
    }

    private async Task CreateNewItemInDB(ReadActivityDB delta)
    {
        await _cosmosReadActivity.CreateItemAsync(new ReadActivityDB
        {
            Id = delta.Id,
            Topic = delta.Topic,
            TotalLikes = delta.TotalLikes,
            TotalShares = delta.TotalShares,
            TotalReports = delta.TotalReports,
            TotalCompletions = delta.TotalCompletions,
            TotalAttempts = delta.TotalAttempts,
            TotalTimeSpent = delta.TotalTimeSpent,
        });
    }
}

public interface IReadActivityAggregator
{
    void Track(ReadActivityDB activity);
    IReadOnlyCollection<ReadActivityDB> Drain();
    Task TrackBatchAsync(List<ReadActivityDB> aggregatorItems);
}
public class ReadActivityAggregator : IReadActivityAggregator
{
    private readonly ConcurrentDictionary<string, ReadActivityDB> _readActivity
        = new();

    public void Track(ReadActivityDB activity)
    {
        var key = activity.Id;

        _readActivity.AddOrUpdate(
            key,
            activity,
            (_, existing) =>
            {
                existing.TotalAttempts += activity.TotalAttempts;
                existing.TotalCompletions += activity.TotalCompletions;
                existing.TotalLikes += activity.TotalLikes;
                existing.TotalShares += activity.TotalShares;
                existing.TotalReports += activity.TotalReports;
                existing.TotalTimeSpent += activity.TotalTimeSpent;
                existing.LastUpdatedUtc = DateTime.UtcNow;
                return existing;
            });
    }

    public IReadOnlyCollection<ReadActivityDB> Drain()
    {
        var snapshot = _readActivity.Values.ToList();
        _readActivity.Clear();
        return snapshot;
    }

    public Task TrackBatchAsync(List<ReadActivityDB> aggregatorItems)
    {
        foreach (var item in aggregatorItems)
        {
             Track(item);
        }
        return Task.CompletedTask;
    }
}
