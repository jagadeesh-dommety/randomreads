using System;
using System.ClientModel;
using System.Numerics;
using System.Text.Json;
using System.Threading.Tasks;
using Azure.AI.OpenAI;
using Azure.AI.Projects;
using Azure.AI.Projects.OpenAI;
using Azure.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Cosmos.Serialization.HybridRow;
using OpenAI;
using RandomReads.Models;

namespace RandomReads.service;
#pragma warning disable OPENAI001 // Type is for evaluation purposes only and is subject to change or removal in future updates. Suppress this diagnostic to proceed.
public class ContentGenAgent
{
    AIProjectClient projectClient;
    AgentReference agentReference;
    const string projectEndpoint = "https://randomreads-content-resource.services.ai.azure.com/api/projects/randomreads-content";
    const string agentName = "content-generator";
    const string agentVersion = "4";

    public ContentGenAgent()
    {
        projectClient = new(endpoint: new Uri(projectEndpoint), tokenProvider: new DefaultAzureCredential(new DefaultAzureCredentialOptions
        {
            ManagedIdentityClientId = Constants.ManagedIdentityClientId
        }));
        agentReference = new AgentReference(agentName, agentVersion);
    }

    public static async Task<ReadOnlyMemory<float>> CreateEmbeddings(string content)
    {
        var embeddingsClient = new AzureOpenAIClient(
            new Uri(Constants.embeddingsEndpoint),
            new DefaultAzureCredential(new DefaultAzureCredentialOptions
            {
                ManagedIdentityClientId = Constants.ManagedIdentityClientId
            })
        );
        var client = embeddingsClient.GetEmbeddingClient(
            Constants.embeddingsModel
        );

        // 3. Generate embeddings
        var embeddingResponse = await client.GenerateEmbeddingAsync(content);

        // 4. Access the vector data
        ReadOnlyMemory<float> vector = embeddingResponse.Value.ToFloats();
        Console.WriteLine($"Generated embedding with {vector.Length} dimensions."); Console.WriteLine($"Embedding created with dimension: {vector.Length}");
        return vector;
    }

    public async Task<ReadItem> GenerateContentByStoryLine(string line, Topic topic)
    {
        string prompt = $"Story line is {line}";

        try
        {
            System.Diagnostics.Trace.TraceInformation($"Processing line: {line}");
            var projectConversation = projectClient.OpenAI.GetProjectConversationsClient();

            ProjectConversation conversation = projectClient.OpenAI.Conversations.CreateProjectConversation();
            var responseClient = projectClient.OpenAI.GetProjectResponsesClientForAgent(agentReference, conversation.Id);

            var response = await responseClient.CreateResponseAsync(prompt);

            // Extract curator output (usually OutputItems[1])
            string curatorText = ContentGenUtils.ExtractCuratorText(response.Value);
            // Parse title + content
            (string title, string content) = ContentGenUtils.ParseGeneratedContent(curatorText);
            float[] embeddingArray = CreateEmbeddings(curatorText).Result.ToArray();

            return new ReadItem(
                Id: Guid.NewGuid().ToString(),
                content: content,
                topic: topic,
                title: title,
                createdAt: DateTime.UtcNow
            );
        }
        catch (Exception ex)
        {

            Console.WriteLine("Exception occurred while generating content.");
            Console.WriteLine($"Error processing line: {line}. Exception: {ex.Message}");
            System.Diagnostics.Trace.TraceInformation("Exception occurred while generating content.");
            System.Diagnostics.Trace.TraceInformation($"Error processing line: {line}. Exception: {ex.Message}");
            throw new Exception($"Error calling ai {ex} and {ex.StackTrace} and {ex.InnerException}", ex);
            ;
        }

    }
}


