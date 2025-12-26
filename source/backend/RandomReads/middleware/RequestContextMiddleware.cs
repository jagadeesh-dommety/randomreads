public class RequestContextMiddleware
    {
        private readonly RequestDelegate _next;

        public RequestContextMiddleware(RequestDelegate next)
        {
            _next = next;
        }

        public async Task InvokeAsync(HttpContext context, CustomRequestContext requestContext)
        {
            // Capture request details
            requestContext.Method = context.Request.Method;
            requestContext.Url = $"{context.Request.Scheme}://{context.Request.Host}{context.Request.Path}{context.Request.QueryString}";
            requestContext.ClientIp = context.Connection.RemoteIpAddress?.ToString() ?? "Unknown";

            // Capture headers (excluding sensitive ones)
            foreach (var header in context.Request.Headers)
            {
                requestContext.Headers[header.Key] = header.Value.ToString();
            }

            // Capture user details if authenticated
            if (context.User.Identity?.IsAuthenticated == true)
            {
                requestContext.UserId = context.User.Claims.FirstOrDefault().Value;
                requestContext.Username = context.User.Claims.FirstOrDefault(x => x.Type == System.IdentityModel.Tokens.Jwt.JwtRegisteredClaimNames.Name).Value;
            }
            await _next(context);
        }
    }
