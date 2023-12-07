using System.ComponentModel.DataAnnotations;

namespace DataAccess.Entities;

public class Supplier
{
    //Id, Name och ContactInformation
    [Key]
    public int ID { get; set; }
    public string Name { get; set; }
    public string ContactInformation { get; set; }
}
