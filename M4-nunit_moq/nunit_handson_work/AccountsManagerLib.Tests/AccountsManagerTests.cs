using NUnit.Framework;
using AccountsManagerLib;
using System;

namespace AccountsManagerLib.Tests
{
    [TestFixture]
    public class AccountsManagerTests
    {
        private AccountsManager _manager = null!;

        [SetUp]
        public void Setup()
        {
            _manager = new AccountsManager();
        }

        [Test]
        public void ValidateUser_ValidCredentialsUser11_ReturnsWelcomeMessage()
        {
            string userId = "user_11";
            string password = "secret@user11";
            string expected = "Welcome user_11!!!";

            string actual = _manager.ValidateUser(userId, password);

            Assert.That(actual, Is.EqualTo(expected));
        }

        [Test]
        public void ValidateUser_ValidCredentialsUser22_ReturnsWelcomeMessage()
        {
            string userId = "user_22";
            string password = "secret@user22";
            string expected = "Welcome user_22!!!";

            string actual = _manager.ValidateUser(userId, password);

            Assert.That(actual, Is.EqualTo(expected));
        }

        [Test]
        public void ValidateUser_InvalidCredentials_ReturnsErrorMessage()
        {
            string userId = "user_11";
            string password = "wrong_password";
            string expected = "Invalid user id/password";

            string actual = _manager.ValidateUser(userId, password);

            Assert.That(actual, Is.EqualTo(expected));
        }

        [Test]
        public void ValidateUser_EmptyUserId_ThrowsArgumentException()
        {
            string userId = "";
            string password = "secret@user11";

            Assert.That(() => _manager.ValidateUser(userId, password), Throws.TypeOf<ArgumentException>());
        }

        [Test]
        public void ValidateUser_EmptyPassword_ThrowsArgumentException()
        {
            string userId = "user_11";
            string password = "";

            Assert.That(() => _manager.ValidateUser(userId, password), Throws.TypeOf<ArgumentException>());
        }
    }
}
