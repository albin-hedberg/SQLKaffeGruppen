using DataAccess;

namespace Övningsuppgifter5_2;

public static class TagManager
{
    public static StoreContext db = new StoreContext();
    public static void AddTag()
    {
        Console.WriteLine("Skapa ny tag (Namn):");
        db.Tags.Add(new()
        {
            Name = Console.ReadLine()
        });

        db.SaveChanges();
    }

    public static void ViewAllTags()
    {
        foreach (var tag in db.Tags.ToList())
        {
            Console.WriteLine($"{tag.ID} {tag.Name}");
        }
    }

    public static void UpdateTag()
    {
        Console.WriteLine("Uppdatera en tag (välj ID):");
        var updateTag = db.Tags.Find(int.Parse(Console.ReadLine()));

        Console.WriteLine("Byt namn:");
        updateTag.Name = Console.ReadLine();

        db.SaveChanges();
    }

    public static void RemoveTag()
    {
        Console.WriteLine("Ta bort en tag (välj ID):");
        var removeTag = db.Tags.Find(int.Parse(Console.ReadLine()));

        db.Tags.Remove(removeTag);

        db.SaveChanges();
    }
}
