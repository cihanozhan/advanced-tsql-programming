

--	Extended Stored Procedure'ler


EXEC sp_configure 'show advanced options',1
GO
RECONFIGURE
GO
EXEC sp_configure 'xp_cmdshell',1
GO
RECONFIGURE
GO


master.dbo.xp_cmdshell 'dir';


EXEC master.dbo.xp_cmdshell 'dir C:\sql_files\*.sql';


EXEC master.dbo.xp_cmdshell 'copy D:\copy1.txt D:\copy2.txt';


--	Stored Procedure Oluþturmak


USE AdventureWorks
GO
CREATE PROC pr_UrunleriGetir
AS
SELECT ProductID, Name, ProductNumber, ListPrice FROM Production.Product;



BEGIN
	SELECT ProductID, Name, 
	ProductNumber, ListPrice 
	FROM 	Production.Product;
END;



sp_helptext 'pr_UrunleriGetir';	



--	NOCOUNT Oturum Parametresinin Kullanýmý


CREATE PROC sp_procName
AS
	SET NOCOUNT ON
	-- Stored Procedure'de iþlemi gerçekleþtirecek sorgu.
GO



SET NOCOUNT ON
SELECT * FROM Production.Product;


SET NOCOUNT OFF



--	Stored Procedure'lerde Deðiþiklik Yapmak


sp_helptext 'pr_UrunleriGetir';



ALTER PROC pr_UrunleriGetir
AS
SET NOCOUNT ON
	SELECT ProductID, Name, 
	ProductNumber, ListPrice 
	FROM 	Production.Product;
SET NOCOUNT OFF



--	Stored Procedure'leri Yeniden Derlemek


ALTER PROC pr_UrunleriGetir
WITH RECOMPILE
AS
SET NOCOUNT ON
	SELECT ProductID, Name, 
	ProductNumber, ListPrice 
	FROM 	Production.Product;
SET NOCOUNT OFF
GO


--	Stored Procedure'ler Ýçin Ýzinleri Yönetmek



DENY ON prosedur_ismi TO public


--	Girdi Parametreler(Input Parameters)


CREATE PROCEDURE pr_UrunAra(@ProductNumber NVARCHAR(25))
AS
SET NOCOUNT ON
IF @ProductNumber IS NOT NULL
	SELECT 
		ProductID, ProductNumber, 
		Name, ListPrice 
	FROM 
		Production.Product 
	WHERE 
		ProductNumber = @ProductNumber;
SET NOCOUNT OFF


--	Girdi Parametreler Ýle Stored Procedure Çaðýrmak


EXEC pr_UrunAra @ProductNumber = 'SA-T872';


EXEC pr_UrunAra 'SA-T872';


--	Tablo Tipi Parametre Alan Stored Procedure'ler



CREATE TYPE dbo.ProductType AS TABLE
(
	ProductCategoryID INT,
	Name	VARCHAR(40)
);



CREATE PROCEDURE pr_AllCateogries
(
	@productCategory AS dbo.ProductType READONLY
)
AS
BEGIN
SET NOCOUNT ON
	SELECT 
	PC.Name AS Category, 
	PS.Name AS SubCategory
	FROM Production.ProductSubcategory AS PS
	JOIN @productCategory AS PC ON 
	PC.ProductCategoryID = PS.ProductCategoryID;
SET NOCOUNT OFF
END;



DECLARE @category AS dbo.ProductType;
INSERT INTO @category (ProductCategoryID, Name)
SELECT TOP(4) ProductCategoryID, Name FROM Production.ProductCategory;
EXEC pr_AllCateogries @category;


--	Çýkýþ Parametrelerle Çalýþmak(Output Parameters)



CREATE PROC pr_HesapMakinesi
(
	@sayi1 INT, 
	@sayi2 INT,
	@islem SMALLINT,
	@sonuc INT	OUTPUT
)
AS
SET NOCOUNT ON
IF @islem IS NOT NULL
	IF(@islem = 0)
		SELECT @sonuc = (@sayi1 + @sayi2);
	ELSE IF(@islem = 1)
		SELECT @sonuc = (@sayi1 - @sayi2);
	ELSE IF(@islem = 2)
		SELECT @sonuc = (@sayi1 * @sayi2);
	ELSE IF(@islem = 3)
		SELECT @sonuc = (@sayi1 / @sayi2);
	ELSE
		SELECT @sonuc = (0);
SET NOCOUNT OFF



--	Çýkýþ Parametrelerini Almak


-- Çýkýþ parametresinden alýnan deðerin tutulacaðý deðiþken.
DECLARE @sonuc INT;

-- Prosedürü çalýþtýrmak için gönderilen parametreler.
EXEC pr_HesapMakinesi 7,6,2,@sonuc OUT;

-- Çýkýþ parametresinden alýnan deðerin gösterilmesi.
SELECT @sonuc;



DECLARE @sonucOut INT;
EXEC pr_HesapMakinesi @sayi1=7, @sayi2=6, @islem = 2, @sonuc = @sonucOut OUT;
SELECT 'Çarpým', @sonucOut;
GO


--	RETURN Deyimi


ALTER PROC pr_HesapMakinesi
(
	@sayi1 INT, 
	@sayi2 INT,
	@islem SMALLINT,
	@sonuc INT	OUTPUT
)
AS
SET NOCOUNT ON
IF @islem IS NOT NULL
	IF(@islem = 0)
		SELECT @sonuc = (@sayi1 + @sayi2);
	ELSE IF(@islem = 1)
		SELECT @sonuc = (@sayi1 - @sayi2);
	ELSE IF(@islem = 2)
		SELECT @sonuc = (@sayi1 * @sayi2);
	ELSE IF(@islem = 3)
		SELECT @sonuc = (@sayi1 / @sayi2);
	ELSE
		SELECT @sonuc = (0);
	RETURN(@sayi1 + @sayi2);		-- Eklenen RETURN deyimi
SET NOCOUNT OFF

Aþaðýdaki þekilde çaðýrabiliriz.
DECLARE @sonucOut INT, 
	  @toplam INT;
EXEC @toplam = pr_HesapMakinesi @sayi1=7, 
					   @sayi2=6, 
					   @islem = 2, 
					   @sonuc = @sonucOut OUT;
SELECT 'Çarpým', @sonucOut, 
	 'Return ile Toplam : ', @toplam;



--	EXECUTE AS CALLER



CREATE PROC pr_UrunGetir
(
	@ProductID	INT
)
WITH EXECUTE AS CALLER
AS
SELECT 
	ProductID, Name, ProductNumber 
FROM 
	Production.Product 
WHERE 
	ProductID = @ProductID;



WITH EXECUTE AS CALLER


--	EXECUTE AS 'kullanýcý'


CREATE PROC pr_UrunGetir
(
	@ProductID	INT
)
WITH EXECUTE AS kullanici_ismi
AS
SELECT 
	ProductID, Name, ProductNumber 
FROM 
	Production.Product 
WHERE 
	ProductID = @ProductID;


--	WITH RESULT SETS ile Stored Procedure Çaðýrmak


CREATE PROC pr_UrunGetir
(
	@ProductID	INT
)
AS
SELECT ProductID, Name, ProductNumber 
FROM Production.Product 
WHERE ProductID = @ProductID;

WITH RESULT SETS ile prosedürü çaðýralým.

EXEC pr_UrunGetir 4		
WITH RESULT SETS(
	(
		KOD	VARCHAR(20),
		[Ürün Adý] VARCHAR(20),
		[Ürün Numarasý] VARCHAR(7)
	)
);



--	Stored Procedure'lerin Þifrelenmesi



sp_helptext 'pr_UrunGetir';



ALTER PROC pr_UrunGetir
(
	@ProductID	INT
)
WITH ENCRYPTION
AS
SELECT ProductID, Name, ProductNumber 
FROM Production.Product 
WHERE ProductID = @ProductID;



sp_helptext 'pr_UrunGetir';



--	Stored Procedure'ler Hakkýnda Bilgi Almak



SELECT 
	Name, Type, Type_Desc, 
	Create_Date, Modify_Date 
FROM 
	Sys.Procedures;



SELECT 
	Name, Type, Type_Desc, 
	Create_Date, Modify_Date 
FROM 
	Sys.Procedures
WHERE
	Name LIKE 'pr_%';




SELECT * FROM Sys.Sql_Modules;




SELECT  Definition, O.Object_ID, Create_Date,
	  OBJECT_NAME(O.Object_ID) Prosedur_Ismi
	  FROM Sys.Sql_Modules M
	  INNER JOIN Sys.Objects O ON
	  M.Object_ID = O.Object_ID
	  WHERE O.type = 'P';


























