using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using RandomReads.service;

[ApiController]
public class ContentGenerateController : ControllerBase
{
    private readonly ILogger<ContentGenerateController> _logger;
    private readonly ContentGenService _contentGenService;

    public ContentGenerateController(ILogger<ContentGenerateController> logger, ContentGenService contentGenService)
    {
        _logger = logger;
        _contentGenService = contentGenService;
    }

    [HttpGet]
    [Route("randomgenerate")]
    public IEnumerable<string> Get()
    {
        _logger.LogInformation("Generating random content.");
        var contents = new List<string>
        {
            "Random content 1",
            "Random content 2",
            "Random content 3"
        };
        return contents;
    }

    [HttpPost]
    [Route("generatebystoryline")]
    public async Task<IActionResult> GenerateByStoryLine([FromBody] StoryInput input)
    {
        _logger.LogInformation("Generating content based on storyline.");
        return await _contentGenService.GenerateContentByStoryLine(input);
    }
}