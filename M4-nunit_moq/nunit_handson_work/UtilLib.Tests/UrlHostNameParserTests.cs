using NUnit.Framework;
using UtilLib;
using System;

namespace UtilLib.Tests
{
    [TestFixture]
    public class UrlHostNameParserTests
    {
        private UrlHostNameParser _parser = null!;

        [SetUp]
        public void Setup()
        {
            _parser = new UrlHostNameParser();
        }

        [Test]
        public void ParseHostName_ValidHttpsUrl_ReturnsHostName()
        {
            string url = "https://www.google.com/search";
            string expected = "www.google.com";

            string actual = _parser.ParseHostName(url);

            Assert.That(actual, Is.EqualTo(expected));
        }

        [Test]
        public void ParseHostName_InvalidProtocolUrl_ThrowsFormatException()
        {
            string url = "ftp://ftp.example.com/files";

            Assert.That(() => _parser.ParseHostName(url), Throws.TypeOf<FormatException>());
        }
    }
}
