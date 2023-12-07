using DataAccess.Entities;
using Microsoft.EntityFrameworkCore;

namespace DataAccess;
public class BlogContext : DbContext
{
    public DbSet<Blog> Blogs { get; set; } = null!;
    public DbSet<Author> Authors { get; set; } = null!;
    public DbSet<Comment> Comments { get; set; } = null!;

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        optionsBuilder.UseSqlServer("Data Source=LAPTOP-PQEVQ8V5;Initial Catalog=Blog;Integrated Security=True;Connect Timeout=30;Encrypt=True;Trust Server Certificate=True;Application Intent=ReadWrite;Multi Subnet Failover=False");
    }
}
