-- Employee Management System - User-Defined Functions (UDFs) Hands-on Exercises

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
    Salary DECIMAL(10,2),
    JoinDate DATE
);

GO

-- =============================================
-- Sample Data Insertion
-- =============================================

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance');

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate) VALUES
(1, 'John', 'Doe', 1, 5000.00, '2020-01-15'),
(2, 'Jane', 'Smith', 2, 6000.00, '2019-03-22'),
(3, 'Bob', 'Johnson', 3, 5500.00, '2021-07-01');

GO

-- =============================================
-- Exercise 1: Create a Scalar Function
-- Goal: Create a scalar function to calculate the annual salary of an employee.
-- =============================================

CREATE FUNCTION fn_CalculateAnnualSalary (
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 12;
END;

GO

-- Test Exercise 1: Select annual salary for each employee
SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    Salary, 
    dbo.fn_CalculateAnnualSalary(Salary) AS AnnualSalary
FROM Employees;

GO

-- =============================================
-- Exercise 2: Create a Table-Valued Function
-- Goal: Create a table-valued function to return employees in a specific department.
-- =============================================

CREATE FUNCTION fn_GetEmployeesByDepartment (
    @DepartmentID INT
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        EmployeeID, 
        FirstName, 
        LastName, 
        DepartmentID, 
        Salary, 
        JoinDate
    FROM Employees
    WHERE DepartmentID = @DepartmentID
);

GO

-- Test Exercise 2: Select employees from the IT department (DepartmentID = 2)
SELECT * FROM dbo.fn_GetEmployeesByDepartment(2);

GO

-- =============================================
-- Exercise 3: Create a User-Defined Function (Bonus Calculation)
-- Goal: Create a user-defined function to calculate the bonus for an employee (10%).
-- =============================================

CREATE FUNCTION fn_CalculateBonus (
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 0.10;
END;

GO

-- Test Exercise 3: Select bonus for each employee
SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    Salary, 
    dbo.fn_CalculateBonus(Salary) AS Bonus
FROM Employees;

GO

-- =============================================
-- Exercise 4: Modify a User-Defined Function
-- Goal: Modify the fn_CalculateBonus function to return Salary * 0.15.
-- =============================================

ALTER FUNCTION fn_CalculateBonus (
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 0.15;
END;

GO

-- Test Exercise 4: Select modified bonus for each employee
SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    Salary, 
    dbo.fn_CalculateBonus(Salary) AS Bonus
FROM Employees;

GO

-- =============================================
-- Exercise 5: Delete a User-Defined Function
-- Goal: Delete the fn_CalculateBonus function.
-- =============================================

DROP FUNCTION fn_CalculateBonus;

GO

-- Verify deletion (Attempting to check existence or recreate for subsequent exercises)
IF OBJECT_ID('dbo.fn_CalculateBonus', 'FN') IS NULL
    PRINT 'Function fn_CalculateBonus deleted successfully.';

GO

-- =============================================
-- Re-creating fn_CalculateBonus for Exercises 9 and 10
-- =============================================

CREATE FUNCTION fn_CalculateBonus (
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 0.10;
END;

GO

-- =============================================
-- Exercise 6: Execute a User-Defined Function
-- Goal: Execute the fn_CalculateAnnualSalary function for each employee.
-- =============================================

SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    Salary, 
    dbo.fn_CalculateAnnualSalary(Salary) AS AnnualSalary
FROM Employees;

GO

-- =============================================
-- Exercise 7: Return Data from a Scalar Function
-- Goal: Return the annual salary for a specific employee with EmployeeID = 1.
-- =============================================

SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    dbo.fn_CalculateAnnualSalary(Salary) AS AnnualSalary
FROM Employees
WHERE EmployeeID = 1;

GO

-- =============================================
-- Exercise 8: Return Data from a Table-Valued Function
-- Goal: Return employees from the Finance department (DepartmentID = 3) using fn_GetEmployeesByDepartment.
-- =============================================

SELECT * FROM dbo.fn_GetEmployeesByDepartment(3);

GO

-- =============================================
-- Exercise 9: Create a Nested User-Defined Function
-- Goal: Create a nested user-defined function to calculate the total compensation for an employee.
-- =============================================

CREATE FUNCTION fn_CalculateTotalCompensation (
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN dbo.fn_CalculateAnnualSalary(@Salary) + dbo.fn_CalculateBonus(@Salary);
END;

GO

-- Test Exercise 9: Select total compensation for each employee
SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    Salary, 
    dbo.fn_CalculateTotalCompensation(Salary) AS TotalCompensation
FROM Employees;

GO

-- =============================================
-- Exercise 10: Modify a Nested User-Defined Function
-- Goal: Modify fn_CalculateTotalCompensation function to use the updated fn_CalculateBonus (15% bonus).
-- =============================================

-- First update fn_CalculateBonus to 15%
ALTER FUNCTION fn_CalculateBonus (
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 0.15;
END;

GO

-- Alter nested function fn_CalculateTotalCompensation
ALTER FUNCTION fn_CalculateTotalCompensation (
    @Salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN dbo.fn_CalculateAnnualSalary(@Salary) + dbo.fn_CalculateBonus(@Salary);
END;

GO

-- Test Exercise 10: Select updated total compensation for each employee
SELECT 
    EmployeeID, 
    FirstName, 
    LastName, 
    Salary, 
    dbo.fn_CalculateBonus(Salary) AS Bonus15Percent,
    dbo.fn_CalculateAnnualSalary(Salary) AS AnnualSalary,
    dbo.fn_CalculateTotalCompensation(Salary) AS TotalCompensation
FROM Employees;

GO
