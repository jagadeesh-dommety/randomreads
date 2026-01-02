using RandomReads.Models;

public record UserActivityDB : CosmosItem
{
    public string userid {get; set;}
    public Topic topic {get; set;}
    public bool iscompleted {get; set;}
    public int timespent {get; set;}
    public bool isliked {get; set;}
    public bool isshared {get;set;}
    public bool isreported {get; set;}
        
}