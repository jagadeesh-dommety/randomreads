using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using RandomReads.service;

public class ContentGenService
{
    private readonly ContentGenAgent _contentGenAgent;
    private readonly CosmosReadItem _cosmosReadItem;
    public ContentGenService(ContentGenAgent contentGenAgent, CosmosReadItem cosmosReadItem)
    {
        this._contentGenAgent = contentGenAgent;
        this._cosmosReadItem = cosmosReadItem;
    }

    public async Task<IActionResult> GenerateContentByStoryLine(StoryInput input)
    {
        List<ReadItem> readItems = _contentGenAgent.GenerateContentByStoryLine(input);
        foreach (var item in readItems)
        {
           var response = await  _cosmosReadItem.CreateItemAsync(item);
        }
        return new OkObjectResult(readItems);
    }
}