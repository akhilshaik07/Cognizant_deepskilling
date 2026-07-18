using NUnit.Framework;
using Moq;
using PlayersManagerLib;
using System;

namespace PlayerManager.Tests;

[TestFixture]
public class PlayerManagerTests
{
    private Mock<IPlayerMapper> _mockMapper = null!;

    [OneTimeSetUp]
    public void Init()
    {
        _mockMapper = new Mock<IPlayerMapper>();
    }

    [TestCase]
    public void TestRegisterNewPlayer_Success()
    {
        _mockMapper.Setup(x => x.IsPlayerNameExistsInDb("Sachin")).Returns(false);
        _mockMapper.Setup(x => x.AddNewPlayerIntoDb(It.IsAny<string>()));

        Player player = Player.RegisterNewPlayer("Sachin", _mockMapper.Object);

        Assert.That(player, Is.Not.Null);
        Assert.That(player.Name, Is.EqualTo("Sachin"));
        Assert.That(player.Age, Is.EqualTo(23));
        Assert.That(player.Country, Is.EqualTo("India"));
        Assert.That(player.NoOfMatches, Is.EqualTo(30));
    }

    [TestCase]
    public void TestRegisterNewPlayer_AlreadyExists_ThrowsException()
    {
        _mockMapper.Setup(x => x.IsPlayerNameExistsInDb("Sachin")).Returns(true);

        Assert.Throws<ArgumentException>(() => Player.RegisterNewPlayer("Sachin", _mockMapper.Object), "Player name already exists.");
    }
}
