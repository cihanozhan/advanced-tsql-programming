

--	View Oluþturmak

USE AdventureWorks
GO
CREATE VIEW vw_Urunler
AS
SELECT ProductID, Name, ProductNumber, ListPrice FROM Production.Product;



SELECT * FROM vw_Urunler;


SELECT ProductID, Name, ProductNumber, ListPrice FROM vw_Urunler;


--	Hatalý View


CREATE VIEW vw_hataliView
AS
SELECT sutun1, sutun2
FROM tablo_ismi
COMPUTE SUM(sutun1) BY sutun2


--	Geliþmiþ Sorgular ile View Kullanýmý


USE AdventureWorks
GO
CREATE VIEW vw_MusteriSiparisler
AS
SELECT
	soh.SalesOrderID,
	soh.OrderDate,
	sod.ProductID,
	p.Name AS UrunAd,
	sod.OrderQty,
	sod.UnitPrice AS BirimFiyat,
	sod.LineTotal AS SatirToplam
FROM
	Sales.SalesOrderHeader AS soh
	JOIN Sales.SalesOrderDetail AS sod
	ON soh.SalesOrderID = sod.SalesOrderID
	JOIN Production.Product AS p
	ON sod.ProductID = p.ProductID;


SELECT * FROM vw_MusteriSiparisler;


SELECT UrunAd, BirimFiyat, SatirToplam 			
FROM vw_MusteriSiparisler 
WHERE OrderDate = '2005-07-01';



--	Tanýmlanan View'leri Görmek ve Sistem View'leri



SELECT *
FROM sys.views;



SELECT 								
	s.Name AS SchemaName,
	v.Name AS ViewName
FROM 
	sys.views AS v
	INNER JOIN sys.schemas AS s 
	ON v.schema_id = s.schema_id
ORDER BY s.Name, v.Name;



SELECT *							
FROM INFORMATION_SCHEMA.VIEWS;



SELECT						
	v.Name AS ViewName,
	c.Name AS ColumnName
FROM 
	sys.columns AS c
	INNER JOIN sys.views AS v 
	ON c.object_id = v.object_id
ORDER BY
	v.Name, c.Name;




--	View'lerin Yapýsýný Görüntülemek



SELECT Definition 
FROM sys.sql_modules
WHERE Object_ID = OBJECT_ID('vw_MusteriSiparisler');



SELECT OBJECT_DEFINITION(OBJECT_ID('vw_MusteriSiparisler'));


SELECT
	sc.text
FROM sys.syscomments sc
	JOIN sys.objects so
	ON sc.id = so.object_id
	JOIN sys.schemas ss
	ON so.schema_id = ss.schema_id
WHERE so.name = 'vw_MusteriSiparisler' AND ss.name = 'dbo';


EXEC sp_helptext 'vw_MusteriSiparisler';


--	View Tanýmlamalarýný Yenilemek


EXEC sp_refreshview 'vw_MusteriSiparisler';


EXEC sp_refreshsqlmodule @name = 'vw_MusteriSiparisler';



--	Kod Güvenliði : View'leri Þifrelemek


ALTER VIEW vw_MusteriSiparisler
WITH ENCRYPTION
AS
SELECT
	soh.SalesOrderID, soh.OrderDate, sod.ProductID,
	p.Name AS UrunAd,	sod.OrderQty, 
	sod.UnitPrice AS BirimFiyat, sod.LineTotal AS SatirToplam
FROM
	Sales.SalesOrderHeader AS soh
	JOIN Sales.SalesOrderDetail AS sod
	ON soh.SalesOrderID = sod.SalesOrderID
	JOIN Production.Product AS p
	ON sod.ProductID = p.ProductID;



sp_helptext 'vw_MusteriSiparisler';



--	Schema Binding

--	View Ýle Verileri  Düzenlemek : Insert, Update, Delete


CREATE VIEW Production.vw_Location
AS
SELECT LocationID, Name, 
	 CostRate, Availability
FROM Production.Location;


INSERT INTO Production.vw_Location(Name, CostRate, Availability)
VALUES('Dijibil Test',1.10,50.00);


SELECT * 						
FROM Production.vw_Location
WHERE Name = 'Dijibil Test';


--	Ýndekslenmiþ View'ler


ALTER VIEW vw_MusteriSiparisler
WITH SCHEMABINDING
AS
SELECT
	soh.SalesOrderID, 
	soh.OrderDate, 
	sod.ProductID,
	p.Name AS UrunAd,	
	sod.OrderQty, 
	sod.UnitPrice AS BirimFiyat, 
	sod.LineTotal AS SatirToplam
FROM
	Sales.SalesOrderHeader AS soh
	JOIN Sales.SalesOrderDetail AS sod
	ON soh.SalesOrderID = sod.SalesOrderID
	JOIN Production.Product AS p
	ON sod.ProductID = p.ProductID;



CREATE UNIQUE CLUSTERED INDEX indexedvMusteriSiparisler
ON vw_MusteriSiparisler(SalesOrderID, ProductID, UrunAd);



vw_MusteriSiparisler(SalesOrderID, ProductID, UrunAd) 



SELECT * FROM vw_MusteriSiparisler;


--	Parçalý View Kullanýmý


CREATE TABLE Department1Product
(
	DepartmentID	TINYINT NOT NULL,
	ProductID		INT,
	ProductName		VARCHAR(50),
	ProductPrice	MONEY,
	PRIMARY KEY(DepartmentID, ProductID),
	CHECK(DepartmentID = 1)
);
GO
INSERT INTO Department1Product
	(DepartmentID, ProductID, ProductName, ProductPrice)
VALUES
	(1,1,'Ýleri Seviye SQL Server', 50),
	(1,2,'Ýleri Seviye Oracle', 50);



CREATE TABLE Department2Product
(
	DepartmentID	TINYINT NOT NULL,
	ProductID		INT,
	ProductName		VARCHAR(50),
	ProductPrice	MONEY,
	PRIMARY KEY(DepartmentID, ProductID),
	CHECK(DepartmentID = 2)
);
GO
INSERT INTO Department2Product
	(DepartmentID, ProductID, ProductName, ProductPrice)
VALUES(2,1,'Ýleri Seviye Java', 50),
      (2,2,'Ýleri Seviye Android', 50);



CREATE VIEW pw_ManagementDepartment_Product
AS
SELECT * FROM Department1Product
UNION ALL
SELECT * FROM Department2Product


SELECT * FROM pw_ManagementDepartment_Product;



INSERT INTO pw_ManagementDepartmentProducts
	(DepartmentID,ProductID,ProductName,ProductPrice)
VALUES
	(1,3,'Ýleri Seviye Robot Programlama','50'), 
	(1,4,'Ýleri Seviye Yapay Zeka','55'),
	(2,3,'Ýleri Seviye PHP','40'),
	(2,4,'Ýleri Seviye JSP','40');


INSERT INTO pw_ManagementDepartmentProducts
 	(DepartmentID,ProductID,ProductName,ProductPrice)
VALUES
	(2,1,'Ýleri Seviye Java',50),
	(2,2,'Ýleri Seviye Android',50);



--	View'larý Kaldýrmak


DROP VIEW vw_MusteriSiparisler;











































































