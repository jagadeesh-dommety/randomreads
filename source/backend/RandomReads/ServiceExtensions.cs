using RandomReads.service;

public static class ServiceExtensions
{
    public static IServiceCollection AddRandomReadsServices(this IServiceCollection services, IConfiguration configuration)
    {
        // Add any RandomReads specific services here
        services.AddSingleton<ContentGenAgent>();
        var cosmosfollowerconfig = configuration.GetSection("ReadsConfig").Get<CosmosDBConfig>();
        services.AddSingleton<CosmosReadItem>(sp =>
        {
            var logger = sp.GetRequiredService<ILogger<CosmosReadItem>>();
            return new CosmosReadItem(cosmosfollowerconfig, logger);
        });
        services.AddSingleton<ContentGenService>();

        return services;
    }
}