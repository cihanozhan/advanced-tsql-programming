

--	Performans Ýçin Ýstatistiksel Veri Kullanýmý


--	Performans Ýçin DMV ve DMF Kullanýmý


--	Baðlantý Hakkýnda Bilgi Almak


SELECT C.session_id,
	C.auth_scheme,
	C.last_read,
	C.last_write,
	C.client_net_address,
	C.local_tcp_port,
	ST.text AS lastQuery
FROM sys.dm_exec_connections C
CROSS APPLY sys.dm_exec_sql_text(C.most_recent_sql_handle) ST


--	Session Hakkýnda Bilgi Almak


SELECT login_name, COUNT(session_id) AS session_count, login_time
FROM sys.dm_exec_sessions 
GROUP BY login_name, login_time;


--	Veritabaný Sunucusu Hakkýnda Bilgi Almak


SELECT * FROM sys.dm_os_sys_info;


SELECT 
DATEDIFF(MINUTE, sqlserver_start_time, CURRENT_TIMESTAMP) AS UpTime
FROM sys.dm_os_sys_info;


SELECT (ms_ticks-sqlserver_start_time_ms_ticks)/1000/60 AS UpTime
FROM sys.dm_os_sys_info;


--	Fiziksel Bellek Hakkýnda Bilgi Almak


SELECT * FROM sys.dm_os_sys_memory;



SELECT 
	total_physical_memory_kb/1024 AS [ToplamFizikselBellek],
	(total_physical_memory_kb-available_physical_memory_kb)/1024 
						    AS [KullanýlanFizikselBellek],
	available_physical_memory_kb/1024 AS [KullanýlabilirFizikselBellek],
	total_page_file_kb/1024 AS [ToplamPageF(MB)],
	(total_page_file_kb - available_page_file_kb)/1024 									    AS[KullanýlanPageF(MB)],
	available_page_file_kb/1024 AS [KullanýlabilirPageF(MB)],
	system_memory_state_desc
FROM 
	sys.dm_os_sys_memory;


--	Aktif Olarak Çalýþan Ýstekleri Sorgulamak


DECLARE @test INT = 0;
WHILE 1 = 1
SET @test = 1;



SELECT DB_NAME(er.database_id) AS DB_ismi,
	es.login_name,
	es.host_name,
	st.text,
      SUBSTRING(st.text, (er.statement_start_offset/2) + 1, 
        ((CASE er.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         	ELSE er.statement_end_offset
          END - er.statement_start_offset)/2) + 1) AS ifade_metni,
   er.blocking_session_id,
   er.status,
   er.wait_type,
   er.wait_time,
   er.percent_complete,
   er.estimated_completion_time
FROM sys.dm_exec_requests er
     LEFT JOIN sys.dm_exec_sessions es ON es.session_id = er.session_id
     CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) st
     CROSS APPLY sys.dm_exec_query_plan(er.plan_handle) qp
WHERE er.session_id > 50 AND er.session_id != @@SPID;



--	Cache'lenen Sorgu Planlarý Hakkýnda Bilgi Almak


SELECT * FROM sys.dm_exec_cached_plans;



SELECT CP.usecounts,
	ST.text,
	QP.query_plan,	   
	CP.cacheobjtype,
	CP.objtype,
	CP.size_in_bytes
FROM sys.dm_exec_cached_plans CP
	CROSS APPLY sys.dm_exec_query_plan(CP.plan_handle) QP
	CROSS APPLY sys.dm_exec_sql_text(CP.plan_handle) ST
WHERE CP.usecounts > 3
ORDER BY CP.usecounts DESC;



SELECT 
	DB_NAME(st.dbid) AS DB_ismi,
	OBJECT_SCHEMA_NAME(ST.objectid, ST.dbid) AS sema_ismi,
	OBJECT_NAME(ST.objectid, ST.dbid) AS nesne_ismi,
	ST.text,
	QP.query_plan,
	CP.usecounts,
	CP.size_in_bytes
FROM sys.dm_exec_cached_plans CP
	CROSS APPLY sys.dm_exec_query_plan(CP.plan_handle) QP
	CROSS APPLY sys.dm_exec_sql_text(CP.plan_handle) ST
WHERE ST.dbid <> 32767 
AND CP.objtype = 'Proc';



--	Cache'lenen Sorgu Planlarýn Nesne Tipine Göre Daðýlýmý


SELECT CP.objtype,COUNT(*) AS nesne_toplam
FROM sys.dm_exec_cached_plans CP
GROUP BY CP.objtype
ORDER BY 2 DESC;



--	Parametre Olarak Verilen sql_handle'ýn SQL Sorgusunu Elde Etmek


SELECT ST.text
FROM sys.dm_exec_requests R
CROSS APPLY sys.dm_exec_sql_text(sql_handle) ST
WHERE session_id = @@SPID;


SELECT ST.text 
FROM sys.dm_exec_connections C
CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) ST
WHERE session_id = @@SPID;



sys.dm_exec_sql_text
sys.dm_exec_requests
sys.dm_exec_cursors
sys.dm_exec_xml_handles
sys.dm_exec_query_memory_grants
sys.dm_exec_connections


--	Parametre Olarak Verilen plan_handle'ýn Sorgu Planýný Elde Etmek


SELECT QP.query_plan
FROM sys.dm_exec_requests C
CROSS APPLY sys.dm_exec_query_plan(plan_handle) QP
WHERE session_id = @@SPID;


--	Sorgu Ýstatistikleri


select * from sys.dm_exec_query_stats;


SELECT 
     q.[text],
     SUBSTRING(q.text, (qs.statement_start_offset/2)+1, 
        ((CASE qs.statement_end_offset
          	WHEN -1 THEN DATALENGTH(q.text)
          	ELSE qs.statement_end_offset
          END - qs.statement_start_offset)/2) + 1) AS ifade_metni,        
     qs.last_execution_time,
     qs.execution_count,
     qs.total_worker_time / 1000000 AS toplam_cpu_zaman_sn,
     qs.total_worker_time / qs.execution_count / 1000 AS avg_cpu_zaman_ms,
     qp.query_plan,
     DB_NAME(q.dbid) AS veritabani_ismi,
     		q.objectid,
     		q.number,
     		q.encrypted
FROM 
    (SELECT TOP 20 
          qs.last_execution_time,
          qs.execution_count,
	    qs.plan_handle, 
          qs.total_worker_time,
          qs.statement_start_offset,
          qs.statement_end_offset
    FROM sys.dm_exec_query_stats qs
    ORDER BY qs.total_worker_time desc) qs
CROSS APPLY sys.dm_exec_sql_text(plan_handle) q
CROSS APPLY sys.dm_exec_query_plan(plan_handle) qp
ORDER BY qs.total_worker_time DESC;



SELECT 
     q.[text],
     SUBSTRING(q.text, (qs.statement_start_offset/2)+1, 
        ((CASE qs.statement_end_offset
          	WHEN -1 THEN DATALENGTH(q.text)
          	ELSE qs.statement_end_offset
          END - qs.statement_start_offset)/2) + 1) AS ifade_metni,        
     qs.last_execution_time,
     qs.execution_count,
     qs.total_logical_reads AS toplam_mantiksal_okuma,
     qs.total_logical_reads/execution_count AS avg_mantiksal_okuma,
     qs.total_worker_time/1000000 AS total_cpu_time_sn,
     qs.total_worker_time/qs.execution_count/1000 AS avg_cpu_zaman_ms,
     qp.query_plan,
     DB_NAME(q.dbid) AS veritabani_ismi,
     		q.objectid,
     		q.number,
     		q.encrypted
FROM
    (SELECT TOP 20 
          qs.last_execution_time,
          qs.execution_count,
	    qs.plan_handle, 
          qs.total_worker_time,
          qs.total_logical_reads,
          qs.statement_start_offset,
          qs.statement_end_offset
    FROM sys.dm_exec_query_stats qs
    ORDER BY qs.total_worker_time desc) qs
CROSS APPLY sys.dm_exec_sql_text(plan_handle) q
CROSS APPLY sys.dm_exec_query_plan(plan_handle) qp
ORDER BY qs.total_logical_reads DESC;


--	Ýþlemlerdeki Bekleme Sorunu Hakkýnda Bilgi Almak



SELECT * FROM sys.dm_os_wait_stats;


DBCC SQLPERF('sys.dm_os_wait_stats', CLEAR);


--	Disk Cevap Süresi Hakkýnda Bilgi Almak


SELECT * FROM sys.dm_io_virtual_file_stats(null, null);


SELECT db_name(mf.database_id) AS veritabani_ismi, 
	 mf.name AS mantiksal_dosya_ismi,
	 io_stall_read_ms/num_of_reads AS cevap_okuma_suresi,
	 io_stall_write_ms/num_of_writes AS cevap_yazma_suresi,
	 io_stall/(num_of_reads+num_of_writes) AS cevap_suresi,
       num_of_reads, num_of_bytes_read, io_stall_read_ms,        
	 num_of_writes, num_of_bytes_written, io_stall_write_ms, 
	 io_stall, size_on_disk_bytes
FROM 
	sys.dm_io_virtual_file_stats(DB_ID('AdventureWorks'), NULL) AS divFS
JOIN 
	sys.master_files AS MF
	ON MF.database_id = divFS.database_id 
	AND MF.file_id = divFS.file_id;


--	Bekleyen I/O Ýstekleri Hakkýnda Bilgi Almak


SELECT * FROM sys.dm_io_pending_io_requests;


SELECT
   FS.database_id AS veritabani_id,
   db_name(FS.database_id) AS veritabani_ismi,
   MF.name AS logical_file_name,
   IP.io_type,
   IP.io_pending_ms_ticks,
   IP.io_pending
FROM sys.dm_io_pending_io_requests IP
LEFT JOIN sys.dm_io_virtual_file_stats(null, null) FS 
     ON FS.file_handle = IP.io_handle
LEFT JOIN sys.master_files MF 
     ON MF.database_id = FS.database_id
     AND MF.file_id = FS.file_id


--	DBCC SQLPERF ile DMV Ýstatistiklerini Temizlemek


SELECT * FROM sys.dm_os_wait_stats 
WHERE wait_time_ms > 0;


DBCC SQLPERF('sys.dm_os_wait_stats', CLEAR);


--	Stored Procedure Ýstatistikleri Hakkýnda Bilgi Almak


SELECT * FROM sys.dm_exec_procedure_stats;


SELECT TOP 20 
   DB_NAME(database_id) AS DB_ismi,
   OBJECT_NAME(object_id) AS SP_ismi,
   st.[text] AS SP_kod,
   qp.query_plan,
   cached_time AS ilk_calisma_zamani,
   last_execution_time,
   execution_count,
   ps.total_logical_reads AS toplam_mantiksal_okuma,
   ps.total_logical_reads / execution_count AS avg_mantiksal_okuma,
   ps.total_worker_time / 1000 AS toplam_cpu_zamani_ms,
   ps.total_worker_time / ps.execution_count/1000 AS avg_cpu_zamani_ms
FROM sys.dm_exec_procedure_stats ps
CROSS APPLY sys.dm_exec_sql_text(ps.plan_handle) st
CROSS APPLY sys.dm_exec_query_plan(ps.plan_handle) qp
WHERE DB_NAME(database_id)='AdventureWorks'
ORDER BY ps.total_worker_time DESC;


--	Kullanýlmayan Stored Procedure'lerin Tespit Edilmesi


SELECT SCHEMA_NAME(O.schema_id) AS sema_ismi,
       P.name AS nesne_ismi, 
       P.create_date,
       P.modify_date
FROM sys.procedures P
LEFT JOIN sys.objects O ON P.object_id = O.object_id
WHERE P.type = 'P'
AND NOT EXISTS(SELECT PS.object_id 
		FROM sys.dm_exec_procedure_stats PS 
		WHERE PS.object_id = P.object_id
		AND PS.database_id=DB_ID('AdventureWorks'))
ORDER BY SCHEMA_NAME(O.schema_id), P.name;


--	Trigger Ýstatistikleri


select * from sys.dm_exec_trigger_stats;



SELECT TOP 10 
	   DB_NAME(database_id) AS DB_ismi,
	   SCHEMA_NAME(O.schema_id) AS tablo_sema_ismi,
	   O.name AS tablo_nesne_ismi, 
	   T.name AS trigger_nesne_ismi,
         ST.[text] AS trigger_kod,
	   QP.query_plan,
	   cached_time AS ilk_calisma_zamani,
	   last_execution_time,
	   execution_count,
       PS.total_logical_reads AS toplam_mantiksal_okuma,
       PS.total_logical_reads / execution_count AS avg_mantiksal_okuma,
       PS.total_worker_time / 1000 AS toplam_cpu_zaman_ms,
       PS.total_worker_time / PS.execution_count / 1000 AS avg_cpu_zaman_ms
FROM sys.dm_exec_trigger_stats PS
LEFT JOIN sys.triggers T ON T.object_id = PS.object_id
LEFT JOIN sys.objects O ON O.object_id = T.parent_id
CROSS APPLY sys.dm_exec_sql_text(PS.plan_handle) ST
CROSS APPLY sys.dm_exec_query_plan(PS.plan_handle) QP
WHERE DB_NAME(database_id) = 'AdventureWorks'
ORDER BY PS.total_worker_time DESC;


UPDATE Production.WorkOrder 
SET StartDate = GETDATE(), EndDate = GETDATE(), DueDate = GETDATE()
WHERE WorkOrderID = 1


UPDATE Sales.SalesOrderHeader
SET OrderDate = GETDATE(), DueDate = GETDATE(), ShipDate = GETDATE()
WHERE SalesOrderID = 75123;



--	Kullanýlmayan Trigger'larý Tespit Etmek


SELECT SCHEMA_NAME(o.schema_id) AS tablo_sema_ismi,
       o.name AS tablo_nesne_ismi, 
       t.name AS trigger_nesne_ismi,
       t.create_date,
       t.modify_date
FROM sys.triggers t
LEFT JOIN sys.objects o ON t.parent_id = o.object_id
WHERE t.is_disabled = 0 AND t.parent_id > 0
AND NOT EXISTS(SELECT ps.object_id 
		FROM sys.dm_exec_procedure_stats ps 
		WHERE ps.object_id = t.object_id
		AND ps.database_id = DB_ID('AdventureWorks'))
		ORDER BY SCHEMA_NAME(o.schema_id),o.name,t.name;


--	Açýk Olan Cursor'leri Sorgulama



SELECT * FROM sys.dm_exec_cursors(0);


DECLARE @ProductID INT;
DECLARE @Name	 VARCHAR(255);
DECLARE ProductCursor CURSOR FOR
	  SELECT ProductID, Name FROM Production.Product WHERE ProductID < 5;
OPEN ProductCursor;
FETCH NEXT FROM ProductCursor INTO @ProductID, @Name;
WHILE @@FETCH_STATUS = 0
BEGIN
	WAITFOR DELAY '00:00:2';
	PRINT CAST(@ProductID AS VARCHAR) + '  -  ' + @Name;
	FETCH NEXT FROM ProductCursor INTO @ProductID, @Name;
END;
CLOSE ProductCursor;
DEALLOCATE ProductCursor;



SELECT ec.cursor_id,
       ec.name AS cursor_name,
       ec.creation_time,
       ec.dormant_duration/1000 AS uyku_suresi_sn,
       ec.fetch_status,
       ec.properties,
       ec.session_id,
       es.login_name,
       es.host_name,
       st.text,
       SUBSTRING(st.text, (ec.statement_start_offset/2)+1, 
        ((CASE ec.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         	ELSE ec.statement_end_offset
          END - ec.statement_start_offset)/2) + 1) AS ifade_metni
FROM sys.dm_exec_cursors(0) ec
CROSS APPLY sys.dm_exec_sql_text(ec.sql_handle) st
JOIN sys.dm_exec_sessions es ON es.session_id = ec.session_id



























































