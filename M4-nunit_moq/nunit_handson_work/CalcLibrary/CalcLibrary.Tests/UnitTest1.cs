using NUnit.Framework;
using ClassicAssert = NUnit.Framework.Legacy.ClassicAssert;
using CalcLibrary;
using System;

namespace CalcLibrary.Tests
{
    [TestFixture]
    public class SimpleCalculatorTests
    {
        private SimpleCalculator _calc = null!;

        [OneTimeSetUp]
        public void Init()
        {
            _calc = new SimpleCalculator();
        }

        [TestCase(10, 5, 5)]
        [TestCase(5, 10, -5)]
        [TestCase(0, 0, 0)]
        public void TestSubtraction(double a, double b, double expected)
        {
            double actual = _calc.Subtraction(a, b);
            ClassicAssert.AreEqual(expected, actual);
        }

        [TestCase(10, 5, 50)]
        [TestCase(-2, 5, -10)]
        [TestCase(0, 5, 0)]
        public void TestMultiplication(double a, double b, double expected)
        {
            double actual = _calc.Multiplication(a, b);
            ClassicAssert.AreEqual(expected, actual);
        }

        [TestCase(10, 5, 2)]
        [TestCase(10, 0, 0)]
        [TestCase(15, 3, 5)]
        public void TestDivision(double a, double b, double expected)
        {
            try
            {
                double actual = _calc.Division(a, b);
                if (b == 0)
                {
                    Assert.Fail("Division by zero");
                }
                else
                {
                    ClassicAssert.AreEqual(expected, actual);
                }
            }
            catch (ArgumentException ex)
            {
                if (b == 0)
                {
                    ClassicAssert.IsInstanceOf<ArgumentException>(ex);
                    ClassicAssert.AreEqual("Second Parameter Can't be Zero", ex.Message);
                    Assert.Fail("Division by zero");
                }
                else
                {
                    Assert.Fail("Unexpected ArgumentException thrown: " + ex.Message);
                }
            }
        }

        [Test]
        public void TestAddAndClear()
        {
            double expectedAddition = 15;
            double actualAddition = _calc.Addition(10, 5);
            ClassicAssert.AreEqual(expectedAddition, actualAddition);

            _calc.AllClear();
            ClassicAssert.AreEqual(0, _calc.GetResult);
        }
    }
}
