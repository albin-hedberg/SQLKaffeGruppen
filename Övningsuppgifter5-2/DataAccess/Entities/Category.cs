using System.ComponentModel.DataAnnotations;

namespace DataAccess.Entities;

public class Category
{
    //Id och Name
    [Key]
    public int ID { get; set; }
    public string Name { get; set; }
}
