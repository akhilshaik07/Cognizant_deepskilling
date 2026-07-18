using Lab3_EFCoreMigrations.Data;
using Lab3_EFCoreMigrations.Models;

using var context = new AppDbContext();

var electronics = new Category { Name = "Electronics" };
var furniture   = new Category { Name = "Furniture" };
context.Categories.AddRange(electronics, furniture);
context.SaveChanges();

context.Products.AddRange(
    new Product { Name = "Wireless Mouse",      Price = 29.99m,  CategoryId = electronics.Id },
    new Product { Name = "Mechanical Keyboard", Price = 74.99m,  CategoryId = electronics.Id },
    new Product { Name = "Ergonomic Chair",     Price = 199.99m, CategoryId = furniture.Id }
);
context.SaveChanges();

Console.WriteLine("=== PRODUCTS ===");
foreach (var p in context.Products.ToList())
    Console.WriteLine($"[ID:{p.Id}] {p.Name,-25} | Price: ${p.Price} | CategoryId: {p.CategoryId}");

Console.WriteLine("\n=== CATEGORIES ===");
foreach (var c in context.Categories.ToList())
    Console.WriteLine($"[ID:{c.Id}] {c.Name}");
