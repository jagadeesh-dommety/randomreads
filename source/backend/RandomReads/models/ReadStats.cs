public class ReadStats
{
  public string readid {get; set;}
  public int likescount{get; set;} = 0;
  public int shareCount{get; set;} = 0;
  public int reportscount{get; set;} = 0;
  public bool hasliked{get; set;} = false;
  public bool hasshared {get; set;} = false;
  public bool hasreported {get; set;} = false;
} 
