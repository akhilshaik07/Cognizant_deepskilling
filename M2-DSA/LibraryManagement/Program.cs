using System;

namespace LibraryManagement
{
    public class Book
    {
        public int BookId { get; set; }
        public string Title { get; set; }
        public string Author { get; set; }

        public Book(int bookId, string title, string author)
        {
            BookId = bookId;
            Title  = title;
            Author = author;
        }

        public override string ToString()
        {
            return $"[ID: {BookId}] {Title,-35} | Author: {Author}";
        }
    }

    public class LibrarySearch
    {
        public static int LinearSearchByTitle(Book[] books, string title)
        {
            for (int i = 0; i < books.Length; i++)
            {
                if (books[i].Title.Equals(title, StringComparison.OrdinalIgnoreCase))
                    return i;
            }
            return -1;
        }

        public static int BinarySearchByTitle(Book[] books, string title)
        {
            int low  = 0;
            int high = books.Length - 1;

            while (low <= high)
            {
                int mid = low + (high - low) / 2;
                int cmp = string.Compare(books[mid].Title, title, StringComparison.OrdinalIgnoreCase);

                if (cmp == 0)
                    return mid;
                else if (cmp < 0)
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
            Book[] books = new Book[]
            {
                new Book(104, "Clean Code",                    "Robert C. Martin"),
                new Book(102, "Design Patterns",               "Gang of Four"),
                new Book(101, "Introduction to Algorithms",    "Cormen et al."),
                new Book(106, "The Pragmatic Programmer",      "Andrew Hunt"),
                new Book(103, "You Don't Know JS",             "Kyle Simpson"),
                new Book(105, "Refactoring",                   "Martin Fowler"),
                new Book(107, "Structure and Interpretation",  "Abelson & Sussman"),
                new Book(108, "Code Complete",                 "Steve McConnell"),
            };

            Book[] sortedBooks = new Book[]
            {
                new Book(108, "Clean Code",                    "Robert C. Martin"),
                new Book(102, "Code Complete",                 "Steve McConnell"),
                new Book(104, "Design Patterns",               "Gang of Four"),
                new Book(101, "Introduction to Algorithms",    "Cormen et al."),
                new Book(105, "Refactoring",                   "Martin Fowler"),
                new Book(107, "Structure and Interpretation",  "Abelson & Sussman"),
                new Book(106, "The Pragmatic Programmer",      "Andrew Hunt"),
                new Book(103, "You Don't Know JS",             "Kyle Simpson"),
            };

            string[] searchTitles = { "Refactoring", "Clean Code", "You Don't Know JS", "Deep Work" };

            Console.WriteLine("=== LINEAR SEARCH BY TITLE ===");
            foreach (string title in searchTitles)
            {
                int index = LibrarySearch.LinearSearchByTitle(books, title);
                if (index != -1)
                    Console.WriteLine($"Found  (index {index}): {books[index]}");
                else
                    Console.WriteLine($"'{title}' not found.");
            }

            Console.WriteLine("\n=== BINARY SEARCH BY TITLE (Sorted Array) ===");
            foreach (string title in searchTitles)
            {
                int index = LibrarySearch.BinarySearchByTitle(sortedBooks, title);
                if (index != -1)
                    Console.WriteLine($"Found  (index {index}): {sortedBooks[index]}");
                else
                    Console.WriteLine($"'{title}' not found.");
            }

            Console.WriteLine("\n=== TIME COMPLEXITY ANALYSIS ===");
            Console.WriteLine($"{"Algorithm",-20} {"Best",-10} {"Average",-12} {"Worst",-10} {"Requires Sorted"}");
            Console.WriteLine($"{"─────────",-20} {"────",-10} {"───────",-12} {"─────",-10} {"───────────────"}");
            Console.WriteLine($"{"Linear Search",-20} {"O(1)",-10} {"O(n)",-12} {"O(n)",-10} {"No"}");
            Console.WriteLine($"{"Binary Search",-20} {"O(1)",-10} {"O(log n)",-12} {"O(log n)",-10} {"Yes"}");
        }
    }
}