using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DataAccess.Entities;

public class Product
{
    //Id, Name, Price, CategoryId och SupplierId
    [Key]
    public int ID { get; set; }
    public string Name { get; set; }
    public double Price { get; set; }

    [ForeignKey("Category")]
    public int CategoryID { get; set; }
    public Category Category { get; set; }

    [ForeignKey("Supplier")]
    public int SupplierID { get; set; }
    public Supplier Supplier { get; set; }
}
