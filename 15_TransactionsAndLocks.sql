

--	Transaction Olu�turmak


CREATE TABLE Accounts(
	AccountID	CHAR(10) PRIMARY KEY NOT NULL,
	FirstName	VARCHAR(50),
	LastName	VARCHAR(50),
	Branch	INT,
	Balance	MONEY
);



INSERT INTO Accounts
VALUES('0000065127','Cihan','�zhan', 489, 10000),
      ('0000064219','Kerim','F�rat', 489, 500);


SELECT * FROM Accounts;



CREATE PROC sp_MoneyTransfer(
	@PurchaserID	CHAR(10),
	@SenderID		CHAR(10),
	@Amount		MONEY
)
AS
BEGIN
	BEGIN TRANSACTION
		UPDATE Accounts
		SET Balance = Balance - @Amount
		WHERE AccountID = @SenderID
	IF @@ERROR <> 0
	ROLLBACK
		UPDATE Accounts
		SET Balance = Balance + @Amount
		WHERE AccountID = @PurchaserID
	IF @@ERROR <> 0
	ROLLBACK
	COMMIT
END;


EXEC sp_MoneyTransfer '0000064219','0000065127',500;


--	Sabitleme Noktas� Olu�turmak : Save Tran



BEGIN TRANSACTION
	SELECT * FROM Accounts;

	UPDATE Accounts
	SET Balance = 500, Branch = 287
	WHERE AccountID = '0000064219';
		SELECT * FROM Accounts;

	SAVE TRAN save_updateAccount;

	DELETE FROM Accounts WHERE AccountID = '0000064219';
		SELECT * FROM Accounts;

	ROLLBACK TRAN save_updateAccount;
		SELECT * FROM Accounts;
	ROLLBACK TRAN;
		SELECT * FROM Accounts;
COMMIT TRANSACTION;



CREATE PROCEDURE SaveTran(@InputCandidateID INT)
AS
DECLARE @TranCounter INT;
SET @TranCounter = @@TRANCOUNT;
IF @TranCounter > 0
    SAVE TRANSACTION ProcedureSave;
ELSE
BEGIN TRANSACTION;
BEGIN TRY
    DELETE HumanResources.JobCandidate 
    WHERE JobCandidateID = @InputCandidateID;
    IF @TranCounter = 0
        COMMIT TRANSACTION;
END TRY
BEGIN CATCH
  IF @TranCounter = 0
      ROLLBACK TRANSACTION;
  ELSE
      IF XACT_STATE() <> -1
          ROLLBACK TRANSACTION ProcedureSave;
  DECLARE @ErrorMessage NVARCHAR(4000);
  DECLARE @ErrorSeverity INT;
  DECLARE @ErrorState INT;
  
  SELECT @ErrorMessage = ERROR_MESSAGE();
  SELECT @ErrorSeverity = ERROR_SEVERITY();
  SELECT @ErrorState = ERROR_STATE();

  RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
END CATCH;


EXEC SaveTran 13;


--	Try-Catch ile Transaction Hatas� Yakalamak


ALTER PROC sp_MoneyTransfer(
	@PurchaserID	CHAR(10),
	@SenderID		CHAR(10),
	@Amount		MONEY
)
AS
BEGIN TRY
	BEGIN TRANSACTION
		UPDATE Accounts
		SET Balance = Balance - @Amount
		WHERE AccountID = @SenderID

		UPDATE Accounts
		SET Balance = Balance + @Amount
		WHERE AccountID = @PurchaserID
	COMMIT
END TRY
BEGIN CATCH
	PRINT @@ERROR + ' hatas� olu�tu�u i�in havale yap�lamad�.'
	ROLLBACK
END CATCH;



--	Xact_State() Fonksiyonu


ALTER PROC sp_MoneyTransfer(
	@PurchaserID	CHAR(10),
	@SenderID		CHAR(10),
	@Amount		MONEY
)
AS
BEGIN TRY
	BEGIN TRANSACTION
		UPDATE Accounts
		SET Balance = Balance - @Amount
		WHERE AccountID = @SenderID

		UPDATE Accounts
		SET Balance = Balance + @Amount
		WHERE AccountID = @PurchaserID
	COMMIT
END TRY
BEGIN CATCH
IF(XACT_STATE()) = -1
BEGIN
	PRINT @@ERROR + ' kodlu hata ger�ekle�ti. Havale yap�lamad�.'
ROLLBACK TRAN
END
IF(XACT_STATE()) = 1
BEGIN
	PRINT @ERROR + ' kodlu hata ger�ekle�ti. Ancak transaction ba�ar� ile bitirildi.'
COMMIT TRAN
END
END CATCH;


--	�� ��e Transaction'lar(Nested Transactions)



BEGIN TRANSACTION  -- D�� Transaction
BEGIN TRY
	BEGIN TRAN A   -- �� Transaction
	BEGIN TRY                  
	   -- sorgu ifadeleri 
	COMMIT TRAN A
    END TRY
    BEGIN CATCH
       ROLLBACK TRAN A
    END CATCH
    ROLLBACK TRAN  -- T�m i�lemleri geri al
END TRY
BEGIN CATCH
  ROLLBACK TRAN
END CATCH


--	Kilitler

--	Optimizer �pu�lar� ile �zel Bir Kilit Tipi Belirlemek


FROM tablo_ismi AS takma_isim WITH (ipucu)
FROM tablo_ismi AS takma_isim (ipucu)
FROM tablo_ismi WITH (ipucu)
FROM tablo_ismi (ipucu)


--	READCOMMITTED


SELECT * FROM Production.Product (READCOMMITTED);



--	READUNCOMMITTED/NOLOCK


SELECT * FROM Production.Product (READUNCOMMITTED);

-- ya da

SELECT * FROM Production.Product (NOLOCK);


--	READCOMMITTEDLOCK


SELECT * FROM Production.Product (READCOMMITTEDLOCK);


--	SERIALIZABLE/HOLDLOCK


SELECT * FROM Production.Product (SERIALIZABLE);

ya da

SELECT * FROM Production.Product (HOLDLOCK);


--	REPEATABLEREAD


SELECT * FROM Production.Product (REPEATABLEREAD);


SELECT * FROM Production.Product (READPAST);


--	ROWLOCK


--	PAGLOCK


SELECT * FROM Production.Product (PAGLOCK);


--	TABLOCK


SELECT * FROM Production.Product (TABLOCK);


--	TABLOCKX


SELECT * FROM Production.Product (TABLOCKX);


--	UPDLOCK


SELECT * FROM Production.Product (UPDLOCK);


--	XLOCK

SELECT * FROM Production.Product (XLOCK);


--	�zolasyon Seviyesi Y�netimi


DBCC USEROPTIONS;


SELECT Name, ListPrice FROM Production.Product
ORDER BY ListPrice DESC;



BEGIN TRAN
	UPDATE Production.Product
	SET ListPrice =  ListPrice * 1.07



SELECT Name, ListPrice FROM Production.Product
ORDER BY ListPrice DESC;



SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT Name, ListPrice FROM Production.Product ORDER BY ListPrice DESC;



SELECT Name, ListPrice FROM Production.Product (NOLOCK) 
ORDER BY ListPrice DESC;



ROLLBACK


SELECT Name, ListPrice FROM Production.Product ORDER BY ListPrice DESC;


SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;


--	Transaction Bazl� Snapshot �zolasyon


USE MASTER
ALTER DATABASE AdventureWorks
SET ALLOW_SNAPSHOT_ISOLATION ON;


SET TRANSACTION ISOLATION LEVEL SNAPSHOT
BEGIN TRAN
	SELECT ProductID, Name FROM Production.Product;
COMMIT TRAN


--	�fade Bazl� Snapshot �zolasyon


USE MASTER
ALTER DATABASE AdventureWorks
SET READ_COMMITTED_SNAPSHOT ON


--	Kilitlemeleri G�zlemlemek


sp_who


sp_who 'sa'


sp_lock


--	Zaman A��m�n� Ayarlamak


SELECT @@LOCK_TIMEOUT


SET LOCK_TIMEOUT 10000


SELECT @@LOCK_TIMEOUT


SET LOCK_TIMEOUT -1


SELECT @@LOCK_TIMEOUT


--	Kilitleme ��kmaz� : Deadlock


--	Aktivite Monit�r� ile Kilitlenmeleri Takip Etmek ve Process �ld�rmek


BEGIN TRAN
UPDATE Accounts
SET Balance = Balance - 500
WHERE AccountID = '0000065127';



SELECT * FROM Accounts;


KILL 56


