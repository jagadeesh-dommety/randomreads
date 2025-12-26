using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Cosmos;
using RandomReads.Models;
using RandomReads.service;

public class ContentGenService
{
    private readonly ContentGenAgent _contentGenAgent;
    private readonly CosmosReadItem _cosmosReadItem;
    private readonly EmbeddingService embeddingService;
    public ContentGenService(ContentGenAgent contentGenAgent, CosmosReadItem cosmosReadItem, EmbeddingService embeddingService)
    {
        this._contentGenAgent = contentGenAgent;
        this._cosmosReadItem = cosmosReadItem;
        this.embeddingService = embeddingService;
    }

    /// <summary>
    /// Creates embeddings - for all read items in the database based on a specific topic
    /// </summary>
    /// <returns></returns>
    public async Task createEmbeddingsFromTextAsync()
    {

        // Removed invalid instantiation of static class 'File'
        List<ReadItem> readItems = _cosmosReadItem.ReadManyByPartitionId(new Microsoft.Azure.Cosmos.PartitionKey((int)Topic.Physics), 10).Result.ToList();
        foreach (var item in readItems)
        {
            try
            {
                var embedding = await ContentGenAgent.CreateEmbeddings($"{item.Title}  {item.Content}");
                EmbeddingItem embeddingItem = new EmbeddingItem(item.Id, item.Topic, embedding.ToArray());
                await embeddingService.CreateEmbeddingIfNotSimilarAsync(item, embedding.ToArray(), 0.80);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error processing item id: {item.Id}. Exception: {ex.Message}");
                System.Diagnostics.Trace.TraceError($"Error processing item id: {item.Id}. Exception: {ex}");
            }
        }

    }
    public async Task<IActionResult> GenerateContentByStoryLine(StoryInput input)
    {
        Console.WriteLine("Generating content based on storyline.");
        System.Diagnostics.Trace.TraceInformation("Generating content based on storyline.");

        foreach (var line in input.StoryLine)
        {
            try
            {
                // Generate content based on storyline
                ReadItem read = await _contentGenAgent.GenerateContentByStoryLine(line, input.Topic);
                System.Diagnostics.Trace.TraceInformation("Content generated based on storyline.");

                // Create embeddings for the generated content
                var embedding = await ContentGenAgent.CreateEmbeddings($"{read.Title}  {read.Content}");
                EmbeddingItem embeddingItem = new EmbeddingItem(read.Id, read.Topic, embedding.ToArray());

                // Save embedding if not similar
                bool notFoundSimilarRead = await embeddingService.CreateEmbeddingIfNotSimilarAsync(read, embedding.ToArray(), 0.80);

                // Add the generated content to Cosmos DB
                if (notFoundSimilarRead)
                await _cosmosReadItem.CreateItemAsync(read);
                else
                {
                    Console.WriteLine($"Similar content already exists for storyline: {line}, skipping saving to database.");
                    System.Diagnostics.Trace.TraceInformation($"Similar content already exists for storyline: {line}, skipping saving to database.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error processing storyline. Exception: {ex.Message}");
                System.Diagnostics.Trace.TraceError($"Error processing storyline. Exception: {ex}");
                return new BadRequestObjectResult($"Error processing storyline: {ex.Message}");
            }
        }

        return new OkObjectResult("Content generation completed successfully.");
    }
}