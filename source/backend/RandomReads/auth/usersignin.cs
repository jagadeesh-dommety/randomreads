using System.IdentityModel.Tokens.Jwt;
using System.Reflection.Metadata;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using Microsoft.IdentityModel.Tokens;

public class UserSignIn
{
    public readonly CosmosUser _cosmosUser;
    private readonly ILogger<UserSignIn> _logger;
    public UserSignIn(CosmosUser cosmosUser, ILogger<UserSignIn> logger)
    {
        _cosmosUser = cosmosUser;
        _logger = logger;
    }
    public async Task<TokenResponse> GetTokenResponse(User user)
    {
        // In a real implementation, generate a JWT or similar token here
        var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(Constants.securitykey));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        List<string> scopes = new List<string>()
        {
            "reads.read"
        };
        if (Constants.admins.Contains(user.Email, StringComparer.OrdinalIgnoreCase))
        {
            scopes.Add("reads.write");
        }
        var claims = new[]
        {
                new System.Security.Claims.Claim(JwtRegisteredClaimNames.Sub, user.Id),
                new System.Security.Claims.Claim(JwtRegisteredClaimNames.Name, user.Name),
                new System.Security.Claims.Claim(JwtRegisteredClaimNames.Email, user.Email ?? ""),
                new System.Security.Claims.Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                new System.Security.Claims.Claim("scp", string.Join(" ", scopes))
            };
        var accessToken = new JwtSecurityTokenHandler().WriteToken(new JwtSecurityToken(
        issuer: Constants.applicationName,
        audience: Constants.applicationName,
        claims: claims,
        expires: DateTime.UtcNow.AddDays(60),
        signingCredentials: credentials));
        UserDb existingUser = await _cosmosUser.ReadItemByDocumentIdAsync(user.Id, new PartitionKey(user.Id));
        if (existingUser == null)
        {
            await _cosmosUser.CreateItemAsync(new UserDb(user.Id, user.Name)
            {
                Email = user.Email,
                ProfileImageUrl = user.ProfileImageUrl,
                isActive = true,
                Gender = user.Gender
            }
        );
        }

        return new TokenResponse(
            token: accessToken,
            expiresAt: DateTimeOffset.UtcNow.AddDays(60),
            user: user
        );
    }
}
