using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
public static class AuthServiceExtensions
{
    public static IServiceCollection AuthServiceExtension(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
        .AddJwtBearer(options =>
        {
            options.TokenValidationParameters = new Microsoft.IdentityModel.Tokens.TokenValidationParameters
            {
                ValidateIssuer = true,
                ValidateAudience = false,
                ValidateLifetime = true,
                ValidateIssuerSigningKey = true,
                ValidIssuer = Constants.applicationName,
                IssuerSigningKey = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(Constants.securitykey))
            };
            options.Events = new JwtBearerEvents
            {
                OnAuthenticationFailed = context =>
                {
                    // Log the exception
                    Console.WriteLine($"Authentication failed: {context.Exception.Message}");
                    throw context.Exception;
                },
                OnTokenValidated = context =>
                {
                    Console.WriteLine($"Token validated for {context.Principal?.Identity?.Name}");
                    return Task.CompletedTask;
                }
            };
        });
        return services;
    }
}