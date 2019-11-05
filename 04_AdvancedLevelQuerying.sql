

--	Ýç Ýçe Alt Sorgular Oluþturmak

--	Tekil Deðerler Döndüren Ýç Ýçe Sorgular


SELECT 							 	 
DISTINCT SOH.OrderDate AS SiparisTarih, 
SOD.ProductID AS UrunNO
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesOrderDetail SOD
ON   SOH.SalesOrderID = SOD.SalesOrderID
WHERE OrderDate = '07/01/2005';



DECLARE @IlkSiparisTarih SMALLDATETIME;			 
SELECT  @IlkSiparisTarih = MIN(OrderDate) 
	  FROM Sales.SalesOrderHeader;
SELECT 
	DISTINCT SOH.OrderDate AS SiparisTarih, 
	SOD.ProductID AS UrunNO
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesOrderDetail SOD
ON   SOH.SalesOrderID = SOD.SalesOrderID
WHERE OrderDate = @IlkSiparisTarih;



SELECT 
	DISTINCT SOH.OrderDate AS SiparisTarih, 
	SOD.ProductID AS UrunNO
FROM Sales.SalesOrderHeader SOH
JOIN Sales.SalesOrderDetail SOD
ON   SOH.SalesOrderID = SOD.SalesOrderID
WHERE SOH.OrderDate = (SELECT MIN(OrderDate) 
			     FROM Sales.SalesOrderHeader);


--	Çoklu Sonuç Döndüren Ýç Ýçe Sorgular


SELECT PC.Name, PSC.Name 				
FROM Production.ProductCategory AS PC
JOIN Production.ProductSubCategory AS PSC
ON PC.ProductCategoryID = PSC.ProductCategoryID
WHERE PC.ProductCategoryID IN (1,2,3);



SELECT PC.Name, PSC.Name 
FROM Production.ProductCategory AS PC
JOIN Production.ProductSubCategory AS PSC
ON PC.ProductCategoryID = PSC.ProductCategoryID
WHERE PC.ProductCategoryID IN(
					SELECT ProductCategoryID 
					FROM Production.ProductCategory 
					WHERE ProductCategoryID = 1 
					OR ProductCategoryID = 2 
					OR ProductCategoryID = 3);


SELECT 							
	PP.BusinessEntityID, 
	PP.FirstName, 
	PP.LastName, 
	P.PhoneNumber
FROM Person.Person PP
JOIN Person.PersonPhone AS P
ON PP.BusinessEntityID = P.BusinessEntityID
WHERE P.BusinessEntityID IN (
				SELECT DISTINCT BusinessEntityID 
				FROM HumanResources.JobCandidate 
				WHERE BusinessEntityID IS NOT NULL);


SELECT 								
	PP.BusinessEntityID, 
	PP.FirstName, 
	PP.LastName, 
	P.PhoneNumber
FROM Person.Person PP
JOIN Person.PersonPhone AS P
ON PP.BusinessEntityID = P.BusinessEntityID
JOIN HumanResources.JobCandidate AS JC
ON P.BusinessEntityID = JC.BusinessEntityID
WHERE JC.BusinessEntityID IS NOT NULL;


--	Türetilmiþ Tablolar


SELECT MAX(Grup.KategoriAdet)				
FROM (
	SELECT 
		PC.ProductCategoryID, 
		COUNT(*) AS KategoriAdet 
	FROM 
		Production.ProductCategory PC
		INNER JOIN Production.ProductSubcategory PSC
		ON PC.ProductCategoryID = PSC.ProductCategoryID
	GROUP BY 
	PC.ProductCategoryID
) Grup



SELECT 
	PC.ProductCategoryID, 			
	COUNT(*) AS KategoriAdet 
FROM 
	Production.ProductCategory PC
INNER JOIN 
	Production.ProductSubcategory PSC
	ON PC.ProductCategoryID = PSC.ProductCategoryID
GROUP BY 
	PC.ProductCategoryID



SELECT MAX(Grup.KategoriAdet)				
FROM (
SELECT PC.ProductCategoryID, 
COUNT(*) FROM Production.ProductCategory PC
INNER JOIN Production.ProductSubcategory PSC
ON PC.ProductCategoryID = PSC.ProductCategoryID
GROUP BY PC.ProductCategoryID
) Grup (ProductCategoryID, KategoriAdet)



SELECT MAX(Grup.KategoriAdet)			-- Hatalý Sorgu
FROM (
	SELECT PC.ProductCategoryID, 
	COUNT(*) FROM Production.ProductCategory PC
	INNER JOIN Production.ProductSubcategory PSC
	ON PC.ProductCategoryID = PSC.ProductCategoryID
	GROUP BY PC.ProductCategoryID
) Grup


--	SELECT Listesindeki Ýliþkili Alt Sorgular



SELECT 
	ProductID, 
	Name, 
	ListPrice, 
	(SELECT 
	Name 
	FROM Production.ProductSubcategory AS PSC
	WHERE PSC.ProductSubcategoryID = PP.ProductSubcategoryID) AS AltKategori
FROM 
	Production.Product AS PP;


--	WHERE Koþulundaki Ýliþkili Alt Sorgular


SELECT 
	SOH1.CustomerID, 
	SOH1.SalesOrderID, 
	SOH1.OrderDate
FROM 	Sales.SalesOrderHeader AS SOH1
WHERE SOH1.OrderDate = (SELECT MIN(SOH2.OrderDate) 
			      FROM Sales.SalesOrderHeader AS SOH2 
			      WHERE SOH2.CustomerID = SOH1.CustomerID)
ORDER BY SOH1.CustomerID;


--	EXISTS ve NOT EXISTS


SELECT 					
	PP.BusinessEntityID, 
	PP.FirstName, 
	PP.LastName, 
	P.PhoneNumber
FROM Person.Person PP
JOIN Person.PersonPhone AS P
ON PP.BusinessEntityID = P.BusinessEntityID
JOIN HumanResources.JobCandidate AS JC
ON P.BusinessEntityID = JC.BusinessEntityID
WHERE EXISTS(SELECT BusinessEntityID 
		 FROM HumanResources.JobCandidate AS JC 
		 WHERE JC.BusinessEntityID = PP.BusinessEntityID);


--	Veri Tiplerini Dönüþtürmek: CAST ve CONVERT


SELECT 'Ürün Kodu : ' 					
	  + CAST(ProductID AS VARCHAR) 
	  + ' - ' 
	  + 'Ürün Adý : ' + Name 
FROM Production.Product;


DECLARE @deger DECIMAL(5, 2);
SET @deger = 14.53;
SELECT CAST(CAST(@deger AS VARBINARY(20)) AS DECIMAL(10,5));


SELECT CONVERT(DECIMAL(10,5),			
CONVERT(VARBINARY(20), @deger));



--	Common Table Expressions(CTE)



;WITH CTEProduct(UrunNo, UrunAd, Renk) AS
(
	SELECT ProductID, Name, Color FROM Production.Product
	WHERE ProductID > 400 AND Color IS NOT NULL
)
SELECT * FROM CTEProduct;



WITH CTEProduct(UrunNo, UrunAd, Renk) AS
(
	SELECT ProductID, Name, Color FROM Production.Product
	WHERE ProductID > 400 AND Color IS NOT NULL
)
UPDATE CTEProduct SET UrunAd = 'Advanced SQL Server'
WHERE UrunNo = 461;



SELECT ProductID, Name, Color 
FROM Production.Product WHERE ProductID = 461;



WITH EnPahaliUrunCTE
AS
(
	SELECT TOP 1 ProductID, Name, ListPrice FROM Production.Product
	WHERE ListPrice > 0
	ORDER BY ListPrice ASC
),
EnUcuzUrunCTE
AS
(
	SELECT TOP 1 ProductID, Name, ListPrice FROM Production.Product
	ORDER BY ListPrice DESC
)
SELECT * FROM EnPahaliUrunCTE
 UNION
SELECT * FROM EnUcuzUrunCTE;



--	ROW_NUMBER()


SELECT ROW_NUMBER() OVER(ORDER BY ProductID) AS SatirNO,
	ProductID, Name, ListPrice 
FROM Production.Product;



--	RANK


SELECT Inv.ProductID, P.Name, 
	   Inv.LocationID, Inv.Quantity,
	   RANK() OVER(PARTITION BY Inv.LocationID 
			   ORDER BY Inv.Quantity DESC) AS 'RANK'
	   FROM Production.ProductInventory Inv 
	   INNER JOIN Production.Product P
	   ON Inv.ProductID = P.ProductID;


--	DENSE_RANK



SELECT Inv.ProductID, P.Name, 
	 Inv.LocationID, Inv.Quantity,
       DENSE_RANK() OVER(PARTITION BY Inv.LocationID 
	 ORDER BY Inv.Quantity DESC) AS 'DENS_RANK'
	 FROM Production.ProductInventory Inv 
	 INNER JOIN Production.Product P
	 ON Inv.ProductID = P.ProductID;


--	NTILE



SELECT P.FirstName, P.LastName, 
	 S.SalesYTD, A.PostalCode,
	 NTILE(4) OVER(ORDER BY SalesYTD DESC) AS 'NTILE'
FROM Sales.SalesPerson S
INNER JOIN Person.Person P ON S.BusinessEntityID = P.BusinessEntityID
INNER JOIN Person.Address A ON A.AddressID = P.BusinessEntityID;


--	TABLESAMPLE



SELECT TOP 20 Name, 				
	 ProductNumber, ReorderPoint
FROM Production.Product
ORDER BY NEWID();



SELECT * FROM Production.Product TABLESAMPLE(50 PERCENT);


SELECT * FROM Production.Product TABLESAMPLE(300 ROWS);


SELECT * FROM Production.Product TABLESAMPLE(600 ROWS)


SELECT FirstName, LastName 
FROM Person.Person TABLESAMPLE(300 ROWS)
REPEATABLE(300);


--	PIVOT


SELECT * FROM
(
	SELECT PSC.Name, P.Color, Envanter.Quantity
	FROM Production.Product P
	INNER JOIN Production.ProductSubcategory PSC
	ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
	LEFT JOIN Production.ProductInventory Envanter
	ON P.ProductID = Envanter.ProductID
)Tablom
PIVOT
(
	SUM(Quantity)
	FOR Color
	IN([Black],[Red],[Blue],[Multi],[Silver],[Grey],[White],[Yellow], 	   [Silver/Black])
)PivotTablom;



--	UNPIVOT


CREATE TABLE UnPvt(
	VendorID int, Col1 int, Col2 int,
    Col3 int, Col4 int, Col5 int);



INSERT INTO UnPvt VALUES (1,4,3,5,4,4);
INSERT INTO UnPvt VALUES (2,4,1,5,5,5);
INSERT INTO UnPvt VALUES (3,4,3,5,4,4);
INSERT INTO UnPvt VALUES (4,4,2,5,5,4);
INSERT INTO UnPvt VALUES (5,5,1,5,5,5);


SELECT * FROM UnPvt;



SELECT VendorID, Employee, Orders
FROM 
   (SELECT VendorID, Col1, Col2, Col3, Col4, Col5 FROM UnPvt) p
	UNPIVOT
   (Orders FOR Employee IN (Col1, Col2, Col3, Col4, Col5)
)AS unpvt_table;



--	INTERSECT


SELECT ProductCategoryID				
FROM Production.ProductCategory
INTERSECT
SELECT ProductCategoryID
FROM Production.ProductSubcategory



SELECT ProductCategoryID
FROM Production.ProductCategory
WHERE ProductCategoryID IN(
		SELECT ProductCategoryID 
		FROM Production.ProductSubCategory);


--	EXCEPT



SELECT ProductID			
FROM Production.Product
EXCEPT
SELECT ProductID
FROM Production.WorkOrder;


--	TRUNCATE TABLE ile Veri Silmek


TRUNCATE TABLE Production.Product;



--	Ýleri Veri Yönetim Teknikleri


--	Sorgu Sonucunu Yeni Tabloda Saklamak


SELECT BusinessEntityID, FirstName, MiddleName, LastName 
INTO #personeller
FROM Person.Person;


SELECT * FROM #Personeller;


--	Stored Procedure Sonucunu Tabloya Eklemek


CREATE TABLE Personeller
(
	BusinessEntityID	INT,
	FirstName		VARCHAR(50),
	MiddleName		VARCHAR(50),
	LastName		VARCHAR(50)
);



CREATE PROC pr_GetAllPerson
AS
BEGIN
	SELECT BusinessEntityID, FirstName, MiddleName, LastName 
	FROM Person.Person;
END;



EXEC pr_GetAllPerson;	



INSERT INTO Personeller(BusinessEntityID, FirstName, MiddleName, LastName)
EXEC pr_GetAllPerson;	



SELECT * FROM Personeller;	



--	Sorgu Sonucunu Var Olan Tabloya Eklemek


INSERT INTO Personeller(BusinessEntityID, FirstName, MiddleName, LastName)
		SELECT BusinessEntityID, FirstName, 
			 MiddleName, LastName 
		FROM Person.Person;


--	Tablolarý Birleþtirerek Veri Güncellemek


UPDATE Production.Product
SET ListPrice = ListPrice * 1.04
FROM Production.Product PP JOIN Sales.SalesOrderDetail SOD
ON PP.ProductID = SOD.ProductID;


--	Alt Sorgular Ýle Veri Güncellemek


UPDATE Production.Product
SET ListPrice = ListPrice * 1.04
FROM (Production.Product PP JOIN Sales.SalesOrderDetail SOD
      ON PP.ProductID = SOD.ProductID);


--	Büyük Boyutlu Verileri Güncellemek


CREATE TABLE WebSites
(
	SiteID	INT NOT NULL,
	URI		VARCHAR(40),
	Description VARCHAR(MAX)
);



INSERT INTO WebSites(SiteID, URI, Description)
VALUES(1,'www.dijibil.com','Online eðitim');


SELECT * FROM WebSites WHERE SiteID = 1;


UPDATE WebSites
SET Description.WRITE(' sistemi',NULL,NULL)
WHERE SiteID = 1


SELECT * FROM WebSites WHERE SiteID = 1;


UPDATE WebSites
SET Description.WRITE('Çevrimiçi',0,6)
WHERE SiteID = 1;


SELECT * FROM WebSites WHERE SiteID = 1;


UPDATE WebSites
SET Description.WRITE('Online',0,9), 
	URI = 'http://www.dijibil.com'
WHERE SiteID = 1;


SELECT * FROM WebSites WHERE SiteID = 1;



--	Tablo Birleþtirerek Veri Silmek



CREATE TABLE Personeller
(
	PersonID	INT NOT NULL,
	FirstName	VARCHAR(30),
	LastName	VARCHAR(30),
	JobID		INT
);



CREATE TABLE Jobs
(
	JobID	INT NOT NULL,
	JobName VARCHAR(50)
);



INSERT INTO Jobs(JobID, JobName)
VALUES(1,'DBA'),(2,'Software Developer'),(3,'Interface Designer');



INSERT INTO Personeller(PersonID, FirstName, LastName, JobID)
VALUES(1,'Cihan','Özhan',1),(2,'Kerim','Fýrat',2),(3,'Uður','Geliþken',2);


SELECT * FROM Jobs;			
	
SELECT * FROM Personeller;


SELECT 
	P.PersonID, P.FirstName, 
	P.LastName , J.JobName 
FROM 
	Personeller AS P
JOIN Jobs AS J
ON P.JobID = J.JobID
WHERE P.JobID = 2;



DELETE FROM Personeller
FROM Personeller AS P
JOIN Jobs AS J
ON P.JobID = J.JobID
WHERE P.JobID = 2;



DELETE FROM Personeller
FROM Personeller AS P
JOIN Jobs AS J
ON P.JobID = J.JobID
WHERE P.PersonID = 1;


--	Alt Sorgular Ýle Veri Silmek


DELETE FROM Sales.SalesPersonQuotaHistory 
WHERE BusinessEntityID IN 
    (SELECT BusinessEntityID 
     FROM Sales.SalesPerson 
     WHERE SalesYTD > 2500000.00);



--	TOP Fonksiyonu Ýle Veri Silmek


DELETE TOP(2.2) PERCENT FROM Production.ProductInventory;


DELETE TOP(2) FROM Production.ProductInventory;


--	Silinen Bir Kaydýn DELETED Ýçerisinde Görüntülenmesi


DELETE Sales.ShoppingCartItem
OUTPUT DELETED.* 
WHERE ShoppingCartID = 14951;


--	Dosyalarýn Veritabanýna Eklenmesi ve Güncellenmesi

--	OPENROWSET Komutu


SELECT BulkColumn 
FROM OPENROWSET(BULK 'C:\video.mp4', SINGLE_BLOB) AS Files;


CREATE TABLE UserFiles
(
	UserID	INT NOT NULL,
	UserFile	VARBINARY(MAX) NOT NULL
);


INSERT UserFiles(UserID, UserFile)
SELECT 1, BulkColumn 
FROM OPENROWSET(BULK'C:\mehter.mp4',SINGLE_BLOB) AS UserVideoFile;


SELECT * FROM UserFiles WHERE UserID = 1;


INSERT UserFiles(UserID, UserFile)
SELECT 1, BulkColumn 
FROM OPENROWSET(BULK'C:\dijibil_logo.png',SINGLE_BLOB) AS UserImageFile;


UPDATE UserFiles
SET UserFile = (
	SELECT BulkColumn 
	FROM OPENROWSET(BULK 'C:\istiklal_marsi.mp4', SINGLE_BLOB) AS Files)
WHERE UserID = 1;


--	FILESTREAM


--	FILESTREAM Özelliðini Aktifleþtirmek


EXEC sp_configure filestream_access_level, 2
GO
RECONFIGURE
GO


--	Mevcut Bir Veritabanýnda FILESTREAM Kullanmak


ALTER DATABASE AdventureWorks ADD
FILEGROUP FSGroup1 CONTAINS FILESTREAM;


ALTER DATABASE AdventureWorks ADD FILE(
	NAME = FSGroupFile1,
	FILENAME = 'C:\Databases\AdventureWorks\ADWorksFS')
	TO FILEGROUP FSGroup1;


CREATE TABLE ADVDocuments
(
	DocID		INT IDENTITY(1,1) PRIMARY KEY,
	DocGUID	UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL,
	DocFile	VARBINARY(MAX) NOT NULL,
	DocDesc	VARCHAR(500)
);


INSERT INTO ADVDocuments(DocGUID, DocFile, DocDesc)
		VALUES(NEWID(), 
		(SELECT * 
		 FROM OPENROWSET(BULK N'C:\kodlab.docx', SINGLE_BLOB) AS Docs), 		 'KodLab Tanýtým Dökümaný');



--	FILESTREAM Özelliði Aktif Edilmiþ Bir Veritabaný Oluþturmak



CREATE DATABASE DijiLabs
ON
PRIMARY(
	NAME = DijiLabsDB,
	FILENAME = 'C:\Databases\DijiLabs\DijiLabsDB.mdf'
),
FILEGROUP DijiLabsFS CONTAINS FILESTREAM(
	NAME = DijiLabsFS,
	FILENAME = 'C:\Databases\DijiLabs\DijiLabsFS'
)
LOG ON(
	NAME = DijiLabsLOG,
	FILENAME = 'C:\Databases\DijiLabs\DijiLabsLOG.ldf'
);


--	Sütunlarý Oluþturmak


CREATE TABLE Person(
	PersonID	UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
	FirstName	VARCHAR(30),
	LastName	VARCHAR(30),
	Email		VARCHAR(50),
	PImage	VARBINARY(MAX) FILESTREAM NULL
);



CREATE TABLE Person1(
	PersonID	UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
	FirstName	VARCHAR(30),
	LastName	VARCHAR(30),
	Email		VARCHAR(50),
	PImage	VARBINARY(MAX) FILESTREAM NULL,
	PImage1	VARBINARY(MAX) FILESTREAM NULL
);


--	Veri Eklemek


INSERT INTO Person(PersonID, FirstName, LastName, Email, PImage)
SELECT NEWID(),
	 'Cihan',
	 'ÖZHAN',
	 'cihan.ozhan@dijibil.com',
	 CAST(BulkColumn AS VARBINARY(MAX))
	 FROM OPENROWSET(BULK 'C:\dijibil.png',SINGLE_BLOB) AS ImageData;


--	Veri Seçmek


SELECT * FROM Person;


--	Veri Güncellemek


UPDATE Person
SET PImage = (
SELECT BulkColumn 
FROM OPENROWSET(BULK 'C:\mehter.mp4', SINGLE_BLOB) AS VideoData)
WHERE PersonID = '96C735D4-60B4-4C0C-B108-A0185F8BD5E2';



--	GUID Deðere Sahip Sütun Oluþturulurken Dikkat Edilmesi Gerekenler


CREATE TABLE Person(
	PersonID	INT NOT NULL IDENTITY(1,1),
	PersonGUID	UNIQUEIDENTIFIER ROWGUIDCOL UNIQUE NOT NULL,
	FirstName	VARCHAR(30),
	LastName	VARCHAR(30),
	Email		VARCHAR(50),
	PImage	VARBINARY(MAX) FILESTREAM NULL
);


--	Veri Silmek


DELETE FROM Person WHERE PersonID = '96C735D4-60B4-4C0C-B108-A0185F8BD5E2';


--	Verileri Gruplamak ve Özetlemek


--	Group By


SELECT 							
	SalesOrderID, OrderQty
FROM 
	Sales.SalesOrderDetail
WHERE 
	SalesOrderID BETWEEN 43670 AND 43680;



SELECT 							
	SalesOrderID AS [Sipariþ NO], 
	SUM(OrderQty) AS [Sipariþ Adet]
FROM 
	Sales.SalesOrderDetail
WHERE 
	SalesOrderID BETWEEN 43670 AND 43680
GROUP BY 
	SalesOrderID;



SELECT 							
	ProductID, 
	COUNT(ProductID) AS [ToplamSatýlanUrun]
FROM 
	Sales.SalesOrderDetail
GROUP BY 
	ProductID;



SELECT 							
	ProductID, 
	COUNT(ProductID) AS [ToplamSatýlanUrun]
FROM 
	Sales.SalesOrderDetail
WHERE 
	ProductID = 707
GROUP BY 
	ProductID;



SELECT 							
	ProductID, 
	COUNT(ProductID) AS [ToplamSatýlanUrun]
FROM 
	Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY [ToplamSatýlanUrun] DESC;



--	Group By All


SELECT 							
	ProductID, 
	COUNT(ProductID) AS [ToplamSatýlanUrun]
FROM 
	Sales.SalesOrderDetail
WHERE ProductID < 800
GROUP BY ProductID;



SELECT 								
	ProductID, 
	COUNT(ProductID) AS [ToplamSatýlanUrun]
FROM 
	Sales.SalesOrderDetail
WHERE ProductID < 800
GROUP BY ALL ProductID;


--	Having Ýle Gruplamalar Üstünde Þart Koþmak


SELECT ProductID, COUNT(ProductID) ToplamSatilanUrun
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING COUNT(ProductID) > 500
ORDER BY ToplamSatilanUrun DESC;


--	AVG Fonksiyonu


SELECT 						
	AVG(StandardCost) 
FROM 
	Production.Product;



SELECT 						
	AVG(ALL StandardCost) 
FROM 
	Production.Product;



SELECT 							
	AVG(DISTINCT StandardCost) AS [FARKLI]
FROM 
	Production.Product;



SELECT 						
	Name, StandardCost 
FROM 
	Production.Product;


--	SUM Fonksiyonu


SELECT 						
	SUM(ListPrice) AS Total_ListPrice, 
	SUM(SafetyStockLevel) AS [Safety Stock]
FROM Production.Product;



SELECT 							
	SUM(DISTINCT ListPrice) AS Total_ListPrice, 
	SUM(ALL SafetyStockLevel) AS [Safety Stock]
FROM Production.Product;



SELECT Color, SUM(ListPrice), SUM(StandardCost) FROM Production.Product;



SELECT 							
	Color, SUM(ListPrice), 
	SUM(StandardCost)
FROM 
	Production.Product
WHERE 
    	Color IS NOT NULL 
	AND ListPrice != 0.00 
    	AND Name LIKE 'Mountain%'
GROUP BY Color
ORDER BY Color;


--	COUNT Fonksiyonu



SELECT COUNT(*)					
FROM Production.Product;


SELECT COUNT(Name)			
FROM Production.Product;


SELECT * FROM Production.Product WHERE Name LIKE 'A%';


SELECT COUNT(*) FROM Production.Product WHERE Name LIKE 'A%';



--	MAX Fonksiyonu


SELECT 						
	MAX(ProductID) AS [En Buyuk]
FROM 
	Production.Product;



SELECT ProductID, Name 							
FROM 
	Production.Product
WHERE 
	ProductID = (SELECT 
			MAX(ProductID) 
			FROM Production.Product);



SELECT MAX(Name) FROM Production.Product;	



--	MIN Fonksiyonu


SELECT 							
	MIN(ProductID) AS [En Kucuk]
FROM 
	Production.Product;



SELECT ProductID, Name 							
FROM 
	Production.Product
WHERE 
	ProductID = (SELECT 
			MIN(ProductID) 
			FROM Production.Product);


SELECT MIN(Name) FROM Production.Product;


--	CUBE



SELECT D.Name, COUNT(*) AS [Çalýþan Sayýsý]
FROM HumanResources.EmployeeDepartmentHistory AS EDH
INNER JOIN HumanResources.Department AS D
ON EDH.DepartmentID = D.DepartmentID
GROUP BY CUBE(D.Name);


SELECT D.Name, COUNT(*) AS [Çalýþan Sayýsý]
FROM HumanResources.EmployeeDepartmentHistory AS EDH
INNER JOIN HumanResources.Department AS D
ON EDH.DepartmentID = D.DepartmentID
GROUP BY CUBE(D.Name)
HAVING COUNT(EDH.DepartmentID) <= 6;



SELECT i.Shelf, SUM(i.Quantity) Total
FROM Production.ProductInventory AS i
WHERE i.Shelf IN('A','B','C')
GROUP BY i.Shelf;


SELECT i.Shelf,	SUM(i.Quantity) Total
FROM Production.ProductInventory AS i
WHERE i.Shelf IN('A','B','C','D')
GROUP BY CUBE(i.Shelf);


--	ROLLUP


CREATE TABLE tbPopulation (
	Category VARCHAR(100),
	SubCategory VARCHAR(100),
	BookName VARCHAR(100),
	[Population (in Millions)] INT
);



SELECT Category, SubCategory, BookName,
SUM ([Population]) AS [Population]
FROM tbPopulation
GROUP BY Category,SubCategory,BookName WITH ROLLUP;



--	GROUPING ile Özetleri Düzenlemek


SELECT SalesQuota, SUM(SalesYTD) 'TotalSalesYTD', 
	 GROUPING(SalesQuota) AS 'Grouping'
FROM Sales.SalesPerson
GROUP BY SalesQuota WITH ROLLUP;















