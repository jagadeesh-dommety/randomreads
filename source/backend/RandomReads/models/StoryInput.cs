using RandomReads.Models;

namespace RandomReads.service;

public class StoryInput
    {
        public List<string> StoryLine { get; set; }
        public Topic Topic { get; set; }
        public string? customPrompt { get; set; }

        public StoryInput(List<string> storyLine, Topic topic, string? customPrompt = null)
        {
            StoryLine = storyLine;
            Topic = topic;
            this.customPrompt = customPrompt;
        }
    }
    #pragma warning disable OPENAI001 // Type is for evaluation purposes only and is subject to change or removal in future updates. Suppress this diagnostic to proceed.