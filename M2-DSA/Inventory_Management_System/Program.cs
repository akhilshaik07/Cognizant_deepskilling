using System;
using System.Collections.Generic;
using System.Linq;

namespace InventoryManagement
{
    public class Product
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public int Quantity { get; set; }
        public double Price { get; set; }

        public Product(int productId, string productName, int quantity, double price)
        {
            ProductId = productId;
            ProductName = productName;
            Quantity = quantity;
            Price = price;
        }

        public override string ToString()
        {
            return $"[ID: {ProductId}] {ProductName,-20} | Qty: {Quantity,5} | Price: ${Price,8:F2}";
        }
    }

    public class InventoryManager
    {
        private readonly Dictionary<int, Product> _inventory;

        public InventoryManager()
        {
            _inventory = new Dictionary<int, Product>();
        }

        public bool AddProduct(Product product)
        {
            if (product == null)
                throw new ArgumentNullException(nameof(product));

            if (_inventory.ContainsKey(product.ProductId))
            {
                Console.WriteLine($"[ERROR] Product ID {product.ProductId} already exists.");
                return false;
            }

            _inventory[product.ProductId] = product;
            Console.WriteLine($"[ADDED] {product}");
            return true;
        }

        public bool UpdateProduct(int productId, string newName = null, int newQuantity = -1, double newPrice = -1)
        {
            if (!_inventory.TryGetValue(productId, out Product product))
            {
                Console.WriteLine($"[ERROR] Product ID {productId} not found.");
                return false;
            }

            if (newName != null) product.ProductName = newName;
            if (newQuantity >= 0) product.Quantity = newQuantity;
            if (newPrice >= 0) product.Price = newPrice;

            Console.WriteLine($"[UPDATED] {product}");
            return true;
        }

        public bool DeleteProduct(int productId)
        {
            if (!_inventory.Remove(productId))
            {
                Console.WriteLine($"[ERROR] Product ID {productId} not found.");
                return false;
            }

            Console.WriteLine($"[DELETED] Product ID {productId} removed.");
            return true;
        }

        public Product GetProduct(int productId)
        {
            _inventory.TryGetValue(productId, out Product product);
            return product;
        }

        public List<Product> SearchByName(string keyword)
        {
            return _inventory.Values
                .Where(p => p.ProductName.Contains(keyword, StringComparison.OrdinalIgnoreCase))
                .ToList();
        }

        public void DisplayAll()
        {
            if (_inventory.Count == 0)
            {
                Console.WriteLine("[INFO] Inventory is empty.");
                return;
            }

            Console.WriteLine($"\n{"ID",-6} {"Product Name",-20} {"Quantity",8} {"Price",10}");
            Console.WriteLine($"{"──",-6} {"────────────",-20} {"────────",8} {"─────",10}");
            foreach (var p in _inventory.Values.OrderBy(p => p.ProductId))
                Console.WriteLine($"{p.ProductId,-6} {p.ProductName,-20} {p.Quantity,8} {p.Price,10:F2}");
        }

        public double GetTotalStockValue()
        {
            return _inventory.Values.Sum(p => p.Quantity * p.Price);
        }

        public int Count => _inventory.Count;
    }

    class Program
    {
        static void Main(string[] args)
        {
            var inventory = new InventoryManager();

            Console.WriteLine("=== ADD ===");
            inventory.AddProduct(new Product(101, "Wireless Mouse", 150, 29.99));
            inventory.AddProduct(new Product(102, "Mechanical Keyboard", 80, 74.99));
            inventory.AddProduct(new Product(103, "USB-C Hub", 200, 19.99));
            inventory.AddProduct(new Product(104, "Monitor Stand", 60, 49.99));
            inventory.AddProduct(new Product(105, "Webcam HD 1080p", 90, 59.99));
            inventory.AddProduct(new Product(101, "Duplicate Mouse", 10, 5.00));

            Console.WriteLine("\n=== DISPLAY ALL ===");
            inventory.DisplayAll();

            Console.WriteLine("\n=== UPDATE ===");
            inventory.UpdateProduct(102, newPrice: 69.99);
            inventory.UpdateProduct(103, newQuantity: 175);
            inventory.UpdateProduct(999, newName: "Ghost Product");

            Console.WriteLine("\n=== DELETE ===");
            inventory.DeleteProduct(104);
            inventory.DeleteProduct(404);

            Console.WriteLine("\n=== SEARCH: 'cam' ===");
            var results = inventory.SearchByName("cam");
            if (results.Count > 0)
                results.ForEach(p => Console.WriteLine($"Found: {p}"));
            else
                Console.WriteLine("No results.");

            Console.WriteLine("\n=== FINAL INVENTORY ===");
            inventory.DisplayAll();
            Console.WriteLine($"\nTotal Products   : {inventory.Count}");
            Console.WriteLine($"Total Stock Value: ${inventory.GetTotalStockValue():F2}");
        }
    }
}