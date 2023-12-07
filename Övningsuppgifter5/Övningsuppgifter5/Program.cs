using DataAccess;
using DataAccess.Entities;
using Microsoft.EntityFrameworkCore;

using var db = new BlogContext();

// ADD:
//AddAuthor();
//AddBlog();
//AddComment();

// VIEW:
//ViewAuthor(testAuthor);
//ViewAllAuthors();
//Console.WriteLine("--------------------");
//ViewAllBlogs();
//Console.WriteLine("--------------------");
//ViewAllComments();
//Console.WriteLine("--------------------");
//ViewBlogComments();

// UPDATE:
//UpdateAuthor();
//UpdateComment();

// DELETE:

#region ADD
void AddAuthor()
{
    string fn, ln, un, em;
    Console.WriteLine("Lägg till ny användare\nFörnamn:");
    fn = Console.ReadLine();
    Console.WriteLine("Efternamn:");
    ln = Console.ReadLine();
    Console.WriteLine("Användarnamn:");
    un = Console.ReadLine();
    Console.WriteLine("Email:");
    em = Console.ReadLine();

    db.Authors.Add(
        new Author()
        {
            FirstName = fn,
            LastName = ln,
            Username = un,
            Email = em
        }
        );

    db.SaveChanges();
}

void AddBlog()
{
    var title = Console.ReadLine();

    Console.WriteLine("What is it going to be about? (in one word, for example: Sports, Fashion..)");
    var content = Console.ReadLine();

    Console.WriteLine("What is your username)");
    string username = Console.ReadLine();


    db.Blogs.Add(new Blog()
    {
        Title = title,
        Content = content,
        AuthorID = db.Authors.Single(a => a.Username == username).Id
    });

    db.SaveChanges();
}

void AddComment()
{
    Console.WriteLine("Skriv in bloggens titel enter och sedan din kommentar");
    db.Comments.Add(
        new()
        {
            BlogID = db.Blogs.Single(b => b.Title.ToLower() == Console.ReadLine().ToLower()).Id,
            Text = Console.ReadLine()
        }
    );

    db.SaveChanges();
}
#endregion

#region VIEW
void ViewAuthor(Author author)
{
    author = db.Authors.Single(a => a.Username == author.Username);
    Console.WriteLine($"{author.Id} {author.FirstName} {author.LastName} {author.Username} {author.Email}");
}

void ViewAllAuthors()
{
    foreach (var author in db.Authors.ToList())
    {
        Console.WriteLine($"{author.Id} {author.FirstName} {author.LastName} {author.Username} {author.Email}");
    }
}

void ViewAllBlogs()
{
    foreach (var blog in db.Blogs.Include(blog => blog.Author).ToList())
    {
        Console.WriteLine($"{blog.Id} {blog.Title} {blog.Content} {blog.Author.Username}");
    }
}

void ViewAllComments()
{
    foreach (var comment in db.Comments.Include(comment => comment.Blog).ToList())
    {
        Console.WriteLine($"{comment.Id} {comment.Blog.Title} {comment.Text}");
    }
}

void ViewBlogComments()
{
    ViewAllBlogs();
    Console.WriteLine("Välj ett blogg id:");
    int blogID = int.Parse(Console.ReadLine());
    var blog = db.Blogs.Find(blogID);

    var blogComments = db.Comments.Where(c => c.BlogID == blog.Id).ToList();

    foreach (var blogComment in blogComments)
    {
        Console.WriteLine($"Blog: {blog.Title}\nId: {blogComment.Id} Comment: {blogComment.Text}");
    }
}
#endregion

#region UPDATE

void UpdateAuthor()
{
    Console.WriteLine("Välj användare ID:");
    int userID = int.Parse(Console.ReadLine());

    var author = db.Authors.Find(userID);

    Console.WriteLine("Uppdatera användare\nFörnamn:");
    author.FirstName = Console.ReadLine();
    Console.WriteLine("Efternamn:");
    author.LastName = Console.ReadLine();
    Console.WriteLine("Användarnamn:");
    author.Username = Console.ReadLine();
    Console.WriteLine("Email:");
    author.Email = Console.ReadLine();

    db.SaveChanges();
}

void UpdateComment()
{
    Console.WriteLine("Write comment id and press enter then blog title. Write your comment and press enter.");
    db.Comments.Update(
        new()
        {
            Id = int.Parse(Console.ReadLine()),
            BlogID = db.Blogs.Single(b => b.Title.ToLower() == Console.ReadLine().ToLower()).Id,
            Text = Console.ReadLine()
        }
    );
    db.SaveChanges();
}
#endregion

#region DELETE

#endregion
