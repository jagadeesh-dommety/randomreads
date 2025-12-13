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

        Console.WriteLine("Generating content based on storyline.");
        System.Diagnostics.Trace.TraceInformation("Generating content based on storyline.");
        foreach (var line in input.StoryLine)
        {
         ReadItem read = await _contentGenAgent.GenerateContentByStoryLine(line, input.Topic);
         System.Diagnostics.Trace.TraceInformation("Content generated based on storyline.");

            Console.WriteLine("adding to db");
            System.Diagnostics.Trace.TraceInformation("adding to db");
            try
            {
                var response = await  _cosmosReadItem.CreateItemAsync(read);

            }
            catch (Exception ex)
            {
                throw new Exception($"Error adding item to Cosmos DB {ex} and {ex.StackTrace} and {ex.InnerException}", ex);
            } 
        }
        return new OkObjectResult("Content generation completed successfully.");
    }
}