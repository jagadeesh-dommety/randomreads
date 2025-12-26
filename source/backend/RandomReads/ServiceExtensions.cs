using RandomReads.service;

public static class ServiceExtensions
{
    public static IServiceCollection AddRandomReadsServices(this IServiceCollection services, IConfiguration configuration)
    {
        // Add any RandomReads specific services here
        services.AddSingleton<ContentGenAgent>();
        services.AddSingleton<EmbeddingService>();
        var cosmosreadconfig = configuration.GetSection("ReadsConfig").Get<CosmosDBConfig>();
        services.AddSingleton<CosmosReadItem>(sp =>
        {
            var logger = sp.GetRequiredService<ILogger<CosmosReadItem>>();
            return new CosmosReadItem(cosmosreadconfig, logger);
        });
        var cosmosembedconfig = configuration.GetSection("EmbeddingConfig").Get<CosmosDBConfig>();
        services.AddSingleton<CosmosEmbeddingItem>(sp =>
        {
            var logger = sp.GetRequiredService<ILogger<CosmosReadItem>>();
            return new CosmosEmbeddingItem(cosmosembedconfig, logger);
        });
        services.AddSingleton<CosmosUser>(sp =>
        {
            var logger = sp.GetRequiredService<ILogger<CosmosUser>>();
            return new CosmosUser(configuration.GetSection("UserConfig").Get<CosmosDBConfig>(), logger);
        });
        services.AddScoped<CustomRequestContext>();
        services.AddSingleton<UserSignIn>();
        services.AddSingleton<UserService>();
        services.AddSingleton<ContentGenService>();
        services.AddScoped<ReadService>();

        return services;
    }
}