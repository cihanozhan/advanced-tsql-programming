

--	Trigger Oluþturmak


--	INSERT Trigger


CREATE TRIGGER locationInsert
ON Production.Location
AFTER INSERT
AS
BEGIN
SET NOCOUNT ON;
	SELECT 'Yeni lokasyon bilgisi eklendi.';
SET NOCOUNT OFF;
END;



INSERT INTO Production.Location(Name, CostRate, Availability, ModifiedDate)
VALUES('Yeni Lokasyon', 0.00, 0.00, GETDATE());



CREATE TRIGGER trg_PersonelHatirlatici
ON Personeller
AFTER INSERT
AS 
	RAISERROR ('Eklenen Personeli Bildir', 16, 10);



CREATE TABLE ProductLog
(
	ProductID		INT,
	Name			VARCHAR(50),
	ProductNumber	NVARCHAR(25),
	ListPrice		DATETIME
);



CREATE TRIGGER trg_ProductLog
ON Production.Product
AFTER INSERT
AS
BEGIN
	INSERT INTO ProductLog SELECT ProductID, Name, 
			ProductNumber, ListPrice 
	FROM inserted;
END;



INSERT INTO Production.Product
	(Name, ProductNumber, MakeFlag, FinishedGoodsFlag, 	SafetyStockLevel,ReorderPoint, StandardCost, ListPrice, 
	DaysToManufacture, SellStartDate,rowguid, ModifiedDate)
VALUES('Test Ürün','SK-3335', 1, 0, 500, 700, 0, 0, 3, 
	 GETDATE(), NEWID(), GETDATE());



SELECT ProductID, Name, ProductNumber FROM Production.Product
WHERE ProductNumber = 'SK-3335';


SELECT * FROM ProductLog;



CREATE TRIGGER trg_GetProduct
ON Production.Product
AFTER INSERT
AS
BEGIN
	SELECT PL.ProductID, PL.Name, PL.ProductNumber 
	FROM Production.Product AS PL
	INNER JOIN INSERTED AS I
	ON PL.ProductID = I.ProductID;
END;



INSERT INTO Production.Product
	(Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, 	ReorderPoint, StandardCost,ListPrice,DaysToManufacture,SellStartDate,
	rowguid, ModifiedDate)
VALUES('Test Product','SK-3334', 1, 0, 500, 700, 0.00, 0.00, 3, 
	GETDATE(), NEWID(), GETDATE());


--	DELETE Trigger



CREATE TRIGGER trg_KullaniciSil
ON Kullanicilar
AFTER DELETE
AS
BEGIN
	SELECT deleted.KullaniciAd + ' kullanýcý adýna ve ' + deleted.Email + 
	' email adresine sahip kullanýcý silindi.' FROM deleted;
END;



DELETE FROM Kullanicilar WHERE KullaniciID = 1;


--	UPDATE Trigger


CREATE TRIGGER trg_UrunGuncellemeTarihiniGuncelle
ON Production.Product
AFTER UPDATE
AS
BEGIN
	UPDATE Production.Product
	SET ModifiedDate = GETDATE()
	WHERE ProductID = (SELECT ProductID FROM inserted)
END;



SELECT ProductID, Name, ProductNumber, ModifiedDate FROM Production.Product 
WHERE ProductID = 999;



UPDATE Production.Product
SET Name = 'Road-750 Red, 52'
WHERE ProductID = 999;



SELECT ProductID, Name, ProductNumber, ModifiedDate FROM Production.Product 
WHERE ProductID = 999;


CREATE TABLE UrunGuncellemeLog
(
	ProductID		INT,
	Name			VARCHAR(50),
	ProductNumber	NVARCHAR(25),
	ListPrice		MONEY,
	ModifiedDate	DATETIME
);


CREATE TRIGGER trg_UrunGuncelleLog
ON Production.Product
AFTER UPDATE
AS
BEGIN
	DECLARE @ProductID INT, @Name VARCHAR(50), 
		  @ProductNumber NVARCHAR(25), @ListPrice MONEY, 
		  @ModifiedDate DATETIME;

	SELECT @ProductID = i.ProductID, @Name = i.Name,
		 @ProductNumber = i.ProductNumber, @ListPrice = i.ListPrice,
		 @ModifiedDate = i.ModifiedDate FROM inserted AS i;
	
	INSERT INTO UrunGuncellemeLog
	VALUES(@ProductID, @Name, @ProductNumber, @ListPrice, @ModifiedDate)
END;



UPDATE Production.Product
SET Name = 'Road-750 Red, 52'
WHERE ProductID = 999;



--	Birden Fazla Ýþlem Ýçin Trigger Oluþturmak


CREATE TRIGGER trigger_ismi
ON tablo_ismi
AFTER INSERT, UPDATE, DELETE


--	INSTEAD OF Trigger


CREATE TABLE Musteriler
(
	MusteriID	INT NOT NULL PRIMARY KEY,
	Ad		VARCHAR(40) NOT NULL
);



CREATE TABLE Siparisler
(
	SiparisID		INT IDENTITY NOT NULL PRIMARY KEY,
	MusteriID		INT NOT NULL REFERENCES Musteriler(MusteriID),
	SiparisTarih	DATETIME NOT NULL
);



CREATE TABLE Urunler
(
	UrunID	INT IDENTITY NOT NULL PRIMARY KEY,
	Ad		VARCHAR(50) NOT NULL,
	BirimFiyat	MONEY NOT NULL
);




CREATE TABLE SiparisUrunleri
(
	SiparisID	INT NOT NULL REFERENCES Siparisler(SiparisID),
	UrunID	INT NOT NULL REFERENCES Urunler(UrunID),
	BirimFiyat	MONEY NOT NULL,
	Miktar	INT NOT NULL
	CONSTRAINT PKSiparisUrun PRIMARY KEY CLUSTERED(SiparisID, UrunID)
);




INSERT INTO Musteriler VALUES(1,'Biliþim Yayýncýlýðý');
INSERT INTO Musteriler VALUES(2,'Çocuk Kitaplarý Yayýncýlýðý');

INSERT INTO Siparisler VALUES(1, GETDATE());
INSERT INTO Siparisler VALUES(2, GETDATE());

INSERT INTO Urunler VALUES('Ýleri Seviye SQL Server T-SQL', 50);
INSERT INTO Urunler VALUES('Keloðlan Masallarý', 20);

INSERT INTO SiparisUrunleri VALUES(1, 1, 50, 3);
INSERT INTO SiparisUrunleri VALUES(2, 2, 20, 2);



SELECT * FROM Siparisler;

SELECT * FROM Urunler;

SELECT * FROM Musteriler;

SELECT * FROM SiparisUrunleri;



CREATE VIEW vw_MusteriSiparisleri
AS
SELECT S.SiparisID,
	 SU.UrunID,
	 U.Ad,
	 SU.BirimFiyat,
	 SU.Miktar,
	 S.SiparisTarih
FROM Siparisler AS S
JOIN SiparisUrunleri AS SU
	ON S.SiparisID = SU.SiparisID
JOIN Urunler AS U
	ON SU.UrunID = U.UrunID;


SELECT * FROM vw_MusteriSiparisleri;



--	INSTEAD OF INSERT Trigger


CREATE TRIGGER trg_MusteriSiparisEkle
ON vw_MusteriSiparisleri
INSTEAD OF INSERT
AS
BEGIN
SET NOCOUNT ON;
	IF(SELECT COUNT(*) FROM inserted) > 0
	BEGIN
		INSERT INTO dbo.SiparisUrunleri
			SELECT i.SiparisID,
				 i.UrunID,
				 i.BirimFiyat,
				 i.Miktar
			FROM inserted AS i
			JOIN Siparisler AS S
				ON i.SiparisID = S.SiparisID
	IF @@ROWCOUNT = 0
		RAISERROR('Eþleþme yok. Ekleme yapýlamadý.', 10, 1)
	END;
SET NOCOUNT OFF;
END;


INSERT INTO vw_MusteriSiparisleri(
	SiparisID, SiparisTarih, UrunID, Miktar, BirimFiyat)
VALUES(1, '2013-02-02', 2, 10, 20);



--	INSTEAD OF UPDATE Trigger



CREATE TRIGGER trg_InsteadOfTrigger
ON Production.Product
INSTEAD OF UPDATE
AS
BEGIN
	PRINT 'Güncelleme iþlemi gerçekleþtirilmek istendi.';
END;


SELECT ProductID, Name, ProductNumber FROM Production.Product 
WHERE ProductID = 1;


UPDATE Production.Product
SET Name = 'Adjustable Race1'
WHERE ProductID = 1;


--	INSTEAD OF DELETE Trigger


ALTER TABLE Urunler
ADD AktifMi	BIT;



UPDATE Urunler
SET AktifMi = 1;



ALTER VIEW vw_MusteriSiparisleri
AS
SELECT S.SiparisID,
	 SU.UrunID,
	 U.Ad,
	 SU.BirimFiyat,
	 SU.Miktar,
	 S.SiparisTarih,
	 U.AktifMi
FROM Siparisler AS S
JOIN SiparisUrunleri AS SU
	ON S.SiparisID = SU.SiparisID
JOIN Urunler AS U
	ON SU.UrunID = U.UrunID;



CREATE TRIGGER trg_UrunuYayindanKaldir
ON vw_MusteriSiparisleri
INSTEAD OF DELETE
AS
BEGIN
SET NOCOUNT ON;
	IF(SELECT COUNT(*) FROM deleted) > 0
	BEGIN
		DECLARE @ID INT
		SELECT @ID = UrunID FROM deleted
		UPDATE vw_MusteriSiparisleri
		SET AktifMi = 0
		WHERE UrunID = @ID;
	IF @@ROWCOUNT = 0
		RAISERROR('Eþleþme yok. Pasifleþtirme iþlemi yapýlamadý.', 10, 1)
	END;
SET NOCOUNT OFF;
END;



DELETE FROM vw_MusteriSiparisleri WHERE UrunID = 1;



SELECT * FROM Urunler;

----- BU ÖRNEÐÝ YAPMA  -----

CREATE TRIGGER trg_MusteriSiparisSil
ON vw_MusteriSiparisleri
INSTEAD OF DELETE
AS
BEGIN
SET NOCOUNT ON;
	IF(SELECT COUNT(*) FROM deleted) > 0
	BEGIN
		DELETE SU 
			FROM SiparisUrunleri AS SU
			JOIN deleted AS d
				ON d.SiparisID = SU.SiparisID
				AND d.UrunID = SU.UrunID
		DELETE S
			FROM Siparisler AS S
			JOIN deleted AS d
				ON S.SiparisID = d.SiparisID
			LEFT JOIN SiparisUrunleri AS SU
				ON SU.SiparisID = d.SiparisID
				AND SU.UrunID = d.SiparisID
	END;
SET NOCOUNT OFF;
END;

SELECT * FROM Siparisler;		
GO
SELECT * FROM SiparisUrunleri;

DELETE vw_MusteriSiparisleri WHERE SiparisID = 1 AND UrunID = 1;

SELECT * FROM Siparisler;		
GO
SELECT * FROM SiparisUrunleri;

--------------------

--	IF UPDATE() ve COLUMNS_UPDATED()


--	UPDATE() Fonksiyonu


CREATE TRIGGER Production.ProductNumberControl
ON Production.Product
AFTER UPDATE
AS
BEGIN
	IF UPDATE(ProductNumber)
	BEGIN
		PRINT 'ProductNumber deðeri deðiþtirilemez.';
		ROLLBACK
	END;
END;


select * from Production.Product WHERE ProductID = 527  -- SÝLÝNECEK KOD


UPDATE Production.Product
SET ProductNumber = 'SK-9284'
WHERE ProductID = 527;


--	COLUMNS_UPDATED() Fonksiyonu


CREATE TRIGGER trigger_ismi
ON tablo_ismi
FOR UPDATE[, INSERT, DELETE]
AS
IF COLUMNS_UPDATED() & maskeleme_degeri > 0
BEGIN
	-- Sütun deðiþikliklerine göre çalýþacak sorgu bloðu.
END;



--	Ýç Ýçe Trigger(Nested Trigger)


SELECT trigger_nestlevel(object_ID('trigger_ismi'));


sp_configure 'nested triggers', 0



--	Recursive Trigger


ALTER DATABASE veritabani_ismi
SET RECURSIVE_TRIGGERS ON



--	DDL Trigger'lar


--	Veritabaný Seviyeli DDL Trigger'lar


CREATE TRIGGER KritikNesnelerGuvenligi
ON DATABASE 
FOR CREATE_TABLE, CREATE_PROCEDURE, CREATE_VIEW 
AS 
   PRINT 'Bu veritabanýnda tablo, prosedür ve view oluþturmak yasaktýr!' 
   ROLLBACK;



CREATE TABLE test ( ID INT );



CREATE TABLE EventsLog
(
	EventType	VARCHAR(50),
	ObjectName	VARCHAR(256),
	ObjectType	VARCHAR(25),
	SQLCommand	VARCHAR(MAX),
	UserName	VARCHAR(256)
);



CREATE TRIGGER EventLogCreateBackup
ON DATABASE
FOR CREATE_PROCEDURE, CREATE_TABLE, CREATE_VIEW, CREATE_TRIGGER
AS
BEGIN
SET NOCOUNT ON;

DECLARE @Data XML;
SET @Data = EVENTDATA();

INSERT INTO dbo.EventsLog(EventType, ObjectName, ObjectType, 
				  SQLCommand, UserName)
VALUES(@Data.value('(/EVENT_INSTANCE/EventType)[1]', 'VARCHAR(50)'), 
       @Data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'VARCHAR(256)'), 
       @Data.value('(/EVENT_INSTANCE/ObjectType)[1]', 'VARCHAR(25)'), 
       @Data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'VARCHAR(MAX)'), 
       @Data.value('(/EVENT_INSTANCE/LoginName)[1]', 'VARCHAR(256)')
);
SET NOCOUNT OFF;
END;



CREATE TABLE test1
(ID INT);

CREATE VIEW view1
AS
SELECT * FROM test1;



SELECT * FROM EventsLog;


--	Sunucu Seviyeli DDL Trigger'lar


CREATE TRIGGER SunucuBazliDegisiklikler
ON ALL SERVER
FOR CREATE_DATABASE
AS
PRINT 'Veritabaný oluþturuldu.';
SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]',
	 'NVARCHAR(MAX)');



CREATE LOGIN yakalanacak_login WITH PASSWORD = 'pwd123';


SELECT * FROM master.sys.server_triggers;


--	Trigger Yönetimi

--	Trigger'ý Deðiþtirmek


ALTER TRIGGER SunucuBazliDegisiklikler
ON ALL SERVER
FOR CREATE_DATABASE, DDL_LOGIN_EVENTS
AS
PRINT 'Veritabaný ya da Login oluþturma olayý yakalandý.';
SELECT EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]',
	'NVARCHAR(MAX)');


CREATE LOGIN testLogin WITH PASSWORD = '123';


--	Trigger'larý Kapatmak ve Açmak


ALTER TABLE Production.Product
DISABLE TRIGGER ProductNumberControl;


ALTER TABLE Production.Product
DISABLE TRIGGER ALL;


ALTER TABLE Production.Product
ENABLE TRIGGER ProductNumberControl;


ALTER TABLE Production.Product
DISABLE TRIGGER ALL;


--	Trigger'larý Silmek


DROP TRIGGER trigger_ismi


--	Veritabaný Seviyeli DDL Trigger'larý Silmek


DROP TRIGGER EventLogCreateBackup 
ON DATABASE;


--	Sunucu Seviyeli DDL Trigger'larý Silmek


DROP TRIGGER SunucuBazliDegisiklikler
ON ALL SERVER;





















