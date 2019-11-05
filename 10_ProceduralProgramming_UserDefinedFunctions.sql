

--	Skaler Kullanýcý Tanýmlý Fonksiyonlar


CREATE FUNCTION PInedir()
RETURNS NUMERIC(5,2)
AS
BEGIN
    RETURN 3.14;
END;


SELECT dbo.PInedir();	


PRINT dbo.PInedir();


SELECT PI();


CREATE FUNCTION dbo.UrunToplamSayi()
RETURNS INT
AS
BEGIN
	DECLARE @toplam INT;
	SELECT @toplam = COUNT(ProductID) FROM Production.Product;
	RETURN @toplam;
END;


SELECT dbo.UrunToplamSayi();


CREATE FUNCTION dbo.KullaniciGetir(@KullniciKod INT = NULL)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @ad_soyad VARCHAR(100)
	SELECT @ad_soyad = FirstName + ' ' + LastName 
	FROM Person.Person WHERE BusinessEntityID = @KullniciKod
	RETURN @ad_soyad
END;


SELECT dbo.KullaniciGetir(1);	


--	Türetilmiþ Sütun Olarak Skaler Fonksiyon


SELECT 
	BusinessEntityID, PersonType, Title, 
	dbo.KullaniciGetir(BusinessEntityID) AS AdSoyad 
FROM Person.Person;



ALTER TABLE Person.Person
ADD AdSoyad AS dbo.KullaniciGetir(BusinessEntityID);


--	Satýrdan Tablo Döndüren Fonksiyonlar


CREATE FUNCTION fnc_UrunAra(
	@ara VARCHAR(10)
)RETURNS TABLE
AS
RETURN SELECT * FROM Production.Product 
WHERE Name LIKE '%' + @ara + '%';


SELECT * FROM dbo.fnc_UrunAra('Be');


--	Çoklu Ýfade Ýle Tablo Döndüren Fonksiyonlar


CREATE FUNCTION dbo.BelirliAraliktakiUrunler(@ilk INT, @son INT)
RETURNS @values TABLE
(
	ProductID		INT,
	Name			VARCHAR(30),
	ProductNumber	VARCHAR(7)
)
AS
BEGIN
	INSERT @values
		SELECT ProductID, Name, ProductNumber 
		FROM Production.Product
		WHERE  ProductID >= @ilk AND ProductID <= @son
	RETURN
END;


SELECT * FROM dbo.BelirliAraliktakiUrunler(1, 4);



CREATE FUNCTION dbo.IntegerAyirici(@liste   VARCHAR(8000), 
								   @ayirac  VARCHAR(10) = ',')
RETURNS @tabloDeger TABLE 
( 
	[Parça] INT 
)
AS
BEGIN 
  DECLARE @parca VARCHAR(255)
  WHILE (DATALENGTH(@liste) > 0)
    BEGIN 
      IF CHARINDEX(@ayirac, @liste) > 0
        BEGIN
          SELECT @parca = SUBSTRING(@liste,1,
							(CHARINDEX(@ayirac, @liste)-1))
          SELECT @liste = SUBSTRING(@liste,(CHARINDEX(@ayirac, @liste) 
					+ DATALENGTH(@ayirac)), DATALENGTH(@liste))
        END
     ELSE
        BEGIN
          SELECT @parca = @liste
          SELECT @liste = NULL
        END
    INSERT @tabloDeger([Parça])
    SELECT [Parça] = CONVERT(INT, @parca) 
   END
 RETURN
END;



SELECT * FROM dbo.Integer_Ayirici('10, 20, 30, 300, 423, 156, 983', ','); 



CREATE FUNCTION dbo.PersonTypePerson(@pt_sp VARCHAR(2), @pt_sc VARCHAR(2), @pt_vc VARCHAR(2), @pt_in VARCHAR(2), @pt_gc VARCHAR(2))
RETURNS @PersonTypeData TABLE
(
	BusinessEntityID INT,
	PersonType	VARCHAR(2),
	FirstName VARCHAR(50),
	LastName VARCHAR(50)
)
AS
BEGIN
	INSERT @PersonTypeData
  		SELECT BusinessEntityID, PersonType, FirstName, LastName 
		FROM Person.Person
		WHERE PersonType = @pt_sp
	INSERT @PersonTypeData
  		SELECT BusinessEntityID, PersonType, FirstName, LastName 
		FROM Person.Person
		WHERE PersonType = @pt_sc
	INSERT @PersonTypeData
  		SELECT BusinessEntityID, PersonType, FirstName, LastName 
		FROM Person.Person
		WHERE PersonType = @pt_vc
	INSERT @PersonTypeData
  		SELECT BusinessEntityID, PersonType, FirstName, LastName 
		FROM Person.Person
		WHERE PersonType = @pt_in
	INSERT @PersonTypeData
  		SELECT BusinessEntityID, PersonType, FirstName, LastName 
		FROM Person.Person
		WHERE PersonType = @pt_gc
	RETURN
END;



SELECT * FROM dbo.PersonTypePerson('SP','SC','VC','IN','GC');


--	Kullanýcý Tanýmlý Fonksiyonlarda Kod Gizliliði : Þifrelemek


ALTER FUNCTION dbo.KullaniciGetir(@KullniciKod INT = NULL)
RETURNS VARCHAR(100)
WITH ENCRYPTION
AS
BEGIN
	DECLARE @ad_soyad VARCHAR(100)
	SELECT @ad_soyad = FirstName + ' ' + LastName 
	FROM Person.Person WHERE BusinessEntityID = @KullniciKod
	RETURN @ad_soyad
END;



EXEC sp_helptext 'dbo.KullaniciGetir';


--	Determinizm


SELECT rowguid, ModifiedDate FROM Production.Product;


SELECT RAND();


CREATE FUNCTION dbo.fnc_Rand()		-- Hatalý Fonksiyon
RETURNS FLOAT
AS
BEGIN
	RETURN RAND()
END;


CREATE VIEW dbo.vw_Rand
AS
SELECT RAND() AS RANDOM;



CREATE FUNCTION dbo.fnc_Rand()
RETURNS FLOAT
AS
BEGIN
	RETURN (SELECT * FROM dbo.vw_Rand)
END;



SELECT dbo.fnc_Rand() AS RANDOM;


--	Schema Binding


ALTER FUNCTION fnc_UrunAra(@ara VARCHAR(10))
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT ProductID, Name FROM Production.Product 
WHERE Name LIKE '%' + @ara + '%';



WITH SCHEMABINDING, ENCRYPTION


--	Tablolarla Tablo Tipi Fonksiyonlarý Birleþtirmek


CREATE TABLE Departments(
   DepartmentID int NOT NULL PRIMARY KEY,
   Name VARCHAR(250) NOT NULL,
) ON [PRIMARY];



CREATE TABLE Employees(
   EmployeesID int NOT NULL PRIMARY KEY,
   FirstName VARCHAR(250) NOT NULL,
   LastName VARCHAR(250) NOT NULL,
   DepartmentID int NOT NULL REFERENCES Departments(DepartmentID),
) ON [PRIMARY];



INSERT Departments (DepartmentID, Name) 
VALUES (1, N'Mühendislik'),(2, N'Yönetim'),(3, N'Satýþ'),
	 (4, N'Pazarlama'),(5, N'Finans')



INSERT Employees (EmployeesID, FirstName, LastName, DepartmentID)
VALUES (1, N'Kerim', N'Fýrat', 1 ), (2, N'Cihan', N'Özhan', 2 ), 
	 (3, N'Emre', N'Okumuþ', 3 ), (4, N'Barýþ', N'Özhan', 3 );


SELECT * FROM Employees;



SELECT * FROM Departments;


--	CROSS APPLY


SELECT * FROM Departments D
INNER JOIN Employees E ON D.DepartmentID = E.DepartmentID;


SELECT * FROM Departments D
CROSS APPLY
(
	SELECT * FROM Employees E WHERE E.DepartmentID = D.DepartmentID
)DIJIBIL;


--	OUTER APPLY


SELECT * FROM Departments D
LEFT OUTER JOIN Employees E ON D.DepartmentID = E.DepartmentID;


SELECT * FROM Departments D
OUTER APPLY
(
   SELECT * FROM Employees E WHERE E.DepartmentID = D.DepartmentID
)KODLAB;



--	CROSS APPLY ve OUTER APPLY Operatörlerinin Fonksiyonlar Ýle Kullanýmý


CREATE FUNCTION dbo.fnc_GetAllEmployeeOfADepartment(@DeptID AS INT) 
RETURNS TABLE
AS
RETURN
(
   SELECT * FROM Employees E WHERE E.DepartmentID = @DeptID
);



SELECT * FROM Departments D
CROSS APPLY dbo.fnc_GetAllEmployeeOfADepartment(D.DepartmentID);


SELECT * FROM Departments D
OUTER APPLY dbo.fnc_GetAllEmployeeOfADepartment(D.DepartmentID);


--	Kullanýcý Tanýmlý Fonksiyonlarý Deðiþtirmek


ALTER FUNCTION dbo.BelirliAraliktakiUrunler(@ilk INT, @son INT)
	RETURNS @values TABLE
	(
		ProductID		INT,
		Name			VARCHAR(30),
		ProductNumber	VARCHAR(7),
		ListPrice		MONEY
	)
AS
BEGIN
	INSERT @values
		SELECT ProductID, Name, ProductNumber, ListPrice 
		FROM Production.Product
		WHERE  ProductID >= @ilk AND ProductID <= @son
	RETURN
END;
















