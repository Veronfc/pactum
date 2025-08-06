namespace backend.Models
{
  public class User
  {
    public Guid Id { get; set; }
    public UserRole Role { get; set; }
    public string RoleString => Role.ToString().ToLower();
    public string Username { get; set; }
    public string PasswordHash { get; set; }
    public byte[] PasswordSalt { get; set; }
    public string? FullName { get; set; }
    public string? BusinessName { get; set; }
    public string? About { get; set; }
    public string? BasedIn { get; set; }
    public DateTime JoinedOn { get; set; }
  }

  public enum UserRole {
    Admin,
    User
  }
}