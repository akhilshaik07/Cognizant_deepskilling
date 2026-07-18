using Lab4_InsertData.Data;
using Lab4_InsertData.Models;

using var context = new AppDbContext();
context.Database.EnsureCreated();

var electronics = new Category { Name = "Electronics" };
var groceries   = new Category { Name = "Groceries" };
await context.Categories.AddRangeAsync(electronics, groceries);
await context.SaveChangesAsync();

var product1 = new Product { Name = "Laptop",   Price = 75000, CategoryId = electronics.Id };
var product2 = new Product { Name = "Rice Bag", Price = 1200,  CategoryId = groceries.Id };
await context.Products.AddRangeAsync(product1, product2);
await context.SaveChangesAsync();

Console.WriteLine("=== CATEGORIES ===");
foreach (var c in context.Categories.ToList())
    Console.WriteLine($"[ID:{c.Id}] {c.Name}");

Console.WriteLine("\n=== PRODUCTS ===");
foreach (var p in context.Products.ToList())
    Console.WriteLine($"[ID:{p.Id}] {p.Name,-15} | Price: ₹{p.Price} | CategoryId: {p.CategoryId}");
