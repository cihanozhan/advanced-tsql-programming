

--	Ýndeksler Hakkýnda Bilgi Edinmek


EXEC sp_helpindex 'Production.Product';


SELECT * FROM sys.indexes;


--	Ýndex Oluþturmak


CREATE CLUSTERED INDEX CL_PersonelID
ON Personeller(PersonelID);


CREATE INDEX NC_PersonelID
ON Personeller(PersonelID);


CREATE INDEX NC_PersonelID
ON Personeller(PersonelID ASC);


--	Unique Ýndeks Oluþturmak


CREATE UNIQUE NONCLUSTERED INDEX UI_Email
ON dbo.Personeller(Email) 
ON [PRIMARY];


--	Kapsam(Covering) Ýndeks Oluþturmak


SELECT Name, ProductNumber, ListPrice FROM Production.Product;


CREATE INDEX CV_Product
ON Production.Product(Name, ProductNumber, ListPrice);



--	Eklenti Sütunlu Ýndeks Oluþturmak


CREATE INDEX CV_SalesDetail
ON Sales.SalesOrderDetail(SalesOrderID)
INCLUDE(OrderQty, ProductID, UnitPrice)


--	Filtreli Ýndeks Oluþturmak


SELECT ProductID, Name, Color FROM Production.Product 
WHERE Color IS NOT NULL


CREATE INDEX FI_Product
ON Production.Product(ProductID, Name)
WHERE Color IS NOT NULL;


--	Ýndeks Yönetimi

--	REBUILD : Ýndeksleri Yeniden Derlemek


ALTER INDEX ALL ON Production.Product
REBUILD WITH(FILLFACTOR = 90)


REBUILD WITH(FILLFACTOR = 90, SORT_IN_TEMPDB = ON)


--	REORGANIZE : Ýndeksleri Yeniden Düzenlemek


ALTER INDEX UI_Email
ON dbo.Personeller
REORGANIZE WITH (LOB_COMPACTION = ON);


--	Ýndeksleri Kapatmak


ALTER INDEX CL_PersonelID		
ON Personeller
DISABLE


SELECT * FROM Personeller;


ALTER INDEX FI_Product		
ON Production.Product
DISABLE


SELECT * FROM Production.Product;


ALTER INDEX CL_PersonelID
ON dbo.Personeller
REBUILD

ALTER INDEX FI_Product
ON Production.Product
REBUILD



--	Ýndeks Seçeneklerini Deðiþtirmek


SELECT Object_ID, Name, Index_ID, Type, type_desc, Allow_Row_Locks FROM sys.indexes WHERE Name = 'FI_Product';


ALTER INDEX FI_Product
ON Production.Product
SET(ALLOW_ROW_LOCKS = ON);


--	Ýstatistikler

--	Ýstatistik Oluþturmak


CREATE STATISTICS Statistic_ProductID
ON Production.Product(ProductID);


--	Ýstatistikleri Silmek


DROP STATISTICS Production.Product.Statistic_ProductID;


