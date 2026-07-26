-- Employee Management System - Triggers Hands-on Exercises

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
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing');

INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate) VALUES
(1, 'John', 'Doe', 1, 5000.00, '2022-01-15'),
(2, 'Jane', 'Smith', 2, 6000.00, '2021-03-22'),
(3, 'Michael', 'Johnson', 3, 7000.00, '2020-07-30'),
(4, 'Emily', 'Davis', 4, 5500.00, '2019-11-05');

GO

-- =============================================
-- Exercise 1: Create an After Trigger
-- Goal: Create an AFTER trigger to log salary changes in the Employees table.
-- =============================================

-- Step 1: Create table EmployeeChanges to store change logs
CREATE TABLE EmployeeChanges (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT,
    OldSalary DECIMAL(10,2),
    NewSalary DECIMAL(10,2),
    ChangeDate DATETIME DEFAULT GETDATE()
);

GO

-- Step 2: Create AFTER UPDATE trigger on Employees
CREATE TRIGGER trg_AfterSalaryUpdate
ON Employees
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Salary)
    BEGIN
        INSERT INTO EmployeeChanges (EmployeeID, OldSalary, NewSalary, ChangeDate)
        SELECT 
            d.EmployeeID, 
            d.Salary AS OldSalary, 
            i.Salary AS NewSalary, 
            GETDATE()
        FROM deleted d
        JOIN inserted i ON d.EmployeeID = i.EmployeeID;
    END
END;

GO

-- Testing Exercise 1: Update salary to verify trigger logging
UPDATE Employees SET Salary = 5500.00 WHERE EmployeeID = 1;
SELECT * FROM EmployeeChanges;

GO

-- =============================================
-- Exercise 2: Create an Instead of Trigger
-- Goal: Create an INSTEAD OF trigger to prevent deletions from the Employees table.
-- =============================================

CREATE TRIGGER trg_InsteadOfDeleteEmployee
ON Employees
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Deletion of employee records is strictly prohibited!', 16, 1);
END;

GO

-- Testing Exercise 2: Attempting deletion (Trigger will intercept and prevent deletion)
-- DELETE FROM Employees WHERE EmployeeID = 1;

GO

-- =============================================
-- Exercise 3: Create a Logon Trigger
-- Goal: Create a LOGON trigger to restrict access to the database during maintenance hours (2 AM to 3 AM).
-- =============================================

CREATE TRIGGER trg_RestrictLoginMaintenance
ON ALL SERVER
FOR LOGON
AS
BEGIN
    -- Check if current time is between 02:00 AM and 03:00 AM
    IF DATEPART(HOUR, GETDATE()) = 2
    BEGIN
        RAISERROR('Database is currently under maintenance (2:00 AM - 3:00 AM). Logins are restricted.', 16, 1);
        ROLLBACK;
    END
END;

GO

-- Disable / Drop Logon trigger after demonstration to avoid blocking server access
DISABLE TRIGGER trg_RestrictLoginMaintenance ON ALL SERVER;
GO

-- =============================================
-- Exercise 4: Modify a Trigger using SSMS (SQL Representation)
-- Goal: Modify an existing trigger to update its logic using ALTER TRIGGER.
-- =============================================

ALTER TRIGGER trg_AfterSalaryUpdate
ON Employees
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Salary)
    BEGIN
        INSERT INTO EmployeeChanges (EmployeeID, OldSalary, NewSalary, ChangeDate)
        SELECT 
            d.EmployeeID, 
            d.Salary AS OldSalary, 
            i.Salary AS NewSalary, 
            GETDATE()
        FROM deleted d
        JOIN inserted i ON d.EmployeeID = i.EmployeeID
        WHERE d.Salary <> i.Salary; -- Ensure log is added only if salary actually changed
    END
END;

GO

-- =============================================
-- Exercise 5: Delete a Trigger
-- Goal: Delete an existing trigger from the Employees table.
-- =============================================

DROP TRIGGER trg_InsteadOfDeleteEmployee;

GO

-- Verify deletion
IF NOT EXISTS (SELECT 1 FROM sys.triggers WHERE name = 'trg_InsteadOfDeleteEmployee')
    PRINT 'Trigger trg_InsteadOfDeleteEmployee deleted successfully.';

GO

-- =============================================
-- Exercise 6: Create a Trigger to Update a Computed Column
-- Goal: Create a trigger to update AnnualSalary column whenever Salary is updated.
-- =============================================

-- Step 1: Add new column AnnualSalary to Employees table
ALTER TABLE Employees 
ADD AnnualSalary DECIMAL(10,2);

GO

-- Step 2: Create trigger to update AnnualSalary on INSERT or UPDATE of Salary
CREATE TRIGGER trg_UpdateAnnualSalary
ON Employees
AFTER INSERT, UPDATE
AS
BEGIN
    IF UPDATE(Salary)
    BEGIN
        UPDATE e
        SET e.AnnualSalary = i.Salary * 12
        FROM Employees e
        JOIN inserted i ON e.EmployeeID = i.EmployeeID;
    END
END;

GO

-- Testing Exercise 6: Test insertion and update to verify computed AnnualSalary
UPDATE Employees SET Salary = 7500.00 WHERE EmployeeID = 3;
SELECT EmployeeID, FirstName, LastName, Salary, AnnualSalary FROM Employees WHERE EmployeeID = 3;

GO
