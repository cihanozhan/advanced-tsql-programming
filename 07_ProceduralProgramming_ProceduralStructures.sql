

--	Script Temelleri


USE AdventureWorks
GO
DECLARE @Ident INT;

INSERT INTO Production.Location(Name, CostRate, Availability, ModifiedDate)
VALUES ('Name_Degeri', 25, 1.7, GETDATE());

SELECT @Ident = @@IDENTITY;
SELECT 'Eklenen satýr için identity deðeri : '+CONVERT(VARCHAR(3),@Ident);


--	Deðiþken Bildirimi


DECLARE @sayi1 INT;				
DECLARE @sayi2 INT;
DECLARE @toplam INT = @sayi1 + @sayi2;	
SELECT @toplam;


DECLARE @sayi1 INT = 12;				
DECLARE @sayi2 INT = 12;		
DECLARE @toplam INT = @sayi1 + @sayi2;
SELECT  @toplam;


--	SET Ýfadesi Kullanýlarak Deðiþkenlere Deðer Atanmasý


DECLARE @Fiyat MONEY; 					
DECLARE @KdvOran MONEY;
DECLARE @KdvMiktar MONEY;
DECLARE @Toplam MONEY;
SET @Fiyat = 10;
SET @KdvOran = 0.18;
SET @KdvMiktar = @Fiyat * @KdvOran;
SET @Toplam = @Fiyat + @KdvMiktar;
SELECT @Toplam;



DECLARE @Fiyat MONEY; @KdvOran MONEY, @KdvMiktar MONEY, @Toplam MONEY;


DECLARE @EnYuksekFiyat MONEY;
SET @EnYuksekFiyat = (SELECT MAX(ListPrice) FROM Production.Product);
SELECT @EnYuksekFiyat AS EnYuksekFiyat;


SELECT ListPrice FROM Production.Product ORDER BY ListPrice DESC;


--	SELECT Ýfadesi Kullanýlarak Deðiþkenlere Deðer Atanmasý



DECLARE @EnYuksekFiyat MONEY;
SELECT @EnYuksekFiyat = MAX(ListPrice) FROM Production.Product;
SELECT @EnYuksekFiyat AS EnYuksekFiyat;


--	Batch'ler


--	SQLCMD



Sqlcmd
  [-U login id] [-P password] [-S server] [-H hostname] 
  [-E trusted connection] [-d use database name] [-l login timeout]
  [-N encrypt connection] [-C trust the server certificate]
  [-t query timeout] [-h headers] [-s colseparator] [-w screen width]
  [-a packetsize] [-e echo input] [-I Enable Quoted Identifiers]
  [-c cmdend] [-L[c] list servers[clean output]] [-q "cmdline query"]
  [-Q "cmdline query" and exit] [-m errorlevel] [-V severitylevel]
  [-W remove trailing spaces] [-u unicode output]
  [-r[0|1] msgs to stderr] [-i inputfile] [-o outputfile]
  [-f <codepage> | i:<codepage>[,o:<codepage>]]
  [-k[1|2] remove[replace] control characters]
  [-y variable length type display width]
  [-Y fixed length type display width]
  [-p[1] print statistics[colon format]]
  [-R use client regional setting] [-b On error batch abort]
  [-v var = "value"...]
  [-X[1] disable commands[and exit with warning]]
  [-? show syntax summary]



sqlcmd -S DIJIBIL-PC



sqlcmd -Ssunucu_ismi123 -Uuser_name123 -Ppwd123



SELECT @@SERVERNAME;
GO


SELECT @@VERSION;
GO


USE AdventureWorks
GO


SELECT ProductID, Name 			
FROM Production.Product 
WHERE ProductID = 1;


--	Akýþ Kontrol Ýfadeleri


--	IF ... ELSE


DECLARE @val INT;
SELECT @val = COUNT(ProductID) FROM Production.Product;
IF @val IS NOT NULL
	PRINT 'Toplam ' + CAST(@val AS VARCHAR) + ' kayýt bulundu.';



IF EXISTS (
	SELECT * 
	FROM Sys.Sysobjects WHERE ID = Object_ID(N'[dbo].[Deneme]')
	AND OBJECTPROPERTY(ID, N'IsUserTable') = 1
)
DROP TABLE dbo.Deneme;
CREATE TABLE dbo.Deneme 
(
	DeneID  INT
);



DECLARE @val INT;
SELECT  @val = COUNT(ProductID) FROM Production.Product
IF @val IS NULL
	PRINT 'Kayýt Yok'
ELSE
	PRINT 'Toplam ' + CAST(@val AS VARCHAR) + ' kayýt bulundu.';



--	ELSE  Koþulu



DECLARE @val INT;					
SET 	  @val = 1;

IF @val = 1
	PRINT 'Bir'
ELSE IF(@val = 2)
	PRINT 'Ýki'
ELSE IF(@val = 3)
	PRINT 'Üç'
ELSE IF(@val >= 4) AND (@val <= 8)
BEGIN
	PRINT '4 - 8 arasýnda bir deðer';
	PRINT '...'
END
ELSE
	PRINT 'Tanýmlanamadý.';



--	Ýç Ýçe IF Kullanýmý



DECLARE @sayi INT;			
SET 	  @sayi = 5;

IF @sayi > 100
	PRINT 'Bu sayý büyük.';
ELSE 
BEGIN
	IF @sayi < 10
		PRINT 'Bu sayý küçük.';
	ELSE
		PRINT 'Ne küçük ne de büyük.';
END;




DECLARE @sayi INT;				
SET 	@sayi = 4;

IF @sayi > 100
	PRINT 'Bu sayý büyük.';
ELSE 
BEGIN
	IF @sayi < 10
		IF @sayi = 1
			PRINT 'Bir'
		ELSE IF(@sayi = 2)
			PRINT 'Ýki'
		ELSE IF(@sayi = 3)
			PRINT 'Üç'
		ELSE IF(@sayi = 4)
		BEGIN
			PRINT 'Dört'
			PRINT 'Hediyeyi kazandýn!'
		END
		ELSE IF(@sayi = 5)
			PRINT 'Beþ'
		ELSE
			PRINT 'Bu sayý, 5 ve 10 arasýnda bir deðere sahip.';
	ELSE
		PRINT 'Ne küçük ne de büyük.';
END;


--	CASE Deyimi



SELECT   ProductNumber, Category =
      CASE ProductLine
         WHEN 'R' THEN 'Yol'
         WHEN 'M' THEN 'Dað'
         WHEN 'T' THEN 'Gezi'
         WHEN 'S' THEN 'Diðer Satýlýklar'
         ELSE 'Satýlýk Deðil'
      END,
   Name
FROM Production.Product
ORDER BY ProductNumber;




SELECT JobTitle, BirthDate, Gender, Cinsiyet =
	CASE
		WHEN Gender = 'M' THEN 'Erkek'
		WHEN Gender = 'F' THEN 'Kadýn'
	END
FROM HumanResources.Employee;



--	WHILE Döngüsü



DECLARE @counter INT
SELECT  @counter = 0

WHILE @counter < 5
BEGIN
  SELECT '@counter deðeri : ' + CAST(@counter AS VARCHAR(1))
  SELECT  @counter = @counter + 1
END;



CREATE TABLE #gecici(
	firmaID 	INT NOT NULL IDENTITY(1,1),
	firma_isim 	VARCHAR(20) NULL
);
WHILE (SELECT count(*) FROM #gecici) < 10
BEGIN
	INSERT #gecici VALUES ('dijibil'),('kodlab')
END;
SELECT * FROM #gecici;



--	CONTINUE Komutu


DECLARE @counter INT, @counter1 INT;
SELECT  @counter = 0, @counter1 = 3;
WHILE @counter <> @counter1
BEGIN
     SELECT CAST(@counter AS VARCHAR) + ' : ' + 'dijibil.com & kodlab.com';
     SELECT @counter = @counter + 1;
END;



--	WAITFOR Ýfadesi


--	WAITFOR DELAY



BEGIN
    WAITFOR DELAY '00:01';
    EXECUTE sp_helpdb;
END;



--	WAITFOR TIME


DECLARE @counter INT, @counter1 INT;
SELECT  @counter = 0, @counter1 = 3;
WHILE   @counter <> @counter1
BEGIN
     WAITFOR TIME '11:00'
     SELECT CAST(@counter AS VARCHAR) + ' : ' + 'dijibil.com & kodlab.com';
     SELECT @counter = @counter + 1;
END;


--	GOTO


DECLARE @Counter int;
SET @Counter = 1;
WHILE @Counter < 10
BEGIN 
    SELECT @Counter
    SET @Counter = @Counter + 1
    IF @Counter = 4 GOTO Etiket_Bir
    IF @Counter = 5 GOTO Etiket_Iki
END
Etiket_Bir:
    SELECT 'Etiket 1'
    GOTO Etiket_Uc;
Etiket_Iki:
    SELECT 'Etiket 2'
Etiket_Uc:
    SELECT 'Etiket 3'



































