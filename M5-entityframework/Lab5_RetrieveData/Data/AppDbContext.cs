using Microsoft.EntityFrameworkCore;
using Lab5_RetrieveData.Models;

namespace Lab5_RetrieveData.Data
{
    public class AppDbContext : DbContext
    {
        public DbSet<Product> Products { get; set; }
        public DbSet<Category> Categories { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer("Server=localhost;Database=Lab5_RetailDB;Trusted_Connection=True;TrustServerCertificate=True;");
        }
    }
}
