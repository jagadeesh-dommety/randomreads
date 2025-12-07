public class ReadEngagement
{
    public readonly string ReadItemId;
    public int Likes { get; set; } = 0;
    public int Shares { get; set; } = 0;
    public int Comments { get; set; } = 0;

    public ReadEngagement(string readItemId)
    {
        ReadItemId = readItemId;
    }
}   