using System.Threading.Tasks;

public class UserService
{
    private readonly UserSignIn _userSignIn;
    public UserService(UserSignIn userSignIn)
    {
        this._userSignIn = userSignIn;
    }
    public User GetUserById(string userId)
    {
        // Placeholder implementation
        return new User(userId, "Sample User");
    }
    public async Task<TokenResponse> CreateTokenForUser(User user)
    {
       return await this._userSignIn.GetTokenResponse(user);
    }
    // User service implementation
}