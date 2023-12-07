using System.ComponentModel.DataAnnotations;

namespace DataAccess.Entities;

public class Author
{
    [Key]
    public int Id { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }

    [Required]
    [MaxLength(20)]
    public string Username { get; set; }

    [Required]
    [EmailAddress]
    public string Email { get; set; }
}
