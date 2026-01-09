using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RandomReads.Models;

[ApiController]
public class ReadController : ControllerBase
{
    private readonly ReadService readService;
    private readonly CustomRequestContext customRequestContext;
    public ReadController(ReadService readService, CustomRequestContext customRequestContext)
    {
        this.readService = readService;
        this.customRequestContext = customRequestContext;
    }

    [Authorize]
    [HttpGet]
    [Route("readitem/{id}")]
    public async Task<IActionResult> GetReadItemById(string id, Topic topic)
    {
        if (!Enum.IsDefined(typeof(Topic), topic))
        {
            return BadRequest("Invalid topic specified.");
        }
        var readItem = await readService.GetReadItemByIdAsync(id, topic);
        return new OkObjectResult(readItem);
    }

    [Authorize]
    [HttpGet]
    [Route("readitems/{topic}/{count}")]
    public async Task<IActionResult> GetReadsByTopic(Topic topic, int count)
    {
        if (!Enum.IsDefined(typeof(Topic), topic))
        {
            return BadRequest("Invalid topic specified.");
        }
        var readItems = await readService.GetReadItemByTopic(topic, count, customRequestContext.UserId);
        return new OkObjectResult(readItems);
    }

    [Authorize]
    [HttpGet]
    [Route("readitems/getfeed")]
    public async Task<IActionResult> GetHomeFeed()
    {
        var readItems = await readService.GetHomeFeed(customRequestContext.UserId); 
        return new ObjectResult(readItems);
    }

    [Authorize]
    [HttpGet]
    [Route("readitems/likereads")]
    public  async Task<IActionResult> GetLikeReads()
    {
        var readItems = await readService.GetLikedReads(customRequestContext.UserId); 
        return new ObjectResult(readItems);
    }

    [Authorize]
    [HttpPost]
    [Route("readitems/submitstoryline")]
    public  async Task<IActionResult> submitstoryline(string storyline)
    {
        Console.WriteLine($"Received storyline: {storyline}");
        return new ObjectResult("success");
    }
}
