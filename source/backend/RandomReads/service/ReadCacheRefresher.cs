
public class ReadCacheRefresher : BackgroundService
{
    private readonly ReadCacheService _readCacheService;
    public ReadCacheRefresher(ReadCacheService readCacheService)
    {
        this._readCacheService = readCacheService;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        await _readCacheService.RefreshAsync();

        while (!stoppingToken.IsCancellationRequested)
        {
            await Task.Delay(TimeSpan.FromMinutes(30), stoppingToken);
            await _readCacheService.RefreshAsync();
        }
    }
}