using NUnit.Framework;
using SeasonsLib;
using System.Collections.Generic;

namespace FourSeasonsLib.Tests
{
    [TestFixture]
    public class SeasonTellerTests
    {
        private SeasonTeller _teller = null!;

        [SetUp]
        public void Setup()
        {
            _teller = new SeasonTeller();
        }

        // Straight-forward way: static method returning TestCaseData
        public static IEnumerable<TestCaseData> StraightForwardTestCases()
        {
            yield return new TestCaseData("February").Returns("Spring");
            yield return new TestCaseData("March").Returns("Spring");
            yield return new TestCaseData("April").Returns("Summer");
            yield return new TestCaseData("May").Returns("Summer");
            yield return new TestCaseData("June").Returns("Summer");
            yield return new TestCaseData("July").Returns("Monsoon");
            yield return new TestCaseData("August").Returns("Monsoon");
            yield return new TestCaseData("September").Returns("Monsoon");
            yield return new TestCaseData("October").Returns("Autumn");
            yield return new TestCaseData("November").Returns("Autumn");
            yield return new TestCaseData("December").Returns("Winter");
            yield return new TestCaseData("January").Returns("Winter");
            yield return new TestCaseData("Unknown").Returns("Invalid Season");
        }

        [Test]
        [TestCaseSource(nameof(StraightForwardTestCases))]
        public string DisplaySeasonBy_ValidMonth_ReturnsExpectedSeason_StraightForward(string monthName)
        {
            return _teller.DisplaySeasonBy(monthName);
        }

        // Alternate way: using a static array of object arrays for Assert.That() explicitly
        public static object[] AlternateTestCases =
        {
            new object[] { "February", "Spring" },
            new object[] { "March", "Spring" },
            new object[] { "April", "Summer" },
            new object[] { "May", "Summer" },
            new object[] { "June", "Summer" },
            new object[] { "July", "Monsoon" },
            new object[] { "August", "Monsoon" },
            new object[] { "September", "Monsoon" },
            new object[] { "October", "Autumn" },
            new object[] { "November", "Autumn" },
            new object[] { "December", "Winter" },
            new object[] { "January", "Winter" },
            new object[] { "Unknown", "Invalid Season" }
        };

        [Test]
        [TestCaseSource(nameof(AlternateTestCases))]
        public void DisplaySeasonBy_ValidMonth_ReturnsExpectedSeason_Alternate(string monthName, string expectedSeason)
        {
            string actual = _teller.DisplaySeasonBy(monthName);
            Assert.That(actual, Is.EqualTo(expectedSeason));
        }
    }
}
