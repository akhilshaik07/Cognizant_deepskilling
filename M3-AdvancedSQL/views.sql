-- Employee Management System - Views Hands-on Exercises

-- =============================================
-- Database Schema Setup
-- =============================================

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    Salary DECIMAL(10, 2),
    JoinDate DATE
);

GO

-- =============================================
-- Exercise 1: Create a Simple View
-- Goal: Create a view to show basic employee details.
-- Task: Create a view named vw_EmployeeBasicInfo that displays EmployeeID, FirstName, LastName, and DepartmentName by joining Employees and Departments.
-- =============================================

CREATE VIEW vw_EmployeeBasicInfo AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentName
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

GO

-- =============================================
-- Exercise 2: Add Computed Column - Full Name
-- Goal: Use a computed column in a view.
-- Task: Modify or create a view named vw_EmployeeFullName that includes a computed column FullName (concatenation of FirstName and LastName).
-- =============================================

CREATE VIEW vw_EmployeeFullName AS
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    FirstName + ' ' + LastName AS FullName
FROM Employees;

GO

-- =============================================
-- Exercise 3: Add Computed Column - Annual Salary
-- Goal: Add a financial computed column.
-- Task: Create a view named vw_EmployeeAnnualSalary that includes a computed column AnnualSalary (Salary * 12).
-- =============================================

CREATE VIEW vw_EmployeeAnnualSalary AS
SELECT 
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    Salary * 12 AS AnnualSalary
FROM Employees;

GO

-- =============================================
-- Exercise 4: Add Multiple Computed Columns
-- Goal: Combine multiple computed columns in a single view.
-- Task: Create a view named vw_EmployeeReport that includes EmployeeID, FullName, DepartmentName, AnnualSalary, and Bonus (10% of AnnualSalary).
-- =============================================

CREATE VIEW vw_EmployeeReport AS
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS FullName,
    d.DepartmentName,
    (e.Salary * 12) AS AnnualSalary,
    ((e.Salary * 12) * 0.10) AS Bonus
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID;

GO
