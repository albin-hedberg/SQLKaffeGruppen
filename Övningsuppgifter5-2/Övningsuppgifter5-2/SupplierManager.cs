using DataAccess;
using DataAccess.Entities;
using Microsoft.EntityFrameworkCore;

namespace Övningsuppgifter5_2;

public class SupplierManager
{
    public static StoreContext db = new StoreContext();

    public static void AddSupplier()
    {
        string n, ci;
        Console.WriteLine("Lägg till en ny supplier:\nNamn:");
        n = Console.ReadLine();
        Console.WriteLine("Kontaktinformation:");
        ci = Console.ReadLine();

        db.Suppliers.Add(
            new Supplier()
            {
                Name = n,
                ContactInformation = ci
            });

        db.SaveChanges();
    }

    public static void UpdateSupplier()
    {
        Console.WriteLine("Uppdatera en supplier (välj ID):");
        var updateSupplier = db.Suppliers.Find(int.Parse(Console.ReadLine()));

        Console.WriteLine("Byt namn:");
        updateSupplier.Name = Console.ReadLine();

        Console.WriteLine("Byt kontaktinformation:");
        updateSupplier.ContactInformation = Console.ReadLine();

        db.SaveChanges();
    }

    public static void ViewSupplierProducts()
    {
        Console.WriteLine("Välj ett supplier ID:");

        foreach (var product in db.Products.Where(p => p.SupplierID == int.Parse(Console.ReadLine()))
                     .Include(product => product.Category)
                     .Include(product => product.Supplier))
        {
            Console.WriteLine($"{product.ID} {product.Name} {product.Price}:- {product.Category.Name} {product.Supplier.Name} {product.Supplier.ContactInformation}");
        }
    }
}
