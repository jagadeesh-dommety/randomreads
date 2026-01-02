using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

public class UserActivityService
{
    private CosmosUserActivity _cosmosUserActivity;
    public UserActivityService(CosmosUserActivity cosmosUserActivity)
    {
        _cosmosUserActivity = cosmosUserActivity;
    }
    public async Task<bool>  RecordUserActivity(UserActivity userActivity)
    {
        UserActivityDB userActivityDB = new UserActivityDB()
        {
            Id = userActivity.readid,
            userid = userActivity.userid,
            iscompleted = userActivity.iscompleted,
            timespent = userActivity.timespent,
            isreported = userActivity.isreported,
            isshared = userActivity.ishared
        
        };
        try
        {
          var item = await _cosmosUserActivity.CreateItemAsync(userActivityDB);
            return true;
        }
        catch
        {
            throw;
        }

    }
}