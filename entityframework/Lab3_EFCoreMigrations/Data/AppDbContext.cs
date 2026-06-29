using Microsoft.EntityFrameworkCore;
using Lab3_EFCoreMigrations.Models;

namespace Lab3_EFCoreMigrations.Data
{
    public class AppDbContext : DbContext
    {
        public DbSet<Product> Products { get; set; }
        public DbSet<Category> Categories { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer("Server=localhost;Database=Lab3_RetailDB;Trusted_Connection=True;TrustServerCertificate=True;");
        }
    }
}
