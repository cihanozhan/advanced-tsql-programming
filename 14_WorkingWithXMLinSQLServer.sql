

--	XML


<root>
	<kitap kitapID=123> Ýleri Seviye SQL Server T-SQL </kitap>
	<kitap kitapID=124> Ýleri Seviye Android Programlama </kitap>
<root>


--	XML Tipi ile Deðiþken ve Parametre Kullanmak


DECLARE @xml_veri VARCHAR(MAX);
SET @xml_veri = '
	<kitaplar>
		<kitap>Ýleri Seviye SQL Server T-SQL</kitap>
		<kitap>Ýleri Seviye Android Programlama</kitap>
		<kitap>Java SE</kitap>
	</kitaplar>';
SELECT CAST(@xml_veri AS XML);
SELECT CONVERT(XML, @xml_veri);
PRINT @xml_veri;



DECLARE @xml_veri XML
SET @xml_veri = '
	<kitaplar>
		<kitap>Ýleri Seviye SQL Server T-SQL</kitap>
		<kitap>Ýleri Seviye Android Programlama</kitap>
		<kitap>Java SE</kitap>
	</kitaplar>'
SELECT CAST(@xml_veri AS VARCHAR(MAX))
SELECT CONVERT(VARCHAR(MAX), @xml_veri)
PRINT CONVERT(VARCHAR(MAX), @xml_veri)


--	Tip Tanýmsýz XML Veri Ýle Çalýþmak(UnTyped)


CREATE TABLE OzGecmis
(
  AdayID INT IDENTITY PRIMARY KEY,
  AdayOzGecmis XML
);


INSERT INTO OzGecmis(AdayOzGecmis)
SELECT Resume FROM HumanResources.JobCandidate;


SELECT * FROM OzGecmis;


DECLARE @Aday XML;
SELECT @Aday = AdayOzGecmis FROM OzGecmis WHERE AdayID = 1;
SELECT @Aday AS Resume; 


<ns:Name>
  <ns:Name.Prefix>M.</ns:Name.Prefix>
  <ns:Name.First>Thierry</ns:Name.First>
  <ns:Name.Middle />
  <ns:Name.Last>D'Hers</ns:Name.Last>
  <ns:Name.Suffix />
</ns:Name>



CREATE PROCEDURE AdayEkle( @Aday XML )
AS
INSERT INTO OzGecmis(AdayOzGecmis) VALUES(@Aday);



DECLARE @AdayProc XML;
SELECT @AdayProc = Resume FROM HumanResources.JobCandidate 
			 	   WHERE JobCandidateID = 8;
EXEC AdayEkle @AdayProc;


SELECT * FROM OzGecmis ORDER BY AdayID DESC;


--	Tip Tanýmlý XML Veri Ýle Çalýþmak(Typed)


CREATE TABLE OzGecmis
(
  AdayID INT IDENTITY PRIMARY KEY,
  AdayOzGecmis XML (HumanResources.HRResumeSchemaCollection)
);


INSERT INTO OzGecmis (AdayOzGecmis)
SELECT Resume FROM HumanResources.JobCandidate;


SELECT * FROM OzGecmis; 


DECLARE @Aday XML (HumanResources.HRResumeSchemaCollection);
SELECT @Aday = AdayOzGecmis FROM OzGecmis WHERE AdayID = 8;
SELECT @Aday AS Aday;


ALTER PROCEDURE AdayEkle
  @Aday XML (HumanResources.HRResumeSchemaCollection)
AS
INSERT INTO OzGecmis (AdayOzGecmis)
VALUES (@Aday);



DECLARE @AdayProc XML;
SELECT @AdayProc = Resume FROM HumanResources.JobCandidate WHERE JobCandidateID = 8;
EXEC AdayEkle @AdayProc;



SELECT * FROM OzGecmis;


--	XML Veri Tipi ile Çoklu Veri Ýþlemleri


CREATE TABLE Kitaplar
(
	KitapID	INT IDENTITY(1,1) PRIMARY KEY,
	Ad		VARCHAR(60),
	KitapDetay	XML
);


INSERT INTO Kitaplar(Ad, KitapDetay)
VALUES('Ýleri Seviye SQL Server T-SQL',
	'<Kitap>
		<Yazar>Cihan Özhan</Yazar>
		<ISBN>978-975-17-2268-7</ISBN>
		<Ozet>Ýleri seviye SQL Server kitabý.</Ozet>
		<SayfaSayisi>500</SayfaSayisi>
		<BaskiSayisi>3</BaskiSayisi>
	</Kitap>'),(
	'Ýleri Seviye Android Programlama',
	'<Kitap>
		<Yazar>Kerim FIRAT</Yazar>
		<ISBN>978-975-17-2243-8</ISBN>
		<Ozet>Ýleri seviye Android programlama kitabý.</Ozet>
		<SayfaSayisi>800</SayfaSayisi>
		<BaskiSayisi>5</BaskiSayisi>
	</Kitap>');


SELECT * FROM Kitaplar;


ALTER PROC KitapEkle
(
	@Ad		VARCHAR(60),
	@KitapDetay	XML
)
AS
BEGIN
	INSERT INTO Kitaplar(Ad, KitapDetay)
	VALUES(@Ad, @KitapDetay)
END;



DECLARE @KD	XML;
SET @KD = '<Kitap>
		<Yazar>Kerim FIRAT</Yazar>
		<ISBN>978-975-17-2243-8</ISBN>
		<Ozet>Java Standard Edition eðitim kitabý.</Ozet>
		<SayfaSayisi>700</SayfaSayisi>
		<BaskiSayisi>4</BaskiSayisi>
	    </Kitap>';
EXEC KitapEkle 'Java SE', @KD;



--	XML Þema Koleksiyonlarý


--	DOCTYPE Bildirimi


<!DOCTYPE dijibil SYSTEM "http://www.dijibil.com/dtds/dijibil.dtd">


--	ELEMENT Bildirimi


<!ELEMENT isim CATALOG>


<!ELEMENT isim (content)>


<!ELEMENT br EMPTY>


<!ELEMENT br ANY>


<!ELEMENT soyisim (#PCDATA)>


<!ELEMENT dijibil (isim, soyisim)>


<!ELEMENT dijibil (isim|soyisim)>


--	ATTLIST Bildirimi


<!ATTLIST dijibil 
	    UserID CDATA #REQUIRED 
	    UserNO  CDATA #IMPLIED>


<!ATTLIST kullanici cinsiyet (bay | bayan) #IMPLIED>


<!ATTLIST kullanici cinsiyet (bay | bayan) "bay" #IMPLIED>


--	XML Þema Koleksiyonlarý Hakkýnda Bilgi Almak


SELECT * FROM sys.xml_schema_collections;


SELECT * FROM sys.xml_schema_namespaces;


--	XML_SCHEMA_NAMESPACE ile Þema Koleksiyonlarýný Listelemek


SELECT 
xml_schema_namespace(
	N'Production',
	N'ProductDescriptionSchemaCollection');



SELECT xml_schema_namespace(
	N'Production',
	N'ProductDescriptionSchemaCollection').query('
/xs:schema[@targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain"]');


SELECT xml_schema_namespace(
	N'Production',
	N'ProductDescriptionSchemaCollection', 	N'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain');


--	XML Þema Koleksiyonu Oluþturmak


CREATE XML SCHEMA COLLECTION EmployeeSchema
    AS'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <xsd:element >
        <xsd:complexType>
            <xsd:sequence>
                <xsd:element />
                <xsd:element />
                <xsd:element />
            </xsd:sequence>
        </xsd:complexType>
    </xsd:element>
</xsd:schema>'



SELECT xml_schema_namespace(
	N'Production',
	N'ProductDescriptionSchemaCollection', 	N'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain');


CREATE XML SCHEMA COLLECTION yeniXMLSemaKoleksiyon AS ''


CREATE XML SCHEMA COLLECTION yeniXMLSemaKoleksiyon AS
'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain" elementFormDefault="qualified">
  <xsd:element name="Maintenance">
    <xsd:complexType>
      <xsd:complexContent>
        <xsd:restriction base="xsd:anyType">
          <xsd:sequence>
            <xsd:element name="NoOfYears" type="xsd:string" />
            <xsd:element name="Description" type="xsd:string" />
          </xsd:sequence>
        </xsd:restriction>
      </xsd:complexContent>
    </xsd:complexType>
  </xsd:element>
  <xsd:element name="Warranty">
    <xsd:complexType>
      <xsd:complexContent>
        <xsd:restriction base="xsd:anyType">
          <xsd:sequence>
            <xsd:element name="WarrantyPeriod" type="xsd:string" />
            <xsd:element name="Description" type="xsd:string" />
          </xsd:sequence>
        </xsd:restriction>
      </xsd:complexContent>
    </xsd:complexType>
  </xsd:element>
</xsd:schema>';



SELECT xml_schema_namespace(
	N'dbo',N'yeniXMLSemaKoleksiyon', 	N'http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain');


--	XML Þema Koleksiyonu Deðiþtirmek


DROP XML SCHEMA COLLECTION yeniXMLSemaKoleksiyon;


--	XML Veri Tipi Metodlarý


CREATE TABLE Magazalar
(
  MagazaID 		INT PRIMARY KEY,
  Anket_UnTyped	XML,
  Anket_Typed	XML(Sales.StoreSurveySchemaCollection)
);




INSERT INTO Magazalar
VALUES
(292,'<MagazaAnket>
	    <YillikSatis>145879</YillikSatis>
	    <YillikGelir>79277</YillikGelir>
	    <BankaAd>HIC Bank</BankaAd>
	    <IsTuru>CO</IsTuru>
	    <AcilisYil>2005</AcilisYil>
	    <Uzmanlik>Technology</Uzmanlik>
	    <Markalar>2</Markalar>
	    <Internet>ISDN</Internet>
	    <CalisanSayisi>14</CalisanSayisi>
	    <Urunler Tip="Yazilim">
	      <Urun>Mobil</Urun>
	      <Urun>Masaüstü</Urun>
	      <Urun>Sistem</Urun>
	      <Urun>Web</Urun>
	    </Urunler>
	    <Urunler Tip="Eðitim">
	      <Urun>Android</Urun>
	      <Urun>Oracle</Urun>
	      <Urun>Java</Urun>
	    </Urunler>
	</MagazaAnket>',
(SELECT Demographics FROM Sales.Store  WHERE BusinessEntityID = 292));



SELECT * FROM Magazalar;


--	xml.query


SELECT Anket_UnTyped.query('/MagazaAnket/Urunler/Urun') AS Urun 
FROM Magazalar;



<Urun>Mobil</Urun>
<Urun>Masaüstü</Urun>
<Urun>Sistem</Urun>
<Urun>Web</Urun>
<Urun>Android</Urun>
<Urun>Oracle</Urun>
<Urun>Java</Urun>



SELECT 
	Anket_UnTyped.query('/MagazaAnket') AS UnTyped_Info, 
	Anket_Typed.query('declare namespace 	ns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";/ns:StoreSurvey') AS Typed_Info
FROM Magazalar;



SELECT
	Anket_UnTyped.query('/MagazaAnket/YillikSatis') AS UnTyped_Info,
	Anket_Typed.query('declare namespace  	ns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";/ns:StoreSurvey/ns:AnnualSales') AS Typed_Info
	FROM Magazalar;


SELECT
  Anket_UnTyped.query('/MagazaAnket/Urunler') AS Urunler
FROM  Magazalar;


SELECT
Anket_UnTyped.query('/MagazaAnket/Urunler[@Tip="Yazilim"]')  AS Yazilim
FROM Magazalar;



SELECT Anket_UnTyped.query('
	for $b in /MagazaAnket/Urunler/Urun
	where contains($b, "Mob")
	return $b
') AS Urun
FROM Magazalar;


SELECT Anket_UnTyped.exist('(/MagazaAnket/Urunler)[2]') AS Sales_UnTyped
FROM Magazalar;



SELECT 
Anket_UnTyped.exist('(/MagazaAnket/Urunler/Urun)[7]') AS Sales_UnTyped
FROM Magazalar;


DECLARE @xml XML;
DECLARE @exist BIT;
SET @xml = (SELECT Anket_UnTyped FROM Magazalar);
SET @exist = @xml.exist('/MagazaAnket[IsTuru="CO"]');
SELECT @exist;



SELECT
Anket_UnTyped.query('/MagazaAnket/Urunler[@Tip="Egitim"]') AS Egitim
FROM Magazalar
WHERE Anket_UnTyped.exist('/MagazaAnket[IsTuru="CO"]') = 1;



SELECT
Anket_UnTyped.query('/MagazaAnket/Urunler[@Tip="Egitim"]') AS Egitim
FROM Magazalar
WHERE Anket_UnTyped.exist('/MagazaAnket[IsTuru="CE"]') = 0;



--	xml.value


SELECT Anket_UnTyped.value('(/MagazaAnket/YillikSatis)[1]', 'INT') AS Satis
FROM Magazalar;



SELECT 
Anket_UnTyped.value('(/MagazaAnket/YillikSatis)[1]', 'INT') AS Satis, 
Anket_Typed.value('declare namespace ns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";(/ns:StoreSurvey/ns:AnnualSales)[1]', 'INT') AS Satis
FROM Magazalar;



SELECT
Anket_UnTyped.value('(/MagazaAnket/Urunler/@Tip)[2]', 'VARCHAR(10)') AS Tip
FROM Magazalar;



SELECT
Anket_UnTyped.value('concat("Uzmanlýk: ", (/MagazaAnket/Uzmanlik)[1])', 			  'VARCHAR(20)') AS Uzmanlýk
FROM Magazalar;


--	xml.nodes


DECLARE @veritabanlari XML;
SET @veritabanlari =
'<Urunler>
   <Urun>SQL Server</Urun>
   <Urun>Oracle</Urun>
   <Urun>DB2</Urun>
   <Urun>PostgreSQL</Urun>
   <Urun>MySQL</Urun>
</Urunler>'
SELECT Kategori.query('./text()') AS VeritabaniTuru
FROM @veritabanlari.nodes('/Urunler/Urun') AS Urun(Kategori);



SELECT Kategori.query('./text()') AS VeritabaniTuru FROM Magazalar 
CROSS APPLY Anket_UnTyped.nodes('/MagazaAnket/Urunler[@Tip="Yazilim"]/Urun')  AS Urun(Kategori);


--	xml.modify() ile XML Veriyi Düzenlemek


DECLARE @xmlAraba XML;
SET @xmlAraba = '
<arabalar>
	<araba></araba>
	<araba></araba>
</arabalar>';
SELECT @xmlAraba;

SET @xmlAraba.modify(
'insert attribute renk{"siyah"}
into /arabalar[1]/araba[1]')
SELECT @xmlAraba;




UPDATE Magazalar
SET Anket_UnTyped.modify('
  insert(<Aciklama>Yazýlým ve eðitim çözümleri</Aciklama>)
  after(/MagazaAnket/CalisanSayisi)[1]'),
  Anket_Typed.modify('declare namespace ns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey";
  insert(<ns:Comments>Yazýlým ve eðitim çözümleri</ns:Comments>)
  after(/ns:StoreSurvey/ns:NumberEmployees)[1]') 
WHERE MagazaID = 292;


--	delete


UPDATE Magazalar
SET Anket_UnTyped.modify('delete(/MagazaAnket/Aciklama)[1]')
WHERE MagazaID = 292;


--	replace value of



UPDATE Magazalar
SET Anket_UnTyped.modify('replace value of (/MagazaAnket/Aciklama/text())[1] with "2. açýklama"')
WHERE MagazaID = 292;


--	XML Biçimindeki Ýliþkisel Veriye Eriþmek


--	FOR XML

--	RAW

SELECT ProductID, Name, ProductNumber
FROM Production.Product
WHERE ProductID < 5
FOR XML RAW;


<row ProductID="1" Name="Adjustable Race" ProductNumber="AR-5381" />
<row ProductID="2" Name="Bearing Ball" ProductNumber="BA-8327" />
<row ProductID="3" Name="BB Ball Bearing" ProductNumber="BE-2349" />
<row ProductID="4" Name="Headset Ball Bearings" ProductNumber="BE-2908" />



SELECT ProductID, Name, ProductNumber
FROM Production.Product
WHERE ProductID < 5
FOR XML RAW, ELEMENTS;


<row>
  <ProductID>1</ProductID>
  <Name>Adjustable Race</Name>
  <ProductNumber>AR-5381</ProductNumber>
</row>
<row>
  <ProductID>2</ProductID>
  <Name>Bearing Ball</Name>
  <ProductNumber>BA-8327</ProductNumber>
</row>
<row>
  <ProductID>3</ProductID>
  <Name>BB Ball Bearing</Name>
  <ProductNumber>BE-2349</ProductNumber>
</row>
<row>
  <ProductID>4</ProductID>
  <Name>Headset Ball Bearings</Name>
  <ProductNumber>BE-2908</ProductNumber>
</row>



SELECT ProductID, Name, ProductNumber
FROM Production.Product
WHERE ProductID < 5
FOR XML RAW('kodlab');



<kodlab ProductID="1" Name="Adjustable Race" ProductNumber="AR-5381" />
<kodlab ProductID="2" Name="Bearing Ball" ProductNumber="BA-8327" />
<kodlab ProductID="3" Name="BB Ball Bearing" ProductNumber="BE-2349" />
<kodlab ProductID="4" Name="Headset Ball" ProductNumber="BE-2908" />


SELECT ProductID, Name, ProductNumber
FROM Production.Product
WHERE ProductID < 5
FOR XML RAW('kodlab'), ROOT('DIJIBIL');



<DIJIBIL>
  <kodlab ProductID="1" Name="Adjustable Race" ProductNumber="AR-5381" />
  <kodlab ProductID="2" Name="Bearing Ball" ProductNumber="BA-8327" />
  <kodlab ProductID="3" Name="BB Ball Bearing" ProductNumber="BE-2349" />
  <kodlab ProductID="4" Name="Headset Ball" ProductNumber="BE-2908" />
</DIJIBIL>



SELECT ProductID, Name, ProductNumber, Color
FROM Production.Product
WHERE ProductID < 5
FOR XML RAW, ELEMENTS XSINIL;


<row xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ProductID>1</ProductID>
  <Name>Adjustable Race</Name>
  <ProductNumber>AR-5381</ProductNumber>
  <Color xsi:nil="true" />
</row>
<row xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ProductID>2</ProductID>
  <Name>Bearing Ball</Name>
  <ProductNumber>BA-8327</ProductNumber>
  <Color xsi:nil="true" />
</row>
<row xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ProductID>3</ProductID>
  <Name>BB Ball Bearing</Name>
  <ProductNumber>BE-2349</ProductNumber>
  <Color xsi:nil="true" />
</row>
<row xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ProductID>4</ProductID>
  <Name>Headset Ball Bearings</Name>
  <ProductNumber>BE-2908</ProductNumber>
  <Color xsi:nil="true" />
</row>


--	AUTO


SELECT ProductID, Name, ProductNumber
FROM Production.Product
WHERE ProductID < 5
FOR XML AUTO;



<Production.Product ProductID="1" Name="Adjus.." ProductNumber="AR-5381" />
<Production.Product ProductID="2" Name="Beari.." ProductNumber="BA-8327" />
<Production.Product ProductID="3" Name="BB Ba.." ProductNumber="BE-2349" />
<Production.Product ProductID="4" Name="Heads.." ProductNumber="BE-2908" />


SELECT ProductID, Name, ProductNumber
FROM Production.Product
WHERE ProductID < 5
FOR XML AUTO, ROOT('DIJIBIL');



<DIJIBIL>
<Production.Product ProductID="1" Name="Adjus.." ProductNumber="AR-5381" />
<Production.Product ProductID="2" Name="Beari.." ProductNumber="BA-8327" />
<Production.Product ProductID="3" Name="BB Ball" ProductNumber="BE-2349" />
<Production.Product ProductID="4" Name="Headset" ProductNumber="BE-2908" />
</DIJIBIL>



SELECT ProductID, Name, ProductNumber
FROM Production.Product
WHERE ProductID < 5
FOR XML AUTO, ELEMENTS, ROOT('DIJIBIL');


<DIJIBIL>
  <Production.Product>
    <ProductID>1</ProductID>
    <Name>Adjustable Race</Name>
    <ProductNumber>AR-5381</ProductNumber>
  </Production.Product>
  <Production.Product>
    <ProductID>2</ProductID>
    <Name>Bearing Ball</Name>
    <ProductNumber>BA-8327</ProductNumber>
  </Production.Product>
  <Production.Product>
    <ProductID>3</ProductID>
    <Name>BB Ball Bearing</Name>
    <ProductNumber>BE-2349</ProductNumber>
  </Production.Product>
  <Production.Product>
    <ProductID>4</ProductID>
    <Name>Headset Ball Bearings</Name>
    <ProductNumber>BE-2908</ProductNumber>
  </Production.Product>
</DIJIBIL>


--	EXPLICIT


SELECT 
	TOP 5 
	1 AS TAG,
	NULL AS PARENT,
	ProductID AS [Product!1!ProductID],
	Name AS [Product!1!Name!element],
	ProductNumber AS [Product!1!ProductNumber!element],
	ListPrice AS [Product!1!ListPrice!element]
FROM Production.Product
ORDER BY ProductID
FOR XML EXPLICIT;



<Product ProductID="1">
  <Name>Adjustable Race</Name>
  <ProductNumber>AR-5381</ProductNumber>
  <ListPrice>0.0000</ListPrice>
</Product>
<Product ProductID="2">
  <Name>Bearing Ball</Name>
  <ProductNumber>BA-8327</ProductNumber>
  <ListPrice>0.0000</ListPrice>
</Product>
<Product ProductID="3">
  <Name>BB Ball Bearing</Name>
  <ProductNumber>BE-2349</ProductNumber>
  <ListPrice>0.0000</ListPrice>
</Product>



ProductID AS [Product!1!ProductID]


ProductNumber AS [Product!1!ProductNumber!element]


SELECT 
	TOP 3 
	1 AS TAG,
	NULL AS PARENT,
	ProductID AS [Product!1!ProductID!element],
	Name AS [Product!1!Name!element],
	ProductNumber AS [Product!1!ProductNumber!element],
	ListPrice AS [Product!1!ListPrice!element]
FROM Production.Product
ORDER BY ProductID
FOR XML EXPLICIT;



<Product>
  <ProductID>1</ProductID>
  <Name>Adjustable Race</Name>
  <ProductNumber>AR-5381</ProductNumber>
  <ListPrice>0.0000</ListPrice>
</Product>
<Product>
  <ProductID>2</ProductID>
  <Name>Bearing Ball</Name>
  <ProductNumber>BA-8327</ProductNumber>
  <ListPrice>0.0000</ListPrice>
</Product>
<Product>
  <ProductID>3</ProductID>
  <Name>BB Ball Bearing</Name>
  <ProductNumber>BE-2349</ProductNumber>
  <ListPrice>0.0000</ListPrice>
</Product>



SELECT 
	TOP 3 
	1 AS TAG,
	NULL AS PARENT,
	ProductID AS [Product!1!ProductID!element],
	Name AS [Product!1!Name!element],
	ProductNumber AS [Product!1!ProductNumber!element],
	ListPrice AS [Product!1!ListPrice!element],
	Color AS [Product!1!Color!elementxsinil]
FROM Production.Product
ORDER BY ProductID DESC
FOR XML EXPLICIT;



<Product xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ProductID>1004</ProductID>
  <Name>% 20 indirimli ürün</Name>
  <ProductNumber>SK-9299</ProductNumber>
  <ListPrice>0.0000</ListPrice>
  <Color xsi:nil="true" />
</Product>
<Product xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ProductID>999</ProductID>
  <Name>Road-750 Black, 52</Name>
  <ProductNumber>BK-R19B-52</ProductNumber>
  <ListPrice>619.5637</ListPrice>
  <Color>Black</Color>
</Product>
<Product xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ProductID>998</ProductID>
  <Name>Road-750 Black, 48</Name>
  <ProductNumber>BK-R19B-48</ProductNumber>
  <ListPrice>619.5637</ListPrice>
  <Color>Black</Color>
</Product>


<Color xsi:nil="true" />


--	EXPLICIT ile Sütunlarý Gizlemek


SELECT 
	TOP 3 
	1 AS TAG,
	NULL AS PARENT,
	ProductID AS [Product!1!ProductID!element],
	Name AS [Product!1!Name!element],
	ProductNumber AS [Product!1!ProductNumber!element],
	ListPrice AS [Product!1!ListPrice!hide],
	Color AS [Product!1!Color!elementxsinil]
FROM Production.Product
ORDER BY ProductID DESC
FOR XML EXPLICIT



<Product xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ProductID>1004</ProductID>
  <Name>% 20 indirimli ürün</Name>
  <ProductNumber>SK-9299</ProductNumber>
  <Color xsi:nil="true" />
</Product>
<Product xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ProductID>999</ProductID>
  <Name>Road-750 Black, 52</Name>
  <ProductNumber>BK-R19B-52</ProductNumber>
  <Color>Black</Color>
</Product>
<Product xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <ProductID>998</ProductID>
  <Name>Road-750 Black, 48</Name>
  <ProductNumber>BK-R19B-48</ProductNumber>
  <Color>Black</Color>
</Product>


--	PATH


SELECT pc.ProductCategoryID, pc.Name, psc.ProductSubcategoryID, psc.Name
FROM Production.ProductCategory AS pc
INNER JOIN Production.ProductSubcategory AS psc
ON pc.ProductCategoryID = psc.ProductCategoryID
FOR XML PATH;



<row>
  <ProductCategoryID>1</ProductCategoryID>
  <Name>Bikes</Name>
  <ProductSubcategoryID>1</ProductSubcategoryID>
  <Name>Mountain Bikes</Name>
</row>
<row>
  <ProductCategoryID>1</ProductCategoryID>
  <Name>Bikes</Name>
  <ProductSubcategoryID>2</ProductSubcategoryID>
  <Name>Road Bikes</Name>
</row>
<row>
  <ProductCategoryID>1</ProductCategoryID>
  <Name>Bikes</Name>
  <ProductSubcategoryID>3</ProductSubcategoryID>
  <Name>Touring Bikes</Name>
</row>



SELECT pc.ProductCategoryID, pc.Name, 
	 psc.ProductSubcategoryID, psc.Name
FROM Production.ProductCategory AS pc
INNER JOIN Production.ProductSubcategory AS psc
ON pc.ProductCategoryID = psc.ProductCategoryID
FOR XML PATH('Kategori'), ROOT('Kategoriler');



SELECT pc.ProductCategoryID "@KategoriID", pc.Name, 
	 psc.ProductSubcategoryID, psc.Name 
FROM Production.ProductCategory AS pc
INNER JOIN Production.ProductSubcategory AS psc
ON pc.ProductCategoryID = psc.ProductCategoryID
FOR XML PATH('Kategori'), ROOT('Kategoriler');



<Kategoriler>
  <Kategori KategoriID="1">
    <Name>Bikes</Name>
    <ProductSubcategoryID>1</ProductSubcategoryID>
    <Name>Mountain Bikes</Name>
  </Kategori>
  <Kategori KategoriID="1">
    <Name>Bikes</Name>
    <ProductSubcategoryID>2</ProductSubcategoryID>
    <Name>Road Bikes</Name>
  </Kategori>
  <Kategori KategoriID="1">
    <Name>Bikes</Name>
    <ProductSubcategoryID>3</ProductSubcategoryID>
    <Name>Touring Bikes</Name>
  </Kategori>
  <Kategori KategoriID="2">
    <Name>Components</Name>
    <ProductSubcategoryID>4</ProductSubcategoryID>
    <Name>Handlebars</Name>
  </Kategori>
</Kategoriler>


--	OPEN XML


CREATE TABLE Books
(
	BookID	INT,
	Name		VARCHAR(50),
	Author	VARCHAR(50),
	Technology	VARCHAR(30)
);




DECLARE @xml_data INT;
DECLARE @xmldoc VARCHAR(1000);

SET @xmldoc =
'<root>
	<book BookID="1" Name="Ýleri Seviye SQL Server T-SQL" 
	Technology="SQL Server" Author="Cihan Ozhan" />
	<book BookID="2" Name="Ýleri Seviye Android Programlama" 	Technology="Android" Author="Kerim Fýrat" />
 </root>'

EXEC sp_xml_preparedocument @xml_data OUTPUT, @xmldoc;

INSERT INTO Books
SELECT * FROM OpenXML(@xml_data,'/root/book') WITH Books;
EXEC sp_xml_removedocument @xml_data;



SELECT * FROM Books;



DECLARE @DocHandle INT;
DECLARE @XmlDocument NVARCHAR(1000);
SET @XmlDocument = 
N'<root>
<Musteri MusteriID="VINET" IletisimAd="Hakan Aydýn">
  <Urun UrunID="10248" MusID="VINET" CalID="8" SipTarih="2013-02-02">
      <UrunDetay UrunID="19" Miktar="7"/>
      <UrunDetay UrunID="25" Miktar="5"/>
   </Urun>
</Musteri>
<Musteri MusteriID="LILAS" IletisimAd="Cansu Aycan">
<Urun UrunID="10283" MusID="LILAS" CalID="6" SipTarih="2013-02-13">
      <UrunDetay UrunID="13" Miktar="2"/>
   </Urun>
</Musteri>
</root>';

EXEC sp_xml_preparedocument @DocHandle OUTPUT, @XmlDocument;

SELECT *
FROM OPENXML(@DocHandle, '/root/Musteri',1)
      WITH (MusteriID  varchar(10),IletisimAd varchar(20));
EXEC sp_xml_removedocument @DocHandle;




DECLARE @XmlDokumanIslem INT;
DECLARE @XmlDokuman	  NVARCHAR(1000);
SET @XmlDokuman = N'
<root>
<Musteri MusteriID="VINET" Iletisim="Hakan Aydýn">
   <Siparis SiparisID="10248" MusteriID="VINET" CalisanID="5" 
           						SiparisTarih="2013-02-02">
      <SiparisDetay UrunID="11" Miktar="12"/>
      <SiparisDetay UrunID="42" Miktar="10"/>
   </Siparis>
</Musteri>
<Musteri MusteriID="LILAS" Iletisim="Cansu Aycan">
   <Siparis SiparisID="10283" MusteriID="LILAS" CalisanID="3" 
           						SiparisTarih="2013-02-04">
      <SiparisDetay UrunID="72" Miktar="3"/>
   </Siparis>
</Musteri>
</root>';

EXEC sp_xml_preparedocument @XmlDokumanIslem OUTPUT, @XmlDokuman;

SELECT *
FROM OPENXML(@XmlDokumanIslem, '/root/Musteri/Siparis/SiparisDetay', 2)
WITH 
(
	SiparisID    INT         '../@SiparisID',
      MusteriID    VARCHAR(10) '../@MusteriID',
      SiparisTarih DATETIME    '../@SiparisTarih',
      UrunID       INT         '@UrunID',
      Miktar       INT         '@Miktar'
);
EXEC sp_xml_removedocument @XmlDokumanIslem;



--	HTTP Endpoint'leri



CREATE PROC sp_Products
AS
SELECT ProductID, Name FROM Production.Product;



CREATE PROC sp_Persons
AS
SELECT BusinessEntityID, PersonType, FirstName, LastName 
FROM Person.Person;


--	HTTP Endpoint Oluþturulmasý ve Yönetilmesi




CREATE ENDPOINT EP_AdventureWorks
STATE = STARTED
AS HTTP
(
	PATH = '/AWorks',
	AUTHENTICATION = (INTEGRATED),
	PORTS = (CLEAR),
	SITE = 'localhost'
)
FOR SOAP
(
	WEBMETHOD 'Products'
	(NAME = 'AdventureWorks2012.dbo.sp_Products'),
	WEBMETHOD 'Persons'
	(NAME = 'AdventureWorks2012.dbo.sp_Persons'),
	BATCHES = DISABLED,
	WSDL = DEFAULT,
	DATABASE = 'AdventureWorks2012',
	NAMESPACE = 'http://AdventureWorks/'
)




http://localhost/AWorks?wsdl


















































