

--	EXEC[UTE]


EXEC ('SELECT * FROM Production.Product');


DECLARE @TabloAd SYSNAME ='Sales.SalesOrderHeader';
EXECUTE ('SELECT * FROM ' + @TabloAd);


DECLARE @SQL VARCHAR(256); 
SET @SQL = 'SELECT * FROM Production.Product';
EXEC (@SQL);


DECLARE @TakmaAd VARCHAR(6) = 'ÜrünAd';
EXEC ('SELECT Name AS ' + @TakmaAd + ' FROM Production.Product');


DECLARE @table VARCHAR(128);
DECLARE @schema VARCHAR(128);
DECLARE @column VARCHAR(128);
DECLARE @exp VARCHAR(4);
DECLARE @value VARCHAR(128);

SET @schema = 'Production'
SET @table  = 'Product'
SET @column = 'ProductID'
SET @exp    = '='
SET @value  = '1'

EXEC('SELECT * FROM ' + @schema + '.' + @table + ' WHERE ' +@column
							   +@exp
							   +@value);


SELECT * FROM Production.Product WHERE ProductID = 1



SET @schema = 'Person'
SET @table  = 'Person'
SET @column = 'BusinessEntityID'
SET @exp    = '<='
SET @value  = '7'



CREATE TABLE DynamicSQL
(
	TableID	INT IDENTITY NOT NULL CONSTRAINT PKDynSQL PRIMARY KEY,
	SchemaName	VARCHAR(150),
	TableName	VARCHAR(150),
	Create_Date SMALLDATETIME
);



INSERT INTO DynamicSQL
SELECT S.Name AS SchemaName, T.Name AS TableName, T.Create_date AS OTarih
FROM Sys.Schemas S
JOIN Sys.Tables T
ON S.Schema_ID = T.Schema_ID;



SELECT * FROM DynamicSQL;


DECLARE @SchemaName VARCHAR(128); 
DECLARE @TableName VARCHAR(128);

SELECT @SchemaName = SchemaName, @TableName = TableName 
FROM DynamicSQL WHERE TableID = 7;

EXEC ('SELECT * FROM ' + @SchemaName + '.' + @TableName);


--	EXEC ile Stored Procedure Kullanýmý


CREATE PROC pr_ProcedureCall(
	@sp_ad   VARCHAR(2000)
)
AS
EXEC (@sp_ad);



pr_ProcedureCall 'sp_lock';


EXEC pr_ProcedureCall 'sp_lock';



--	Dinamik SQL Güvenlik Sorunsalý


pr_ProcedureCall 'sp_lock';


pr_ProcedureCall 'USE DIJIBIL; DROP TABLE Makaleler';


CREATE PROCEDURE sp_ProductDynamicSP(
	@val	VARCHAR(10)
)
AS
EXEC('SELECT Name, ProductNumber
      FROM Production.Product
      WHERE Name LIKE ''%' + @val + '%''');



EXEC sp_ProductDynamicSP 'jus'


EXEC sp_ProductDynamicSP 'a'	



CREATE PROCEDURE sp_GetProductByIDdynSP(
	@productID	VARCHAR(10)
)
AS
EXEC('SELECT Name, ProductNumber
      FROM Production.Product
      WHERE ProductID = ' + @productID + '');



EXEC sp_GetProductByIDdynSP 1;


--	EXEC Fonksiyonu Ýçerisinde Tür Dönüþümü


CREATE PROCEDURE sp_GetProductByIDdynSP( 	@productID	INT )
AS
EXEC('SELECT Name, ProductNumber
      FROM Production.Product
      WHERE ProductID = ' + CONVERT(VARCHAR(5), @productID));



CREATE PROCEDURE sp_GetProductByIDdynSP(	@productID	INT )
AS
DECLARE @val VARCHAR(5) = CONVERT(VARCHAR(5), @productID);
EXEC('SELECT Name, ProductNumber
	FROM Production.Product
	WHERE ProductID = ' + @val);



EXEC sp_GetProductByIDdynSP 1;



USE AdventureWorks
GO
DECLARE @cmd VARCHAR(4000);
SET @cmd = 'EXEC spCurrDB';
SET @cmd = 'SELECT ''Geçerli Veritabaný: [''+D.NAME+'']'''
+ ' FROM master..sysdatabases d, master..sysprocesses p '
+ ' WHERE p.spid = @@SPID and p.dbid = d.dbid ';
EXEC (@cmd);
EXEC (N'USE master;'+@cmd);
EXEC (@cmd);



--	SP_ExecuteSQL ile Dinamik Sorgu Çalýþtýrmak



EXECUTE sp_executeSQL N'SELECT * FROM Purchasing.PurchaseOrderHeader';



DECLARE @SQL NVARCHAR(MAX), 
	  @ParmDefinition NVARCHAR(1024)
DECLARE @ListPrice MONEY = 2000.0, 
	  @LastProduct VARCHAR(64)
SET @SQL = N'SELECT @pLastProduct = MAX(Name)
             FROM AdventureWorks2012.Production.Product
             WHERE ListPrice >= @pListPrice'
SET @ParmDefinition = N'@pListPrice MONEY, 
    @pLastProduct VARCHAR(64) OUTPUT'

EXECUTE sp_executeSQL @SQL, @ParmDefinition, @pListPrice = @ListPrice,
			    @pLastProduct = @LastProduct OUTPUT

SELECT [ListPrice >=] = @ListPrice, LastProduct = @LastProduct;



DECLARE @SQL NVARCHAR(MAX), @dbName SYSNAME;
DECLARE DBcursor CURSOR  FOR
 SELECT NAME FROM     master.dbo.sysdatabases
 WHERE  NAME NOT IN ('master','tempdb','model','msdb')
   AND  DATABASEPROPERTYEX(NAME,'status') = 'ONLINE' ORDER BY NAME;
OPEN DBcursor; FETCH  DBcursor   INTO @dbName;
 WHILE (@@FETCH_STATUS = 0)
   BEGIN
    DECLARE @dbContext NVARCHAR(256) = @dbName+'.dbo.'+'sp_executeSQL'
    SET @SQL = 'SELECT ''Database: ' + @dbName +
               ' TABLE COUNT'' = COUNT(*) FROM sys.tables';
    PRINT @SQL;
    EXEC @dbContext @SQL;
    FETCH  DBcursor INTO @dbName;
   END;
CLOSE DBcursor; DEALLOCATE DBcursor;


--	Dinamik SQL ile Sýralama Ýþlemi


DECLARE @SQL NVARCHAR(MAX) = 'SELECT ProductID, Name, ListPrice, Color
					 FROM Production.Product ORDER BY Name '
DECLARE @Collation NVARCHAR(MAX);
SET @Collation = 'COLLATE SQL_Latin1_General_CP1250_CS_AS'
SET @SQL = @SQL + @Collation
PRINT @SQL
EXEC sp_executeSQL @SQL;



--	SP_ExecuteSQL ile Stored Procedure Kullanýmý


CREATE PROCEDURE pr_UrunAra @ProductName VARCHAR(32)  = NULL
AS
  BEGIN
    DECLARE  @SQL NVARCHAR(MAX)
    SELECT @SQL = ' SELECT ProductID, ProductName = Name, 
			  Color, ListPrice ' + CHAR(10)+
                  ' FROM Production.Product' + CHAR(10)+
                  ' WHERE 1 = 1 ' + CHAR(10)
    IF @ProductName IS NOT NULL
      SELECT @SQL = @SQL + ' AND Name LIKE @pProductName'
    PRINT @SQL 

    EXEC sp_executesql @SQL, N'@pProductName VARCHAR(32)', @ProductName 
  END
GO


EXEC pr_UrunAra '%bike%';



--	SP_ExecuteSQL ile INSERT Ýþlemi


CREATE TABLE #Product(ProductID int, ProductName varchar(64));
INSERT #Product
EXEC sp_executeSQL N'SELECT ProductID, Name FROM Production.Product';
SELECT * FROM #Product ORDER BY ProductName;
GO
DROP TABLE #Product;


--	SP_ExecuteSQL ile Veritabaný Oluþturmak



CREATE PROC pr_CreateDB @DBName SYSNAME
AS
BEGIN
  DECLARE @SQL NVARCHAR(255) = 'CREATE DATABASE ' + @DBName;
  EXEC sp_executeSQL @SQL;
END;


EXEC pr_CreateDB 'ornek_db';














