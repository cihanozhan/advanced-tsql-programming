

--	PRINT Komutu


USE KodLab
GO
DECLARE @kitap VARCHAR(29);
SET @kitap = 'Ýleri Seviye SQL Server T-SQL';
PRINT @kitap
GO




--	CREATE DATABASE ile Veritabaný Oluþturmak


USE master
CREATE DATABASE KodLab




CREATE DATABASE DIJIBIL 
ON  PRIMARY 
( 
	NAME = N'DIJIBIL_Data', 
	FILENAME = N'C:\Databases\DIJIBIL_Data.mdf',
	SIZE = 21632KB, 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 16384KB 
)
LOG ON 
( 
	NAME = N'DIJIBIL_Log', 
	FILENAME = N'C:\Databases\DIJIBIL_Log.ldf',
	SIZE = 2048KB, 
	MAXSIZE = 2048GB, 
	FILEGROWTH = 16384KB 
)
GO


EXEC sp_helpdb 'DIJIBIL';




--	CREATE TABLE ile Tablo Oluþturmak



SELECT FirstName + ' ' + LastName AS [Ýsim] FROM Person.Person;



USE DIJIBIL
GO
CREATE TABLE diji_Kullanicilar(
	kul_ID	INT	       NOT NULL,
	kul_ad	VARCHAR(20)  NOT NULL,
	kul_soyad	VARCHAR(20)  NOT NULL,
	kul_telefon	VARCHAR(11)  NULL,
	kul_email	VARCHAR(320) NOT NULL
);



EXECUTE sp_help 'diji_Kullanicilar';



--	ALTER ile Veritabaný Yapýsýný Deðiþtirmek



EXEC sp_helpdb DIJIBIL;



ALTER DATABASE DIJIBIL
MODIFY FILE
(
	NAME = DIJIBIL_Data,
	SIZE = 300MB
);


EXEC sp_helpdb DIJIBIL;



--	ALTER ile Tablo Yapýsýný Deðiþtirmek




EXEC sp_help diji_Kullanicilar;



ALTER TABLE diji_Kullanicilar
ADD
kul_adres	    VARCHAR(150) NULL,
kul_kayitTarih  DATETIME     NOT NULL DEFAULT GETDATE();




--	DROP ile Tablo Silmek


USE DIJIBIL						
GO
DROP TABLE diji_Kitaplar;




--	DROP ile Veritabaný Silmek


USE master
GO
DROP DATABASE KodLab;



--	INSERT ile Veri Eklemek



INSERT INTO diji_Kullanicilar
VALUES(1,'Cihan','Özhan','02124537488','cihan.ozhan@dijibil.com','Istanbul',GETDATE());




--	SELECT ile Veri Seçmek


USE DIJIBIL
GO
SELECT * FROM diji_Kullanicilar;



USE DIJIBIL
GO
SELECT 
	kul_ID,kul_ad,kul_soyad,kul_telefon,
	kul_email,kul_adres,kul_kayitTarih 
FROM 
	diji_Kullanicilar;




--	UPDATE ile Veri Güncellemek


UPDATE diji_Kullanicilar
SET 	kul_adres = 'Ýstanbul / Fatih'
WHERE kul_ID = 2;



--	DELETE ile Veri Silmek


DELETE FROM diji_Kullanicilar WHERE kul_ID = 2;



DELETE FROM diji_Kullanicilar;



--	GRANT ile Yetki Vermek


GRANT CREATE TABLE
TO DIJIUser;


GRANT CREATE TABLE TO AppRole, DIJIUser;


CREATE USER newDijiUser FOR LOGIN DIJILogin;


GRANT CREATE DATABASE, CREATE TABLE TO newDijiUser;



--	WITH GRANT OPTION ile Basamaklý Yetkilendirme



GRANT SELECT, INSERT ON diji_Kullanicilar
TO AppRole
WITH GRANT OPTION;



--	DENY ile Eriþimi Kýsýtlamak


DENY CREATE TABLE TO DIJIUser;


DENY SELECT ON diji_Kullanicilar TO DIJIUser;



--	REVOKE ile Eriþim Tanýmýný Kaldýrmak


REVOKE ALL TO PUBLIC


REVOKE SELECT ON diji_Kullanicilar TO DIJIUser;








