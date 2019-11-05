

--	Tablo Oluþturma Sýrasýnda Primary Key Oluþturmak


CREATE TABLE Urunler(
	UrunID	INT,
	UrunAd	VARCHAR(200),
	UrunFiyat	MONEY,
	CONSTRAINT  PKC_UrunID PRIMARY KEY(UrunID)
);



CREATE TABLE Urunler(
	UrunID	INT IDENTITY NOT NULL PRIMARY KEY,
	UrunAd	VARCHAR(200),
	UrunFiyat	MONEY
);



sp_helpconstraint 'Urunler';


--	Mevcut Bir Tabloda Primary Key Oluþturmak


CREATE TABLE Kullanicilar(
	KullaniciID		INT PRIMARY KEY NOT NULL,
	Ad			VARCHAR(50),
	Soyad			VARCHAR(50),
	KullaniciAd		VARCHAR(20)
);



ALTER TABLE Kullanicilar
ADD CONSTRAINT PKC_KullaniciID PRIMARY KEY(KullaniciID);


--	Unique Key Constraint Oluþturmak

--	Tablo Oluþturma Sýrasýnda Unique Key Constraint Oluþturmak


CREATE TABLE Personeller
(
	PersonelID	INT PRIMARY KEY NOT NULL,
	Ad		VARCHAR(255) NOT NULL,
	Soyad		VARCHAR(255) NOT NULL,
	KullaniciAd	VARCHAR(10) NOT NULL UNIQUE,
	Email		VARCHAR(50),
	Adres		VARCHAR(255),
	Sehir		VARCHAR(255),
);



CREATE TABLE Personeller
(
	PersonelID	INT PRIMARY KEY NOT NULL,
	Ad		VARCHAR(255) NOT NULL,
	Soyad		VARCHAR(255) NOT NULL,
	KullaniciAd	VARCHAR(10) NOT NULL,
	Email		VARCHAR(50),
	Adres		VARCHAR(255),
	Sehir		VARCHAR(255),
	UNIQUE (KullaniciAd)
);



sp_helpconstraint 'Personeller';


--	Mevcut Bir Tabloda Unique Key Oluþturmak


ALTER TABLE Personeller
ADD CONSTRAINT UQ_PersonelEmail
UNIQUE (Email)



--	Default Constraint


--	Tablo Oluþtururken DEFAULT Constraint Tanýmlama


DROP TABLE Personeller



CREATE TABLE Personeller
(
	PersonelID	INT PRIMARY KEY NOT NULL,
	KullaniciAd	VARCHAR(20) NOT NULL,
	Email		VARCHAR(50),
	Sehir		VARCHAR(50),
	KayitTarih	SMALLDATETIME NOT NULL DEFAULT GETDATE()
);



INSERT INTO Personeller(PersonelID, KullaniciAd, Email, Sehir)
VALUES(1,'SamilAyyildiz','samil.ayyildiz@abc.com', 'Ýstanbul');


SELECT * FROM Personeller;


sp_helpconstraint 'Personeller';



--	Var Olan Tabloya DEFAULT Constraint Eklemek


ALTER TABLE Personeller
ADD CONSTRAINT DC_KayitTarih DEFAULT GETDATE() FOR KayitTarih


ALTER TABLE Personeller
ADD CONSTRAINT DC_Sehir DEFAULT 'Tanýmsýz' FOR Sehir


--	Check Constraint


CREATE TABLE Kullanicilar
(
	KullaniciID		INT PRIMARY KEY NOT NULL,
	KullaniciAd		VARCHAR(20) NOT NULL,
	Sifre			VARCHAR(15) NOT NULL,
	Email			VARCHAR(40) NOT NULL,
	Telefon		VARCHAR(11) NOT NULL
);



ALTER TABLE Kullanicilar
ADD CONSTRAINT CHK_SifreUzunluk CHECK(LEN(Sifre) >= 5 AND LEN(Sifre) <= 15)


ALTER TABLE Kullanicilar
ADD CONSTRAINT CHK_Email CHECK(CHARINDEX('@', Email) > 0 OR Email IS NULL)


INSERT INTO Kullanicilar
VALUES(1,'cihan','sifre','cihan.ozhan@hotmail.com','05551112233');


INSERT INTO Kullanicilar
VALUES(1,'cihan','sifre1','cihan.ozhan@hotmail.com');


INSERT INTO Kullanicilar
VALUES(1,'cihan','sifre','cihan.ozhan-hotmail.com');


INSERT INTO Kullanicilar
VALUES(1,'cihan','sifre','cihan.ozhan@hotmail.com','5551112233');


ALTER TABLE Kullanicilar
ADD CONSTRAINT CHK_Telefon CHECK(
Telefon IS NULL OR(
Telefon LIKE '[0][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') 
AND LEN(Telefon) = 11)



ALTER TABLE Kullanicilar
ADD CONSTRAINT CHK_Telefon CHECK(
Telefon IS NULL OR(
Telefon LIKE '[0][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') 
AND LEN(Telefon) = 14)


--	Sütunlar Arasý Check Constraint


CREATE TABLE Uyeler
(
	UyelerID	INT PRIMARY KEY NOT NULL,
	UyelikAd	VARCHAR(20) NOT NULL,
	Sifre		VARCHAR(10) NOT NULL,
	Email		VARCHAR(30),
	Telefon	VARCHAR(11),
	GirisTarih	DATETIME,
	CikisTarih	DATETIME NULL,
	CONSTRAINT CHK_CalismaTarih CHECK(
	CikisTarih IS NULL OR CikisTarih >= GirisTarih)
);



INSERT INTO Uyeler
VALUES(1,'cihan','sifre','cihan.ozhan@hotmail.com','05310806080',
	 '2011-01-15','2011-11-25');



INSERT INTO Uyeler
VALUES(1,'cihan','sifre','cihan.ozhan@hotmail.com','05310806080',
	 '2011-01-15','2010-11-25');


--	Foreign Key Constraint


CREATE TABLE Kategoriler
(
	KategoriID	INT IDENTITY PRIMARY KEY,
	KategoriAd	VARCHAR(20)
);



CREATE TABLE Makaleler
(
	MakaleID		INT IDENTITY PRIMARY KEY,
	Baslik		VARCHAR(100),
	Icerik		VARCHAR(MAX),
	KategoriID		INT FOREIGN KEY REFERENCES Kategoriler(KategoriID),
	EklenmeTarih	DATETIME
);



--	Var Olan Tabloya Foreign Key Constraint Eklemek


ALTER TABLE Makaleler
ADD CONSTRAINT FK_MakaleKategoriler
FOREIGN KEY(KategoriID) REFERENCES Kategoriler(KategoriID)


sp_helpconstraint 'Makaleler'



--	Constraint'leri Ýncelemek


EXEC sp_helpconstraint 'Production.Product';


--	Constraint'leri Devre Dýþý Býrakmak


--	Bozuk Veriyi Ýhmal Etmek


ALTER TABLE Kullanicilar
WITH NO CHECK
ADD CONSTRAINT CHK_Telefon CHECK(
Telefon IS NULL OR(
Telefon LIKE '[0][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') 
AND LEN(Telefon) = 14)


--	Constraint'i Geçici Olarak Devre Dýþý Býrakmak


ALTER TABLE Kullanicilar
NOCHECK
CONSTRAINT CHK_Telefon





































































































































