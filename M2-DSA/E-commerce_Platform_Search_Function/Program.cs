using System;

namespace EcommerceSearch
{
    public class Product
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string Category { get; set; }

        public Product(int productId, string productName, string category)
        {
            ProductId = productId;
            ProductName = productName;
            Category = category;
        }

        public override string ToString()
        {
            return $"[ID: {ProductId}] {ProductName,-22} | Category: {Category}";
        }
    }

    public class SearchAlgorithms
    {
        // Linear Search — O(n) worst case
        public static int LinearSearch(Product[] products, int targetId)
        {
            for (int i = 0; i < products.Length; i++)
            {
                if (products[i].ProductId == targetId)
                    return i;
            }
            return -1;
        }

        // Binary Search — O(log n) worst case
        // Requires array sorted by ProductId
        public static int BinarySearch(Product[] products, int targetId)
        {
            int low = 0;
            int high = products.Length - 1;

            while (low <= high)
            {
                int mid = low + (high - low) / 2;

                if (products[mid].ProductId == targetId)
                    return mid;
                else if (products[mid].ProductId < targetId)
                    low = mid + 1;
                else
                    high = mid - 1;
            }
            return -1;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            // Unsorted array for Linear Search
            Product[] products = new Product[]
            {
                new Product(103, "Wireless Mouse",      "Peripherals"),
                new Product(101, "Mechanical Keyboard", "Peripherals"),
                new Product(107, "USB-C Hub",           "Accessories"),
                new Product(102, "Monitor Stand",       "Furniture"),
                new Product(105, "Webcam HD 1080p",     "Peripherals"),
                new Product(109, "Laptop Sleeve",       "Accessories"),
                new Product(104, "Noise Cancelling Headphones", "Audio"),
                new Product(106, "Ergonomic Chair",     "Furniture"),
                new Product(108, "LED Desk Lamp",       "Lighting"),
                new Product(110, "Portable SSD 1TB",    "Storage"),
            };

            // Sorted array for Binary Search (sorted by ProductId)
            Product[] sortedProducts = new Product[]
            {
                new Product(101, "Mechanical Keyboard", "Peripherals"),
                new Product(102, "Monitor Stand",       "Furniture"),
                new Product(103, "Wireless Mouse",      "Peripherals"),
                new Product(104, "Noise Cancelling Headphones", "Audio"),
                new Product(105, "Webcam HD 1080p",     "Peripherals"),
                new Product(106, "Ergonomic Chair",     "Furniture"),
                new Product(107, "USB-C Hub",           "Accessories"),
                new Product(108, "LED Desk Lamp",       "Lighting"),
                new Product(109, "Laptop Sleeve",       "Accessories"),
                new Product(110, "Portable SSD 1TB",    "Storage"),
            };

            int[] testIds = { 105, 101, 110, 999 };

            Console.WriteLine("=== LINEAR SEARCH ===");
            foreach (int id in testIds)
            {
                int index = SearchAlgorithms.LinearSearch(products, id);
                if (index != -1)
                    Console.WriteLine($"Found  (index {index}): {products[index]}");
                else
                    Console.WriteLine($"ID {id} not found.");
            }

            Console.WriteLine("\n=== BINARY SEARCH ===");
            foreach (int id in testIds)
            {
                int index = SearchAlgorithms.BinarySearch(sortedProducts, id);
                if (index != -1)
                    Console.WriteLine($"Found  (index {index}): {sortedProducts[index]}");
                else
                    Console.WriteLine($"ID {id} not found.");
            }

            Console.WriteLine("\n=== TIME COMPLEXITY COMPARISON ===");
            Console.WriteLine($"{"Algorithm",-16} {"Best",-10} {"Average",-12} {"Worst",-10}");
            Console.WriteLine($"{"─────────",-16} {"────",-10} {"───────",-12} {"─────",-10}");
            Console.WriteLine($"{"Linear Search",-16} {"O(1)",-10} {"O(n)",-12} {"O(n)",-10}");
            Console.WriteLine($"{"Binary Search",-16} {"O(1)",-10} {"O(log n)",-12} {"O(log n)",-10}");
        }
    }
}