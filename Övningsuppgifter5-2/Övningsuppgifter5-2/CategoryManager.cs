using DataAccess;
using DataAccess.Entities;

namespace Övningsuppgifter5_2;

public static class CategoryManager
{
    public static StoreContext db = new StoreContext();

    public static void AddCategory()
    {
        Console.WriteLine("Lägg till en ny kategori (skriv Namn):");
        db.Categories.Add(
            new Category()
            {
                Name = Console.ReadLine()
            });

        db.SaveChanges();
    }

    public static void ViewAllCategories()
    {
        foreach (var category in db.Categories.ToList())
        {
            Console.WriteLine($"{category.ID} {category.Name}");
        }
    }

    public static void UpdateCategory()
    {
        Console.WriteLine("Uppdatera en kategori (välj ID):");
        var updateCategory = db.Categories.Find(int.Parse(Console.ReadLine()));

        Console.WriteLine("Byt namn:");
        updateCategory.Name = Console.ReadLine();

        db.SaveChanges();
    }

    public static void RemoveCategory()
    {
        Console.WriteLine("Ta bort en kategori (välj ID):");
        var removeCategory = db.Categories.Find(int.Parse(Console.ReadLine()));

        db.Categories.Remove(removeCategory);

        db.SaveChanges();
    }
}
