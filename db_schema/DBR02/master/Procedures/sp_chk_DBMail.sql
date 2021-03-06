USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--
CREATE PROC dbo.sp_chk_DBMail
	(	-- Check failed report ON/OFF 
		@ShowCheckFailed tinyint = 0,	-- * DEFAULT = 0 (NOT Shown)
		@ShowLastItems tinyint = 0	-- * DEFAULT = 0 (NOT Shown)
	)
AS
BEGIN;
SET NOCOUNT ON
------------------------------------------------------------------------------------------- 
-- Database Mail service CHECK
--	Check Fail MailItems (@ShowCheckFailed=1)
--	Show Last MailItems, with recipients Cleanup Check (@ShowLastItems=1)
------------------------------------------------------------------------------------------- 
-- -- **  ...\wrk_abox\dba\MSSQL\MSSQL2005+\20_DBMail_check_stat.sql
---
print @@SERVERNAME + ' [' + convert(varchar(20), getdate(),120) + ']'
print '/* -- Database Mail service CHECK: (msdb.) */'
print ''

CREATE TABLE #DBMailCk ( check_ varchar(200)
	, queue_type varchar(40)
    , length int
    , state_Status varchar(100)
	, last_empty_rowset_time datetime 
	, last_activated_time datetime
	, checked_dt varchar(50) default CONVERT(VARCHAR(19), getdate(),126)
);
-- * Populate the temporary table
INSERT #DBMailCk (state_Status)
   EXEC  msdb.dbo.sysmail_help_status_sp
;
UPDATE #DBMailCk SET check_ = 'DBMail service Status (sysmail_help_status_sp)';
-- 
INSERT #DBMailCk (queue_type, length, state_Status, last_empty_rowset_time, last_activated_time)
   EXEC msdb.dbo.sysmail_help_queue_sp 
;
UPDATE #DBMailCk SET check_ = 'queues State (sysmail_help_queue_sp)' where queue_type in ('mail','status');
--
INSERT #DBMailCk(check_) VALUES ('(****) [NULL] values indicate no use for the particular Check_'); 
select * from #DBMailCk;
DROP table #DBMailCk;

print ''
print '___________________'
print '(***) : [state_Status] state or Status of the check.
	Possible values for queues: INACTIVE (queue is inactive), NOTIFIED (queue has been notified receipt to occur), and RECEIVES_OCCURRING (queue is receiving).'
print ''
------------------------------------------------------------------------------------------

IF (@ShowCheckFailed = 1) 
BEGIN;
	--
	-- Show the subject, the time that the mail item row was last modified, and the log information.
	-- Join sysmail_faileditems to sysmail_event_log on the mailitem_id column.
	-- --
	print ''
	print '/* -- Database Mail failed Items ( top 50 ): */'
	print ''
	SELECT top 50 LTRIM(RTRIM(REPLACE(items.recipients,CHAR(13)+CHAR(10),''))) [recipients_cleanedup]
		, CONCAT('"',items.subject,'"') subject_quoted, items.last_mod_date, CONCAT('"',l.description,'"') [Error_message_quoted]
		, CONCAT('"',items.recipients,'"')	recipients_quoted	
		, CASE WHEN items.recipients=(LTRIM(RTRIM(REPLACE(items.recipients,CHAR(13)+CHAR(10),'')))) 
			THEN NULL ELSE -1 END [recipients_clean_chk]
	FROM msdb.dbo.sysmail_faileditems as items
		INNER JOIN msdb.dbo.sysmail_event_log AS l
			ON items.mailitem_id = l.mailitem_id
	ORDER BY items.last_mod_date DESC
	;
	print '';
	print '___________________'
	print '(**) recipients Cleanup check: 
		[recipients_cleanedup], is [recipients] column after Trims and Cleanup from \r\n
		[recipients_clean_chk], values=-1 shows that [recipients]<>[recipients_cleared]
		-- 
		[.. _quoted] column notation: double quotes have been concatenated to column value';
	print '';
END;


------------------------------------------------------------------------------------------

IF (@ShowLastItems = 1) 
BEGIN;
	--
	-- Show Last MailItems processed when was last modified, and the log information.
	-- Join sysmail_allitems to sysmail_event_log on the mailitem_id column.
	-- 	** with recipients Cleanup
	print '';
	print '/* -- Database Last MailItems processed ( top 100 ): */';
	-- 
	SELECT TOP 100  items.recipients, items.subject, items.last_mod_date, items.body	
		, items.profile_id, items.send_request_date, items.sent_date, items.sent_status
		,l.description log_descr, l.last_mod_user log_last_mod_user
		, LTRIM(RTRIM(REPLACE(items.recipients,CHAR(13)+CHAR(10),''))) [recipients_cleanedup]
		, CASE WHEN items.recipients=(LTRIM(RTRIM(REPLACE(items.recipients,CHAR(13)+CHAR(10),'')))) 
			THEN NULL ELSE -1 END [recipients_clean_chk]
	FROM msdb.dbo.sysmail_allitems as items
	left JOIN msdb.dbo.sysmail_event_log AS l
		ON items.mailitem_id = l.mailitem_id
	-- WHERE items.subject like '%mt1%'  
	ORDER BY items.last_mod_date desc
	;
	print '';
	print '___________________'
	print '(**) recipients Cleanup check: 
		[recipients_cleanedup], is [recipients] column after Trims and Cleanup from \r\n
		[recipients_clean_chk], values=-1 shows that [recipients]<>[recipients_cleared]
		-- 
		[.. _quoted] column notation: double quotes have been concatenated to column value ';
	print '';
END;
-- -- ** ENDoF: server Database Mail service CHECK
-- -- -- --
--

-- ** ENDoF sp_chk_DBMail
SET NOCOUNT OFF
END;

GO
