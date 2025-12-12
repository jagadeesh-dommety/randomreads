using System;
using System.ClientModel;
using System.Text.Json;
using Azure.AI.OpenAI;
using Azure.AI.Projects;
using Azure.AI.Projects.OpenAI;
using Azure.Identity;
using Microsoft.AspNetCore.Mvc;

namespace RandomReads.service;
#pragma warning disable OPENAI001 // Type is for evaluation purposes only and is subject to change or removal in future updates. Suppress this diagnostic to proceed.
public class ContentGenAgent
{
    AIProjectClient projectClient;
    AgentReference agentReference;
    ProjectResponsesClient responseClient;
    const string projectEndpoint = "https://randomreads-content-resource.services.ai.azure.com/api/projects/randomreads-content";
    const string agentName = "content-generator";
    const string conversation_id = "conv_cd5ae0c4c50c091100h9krU7piKrnKutvtPhDQQSZQPEfy5Enx";
    const string agentVersion = "4";

    public ContentGenAgent()
    {
        projectClient = new(endpoint: new Uri(projectEndpoint), tokenProvider: new DefaultAzureCredential(new DefaultAzureCredentialOptions
                {
                    ManagedIdentityClientId = Constants.ManagedIdentityClientId
                }));
        agentReference = new AgentReference(agentName, agentVersion);
        responseClient = projectClient.OpenAI.GetProjectResponsesClientForAgent(agentReference, conversation_id);
    }

    public List<ReadItem> GenerateContentByStoryLine(StoryInput input)
    {
        List<ReadItem> ReadItemList = new List<ReadItem>();
        foreach (var line in input.StoryLine)
        {
            string prompt = $"Story line is {line}";

            try
            {
                System.Diagnostics.Trace.TraceInformation($"Processing line: {line}");
                var response = responseClient.CreateResponse(prompt);

                // Extract curator output (usually OutputItems[1])
                string curatorText = ContentGenUtils.ExtractCuratorText(response.Value);

                // Parse title + content
                (string title, string content) = ContentGenUtils.ParseGeneratedContent(curatorText);

                var readItem = new ReadItem(
                    Id: Guid.NewGuid().ToString(),
                    content: content,
                    topic: input.Topic,
                    title: title,
                    createdAt: DateTime.UtcNow
                );
                ReadItemList.Add(readItem);
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
        return ReadItemList;
    }

}
