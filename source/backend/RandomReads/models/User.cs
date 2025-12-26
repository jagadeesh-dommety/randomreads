public record User
{
    public string Id { get; }
    public string? Email { get; set; }
    public string  Name { get; set; }
    public bool isActive { get; set; } = true;
    public DateTime Joinedat { get; } = DateTime.UtcNow;
    public string? ProfileImageUrl { get; set; } 
    public Gender Gender { get; set; } = Gender.unknown;
    public User(string id, string name)
    {
        this.Id = id;
        this.Name = name;
    }
}

public enum Gender
{
    unknown,
    Male,
    Female,
    Other
}