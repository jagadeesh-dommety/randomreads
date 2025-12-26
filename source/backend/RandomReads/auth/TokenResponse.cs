public class TokenResponse
{
    public string Token { get; set; }
    public DateTimeOffset ExpiresAt { get; set; }
    public User User { get; set; }

    public TokenResponse(string token, DateTimeOffset expiresAt, User user)
    {
        Token = token;
        ExpiresAt = expiresAt;
        User = user;
    }
}