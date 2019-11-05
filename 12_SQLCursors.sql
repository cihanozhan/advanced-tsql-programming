

-	Cursor'un Ömrü


DECLARE @ProductID INT
DECLARE @Name	 VARCHAR(255)
DECLARE ProductCursor CURSOR FOR
	  SELECT ProductID, Name FROM Production.Product
OPEN ProductCursor
FETCH NEXT FROM ProductCursor INTO @ProductID, @Name
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT CAST(@ProductID AS VARCHAR) + '  -  ' + @Name
	FETCH NEXT FROM ProductCursor INTO @ProductID, @Name
END
CLOSE ProductCursor
DEALLOCATE ProductCursor


--	TYPE_WARNING


DECLARE ProductCursor CURSOR
GLOBAL
SCROLL
KEYSET
TYPE_WARNING		-- Dönüþtürme mesajýný verecek olan özellik
FOR
SELECT ProductID, Name FROM Production.Product

DECLARE @ProductID INT
DECLARE @Name	   VARCHAR(5)

OPEN ProductCursor

FETCH NEXT FROM ProductCursor INTO @ProductID, @Name

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT CAST(@ProductID AS VARCHAR) + ' ' +  @Name
	FETCH NEXT FROM ProductCursor INTO @ProductID, @Name
END

CLOSE ProductCursor
DEALLOCATE ProductCursor


--	Statik Cursor'ler


SELECT ProductID, Name INTO ProductCursorTable FROM Production.Product;


SELECT ProductID, Name INTO ProductCursorTable FROM Production.Product
DECLARE ProductCursor CURSOR
GLOBAL
SCROLL
STATIC
FOR
SELECT ProductID, Name FROM ProductCursorTable
DECLARE @ProductID INT
DECLARE @Name	  VARCHAR(30)
OPEN ProductCursor

FETCH NEXT FROM ProductCursor INTO @ProductID, @Name
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT CAST(@ProductID AS VARCHAR) + ' - ' + @Name
	FETCH NEXT FROM ProductCursor INTO @ProductID, @Name
END
UPDATE ProductCursorTable
SET Name = 'Update ile deðiþtirildi'
WHERE ProductID = 1
FETCH FIRST FROM ProductCursor INTO @ProductID, @Name
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT CAST(@ProductID AS VARCHAR) + ' - ' + @Name
	FETCH NEXT FROM ProductCursor INTO @ProductID, @Name
END
CLOSE ProductCursor
DEALLOCATE ProductCursor



--	Anahtar Takýmý ile Çalýþtýrýlan Cursor'ler


DECLARE @ProductID INT;
DECLARE @Name	  VARCHAR(30);
WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT CAST(@ProductID AS VARCHAR) + ' ' + @Name
	FETCH NEXT FROM ProductCursor INTO @ProductID, @Name
END
CLOSE ProductCursor

DEALLOCATE ProductCursor


--	FOR UPDATE


CREATE TABLE dbo.Employees(
    EmployeeID INT NOT NULL,
    Random_No  VARCHAR(50) NULL
) ON [PRIMARY]



SET NOCOUNT ON
DECLARE @Rec_ID   AS INT
SET @Rec_ID = 1

WHILE (@Rec_ID <= 100)
BEGIN
    INSERT INTO Employees
    SELECT @Rec_ID, NULL

    IF(@Rec_ID <= 100)
    BEGIN
        SET @Rec_ID = @Rec_ID + 1
        CONTINUE
    END
    ELSE
    BEGIN
        BREAK
    END
END
SET NOCOUNT OFF



SELECT EmployeeID, Random_No FROM Employees;



ALTER TABLE dbo.Employees
ADD CONSTRAINT PK_Employees PRIMARY KEY CLUSTERED 
(
    EmployeeID ASC
)ON [PRIMARY]




SET NOCOUNT ON

DECLARE 
    @Employee_ID       INT, 
    @Random_No		VARCHAR(50),
    @TEMP              VARCHAR(50)
DECLARE EmployeeCursor CURSOR FOR
SELECT EmployeeID, Random_No FROM Employees FOR UPDATE OF Random_No
OPEN EmployeeCursor
FETCH NEXT FROM EmployeeCursor
INTO @Employee_ID, @Random_No
WHILE (@@FETCH_STATUS = 0)
BEGIN
    SELECT @TEMP =  FLOOR(RAND()*10000000000000)
    UPDATE Employees SET Random_No = @TEMP WHERE CURRENT OF EmployeeCursor
    FETCH NEXT FROM EmployeeCursor
    INTO @Employee_ID, @Random_No
END

CLOSE EmployeeCursor
DEALLOCATE EmployeeCursor

SET NOCOUNT OFF



SELECT EmployeeID, Random_No FROM Employees;
































































