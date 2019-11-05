

-	DATE


DECLARE @date date = '2013-01-25';			
SELECT @date AS '@date';



DECLARE @date date= '12-10-25';
DECLARE @datetime datetime= @date;

SELECT @date AS '@date', @datetime AS '@datetime';



--	Time


DECLARE @time time(7) = '12:34:54.1234567';
DECLARE @time1 time(1) = @time;
DECLARE @time2 time(2) = @time;
DECLARE @time3 time(3) = @time;
DECLARE @time4 time(4) = @time;
DECLARE @time5 time(5) = @time;
DECLARE @time6 time(6) = @time;
DECLARE @time7 time(7) = @time;

SELECT 
	@time1 AS 'time(1)', @time2 AS 'time(2)', @time3 AS 'time(3)', 
	@time4 AS 'time(4)', @time5 AS 'time(5)', @time6 AS 'time(6)',
	@time7 AS 'time(7)';



DECLARE @time time(4) = '12:15:04.1234';
DECLARE @datetime datetime= @time;

SELECT @time AS '@time', @datetime AS '@datetime';


--	SmallDateTime


DECLARE @smalldatetime smalldatetime = '1955-12-13 12:43:10';
DECLARE @date date = @smalldatetime;

SELECT @smalldatetime AS '@smalldatetime', @date AS 'date';


--	DateTime


DECLARE @smalldatetime smalldatetime = '1955-12-13 12:43:10';
DECLARE @datetime datetime = @smalldatetime;

SELECT @smalldatetime AS '@smalldatetime', @datetime AS '@datetime';


--	DateTime2


DECLARE @datetime2 datetime2(4) = '12-10-25 12:32:10.1234';
DECLARE @date date = @datetime2;
SELECT @datetime2 AS '@datetime2', @date AS 'date';


--	DateTimeOffSet


DECLARE @datetimeoffset datetimeoffset(4) = '12-10-25 12:32:10 +01:0';
DECLARE @date date= @datetimeoffset;

SELECT @datetimeoffset AS '@datetimeoffset ', @date AS 'date';


--	Girdi Tarih Formatlarý


-- AY/GÜN/YIL
SET DATEFORMAT MDY			Sonuç : 2013-12-31 00:00:00.000
DECLARE @datevar datetime
SET @datevar = '12/31/13'
SELECT @datevar
GO
-- YIL/GÜN/AY
SET DATEFORMAT YDM			Sonuç : 2013-12-31 00:00:00.000
DECLARE @datevar datetime
SET @datevar = '13/31/12'
SELECT @datevar
GO
-- YIL/AY/GÜN
SET DATEFORMAT YMD			Sonuç : 2013-12-31 00:00:00.000
DECLARE @datevar datetime
SET @datevar = '13/12/31'
SELECT @datevar
GO
-- GÜN/AY/YIL
SET DATEFORMAT DMY			Sonuç : 2013-12-31 00:00:00.000
DECLARE @datevar datetime
SET @datevar = '31/12/13'
SELECT @datevar


--	GETDATE


SELECT GETDATE();	


--	CAST ve CONVERT ile Tarih Formatlama


SELECT CONVERT(VARCHAR(16), GETDATE(), 100)


SELECT GETDATE() AS DonusturulmemisTarih,
   	 CAST(GETDATE() AS NVARCHAR(30)) AS Cast_ile,
   	 CONVERT(NVARCHAR(30), GETDATE(), 126) AS Convert_ile;


SELECT '2006-04-25T15:50:59.997' AS DonusturulmemisTarih,
   	  CAST('2006-04-25T15:50:59.997' AS DATETIME) AS Cast_ile,
	  CONVERT(DATETIME, '2006-04-25T15:50:59.997', 126) AS Convert_ile;



SELECT CONVERT(VARCHAR, GETDATE(), 0)    Sonuç : Feb  1 2013 10:06AM
SELECT CONVERT(VARCHAR, GETDATE(), 1)    Sonuç : 02/01/13
SELECT CONVERT(VARCHAR, GETDATE(), 2)    Sonuç : 13.02.01
SELECT CONVERT(VARCHAR, GETDATE(), 3)    Sonuç : 01/02/13
SELECT CONVERT(VARCHAR, GETDATE(), 4)    Sonuç : 01.02.13
SELECT CONVERT(VARCHAR, GETDATE(), 5)    Sonuç : 01-02-13
SELECT CONVERT(VARCHAR, GETDATE(), 6)    Sonuç : 01 Feb 13
SELECT CONVERT(VARCHAR, GETDATE(), 7)    Sonuç : Feb 01, 13
SELECT CONVERT(VARCHAR, GETDATE(), 8)    Sonuç : 10:08:01
SELECT CONVERT(VARCHAR, GETDATE(), 9)    Sonuç : Feb  1 2013 10:08:10:327AM
SELECT CONVERT(VARCHAR, GETDATE(), 10)   Sonuç : 02-01-13
SELECT CONVERT(VARCHAR, GETDATE(), 11)   Sonuç : 13/02/01
SELECT CONVERT(VARCHAR, GETDATE(), 12)   Sonuç : 130201
SELECT CONVERT(VARCHAR, GETDATE(), 13)   Sonuç : 01 Feb 2013 10:08:45:857
SELECT CONVERT(VARCHAR, GETDATE(), 14)   Sonuç : 10:08:54:127
SELECT CONVERT(VARCHAR, GETDATE(), 20)   Sonuç : 2013-02-01 10:09:07
SELECT CONVERT(VARCHAR, GETDATE(), 21)   Sonuç : 2013-02-01 10:09:23.973
SELECT CONVERT(VARCHAR, GETDATE(), 22)   Sonuç : 02/01/13 10:09:32 AM
SELECT CONVERT(VARCHAR, GETDATE(), 23)   Sonuç : 2013-02-01
SELECT CONVERT(VARCHAR, GETDATE(), 24)   Sonuç : 10:09:49
SELECT CONVERT(VARCHAR, GETDATE(), 25)   Sonuç : 2013-02-01 10:09:57.257
SELECT CONVERT(VARCHAR, GETDATE(), 100)  Sonuç : Feb  1 2013 10:10AM
SELECT CONVERT(VARCHAR, GETDATE(), 101)  Sonuç : 02/01/2013
SELECT CONVERT(VARCHAR, GETDATE(), 102)  Sonuç : 2013.02.01
SELECT CONVERT(VARCHAR, GETDATE(), 103)  Sonuç : 01/02/2013
SELECT CONVERT(VARCHAR, GETDATE(), 104)  Sonuç : 01.02.2013
SELECT CONVERT(VARCHAR, GETDATE(), 105)  Sonuç : 01-02-2013
SELECT CONVERT(VARCHAR, GETDATE(), 106)  Sonuç : 01 Feb 2013
SELECT CONVERT(VARCHAR, GETDATE(), 107)  Sonuç : Feb 01, 2013
SELECT CONVERT(VARCHAR, GETDATE(), 108)  Sonuç : 10:12:24
SELECT CONVERT(VARCHAR, GETDATE(), 109)  Sonuç : Feb 1 2013 10:12:31:237AM
SELECT CONVERT(VARCHAR, GETDATE(), 110)  Sonuç : 02-01-2013
SELECT CONVERT(VARCHAR, GETDATE(), 111)  Sonuç : 2013/02/01
SELECT CONVERT(VARCHAR, GETDATE(), 112)  Sonuç : 20130201
SELECT CONVERT(VARCHAR, GETDATE(), 113)  Sonuç : 01 Feb 2013 10:13:01:103
SELECT CONVERT(VARCHAR, GETDATE(), 114)  Sonuç : 10:13:14:437
SELECT CONVERT(VARCHAR, GETDATE(), 120)  Sonuç : 2013-02-01 10:13:21
SELECT CONVERT(VARCHAR, GETDATE(), 121)  Sonuç : 2013-02-01 10:13:27.237
SELECT CONVERT(VARCHAR, GETDATE(), 126)  Sonuç : 2013-02-01T10:13:34.317
SELECT CONVERT(VARCHAR, GETDATE(), 127)  Sonuç : 2013-02-01T10:13:41.897


--	FORMAT


SELECT FORMAT(GETDATE(), 'yyyy.MM.d HH:MM:ss');	


DECLARE @tarih DATETIME = GETDATE()
SELECT FORMAT ( @tarih, 'd', 'tr-TR' ) AS 'Türkçe'
      ,FORMAT ( @tarih, 'd', 'en-US' ) AS 'Amerikan Ýngilizcesi'
      ,FORMAT ( @tarih, 'd', 'en-gb' ) AS 'Ýngiltere Ýngilizcesi'
      ,FORMAT ( @tarih, 'd', 'de-de' ) AS 'Almanca'
      ,FORMAT ( @tarih, 'd', 'zh-cn' ) AS 'Çince'; 


DECLARE @tarih DATETIME = GETDATE()
SELECT FORMAT ( @tarih, 'D', 'tr-TR' ) AS 'Türkçe'
      ,FORMAT ( @tarih, 'D', 'en-US' ) AS 'Amerikan Ýngilizcesi'
      ,FORMAT ( @tarih, 'D', 'en-gb' ) AS 'Ýngiltere Ýngilizcesi'
      ,FORMAT ( @tarih, 'D', 'de-de' ) AS 'Almanca'
      ,FORMAT ( @tarih, 'D', 'zh-cn' ) AS 'Çince'; 



SELECT FORMAT ( GETDATE(), 'd', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'dd', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'ddd', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'dddd', 'tr-TR' ) AS Turkiye;


SELECT FORMAT ( GETDATE(), 'm', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'mm', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'mmm', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'mmmm', 'tr-TR' ) AS Turkiye;


SELECT FORMAT ( GETDATE(), 'y', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'yy', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( GETDATE(), 'yyy', 'tr-TR' ) AS Turkiye;


--	FORMAT Fonksiyonunun Farklý Ülke Para Birimleri Ýle Kullanýmý


DECLARE @para INT = 500;
SELECT FORMAT ( @para, 'c', 'tr-TR' ) AS Turkiye;
SELECT FORMAT ( @para, 'c', 'en-US' ) AS ABD;
SELECT FORMAT ( @para, 'c', 'fr-FR' ) AS Fransa;
SELECT FORMAT ( @para, 'c', 'de-DE' ) AS Almanca;
SELECT FORMAT ( @para, 'c', 'zh-cn' ) AS Cin;



DECLARE @para INT = 50
SELECT FORMAT(@para,'c') AS Para;
SELECT FORMAT(@para,'c1') AS Para;
SELECT FORMAT(@para,'c2') AS Para;
SELECT FORMAT(@para,'c3') AS Para;



DECLARE @var INT = 50
SELECT FORMAT(@var,'p') AS Yüzde;		--(P = Percentage)
SELECT FORMAT(@var,'e') AS Bilimsel;	--(E = Scientific)
SELECT FORMAT(@var,'x') AS Hexa;
SELECT FORMAT(@var,'x4') AS Hexa1;



SELECT FORMAT (GETDATE(), N'dddd MMMM dd, yyyy', 'tr-TR') AS Turkce;
SELECT FORMAT (GETDATE(), N'dddd MMMM dd, yyyy', 'en-US') AS Ingilizce;
SELECT FORMAT (GETDATE(), N'dddd MMMM dd, yyyy', 'hi') AS HindistanDili;
SELECT FORMAT (GETDATE(), N'dddd MMMM dd, yyyy', 'gu') AS GujaratDili;
SELECT FORMAT (GETDATE(), N'dddd MMMM dd, yyyy', 'zh-cn') AS Cince;



SELECT ModifiedDate, ListPrice,
	 FORMAT(ModifiedDate, N'dddd MMMM dd, yyyy','tr') TR_DegistirmeTarih, 
	 FORMAT(ListPrice, 'c','tr') TR_UrunFiyat
FROM Production.Product;


--	DATEPART



SELECT DATEPART(WEEKDAY, GETDATE());



SELECT DATEPART(YY, GETDATE());			Sonuç : 2013
SELECT DATEPART(YYYY, GETDATE());			Sonuç : 2013
SELECT DATEPART(YEAR, GETDATE());			Sonuç : 2013



SELECT DATEPART(QQ, GETDATE());			Sonuç : 1
SELECT DATEPART(Q, GETDATE());			 Sonuç : 1
SELECT DATEPART(QUARTER, GETDATE());		 Sonuç : 1



SELECT DATEPART(MM, GETDATE());		
SELECT DATEPART(M, GETDATE());			
SELECT DATEPART(MONTH, GETDATE());



SELECT DATEPART(DY, GETDATE());	
SELECT DATEPART(Y, GETDATE());		
SELECT DATEPART(DAYOFYEAR, GETDATE());	


SELECT DATEPART(DD, GETDATE());
SELECT DATEPART(D, GETDATE());
SELECT DATEPART(DAY, GETDATE());


SELECT DATEPART(WK, GETDATE());
SELECT DATEPART(WW, GETDATE());
SELECT DATEPART(WEEK, GETDATE());


SELECT DATEPART(DW, GETDATE());
SELECT DATEPART(WEEKDAY, GETDATE());


SELECT DATEPART(HH, GETDATE());
SELECT DATEPART(HOUR, GETDATE());


SELECT DATEPART(MI, GETDATE());
SELECT DATEPART(N, GETDATE());
SELECT DATEPART(MINUTE, GETDATE());


SELECT DATEPART(SS, GETDATE());
SELECT DATEPART(S, GETDATE());
SELECT DATEPART(SECOND, GETDATE());


SELECT DATEPART(MS, GETDATE());
SELECT DATEPART(MILLISECOND, GETDATE());


--	ISDATE

SELECT ISDATE('02/15/2013');	Sonuç : 1
SELECT ISDATE('15/02/2013');	Sonuç : 0


SET LANGUAGE Turkish


SELECT ISDATE('02/15/2013');	Sonuç : 0
SELECT ISDATE('15/02/2013');	Sonuç : 1


IF ISDATE('15/02/2013') = 1			
    PRINT 'GEÇERLÝ'
ELSE
    PRINT 'GEÇERSÝZ'


SET LANGUAGE us_english	



IF ISDATE('15/02/2013') = 1			
    PRINT 'GEÇERLÝ'
ELSE
    PRINT 'GEÇERSÝZ'


SET LANGUAGE Turkish;
SELECT ISDATE('15/02/2013'); -- Sonuç : 1
SET LANGUAGE English;
SELECT ISDATE('15/02/2013'); -- Sonuç : 0
SET LANGUAGE Hungarian;
SELECT ISDATE('15/2013/02'); -- Sonuç : 0
SET LANGUAGE Swedish;
SELECT ISDATE('2013/15/02'); -- Sonuç : 0
SET LANGUAGE Italian;
SELECT ISDATE('15/02/2013'); -- Sonuç : 1


--	DATEADD


SELECT DATEADD(YY, 2, '01.01.2013');


SELECT DATEADD(MM, 2, '01.01.2013');


SELECT DATEADD(QQ, 3, '01.01.2013');


SELECT DATEADD(MM, -3, '01.01.2013');


--	DATEDIFF


SELECT DATEDIFF(YY,'01.01.2012','01.01.2013');


SELECT DATEDIFF(MONTH,'01.01.2012','01.01.2013');


SELECT DATEDIFF(WK,'01.01.2012','01.01.2013');


SELECT DATEDIFF(DD,'01.01.2012','01.01.2013');


SELECT DATEDIFF(ss,'01.01.2012','01.01.2013');


--	DATENAME


SELECT DATENAME(YY, GETDATE());

SELECT DATENAME(YY, GETDATE());


SELECT DATENAME(MS, GETDATE());


--	DAY


SELECT DAY(GETDATE());



--	MONTH


SELECT MONTH(GETDATE());


--	YEAR


SELECT YEAR(GETDATE());


--	DATEFROMPARTS


SELECT DATEFROMPARTS(2013, 1, 1);


--	DATETIMEFROMPARTS


SELECT DATETIMEFROMPARTS(2013, 02, 01, 17, 37, 12, 997);


--	SMALLDATETIMEFROMPARTS


SELECT SMALLDATETIMEFROMPARTS(2013, 2, 1, 17, 45)


--	TIMEFROMPARTS


SELECT TIMEFROMPARTS (17, 25, 55, 5, 1);


SELECT TIMEFROMPARTS (17, 25, 55, 5, 1);
SELECT TIMEFROMPARTS (17, 25, 55, 50, 2);
SELECT TIMEFROMPARTS (17, 25, 55, 500, 3);


SELECT TIMEFROMPARTS (17, 25, 55, 5000, 3);


SELECT TIMEFROMPARTS (17, 25, 55, 5000000, 7);


--	EOMONTH


SELECT EOMONTH(GETDATE());


SELECT EOMONTH(GETDATE());


DECLARE @date DATETIME = GETDATE();		
SELECT EOMONTH (@date, -1) AS 'Önceki Ay';
SELECT EOMONTH (@date) AS 'Þimdiki Ay';
SELECT EOMONTH (@date, 1) AS 'Sonraki Ay';


--	SYSDATETIME

SELECT GETDATE() [GetDate], SYSDATETIME() [SysDateTime]



--	SYSUTCDATETIME


SELECT GETDATE(), SYSUTCDATETIME();



--	SYSDATETIMEOFFSET


SELECT SYSDATETIMEOFFSET() OffSet;
SELECT TODATETIMEOFFSET(SYSDATETIMEOFFSET(), '-04:00') 'OffSet -4';
SELECT TODATETIMEOFFSET(SYSDATETIMEOFFSET(), '-02:00') 'OffSet -2';
SELECT TODATETIMEOFFSET(SYSDATETIMEOFFSET(), '+00:00') 'OffSet +0';
SELECT TODATETIMEOFFSET(SYSDATETIMEOFFSET(), '+02:00') 'OffSet +2';
SELECT TODATETIMEOFFSET(SYSDATETIMEOFFSET(), '+04:00') 'OffSet +4';


--	SWITCHOFFSET


CREATE TABLE dbo.OffSetTest(
    ColDatetimeoffset datetimeoffset
);


INSERT INTO dbo.OffSetTest VALUES ('2013-02-01 8:25:50.71345 -5:00');


SELECT SWITCHOFFSET (ColDatetimeoffset, '-08:00') FROM dbo.OffSetTest;

SELECT ColDatetimeoffset FROM dbo.OffSetTest;


--	TODATETIMEOFFSET


SELECT TODATETIMEOFFSET(SYSDATETIMEOFFSET(), '-05:00') AS TODATETIME;


--	GETUTCDATE


SELECT GETUTCDATE()





























































