using Confluent.Kafka;

Console.WriteLine("1 = Producer (send messages), 2 = Consumer (read messages)");
Console.Write("Choose mode: ");
string? mode = Console.ReadLine();

string topic = "chat-messages";
string bootstrapServers = "localhost:9092";

if (mode == "1")
{
    var config = new ProducerConfig { BootstrapServers = bootstrapServers };
    using var producer = new ProducerBuilder<Null, string>(config).Build();

    Console.WriteLine("Type messages and press Enter to send. Type 'exit' to quit.");
    while (true)
    {
        Console.Write("You: ");
        string? message = Console.ReadLine();
        if (message == "exit") break;

        var result = await producer.ProduceAsync(topic, new Message<Null, string> { Value = message });
        Console.WriteLine($"Sent to partition {result.Partition}, offset {result.Offset}");
    }
}
else if (mode == "2")
{
    var config = new ConsumerConfig
    {
        BootstrapServers = bootstrapServers,
        GroupId = "chat-consumer-group",
        AutoOffsetReset = AutoOffsetReset.Earliest
    };

    using var consumer = new ConsumerBuilder<Null, string>(config).Build();
    consumer.Subscribe(topic);

    Console.WriteLine("Listening for messages... (Ctrl+C to quit)");
    while (true)
    {
        var cr = consumer.Consume();
        Console.WriteLine($"[{DateTime.Now:HH:mm:ss}] Received: {cr.Message.Value}");
    }
}