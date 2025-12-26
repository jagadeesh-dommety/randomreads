public record UserDb : CosmosItem
{
    public string? Email { get; set; }
    public string  Name { get; set; }
    public bool isActive { get; set; } = true;
    public DateTime Joinedat { get; } = DateTime.UtcNow;
    public string? ProfileImageUrl { get; set; } 
    public Gender Gender { get; set; } = Gender.unknown;
    public UserDb(string id, string userName)
    {
        this.Id = id;
        this.Name = userName;
    }
}