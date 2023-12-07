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

    public static void ViewAllProducts()
    {
        foreach (var product in db.Products
                     .Include(product => product.Tags).Include(product => product.Category)
                     .Include(product => product.Supplier).ToList())
        {
            Console.WriteLine($"{product.ID} {product.Name} {product.Price} Tags: {product.Tags} {product.Category.Name} {product.Supplier.Name} {product.Supplier.ContactInformation}");
        }
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

    public static void UpdateProductSupplier()
    {
        Console.WriteLine("Välj ett produkt ID:");
        var updateProduct = db.Products.Find(int.Parse(Console.ReadLine()));

        Console.WriteLine("Välj ett nytt supplier ID:");
        updateProduct.SupplierID = int.Parse(Console.ReadLine());

        db.SaveChanges();
    }

    public static void AddTagToProduct()
    {
        Console.WriteLine("Välj ett produkt ID:");
        var product = db.Products.Find(int.Parse(Console.ReadLine()));

        Console.WriteLine("Välj ett tag ID:");
        var tag = db.Tags.Find(int.Parse(Console.ReadLine()));

        product.Tags.Add(tag);

        db.SaveChanges();
    }
}
