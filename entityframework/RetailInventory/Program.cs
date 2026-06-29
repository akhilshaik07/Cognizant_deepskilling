using RetailInventory.Data;
using RetailInventory.Models;

using var context = new RetailDbContext();
context.Database.EnsureCreated();

var electronics = new Category { CategoryName = "Electronics" };
var furniture   = new Category { CategoryName = "Furniture" };
context.Categories.AddRange(electronics, furniture);
context.SaveChanges();

context.Products.AddRange(
    new Product { ProductName = "Wireless Mouse",      Price = 29.99m, StockLevel = 150, CategoryId = electronics.CategoryId },
    new Product { ProductName = "Mechanical Keyboard", Price = 74.99m, StockLevel = 80,  CategoryId = electronics.CategoryId },
    new Product { ProductName = "Ergonomic Chair",     Price = 199.99m, StockLevel = 40, CategoryId = furniture.CategoryId }
);
context.SaveChanges();

var products = context.Products.ToList();
Console.WriteLine("=== INVENTORY ===");
foreach (var p in products)
    Console.WriteLine($"[ID:{p.ProductId}] {p.ProductName,-25} | Price: ${p.Price} | Stock: {p.StockLevel}");
