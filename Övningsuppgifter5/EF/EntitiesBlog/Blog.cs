using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataAccess.Entities;

public class Blog
{
    [Key]
    public int Id { get; set; }

    [Required]
    [MaxLength(50)]
    public string Title { get; set; }
    public string Content { get; set; }

    [ForeignKey("Author.Id")]
    public int AuthorID { get; set; }
    public Author Author { get; set; }
}
