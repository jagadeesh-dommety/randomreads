public class Read
{
    public Read(ReadItem readItem, ReadStats readStats)
    {
        this.readitem = readItem;
        this.readstats = readStats;

    }
    public ReadItem readitem {get; init; }
    public ReadStats readstats {get; init; }
}