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
}