using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using RandomReads.Models;

[ApiController]
public class UserActivityController : ControllerBase
{
    private readonly UserActivityService userActivityService;
    public UserActivityController(UserActivityService userActivityService)
    {
        this.userActivityService = userActivityService;
    }

    [HttpPost]
    [Route("useractivity")]
    public async Task<IActionResult> Activity(List<UserActivity> userActivity)
    {
       await  userActivityService.RecordUserActivityAsync(userActivity);
       return new OkResult();
    }

    [HttpPost]
    [Route("userreport")]
    public IActionResult ReportRead()
    {
        return new OkResult();
    }

    [HttpPost]
    [Route("usershare")]
    public IActionResult ShareRead()
    {
        return new OkResult();
    }
}

public class TopicActivity
{
    public Topic topic { get; set ;} //pk
    public string readid {get; set;}
    public int totallikes {get; set;}
    public int totalshares {get; set;}
    public int totalreports {get; set;}
    public int readcount {get; set;}
    public int totalcompletions {get; set;}
    public int totaltimespent {get; set;}

}