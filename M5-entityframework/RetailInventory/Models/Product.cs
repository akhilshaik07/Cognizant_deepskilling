namespace RetailInventory.Models
{
    public class Category
    {
        public int CategoryId { get; set; }
        public string CategoryName { get; set; }
        public List<Product> Products { get; set; }
    }

    public class Product
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public decimal Price { get; set; }
        public int StockLevel { get; set; }
        public int CategoryId { get; set; }
        public Category Category { get; set; }
    }
}
