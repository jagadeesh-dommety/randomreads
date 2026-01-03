using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Cosmos;

public class UserActivityService
{
    private CosmosUserActivity _cosmosUserActivity;
    public UserActivityService(CosmosUserActivity cosmosUserActivity)
    {
        _cosmosUserActivity = cosmosUserActivity;
    }

    public async Task<bool> RecordUserActivityAsync(
    List<UserActivity> activities)
    {
        if (activities == null || activities.Count == 0)
            return true;

        foreach (var activity in activities)
        {
            UserActivityDB existing = null;

            try
            {
                existing = await _cosmosUserActivity.ReadItemByDocumentIdAsync(
                    activity.readid,
                    new PartitionKey(activity.userid));
            }
            catch (CosmosException ex) when (ex.StatusCode == System.Net.HttpStatusCode.NotFound)
            {
                Console.WriteLine("Item not found - expected");
            }

            var updated = existing == null
                ? CreateNew(activity, activity.readid)
                : Merge(existing, activity);

            await _cosmosUserActivity.UpsertItemAsync(
                updated);
        }

        return true;
    }
    private UserActivityDB Merge(
        UserActivityDB existing,
        UserActivity incoming)
    {
        return new UserActivityDB
        {
            Id = existing.Id,
            userid = existing.userid,
            topic = existing.topic,

            timespent = Math.Min(
                existing.timespent + incoming.timespent, 300),

            iscompleted = existing.iscompleted || incoming.iscompleted,
            isliked = existing.isliked || incoming.islike,
            isshared = existing.isshared || incoming.ishared,
            isreported = existing.isreported || incoming.isreported,
        };
    }
    private UserActivityDB CreateNew(
        UserActivity activity,
        string docId)
    {
        return new UserActivityDB
        {
            Id = docId,
            userid = activity.userid,
            topic = activity.topic,

            timespent = Math.Min(activity.timespent, 300),
            iscompleted = activity.iscompleted,
            isliked = activity.islike,
            isshared = activity.ishared,
            isreported = activity.isreported,

        };
    }




}