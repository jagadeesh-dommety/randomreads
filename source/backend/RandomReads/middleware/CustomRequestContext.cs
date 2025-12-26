public class CustomRequestContext
    {
        public string UserId { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        // Request Information
        public string Method { get; set; } = string.Empty;
        public string Url { get; set; } = string.Empty;
        public string ClientIp { get; set; } = string.Empty;
        public Dictionary<string, string> Headers { get; set; } = new();

        public bool IsAuthenticated => !string.IsNullOrEmpty(UserId);
    }