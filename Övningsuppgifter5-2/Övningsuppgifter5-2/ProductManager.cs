using DataAccess;
using DataAccess.Entities;
using Microsoft.EntityFrameworkCore;

namespace Övningsuppgifter5_2;

public static class ProductManager
{
    public static StoreContext db = new StoreContext();
    public static void AddProduct()
    {
        string n, p, cid, sid;
        Console.WriteLine("Lägg till en ny produkt:\nNamn:");
        n = Console.ReadLine();
        Console.WriteLine("Pris:");
        p = Console.ReadLine();
        Console.WriteLine("Kategori ID:");
        cid = Console.ReadLine();
        Console.WriteLine("Supplier ID:");
        sid = Console.ReadLine();

        db.Products.Add(
            new Product()
            {
                Name = n,
                Price = double.Parse(p),
                CategoryID = int.Parse(cid),
                SupplierID = int.Parse(sid)
            });

        db.SaveChanges();
    }

    public static void ViewCategoryProducts()
    {
        Console.WriteLine("Välj ett kategori ID:");

        foreach (var product in db.Products.Where(p => p.CategoryID == int.Parse(Console.ReadLine()))
                     .Include(product => product.Category)
                     .Include(product => product.Supplier))
        {
            Console.WriteLine($"{product.ID} {product.Name} {product.Price} {product.Category.Name} {product.Supplier.Name} {product.Supplier.ContactInformation}");
        }
    }
}
