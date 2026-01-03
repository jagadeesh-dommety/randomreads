using RandomReads.Models;

public record ReadActivityDB : CosmosItem{

    public int Topic { get; set; }
    public string ReadId { get; set; }
    public int TotalAttempts { get; set; }
    public int TotalCompletions { get; set; }
    public int TotalLikes { get; set; }
    public int TotalShares { get; set; }
    public int TotalReports { get; set; }
    public int TotalTimeSpent { get; set; }

    public DateTime LastUpdatedUtc { get; set; }
}


