using NUnit.Framework;
using Moq;
using CustomerCommLib;

namespace CustomerCommLib.Tests;

[TestFixture]
public class CustomerCommTests
{
    private Mock<IMailSender> _mockMailSender = null!;

    [OneTimeSetUp]
    public void Init()
    {
        _mockMailSender = new Mock<IMailSender>();
        _mockMailSender
            .Setup(m => m.SendMail(It.IsAny<string>(), It.IsAny<string>()))
            .Returns(true);
    }

    [TestCase]
    public void TestSendMailToCustomer()
    {
        CustomerComm customerComm = new CustomerComm(_mockMailSender.Object);
        bool result = customerComm.SendMailToCustomer();
        Assert.That(result, Is.True);
    }
}
