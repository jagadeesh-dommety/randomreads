using Microsoft.AspNetCore.Mvc;

[ApiController]
public class UserSignInController : ControllerBase
{
    private readonly ILogger<UserSignInController> _logger;
    private readonly UserService _userService;
    public UserSignInController(UserService userService, ILogger<UserSignInController> logger)
    {
        _userService = userService;
        _logger = logger;
    }
    [HttpPost]
    [Route("usersignin")]
    public Task<TokenResponse> SignIn(User user)
    {
        _logger.LogInformation("User sign-in attempted.");
        return _userService.CreateTokenForUser(user);
    }

    [HttpPost]
    [Route("googlesignin")]
    public IActionResult GoogleSignIn()
    {
        _logger.LogInformation("User sign-in attempted.");
        return Ok("Sign-in functionality is not yet implemented.");
    }

}

