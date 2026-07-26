-- Employee Management System - Error Handling Exercises (TRY...CATCH, THROW, RAISERROR)

-- =============================================
-- Database Schema Setup
-- =============================================

CREATE TABLE Departments ( 
    DepartmentID INT PRIMARY KEY, 
    DepartmentName VARCHAR(100) NOT NULL 
);

CREATE TABLE Employees ( 
    EmployeeID INT PRIMARY KEY, 
    FirstName VARCHAR(50), 
    LastName VARCHAR(50), 
    Email VARCHAR(100) UNIQUE, 
    Salary DECIMAL(10, 2), 
    DepartmentID INT, 
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) 
);

CREATE TABLE AuditLog ( 
    LogID INT IDENTITY(1,1) PRIMARY KEY, 
    Action VARCHAR(100), 
    ErrorMessage VARCHAR(4000), 
    ActionDate DATETIME DEFAULT GETDATE() 
);

GO

-- =============================================
-- Sample Data Setup
-- =============================================

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT');

INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', 5000.00, 1),
(2, 'Jane', 'Smith', 'jane.smith@example.com', 6000.00, 2);

GO

-- =============================================
-- Question 1: Basic TRY...CATCH for Error Logging
-- Scenario: Insert a new employee; catch errors (e.g., duplicate email) and log to AuditLog.
-- =============================================

CREATE PROCEDURE AddEmployee_Basic
    @EmployeeID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @Salary DECIMAL(10, 2),
    @DepartmentID INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID)
        VALUES (@EmployeeID, @FirstName, @LastName, @Email, @Salary, @DepartmentID);

        PRINT 'Employee added successfully.';
    END TRY
    BEGIN CATCH
        INSERT INTO AuditLog (Action, ErrorMessage, ActionDate)
        VALUES ('AddEmployee Failed', ERROR_MESSAGE(), GETDATE());

        PRINT 'Error occurred while adding employee. Logged to AuditLog.';
    END CATCH
END;

GO

-- Test Question 1: Attempt duplicate email insert
EXEC AddEmployee_Basic 3, 'Duplicate', 'User', 'john.doe@example.com', 4500.00, 1;
SELECT * FROM AuditLog;

GO

-- =============================================
-- Question 2: Using THROW to Re-raise Errors
-- Scenario: Log the error into AuditLog, then use THROW to re-raise it.
-- =============================================

CREATE PROCEDURE AddEmployee_WithThrow
    @EmployeeID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @Salary DECIMAL(10, 2),
    @DepartmentID INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID)
        VALUES (@EmployeeID, @FirstName, @LastName, @Email, @Salary, @DepartmentID);
    END TRY
    BEGIN CATCH
        -- Log error to AuditLog
        INSERT INTO AuditLog (Action, ErrorMessage, ActionDate)
        VALUES ('AddEmployee THROW Log', ERROR_MESSAGE(), GETDATE());

        -- Re-raise error to caller
        THROW;
    END CATCH
END;

GO

-- =============================================
-- Question 3: Custom Error with RAISERROR
-- Scenario: Validate that Salary must be greater than 0 before insertion.
-- =============================================

CREATE PROCEDURE AddEmployee_ValidateSalary
    @EmployeeID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @Salary DECIMAL(10, 2),
    @DepartmentID INT
AS
BEGIN
    BEGIN TRY
        -- Check if Salary <= 0
        IF @Salary <= 0
        BEGIN
            RAISERROR('Salary must be greater than zero.', 16, 1);
            RETURN;
        END

        INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID)
        VALUES (@EmployeeID, @FirstName, @LastName, @Email, @Salary, @DepartmentID);

        PRINT 'Employee added successfully.';
    END TRY
    BEGIN CATCH
        INSERT INTO AuditLog (Action, ErrorMessage, ActionDate)
        VALUES ('AddEmployee Salary Validation', ERROR_MESSAGE(), GETDATE());

        THROW;
    END CATCH
END;

GO

-- Test Question 3: Attempt inserting employee with Salary <= 0
-- EXEC AddEmployee_ValidateSalary 4, 'Zero', 'Salary', 'zero@example.com', 0, 1;

GO

-- =============================================
-- Question 4: Nested TRY...CATCH with RAISERROR
-- Scenario: Update employee department; handle invalid department with nested TRY...CATCH.
-- =============================================

CREATE PROCEDURE TransferEmployee
    @EmployeeID INT,
    @NewDepartmentID INT
AS
BEGIN
    -- Outer TRY Block
    BEGIN TRY
        -- Inner TRY Block for Department Validation
        BEGIN TRY
            IF NOT EXISTS (SELECT 1 FROM Departments WHERE DepartmentID = @NewDepartmentID)
            BEGIN
                RAISERROR('Department ID %d does not exist.', 16, 1, @NewDepartmentID);
            END

            UPDATE Employees
            SET DepartmentID = @NewDepartmentID
            WHERE EmployeeID = @EmployeeID;

            PRINT 'Employee transferred successfully.';
        END TRY
        BEGIN CATCH
            -- Inner Catch: Log error to AuditLog and re-raise to outer catch
            INSERT INTO AuditLog (Action, ErrorMessage, ActionDate)
            VALUES ('TransferEmployee Inner Catch', ERROR_MESSAGE(), GETDATE());

            THROW; -- Propagate to outer catch
        END CATCH
    END TRY
    BEGIN CATCH
        -- Outer Catch: Log final handler action
        PRINT 'Outer Catch: Handled transferred error -> ' + ERROR_MESSAGE();
    END CATCH
END;

GO

-- Test Question 4: Transfer employee to invalid department ID 99
EXEC TransferEmployee @EmployeeID = 1, @NewDepartmentID = 99;
SELECT * FROM AuditLog;

GO

-- =============================================
-- Question 5: Logging All Errors in a Transaction
-- Scenario: Batch insert employees inside a transaction; rollback and log error if any fails.
-- =============================================

CREATE PROCEDURE BatchInsertEmployees
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Insert Record 1 (Valid)
        INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID)
        VALUES (10, 'Alice', 'Green', 'alice@example.com', 5200.00, 1);

        -- Insert Record 2 (Invalid - Duplicate Email causes failure)
        INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID)
        VALUES (11, 'Bob', 'Brown', 'john.doe@example.com', 4800.00, 2);

        COMMIT TRANSACTION;
        PRINT 'Batch insert completed successfully.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        INSERT INTO AuditLog (Action, ErrorMessage, ActionDate)
        VALUES ('BatchInsert Failed & Rolled Back', ERROR_MESSAGE(), GETDATE());

        PRINT 'Batch insert failed and transaction rolled back. Error logged to AuditLog.';
    END CATCH
END;

GO

-- Test Question 5: Run batch insert
EXEC BatchInsertEmployees;
SELECT * FROM AuditLog;

GO

-- =============================================
-- Question 6: Dynamic RAISERROR with Severity and State
-- Scenario: Raise warning (severity 10) if salary < 1000; raise error (severity 16) if negative.
-- =============================================

CREATE PROCEDURE AddEmployee_DynamicSeverity
    @EmployeeID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @Salary DECIMAL(10, 2),
    @DepartmentID INT
AS
BEGIN
    BEGIN TRY
        -- Check for negative salary (Error level: 16)
        IF @Salary < 0
        BEGIN
            RAISERROR('Error: Salary cannot be negative.', 16, 1);
            RETURN;
        END

        -- Check for low salary (Warning level: 10 - Info only, doesn't jump to CATCH)
        IF @Salary < 1000
        BEGIN
            RAISERROR('Warning: Salary is too low (< 1000).', 10, 1);
        END

        INSERT INTO Employees (EmployeeID, FirstName, LastName, Email, Salary, DepartmentID)
        VALUES (@EmployeeID, @FirstName, @LastName, @Email, @Salary, @DepartmentID);

        PRINT 'Employee processed successfully.';
    END TRY
    BEGIN CATCH
        INSERT INTO AuditLog (Action, ErrorMessage, ActionDate)
        VALUES ('AddEmployee Severity 16 Error', ERROR_MESSAGE(), GETDATE());

        PRINT 'Severity 16 Error caught and logged.';
    END CATCH
END;

GO

-- Test Question 6: Low salary warning vs negative salary error
EXEC AddEmployee_DynamicSeverity 5, 'Low', 'Pay', 'lowpay@example.com', 500.00, 1;
EXEC AddEmployee_DynamicSeverity 6, 'Negative', 'Pay', 'negpay@example.com', -100.00, 1;

SELECT * FROM AuditLog;

GO
