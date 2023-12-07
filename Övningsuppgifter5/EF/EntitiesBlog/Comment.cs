using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataAccess.Entities;

public class Comment
{
    [Key]
    public int Id { get; set; }

    [MinLength(1)]
    public string Text { get; set; }

    [ForeignKey("Blog")]
    public int BlogID { get; set; }
    public Blog Blog { get; set; }
}
