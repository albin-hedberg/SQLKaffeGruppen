using System.ComponentModel.DataAnnotations;

namespace DataAccess.Entities;

public class Tag
{
    [Key]
    public int ID { get; set; }
    public string Name { get; set; }
    public List<Product> Products { get; set; }
}
