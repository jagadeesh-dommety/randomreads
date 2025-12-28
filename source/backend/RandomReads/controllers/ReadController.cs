using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using RandomReads.Models;

[ApiController]
public class ReadController : ControllerBase
{
    private readonly ReadService readService;
    public ReadController(ReadService readService)
    {
        this.readService = readService;
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
        var readItems = await readService.GetAllReadItemsAsync(topic, count);
        return new OkObjectResult(readItems);
    }

    [Authorize]
    [HttpGet]
    [Route("readitems/getfeed")]
    public async Task<IActionResult> GetHomeFeed()
    {
        var readItems = readService.GetHomeFeed(); 
        return new ObjectResult(readItems);
    }
}