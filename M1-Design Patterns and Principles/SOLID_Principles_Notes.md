# Module 1 - SOLID Principles (Practice Notes)

These are my notes/practice while going through the SOLID principles part of Module 1.
I tried to write small C# examples for each principle - first a "bad" version, then a
fixed version, just so I can actually see the difference instead of only reading theory.

Reference used: https://www.baeldung.com/solid-principles

---

## 1. Single Responsibility Principle (SRP)

**Idea:** A class should have only one reason to change. Basically, don't cram
multiple jobs into one class.

### Before (violates SRP)

```csharp
public class Invoice
{
    public string CustomerName { get; set; }
    public decimal Amount { get; set; }

    public void CalculateTotal()
    {
        // pretend some calculation happens here
        Console.WriteLine("Calculating total...");
    }

    // problem: this class is also doing printing AND saving to db
    public void PrintInvoice()
    {
        Console.WriteLine($"Invoice for {CustomerName}: {Amount}");
    }

    public void SaveToDatabase()
    {
        Console.WriteLine("Saving invoice to database...");
    }
}
```

Here `Invoice` is doing 3 things - business logic, printing, and persistence.
If the print format changes or the DB changes, this same class has to change.

### After (fixed)

```csharp
public class Invoice
{
    public string CustomerName { get; set; }
    public decimal Amount { get; set; }

    public void CalculateTotal()
    {
        Console.WriteLine("Calculating total...");
    }
}

public class InvoicePrinter
{
    public void Print(Invoice invoice)
    {
        Console.WriteLine($"Invoice for {invoice.CustomerName}: {invoice.Amount}");
    }
}

public class InvoiceRepository
{
    public void Save(Invoice invoice)
    {
        Console.WriteLine("Saving invoice to database...");
    }
}
```

Now each class has just one job. Easier to test and change individually.

---

## 2. Open/Closed Principle (OCP)

**Idea:** Classes should be open for extension but closed for modification.
Meaning, when I need new behaviour, I should be able to add new code instead
of editing existing tested code.

### Before (violates OCP)

```csharp
public class DiscountService
{
    public decimal GetDiscount(string customerType, decimal amount)
    {
        if (customerType == "Regular")
            return amount * 0.05m;
        else if (customerType == "Premium")
            return amount * 0.10m;
        // every time a new customer type comes, I have to keep editing this method
        else
            return 0;
    }
}
```

### After (fixed using abstraction)

```csharp
public interface IDiscountStrategy
{
    decimal GetDiscount(decimal amount);
}

public class RegularCustomerDiscount : IDiscountStrategy
{
    public decimal GetDiscount(decimal amount) => amount * 0.05m;
}

public class PremiumCustomerDiscount : IDiscountStrategy
{
    public decimal GetDiscount(decimal amount) => amount * 0.10m;
}

// if a new customer type comes, just add a new class - no need to touch existing ones
public class DiscountService
{
    public decimal Calculate(IDiscountStrategy strategy, decimal amount)
    {
        return strategy.GetDiscount(amount);
    }
}
```

---

## 3. Liskov Substitution Principle (LSP)

**Idea:** Objects of a subclass should be replaceable with objects of the parent
class without breaking the program.

### Before (violates LSP) - classic Rectangle/Square issue

```csharp
public class Rectangle
{
    public virtual int Width { get; set; }
    public virtual int Height { get; set; }

    public int GetArea() => Width * Height;
}

public class Square : Rectangle
{
    // forcing width and height to always be equal breaks the parent's behaviour
    public override int Width
    {
        set { base.Width = base.Height = value; }
    }

    public override int Height
    {
        set { base.Width = base.Height = value; }
    }
}
```

If some code expects a `Rectangle` and sets Width = 5, Height = 10, it gets area 50
for a normal rectangle, but for `Square` it would silently give 100. That's a
broken substitution.

### After (fixed)

```csharp
public abstract class Shape
{
    public abstract int GetArea();
}

public class Rectangle : Shape
{
    public int Width { get; set; }
    public int Height { get; set; }

    public override int GetArea() => Width * Height;
}

public class Square : Shape
{
    public int Side { get; set; }

    public override int GetArea() => Side * Side;
}
```

Now both are independent shapes and don't pretend to be one another. No surprises.

---

## 4. Interface Segregation Principle (ISP)

**Idea:** Don't force a class to implement methods it doesn't need. Better to
have smaller, specific interfaces than one big fat interface.

### Before (violates ISP)

```csharp
public interface IWorker
{
    void Work();
    void Eat();
}

// a robot worker doesn't eat, but it's still forced to implement Eat()
public class RobotWorker : IWorker
{
    public void Work() => Console.WriteLine("Robot working...");

    public void Eat()
    {
        throw new NotImplementedException(); // ugly
    }
}
```

### After (fixed)

```csharp
public interface IWorkable
{
    void Work();
}

public interface IFeedable
{
    void Eat();
}

public class HumanWorker : IWorkable, IFeedable
{
    public void Work() => Console.WriteLine("Human working...");
    public void Eat() => Console.WriteLine("Human eating lunch...");
}

public class RobotWorker : IWorkable
{
    public void Work() => Console.WriteLine("Robot working...");
    // no Eat() needed anymore, makes sense now
}
```

---

## 5. Dependency Inversion Principle (DIP)

**Idea:** High level modules should not depend on low level modules directly.
Both should depend on abstractions (interfaces).

### Before (violates DIP)

```csharp
public class EmailNotifier
{
    public void Send(string message) => Console.WriteLine($"Email: {message}");
}

public class OrderService
{
    private readonly EmailNotifier _notifier = new EmailNotifier(); // tightly coupled

    public void PlaceOrder()
    {
        Console.WriteLine("Order placed.");
        _notifier.Send("Your order has been placed!");
    }
}
```

If tomorrow I want SMS notification instead of Email, I have to change `OrderService`.

### After (fixed with abstraction + constructor injection)

```csharp
public interface INotifier
{
    void Send(string message);
}

public class EmailNotifier : INotifier
{
    public void Send(string message) => Console.WriteLine($"Email: {message}");
}

public class SmsNotifier : INotifier
{
    public void Send(string message) => Console.WriteLine($"SMS: {message}");
}

public class OrderService
{
    private readonly INotifier _notifier;

    public OrderService(INotifier notifier) // dependency injected from outside
    {
        _notifier = notifier;
    }

    public void PlaceOrder()
    {
        Console.WriteLine("Order placed.");
        _notifier.Send("Your order has been placed!");
    }
}
```

Now `OrderService` doesn't care which notifier is used - I can pass Email, SMS,
or even a mock for testing.

---

## My takeaways

- SRP, OCP, ISP all kind of push towards "small, focused units" - classes,
  methods, interfaces.
- LSP is mainly about not breaking the contract/behaviour expected from the parent.
- DIP is the one that makes dependency injection make sense - before this I never
  understood why DI containers exist, now it's a bit more clear.
- Overall these principles overlap a lot with the design patterns in the next
  section (especially Strategy and Factory which I used while practicing OCP/DIP).
