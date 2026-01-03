using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Microsoft.Extensions.Logging;
using RandomReads.Models; // Assuming your models namespace

public class UserActivityService
{
    private readonly CosmosUserActivity _cosmosUserActivity;
    private readonly IReadActivityAggregator _readActivityAggregator;
    private readonly ILogger<UserActivityService> _logger;

    public UserActivityService(
        CosmosUserActivity cosmosUserActivity, 
        IReadActivityAggregator readActivityAggregator,
        ILogger<UserActivityService> logger)
    {
        _cosmosUserActivity = cosmosUserActivity;
        _readActivityAggregator = readActivityAggregator;
        _logger = logger;
    }

    public async Task<bool> RecordUserActivityAsync(List<UserActivity> activities)
    {
        if (activities == null || activities.Count == 0)
        {
            _logger.LogInformation("No activities to record.");
            return true;
        }

        var userActivitiesToUpsert = new List<UserActivityDB>();
        var aggregatorItems = new List<ReadActivityDB>();

        // Parallel create/prepare (no reads needed)
        var tasks = activities.Select(async activity =>
        {
            if (string.IsNullOrEmpty(activity.readid) || string.IsNullOrEmpty(activity.userid))
            {
                _logger.LogWarning("Skipping invalid activity for readId {ReadId} and user {UserId}", 
                    activity.readid, activity.userid);
                return;
            }

            // Always create new from incoming (no merge—UI handles state)
            var newActivity = CreateNew(activity);
            userActivitiesToUpsert.Add(newActivity);

            // Incremental aggregator prep (per-activity counts)
            var aggItem = new ReadActivityDB
            {
                Id = activity.readid,
                Topic = (int)activity.topic,
                TotalAttempts = 1, // Each call = 1 interaction
                TotalTimeSpent = Math.Min(activity.timespent, 300), // Cap per entry
                TotalLikes = activity.islike ? 1 : 0,
                TotalCompletions = activity.iscompleted ? 1 : 0,
                TotalReports = activity.isreported ? 1 : 0,
                TotalShares = activity.ishared ? 1 : 0
            };
            aggregatorItems.Add(aggItem);
        });

        await Task.WhenAll(tasks); // Parallel prep

        if (userActivitiesToUpsert.Count == 0)
        {
            _logger.LogWarning("No valid activities to upsert after processing.");
            return false;
        }

        // Batch upsert user activities (parallel)
        try
        {
            var userTasks = userActivitiesToUpsert.Select(activity =>
                _cosmosUserActivity.UpsertItemAsync(activity)
            );
            await Task.WhenAll(userTasks);
            _logger.LogInformation("Upserted {Count} user activities", userActivitiesToUpsert.Count);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Batch upsert failed for user activities");
            return false;
        }

        // Batch to aggregator (separate, incremental)
        try
        {
            await _readActivityAggregator.TrackBatchAsync(aggregatorItems);
            _logger.LogInformation("Tracked {Count} aggregator items", aggregatorItems.Count);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Batch aggregator track failed");
            // Non-fatal—user activity succeeded
        }

        return true;
    }

    private UserActivityDB CreateNew(UserActivity activity)
    {
        return new UserActivityDB
        {
            Id = activity.readid, // Doc ID = readId for uniqueness per user-story
            userid = activity.userid,
            topic = activity.topic,
            timespent = Math.Min(activity.timespent, 300), // Cap per snapshot at 5 min
            iscompleted = activity.iscompleted,
            isliked = activity.islike,
            isshared = activity.ishared,
            isreported = activity.isreported,
        };
    }
}