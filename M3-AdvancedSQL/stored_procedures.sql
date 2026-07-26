-- Employee Management System - Stored Procedures Hands-on Exercises

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
(1, 'John', 'Doe', 1, 5000.00, '2020-01-15'),
(2, 'Jane', 'Smith', 2, 6000.00, '2019-03-22'),
(3, 'Michael', 'Johnson', 3, 7000.00, '2018-07-30'),
(4, 'Emily', 'Davis', 4, 5500.00, '2021-11-05');

GO

-- =============================================
-- Exercise 1: Create a Stored Procedure
-- Goal: Create a stored procedure to retrieve employee details by department and insert employees.
-- =============================================

-- Stored Procedure to retrieve employee details by department
CREATE PROCEDURE sp_GetEmployeesByDepartment
    @DepartmentID INT
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DepartmentID
    FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;

GO

-- Stored Procedure to insert a new employee
CREATE PROCEDURE sp_InsertEmployee
    @EmployeeID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @DepartmentID INT,
    @Salary DECIMAL(10,2),
    @JoinDate DATE
AS
BEGIN
    INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate)
    VALUES (@EmployeeID, @FirstName, @LastName, @DepartmentID, @Salary, @JoinDate);
END;

GO

-- =============================================
-- Exercise 2: Modify a Stored Procedure
-- Goal: Modify the stored procedure to include employee salary in the result.
-- =============================================

ALTER PROCEDURE sp_GetEmployeesByDepartment
    @DepartmentID INT
AS
BEGIN
    SELECT EmployeeID, FirstName, LastName, DepartmentID, Salary
    FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;

GO

-- =============================================
-- Exercise 3: Delete a Stored Procedure
-- Goal: Delete the stored procedure created in Exercise 1.
-- =============================================

-- Command to drop stored procedure
DROP PROCEDURE sp_InsertEmployee;

GO

-- =============================================
-- Exercise 4: Execute a Stored Procedure
-- Goal: Execute the stored procedure to retrieve employee details for a specific department.
-- =============================================

EXEC sp_GetEmployeesByDepartment @DepartmentID = 1;

GO

-- =============================================
-- Exercise 5: Return Data from a Stored Procedure
-- Goal: Create a stored procedure that returns the total number of employees in a department.
-- =============================================

CREATE PROCEDURE sp_GetEmployeeCountByDepartment
    @DepartmentID INT
AS
BEGIN
    SELECT COUNT(*) AS TotalEmployees
    FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;

GO

-- Execution Example:
EXEC sp_GetEmployeeCountByDepartment @DepartmentID = 2;

GO

-- =============================================
-- Exercise 6: Use Output Parameters in a Stored Procedure
-- Goal: Create a stored procedure that returns the total salary of employees in a department using an output parameter.
-- =============================================

CREATE PROCEDURE sp_GetTotalSalaryByDepartment
    @DepartmentID INT,
    @TotalSalary DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @TotalSalary = SUM(Salary)
    FROM Employees
    WHERE DepartmentID = @DepartmentID;
END;

GO

-- Execution Example for Output Parameter:
DECLARE @TotalSalaryResult DECIMAL(10,2);
EXEC sp_GetTotalSalaryByDepartment @DepartmentID = 2, @TotalSalary = @TotalSalaryResult OUTPUT;
SELECT @TotalSalaryResult AS TotalSalaryForDepartment;

GO

-- =============================================
-- Exercise 7: Create a Stored Procedure with Multiple Parameters
-- Goal: Create a stored procedure to update employee salary.
-- =============================================

CREATE PROCEDURE sp_UpdateEmployeeSalary
    @EmployeeID INT,
    @Salary DECIMAL(10,2)
AS
BEGIN
    UPDATE Employees
    SET Salary = @Salary
    WHERE EmployeeID = @EmployeeID;
END;

GO

-- Execution Example:
EXEC sp_UpdateEmployeeSalary 1, 5500.00;

GO

-- =============================================
-- Exercise 8: Create a Stored Procedure with Conditional Logic
-- Goal: Create a stored procedure to give a bonus to employees based on their department.
-- =============================================

CREATE PROCEDURE sp_GiveBonus
    @DepartmentID INT,
    @BonusAmount DECIMAL(10,2)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = @DepartmentID)
    BEGIN
        UPDATE Employees
        SET Salary = Salary + @BonusAmount
        WHERE DepartmentID = @DepartmentID;
    END
    ELSE
    BEGIN
        PRINT 'Department does not exist.';
    END
END;

GO

-- Execution Example:
EXEC sp_GiveBonus 1, 500.00;

GO

-- =============================================
-- Exercise 9: Use Transactions in a Stored Procedure
-- Goal: Create a stored procedure that updates employee salaries and uses a transaction to ensure data integrity.
-- =============================================

CREATE PROCEDURE sp_UpdateSalaryWithTransaction
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        UPDATE Employees
        SET Salary = @NewSalary
        WHERE EmployeeID = @EmployeeID;
        
        COMMIT TRANSACTION;
        PRINT 'Salary updated successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Transaction rolled back due to error.';
    END CATCH
END;

GO

-- Execution Example:
EXEC sp_UpdateSalaryWithTransaction @EmployeeID = 2, @NewSalary = 6500.00;

GO

-- =============================================
-- Exercise 10: Use Dynamic SQL in a Stored Procedure
-- Goal: Create a stored procedure that uses dynamic SQL to retrieve employee details based on a flexible filter.
-- =============================================

CREATE PROCEDURE sp_GetEmployeesDynamic
    @FilterColumn NVARCHAR(50),
    @FilterValue NVARCHAR(100)
AS
BEGIN
    DECLARE @SQL NVARCHAR(MAX);
    
    SET @SQL = 'SELECT EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate FROM Employees WHERE ' 
               + QUOTENAME(@FilterColumn) + ' = @Value';
               
    EXEC sp_executesql @SQL, N'@Value NVARCHAR(100)', @Value = @FilterValue;
END;

GO

-- Execution Example:
EXEC sp_GetEmployeesDynamic @FilterColumn = 'DepartmentID', @FilterValue = '3';

GO

-- =============================================
-- Exercise 11: Handle Errors in a Stored Procedure
-- Goal: Create a stored procedure that handles errors and returns a custom error message.
-- =============================================

CREATE PROCEDURE sp_UpdateSalaryWithErrorHandling
    @EmployeeID INT,
    @NewSalary DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        IF @NewSalary < 0
        BEGIN
            RAISERROR('Salary cannot be negative.', 16, 1);
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM Employees WHERE EmployeeID = @EmployeeID)
        BEGIN
            RAISERROR('Employee ID not found.', 16, 1);
            RETURN;
        END

        UPDATE Employees
        SET Salary = @NewSalary
        WHERE EmployeeID = @EmployeeID;

        PRINT 'Employee salary updated successfully.';
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_MESSAGE() AS CustomErrorMessage;
    END CATCH
END;

GO

-- Execution Example:
EXEC sp_UpdateSalaryWithErrorHandling @EmployeeID = 1, @NewSalary = 5800.00;

GO
