using NUnit.Framework;
using CollectionAssert = NUnit.Framework.Legacy.CollectionAssert;
using CollectionsLib;
using System;
using System.Collections.Generic;

namespace CollectionsLib.Tests
{
    [TestFixture]
    public class EmployeeManagerTests
    {
        private EmployeeManager _manager = null!;

        [SetUp]
        public void Setup()
        {
            _manager = new EmployeeManager();
        }

        // --- Scenario 1: Ensure no null values ---
        [Test]
        public void GetEmployees_CheckNullValues_NoNullItemsClassic()
        {
            List<Employee> employees = _manager.GetEmployees();
            CollectionAssert.AllItemsAreNotNull(employees);
        }

        [Test]
        public void GetEmployees_CheckNullValues_NoNullItemsConstraint()
        {
            List<Employee> employees = _manager.GetEmployees();
            Assert.That(employees, Has.None.Null);
        }

        // --- Scenario 2: Verify employee with Id 100 exists ---
        [Test]
        public void GetEmployees_CheckEmployeeId100Exists_EmployeeExistsClassic()
        {
            List<Employee> employees = _manager.GetEmployees();
            Employee target = new Employee { EmpId = 100 };
            CollectionAssert.Contains(employees, target);
        }

        [Test]
        public void GetEmployees_CheckEmployeeId100Exists_EmployeeExistsConstraint()
        {
            List<Employee> employees = _manager.GetEmployees();
            Employee target = new Employee { EmpId = 100 };
            Assert.That(employees, Has.Member(target));
        }

        // --- Scenario 3 (Part 1): Check only unique employees returned ---
        [Test]
        public void GetEmployees_CheckUniqueEmployees_AllItemsAreUniqueClassic()
        {
            List<Employee> employees = _manager.GetEmployees();
            CollectionAssert.AllItemsAreUnique(employees);
        }

        [Test]
        public void GetEmployees_CheckUniqueEmployees_AllItemsAreUniqueConstraint()
        {
            List<Employee> employees = _manager.GetEmployees();
            Assert.That(employees, Is.Unique);
        }

        // --- Scenario 3 (Part 2): Compare both GetEmployees and GetEmployeesWhoJoinedInPreviousYears ---
        [Test]
        public void GetEmployees_CompareWithPreviousYearsJoined_CollectionsAreEqualClassic()
        {
            List<Employee> list1 = _manager.GetEmployees();
            List<Employee> list2 = _manager.GetEmployeesWhoJoinedInPreviousYears();
            CollectionAssert.AreEquivalent(list1, list2);
        }

        [Test]
        public void GetEmployees_CompareWithPreviousYearsJoined_CollectionsAreEqualConstraint()
        {
            List<Employee> list1 = _manager.GetEmployees();
            List<Employee> list2 = _manager.GetEmployeesWhoJoinedInPreviousYears();
            Assert.That(list1, Is.EquivalentTo(list2));
        }
    }
}
