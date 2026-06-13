# Module 1 - Common Design Patterns (Practice Notes)

Continuing from the SOLID notes, these are my practice notes for the Creational,
Structural and Behavioral design patterns mentioned in Module 1. I picked the
3 patterns under each category that were listed and wrote small C# snippets to
get a feel for how they actually look in code (not just the theory diagrams).

Reference used: https://medium.com/@softwaretechsolution/designpattern-81ef65829de2

---

## Creational Patterns

Creational patterns are basically about *how objects get created*, so that the
creation logic doesn't get scattered everywhere.

### 1. Singleton Pattern

**When to use:** when you need exactly ONE instance of a class throughout the
app - e.g., a config manager, logger, or connection manager.

```csharp
public class AppLogger
{
    private static AppLogger _instance;
    private static readonly object _lock = new object();

    // private constructor so no one can do "new AppLogger()" from outside
    private AppLogger() { }

    public static AppLogger Instance
    {
        get
        {
            lock (_lock) // thread safety, this part took me a while to get
            {
                if (_instance == null)
                {
                    _instance = new AppLogger();
                }
                return _instance;
            }
        }
    }

    public void Log(string message)
    {
        Console.WriteLine($"[LOG]: {message}");
    }
}

// usage
// AppLogger.Instance.Log("Application started");
```

Note: I read that in real C# projects, people often use Dependency Injection
with a "Singleton lifetime" instead of writing this manually, but writing it
manually first helped me understand what's actually happening under the hood.

### 2. Factory Method Pattern

**When to use:** when the exact type of object to create depends on some
condition, and you want to hide that "new XYZ()" logic from the caller.

```csharp
public interface IVehicle
{
    void Drive();
}

public class Car : IVehicle
{
    public void Drive() => Console.WriteLine("Driving a car...");
}

public class Bike : IVehicle
{
    public void Drive() => Console.WriteLine("Riding a bike...");
}

public class VehicleFactory
{
    public IVehicle CreateVehicle(string type)
    {
        switch (type.ToLower())
        {
            case "car":
                return new Car();
            case "bike":
                return new Bike();
            default:
                throw new ArgumentException("Unknown vehicle type");
        }
    }
}

// usage
// var factory = new VehicleFactory();
// IVehicle v = factory.CreateVehicle("car");
// v.Drive();
```

This kind of connects back to OCP from the SOLID notes - I can add a `Truck`
class and a case for it without changing the calling code much.

### 3. Builder Pattern

**When to use:** when an object has a lot of optional fields and creating it
with one giant constructor becomes messy.

```csharp
public class Computer
{
    public string CPU { get; set; }
    public string RAM { get; set; }
    public string Storage { get; set; }
    public bool HasGraphicsCard { get; set; }

    public override string ToString()
    {
        return $"CPU: {CPU}, RAM: {RAM}, Storage: {Storage}, GPU: {HasGraphicsCard}";
    }
}

public class ComputerBuilder
{
    private readonly Computer _computer = new Computer();

    public ComputerBuilder SetCPU(string cpu)
    {
        _computer.CPU = cpu;
        return this; // returning "this" lets us chain calls
    }

    public ComputerBuilder SetRAM(string ram)
    {
        _computer.RAM = ram;
        return this;
    }

    public ComputerBuilder SetStorage(string storage)
    {
        _computer.Storage = storage;
        return this;
    }

    public ComputerBuilder AddGraphicsCard()
    {
        _computer.HasGraphicsCard = true;
        return this;
    }

    public Computer Build() => _computer;
}

// usage
// var pc = new ComputerBuilder()
//     .SetCPU("Intel i7")
//     .SetRAM("16GB")
//     .SetStorage("512GB SSD")
//     .AddGraphicsCard()
//     .Build();
```

---

## Structural Patterns

Structural patterns are more about *how classes/objects are composed together*.

### 4. Adapter Pattern

**When to use:** when you have an existing class with an interface that doesn't
match what the rest of your code expects - the adapter "translates" between them.

```csharp
// existing class we can't change (maybe it's from a 3rd party library)
public class OldPrinter
{
    public void PrintOld(string text)
    {
        Console.WriteLine($"Old Printer: {text}");
    }
}

// the interface our app actually expects
public interface IModernPrinter
{
    void Print(string text);
}

// adapter bridges the two
public class PrinterAdapter : IModernPrinter
{
    private readonly OldPrinter _oldPrinter;

    public PrinterAdapter(OldPrinter oldPrinter)
    {
        _oldPrinter = oldPrinter;
    }

    public void Print(string text)
    {
        _oldPrinter.PrintOld(text); // calling old method through new interface
    }
}

// usage
// IModernPrinter printer = new PrinterAdapter(new OldPrinter());
// printer.Print("Hello");
```

### 5. Decorator Pattern

**When to use:** to add extra behaviour to an object dynamically, without
changing its class - kind of like wrapping it.

```csharp
public interface ICoffee
{
    string GetDescription();
    double GetCost();
}

public class BasicCoffee : ICoffee
{
    public string GetDescription() => "Coffee";
    public double GetCost() => 50;
}

public abstract class CoffeeDecorator : ICoffee
{
    protected ICoffee _coffee;

    public CoffeeDecorator(ICoffee coffee)
    {
        _coffee = coffee;
    }

    public abstract string GetDescription();
    public abstract double GetCost();
}

public class MilkDecorator : CoffeeDecorator
{
    public MilkDecorator(ICoffee coffee) : base(coffee) { }

    public override string GetDescription() => _coffee.GetDescription() + " + Milk";
    public override double GetCost() => _coffee.GetCost() + 10;
}

public class SugarDecorator : CoffeeDecorator
{
    public SugarDecorator(ICoffee coffee) : base(coffee) { }

    public override string GetDescription() => _coffee.GetDescription() + " + Sugar";
    public override double GetCost() => _coffee.GetCost() + 5;
}

// usage
// ICoffee order = new SugarDecorator(new MilkDecorator(new BasicCoffee()));
// Console.WriteLine($"{order.GetDescription()} = {order.GetCost()}");
// output: Coffee + Milk + Sugar = 65
```

This one was actually fun to write, the "wrapping" idea makes a lot more sense
once you see the output.

### 6. Proxy Pattern

**When to use:** when you want an object to act as a placeholder/gatekeeper
for another object - e.g., for access control, lazy loading, logging, etc.

```csharp
public interface IDocument
{
    void Display();
}

public class RealDocument : IDocument
{
    private string _fileName;

    public RealDocument(string fileName)
    {
        _fileName = fileName;
        LoadFromDisk();
    }

    private void LoadFromDisk()
    {
        Console.WriteLine($"Loading document: {_fileName}");
    }

    public void Display()
    {
        Console.WriteLine($"Displaying document: {_fileName}");
    }
}

// proxy delays creation of the real (expensive) object until it's actually needed
public class DocumentProxy : IDocument
{
    private RealDocument _realDocument;
    private string _fileName;

    public DocumentProxy(string fileName)
    {
        _fileName = fileName;
    }

    public void Display()
    {
        if (_realDocument == null)
        {
            _realDocument = new RealDocument(_fileName); // created only when needed
        }
        _realDocument.Display();
    }
}
```

---

## Behavioral Patterns

Behavioral patterns focus on *how objects communicate/interact* with each other.

### 7. Observer Pattern

**When to use:** when one object's state change should automatically notify
other dependent objects - e.g., notifications, event systems.

```csharp
public interface IObserver
{
    void Update(decimal newPrice);
}

public class Stock
{
    private readonly List<IObserver> _observers = new List<IObserver>();
    private decimal _price;

    public void Attach(IObserver observer) => _observers.Add(observer);

    public decimal Price
    {
        get => _price;
        set
        {
            _price = value;
            NotifyAll();
        }
    }

    private void NotifyAll()
    {
        foreach (var observer in _observers)
        {
            observer.Update(_price);
        }
    }
}

public class Investor : IObserver
{
    private string _name;

    public Investor(string name)
    {
        _name = name;
    }

    public void Update(decimal newPrice)
    {
        Console.WriteLine($"{_name} notified: new stock price is {newPrice}");
    }
}

// usage
// var stock = new Stock();
// stock.Attach(new Investor("Akhil"));
// stock.Attach(new Investor("Ravi"));
// stock.Price = 105.50m; // both investors get notified automatically
```

### 8. Strategy Pattern

**When to use:** when you have multiple ways of doing something and want to
switch between them at runtime - very similar to what I used in the OCP example
above (that was actually a strategy pattern, just realized it now).

```csharp
public interface IPaymentStrategy
{
    void Pay(decimal amount);
}

public class CreditCardPayment : IPaymentStrategy
{
    public void Pay(decimal amount) => Console.WriteLine($"Paid {amount} using Credit Card");
}

public class UpiPayment : IPaymentStrategy
{
    public void Pay(decimal amount) => Console.WriteLine($"Paid {amount} using UPI");
}

public class ShoppingCart
{
    private IPaymentStrategy _paymentStrategy;

    public void SetPaymentStrategy(IPaymentStrategy strategy)
    {
        _paymentStrategy = strategy;
    }

    public void Checkout(decimal amount)
    {
        _paymentStrategy.Pay(amount);
    }
}

// usage
// var cart = new ShoppingCart();
// cart.SetPaymentStrategy(new UpiPayment());
// cart.Checkout(500);
```

### 9. Command Pattern

**When to use:** when you want to wrap a request/action as an object - useful
for things like undo/redo, queuing tasks, or button click handlers.

```csharp
public interface ICommand
{
    void Execute();
}

public class Light
{
    public void TurnOn() => Console.WriteLine("Light is ON");
    public void TurnOff() => Console.WriteLine("Light is OFF");
}

public class TurnOnCommand : ICommand
{
    private readonly Light _light;

    public TurnOnCommand(Light light)
    {
        _light = light;
    }

    public void Execute() => _light.TurnOn();
}

public class TurnOffCommand : ICommand
{
    private readonly Light _light;

    public TurnOffCommand(Light light)
    {
        _light = light;
    }

    public void Execute() => _light.TurnOff();
}

public class RemoteControl
{
    public void PressButton(ICommand command)
    {
        command.Execute();
    }
}

// usage
// var light = new Light();
// var remote = new RemoteControl();
// remote.PressButton(new TurnOnCommand(light));
// remote.PressButton(new TurnOffCommand(light));
```

---

## Quick note on Architectural Patterns (MVC & DI)

The module also briefly mentions MVC and Dependency Injection as architectural
patterns:

- **MVC (Model-View-Controller):** separates an app into Model (data),
  View (UI), and Controller (handles input and updates Model/View). Most
  ASP.NET applications I've seen follow this structure - Controllers folder,
  Models folder, Views folder.
- **Dependency Injection (DI):** ties back directly to the DIP notes from the
  SOLID file - instead of a class creating its own dependencies, they are
  "injected" (usually via constructor) from outside, often through a DI
  container.

---

## My takeaways

- Creational patterns (Singleton, Factory, Builder) are mostly about
  controlling **object creation**.
- Structural patterns (Adapter, Decorator, Proxy) are about **composing**
  classes/objects together without messing up existing code.
- Behavioral patterns (Observer, Strategy, Command) are about how objects
  **talk to each other** and react to changes/requests.
- A lot of these patterns aren't isolated - e.g. Strategy pattern is basically
  OCP + DIP in action, and Factory Method also supports OCP.
- Need more practice picking the *right* pattern for a problem instead of
  forcing a pattern where a simple solution would do - that's something I want
  to focus on in the practical exercises.
