

--	Hata Mesajlarý


INSERT INTO Production.Product(Name, ProductNumber)
VALUES('Test Ürün','AR-5388');


SELECT * FROM sys.messages;


SELECT * FROM sys.messages WHERE message_id = 515;


SELECT * FROM sys.messages WHERE message_id = 515 AND language_id = 1033;


SELECT * FROM sys.messages WHERE message_id = 515 AND language_id = 1055;


--	Mesajlarý Görüntülemek


SELECT * FROM sys.messages;


SELECT * FROM SYS.Messages ORDER BY Message_ID DESC;


sp_addmessage @msgnum = 'mesaj_kod',
	        @severity = 'seviye',
	        @msgtext = 'mesaj',
	        @with_log = 'true'|'false',
	        @lang = 'dil_kod',
		  @replace = ''


sp_addmessage @msgnum = '50006',
		  @severity = 10,
		  @msgtext = 'Geçerli bir ürün numarasý giriniz',
		  @with_log = 'true';


SELECT * FROM SYS.Messages WHERE Message_ID = 50006;


--	Parametreli Hata Mesajý Tanýmlamak



sp_addmessage @msgnum = 50002, 
    	        @severity = 11, 
		  @msgtext = '%d adet ürün %s kullanýcýsý tarafýndan silindi.',
		  @with_log = 'true'


--	Mesaj Silmek


sp_dropmessage 50001


--	Oluþan Son Hatanýn Kodunu Yakalamak : @@ERROR


DECLARE @deadline INT, @hataKod INT;

SET @deadline = 0

SELECT DaysToManufacture / @deadline 
FROM Production.Product 
WHERE ProductID = 921

SET @hataKod = @@ERROR

IF @@ERROR <> 8134
BEGIN
PRINT CAST(@hataKod AS VARCHAR) + ' No''lu sýfýra bölünme hatasý.';
END
ELSE IF @@ERROR <> 0
BEGIN
PRINT CAST(@hataKod AS VARCHAR) + ' No''lu bilinmeyen bir hata oluþtu.';
END;



CREATE PROC pr_HataGoster(
	@hataKod	INT,
	@dilKod	INT
)
AS
BEGIN
	DECLARE @text VARCHAR(100);
	SELECT @text = Text FROM sys.messages 
	WHERE message_id = @hataKod AND language_id = @dilKod;
	PRINT @text;
END;




EXEC pr_HataGoster 8134, 1055;




DECLARE @deadline INT, @hataKod INT, @dilKod INT

SET @deadline = 0

SELECT DaysToManufacture / @deadline FROM Production.Product 
WHERE ProductID = 921

SET @hataKod = @@ERROR;
SET @dilKod	= 1055;	-- Türkçe dil kodu

IF @@ERROR <> 8134
BEGIN
  -- Sýfýra bölünme hatasýnýn Türkçe açýklamasýný getirir.
  EXEC pr_HataGoster @hataKod, @dilKod
END
ELSE IF @@ERROR <> 0
BEGIN
  -- Hangi hata gerçekleþirse o hatanýn Türkçe açýklamasýný getirir.
  EXEC pr_HataGoster @hataKod, @dilKod	
END;



--	Stored Procedure Ýçerisinde @@ERROR Kullanýmý



CREATE PROCEDURE HumanResources.pr_DeleteCandidate(
    @CanID INT
)
AS
DELETE FROM HumanResources.JobCandidate WHERE JobCandidateID = @CanID;
IF @@ERROR <> 0 
    BEGIN
	  -- Baþarýsýz olduðunu göstermek için 99 döndürür.
        PRINT N'Aday silme iþleminde bir hata oluþtu.';
        RETURN 99;
    END
ELSE
    BEGIN
        -- Baþarýlý olduðunu göstermek için 0 döndürür.
        PRINT N'Ýþ adayý silindi.';
        RETURN 0;
    END;


--	RAISERROR Ýfadesi


RAISERROR('Mevcut bir ürünü eklemeye çalýþýyorsunuz.', 10, 1);



RAISERROR('Mevcut bir ürünü eklemeye çalýþýyorsunuz.', 16, 1);



DECLARE @DBID INT;
DECLARE @DBNAME NVARCHAR(128);

SET @DBID = DB_ID();
SET @DBNAME = DB_NAME();

RAISERROR
    (N'Þu anki veritabaný ID deðeri: %d ve veritabaný adý: %s.',
    10, -- Þiddet.
    1, -- Durum.
    @DBID, -- Ýlk argüman.
    @DBNAME); -- Ýkinci argüman.



DECLARE @DBID INT;
DECLARE @DBNAME NVARCHAR(128);

SET @DBID = DB_ID();
SET @DBNAME = DB_NAME();

RAISERROR
   (N'Þu anki veritabaný ID deðeri: %d ve veritabaný adý: %s. Coder : %s',
    10, -- Þiddet.
    1, -- Durum.
    @DBID, -- Ýlk argüman.
    @DBNAME, -- Ýkinci argüman.
    'Cihan Özhan'); -- Üçüncü argüman.




EXECUTE sp_addmessage 
	  50007, 
	  10,
    	  N'Þu anki veritabaný ID deðeri: %d ve veritabaný adý: %s.';

DECLARE @DBID INT;
SET @DBID = DB_ID();

DECLARE @DBNAME NVARCHAR(128);
SET @DBNAME = DB_NAME();

RAISERROR (50007, 10, 1, @DBID, @DBNAME);



--	THROW  Ýfadesi


THROW 50001, 'Ürün ekleme sýrasýnda bir hata meydana geldi.', 5;



USE tempdb;
GO
CREATE TABLE dbo.Deneme_Tablo
(
  sutun_1 int NOT NULL PRIMARY KEY,
  sutun_2 int NULL
);




BEGIN TRY
  TRUNCATE TABLE dbo.Deneme_Tablo;
  INSERT dbo.Deneme_Tablo VALUES(1, 1);
  PRINT 'Ýlk Ekleme Sonrasý';
  -- Msg 2627, Level 14, State 1 - PRIMARY KEY kýsýtlama ihlali
  INSERT dbo.Deneme_Tablo VALUES(1, 1);
  PRINT 'Ýkinci Ekleme Sonrasý';
END TRY
BEGIN CATCH
  PRINT 'Gerekirse burada istisna iþlenebilir ve fýrlatýlabilir.';
  THROW;
END CATCH;




SELECT * FROM Deneme_Tablo;



--	Hata Kontrolü ve TRY-CATCH


DECLARE @sayi1 INT = 5
DECLARE @sayi2 INT = 0
DECLARE @sonuc INT

BEGIN TRY
	SET @sonuc = @sayi1 / @sayi2
END TRY
BEGIN CATCH
	PRINT CAST(@@ERROR AS VARCHAR) + ' no lu hata oluþtu'
END CATCH;



SELECT * FROM sys.messages WHERE message_id = 8134 AND language_id = 1055;




CREATE PROCEDURE pr_HataBilgisiGetir
AS
SELECT
     ERROR_NUMBER() AS ErrorNumber,
     ERROR_SEVERITY() AS ErrorSeverity,
     ERROR_STATE() AS ErrorState,
     ERROR_PROCEDURE() AS ErrorProcedure,
     ERROR_LINE() AS ErrorLine,
     ERROR_MESSAGE() AS ErrorMessage;




DECLARE @sayi1 INT = 5
DECLARE @sayi2 INT = 0
DECLARE @sonuc INT

BEGIN TRY
	SET @sonuc = @sayi1 / @sayi2
END TRY
BEGIN CATCH
	EXECUTE pr_HataBilgisiGetir;
END CATCH;











































