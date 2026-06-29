using Lab5_RetrieveData.Data;
using Lab5_RetrieveData.Models;
using Microsoft.EntityFrameworkCore;

using var context = new AppDbContext();
context.Database.EnsureCreated();

// Seed Data
var electronics = new Category { Name = "Electronics" };
var groceries   = new Category { Name = "Groceries" };
await context.Categories.AddRangeAsync(electronics, groceries);
await context.SaveChangesAsync();

await context.Products.AddRangeAsync(
    new Product { Name = "Laptop",        Price = 75000, CategoryId = electronics.Id },
    new Product { Name = "Mobile Phone",  Price = 25000, CategoryId = electronics.Id },
    new Product { Name = "Rice Bag",      Price = 1200,  CategoryId = groceries.Id   },
    new Product { Name = "Washing Machine", Price = 32000, CategoryId = electronics.Id }
);
await context.SaveChangesAsync();

// 1. Retrieve All Products
Console.WriteLine("=== ALL PRODUCTS ===");
var products = await context.Products.ToListAsync();
foreach (var p in products)
    Console.WriteLine($"[ID:{p.Id}] {p.Name,-20} | Price: ₹{p.Price}");

// 2. Find by ID
Console.WriteLine("\n=== FIND BY ID (ID: 1) ===");
var product = await context.Products.FindAsync(1);
Console.WriteLine($"Found: {product?.Name} | Price: ₹{product?.Price}");

// 3. FirstOrDefault with Condition
Console.WriteLine("\n=== FIRST PRODUCT WITH PRICE > ₹50000 ===");
var expensive = await context.Products.FirstOrDefaultAsync(p => p.Price > 50000);
Console.WriteLine(expensive != null
    ? $"Expensive: {expensive.Name} | Price: ₹{expensive.Price}"
    : "No product found above ₹50000");

// 4. Filter with Where
Console.WriteLine("\n=== PRODUCTS UNDER ₹30000 ===");
var affordable = await context.Products.Where(p => p.Price < 30000).ToListAsync();
foreach (var p in affordable)
    Console.WriteLine($"{p.Name,-20} | Price: ₹{p.Price}");

// 5. Include Category (Eager Loading)
Console.WriteLine("\n=== PRODUCTS WITH CATEGORY ===");
var withCategory = await context.Products.Include(p => p.Category).ToListAsync();
foreach (var p in withCategory)
    Console.WriteLine($"{p.Name,-20} | Price: ₹{p.Price,-10} | Category: {p.Category.Name}");
