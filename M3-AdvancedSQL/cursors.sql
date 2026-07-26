-- Employee Management System - SQL Server Cursor Exercises

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
(3, 'Bob', 'Johnson', 3, 5500.00, '2021-07-30');

GO

-- =============================================
-- Exercise 1: Create a Cursor
-- Goal: Create a cursor to iterate over all employees and print their details.
-- =============================================

DECLARE 
    @EmployeeID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @DepartmentID INT,
    @Salary DECIMAL(10,2),
    @JoinDate DATE;

-- 1. Declare cursor
DECLARE emp_cursor CURSOR FOR
SELECT EmployeeID, FirstName, LastName, DepartmentID, Salary, JoinDate
FROM Employees;

-- 2. Open cursor
OPEN emp_cursor;

-- 3. Fetch initial row
FETCH NEXT FROM emp_cursor INTO @EmployeeID, @FirstName, @LastName, @DepartmentID, @Salary, @JoinDate;

PRINT '================ EMPLOYEE DETAILS ================';

-- 4. Loop through each row
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'ID: ' + CAST(@EmployeeID AS VARCHAR(10)) +
          ' | Name: ' + @FirstName + ' ' + @LastName +
          ' | DeptID: ' + CAST(@DepartmentID AS VARCHAR(10)) +
          ' | Salary: ' + CAST(@Salary AS VARCHAR(15)) +
          ' | JoinDate: ' + CAST(@JoinDate AS VARCHAR(15));
    
    FETCH NEXT FROM emp_cursor INTO @EmployeeID, @FirstName, @LastName, @DepartmentID, @Salary, @JoinDate;
END;

-- 5. Close and deallocate cursor
CLOSE emp_cursor;
DEALLOCATE emp_cursor;

GO

-- =============================================
-- Exercise 2: Types of Cursors
-- Goal: Understand and demonstrate the 4 types of cursors in SQL Server.
-- =============================================

DECLARE 
    @EmpID INT,
    @FName VARCHAR(50),
    @LName VARCHAR(50);

-- ---------------------------------------------
-- 1. STATIC Cursor
-- Snapshot of data. Inserts/updates to underlying table are NOT visible in static cursor.
-- ---------------------------------------------
PRINT '--- 1. STATIC CURSOR ---';

DECLARE static_emp_cursor CURSOR STATIC FOR
SELECT EmployeeID, FirstName, LastName FROM Employees;

OPEN static_emp_cursor;
FETCH NEXT FROM static_emp_cursor INTO @EmpID, @FName, @LName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Static Fetch -> ID: ' + CAST(@EmpID AS VARCHAR) + ' | Name: ' + @FName + ' ' + @LName;
    FETCH NEXT FROM static_emp_cursor INTO @EmpID, @FName, @LName;
END;

CLOSE static_emp_cursor;
DEALLOCATE static_emp_cursor;

GO

-- ---------------------------------------------
-- 2. DYNAMIC Cursor
-- Reflects all changes (INSERT, UPDATE, DELETE) made to the data while iterating.
-- Supports scrolling back and forth.
-- ---------------------------------------------
PRINT '--- 2. DYNAMIC CURSOR ---';

DECLARE 
    @EmpID INT,
    @FName VARCHAR(50),
    @LName VARCHAR(50);

DECLARE dynamic_emp_cursor CURSOR DYNAMIC FOR
SELECT EmployeeID, FirstName, LastName FROM Employees;

OPEN dynamic_emp_cursor;
FETCH FIRST FROM dynamic_emp_cursor INTO @EmpID, @FName, @LName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Dynamic Fetch -> ID: ' + CAST(@EmpID AS VARCHAR) + ' | Name: ' + @FName + ' ' + @LName;
    FETCH NEXT FROM dynamic_emp_cursor INTO @EmpID, @FName, @LName;
END;

CLOSE dynamic_emp_cursor;
DEALLOCATE dynamic_emp_cursor;

GO

-- ---------------------------------------------
-- 3. FORWARD-ONLY Cursor
-- Default fast cursor. Scrolls only sequentially from first to last row.
-- ---------------------------------------------
PRINT '--- 3. FORWARD-ONLY CURSOR ---';

DECLARE 
    @EmpID INT,
    @FName VARCHAR(50),
    @LName VARCHAR(50);

DECLARE forward_only_emp_cursor CURSOR FORWARD_ONLY FOR
SELECT EmployeeID, FirstName, LastName FROM Employees;

OPEN forward_only_emp_cursor;
FETCH NEXT FROM forward_only_emp_cursor INTO @EmpID, @FName, @LName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Forward-Only Fetch -> ID: ' + CAST(@EmpID AS VARCHAR) + ' | Name: ' + @FName + ' ' + @LName;
    FETCH NEXT FROM forward_only_emp_cursor INTO @EmpID, @FName, @LName;
END;

CLOSE forward_only_emp_cursor;
DEALLOCATE forward_only_emp_cursor;

GO

-- ---------------------------------------------
-- 4. KEYSET-DRIVEN Cursor
-- Set of unique keys stored in tempdb. Column modifications are visible, but new inserted rows are NOT visible.
-- ---------------------------------------------
PRINT '--- 4. KEYSET-DRIVEN CURSOR ---';

DECLARE 
    @EmpID INT,
    @FName VARCHAR(50),
    @LName VARCHAR(50);

DECLARE keyset_emp_cursor CURSOR KEYSET FOR
SELECT EmployeeID, FirstName, LastName FROM Employees;

OPEN keyset_emp_cursor;
FETCH NEXT FROM keyset_emp_cursor INTO @EmpID, @FName, @LName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Keyset Fetch -> ID: ' + CAST(@EmpID AS VARCHAR) + ' | Name: ' + @FName + ' ' + @LName;
    FETCH NEXT FROM keyset_emp_cursor INTO @EmpID, @FName, @LName;
END;

CLOSE keyset_emp_cursor;
DEALLOCATE keyset_emp_cursor;

GO

/*
=============================================================================
Comparison of Cursor Types in SQL Server:
-----------------------------------------------------------------------------
1. STATIC:
   - Builds a temporary copy of data in tempdb.
   - Updates, deletes, or inserts after cursor open are NOT visible.
   - Supports scrolling (FORWARD / PRIOR / FIRST / LAST).

2. DYNAMIC:
   - Reflects all underlying data modifications (updates, inserts, deletes) dynamically.
   - Full scrolling support. Higher overhead on system resources.

3. FORWARD_ONLY:
   - Only allows FETCH NEXT scrolling from start to end.
   - Lowest memory/resource overhead, making it the default and fastest cursor type.

4. KEYSET:
   - Key values stored in tempdb keyset table.
   - Updates to non-key columns ARE visible.
   - New inserted rows are NOT visible.
=============================================================================
*/
