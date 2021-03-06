BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'v_ship_batch_job', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'MT_dbadmin_gmail', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'disable_bacth_jobs', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC msdb.dbo.sp_update_job @job_name=''v_ship_diff'',@enabled = 0
EXEC msdb.dbo.sp_update_job @job_name=''v_pos_all_batch_job'',@enabled = 0
waitfor delay ''00:00:30''', 
		@database_name=N'master', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'v_ship_step', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=2, 
		@retry_interval=2, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- 2 execs One for each V_SHIP_BATCH1/2
DECLARE @objectn NVARCHAR(1035), @mdt DATETIME;
SELECT @objectn = base_object_name , @mdt=modify_date FROM sys.synonyms WHERE name=''V_SHIP_TEMP'';
PRINT @@SERVERNAME+ ''.''+DB_NAME()+''[''+CONVERT(VARCHAR(19), GETDATE(),126)+''] | object to be affected: ''+@objectn+ '' | modified_date: (''+CONVERT(VARCHAR(19), @mdt,126)+'')'';  
exec v_ship_batch_sp;
SELECT @objectn = base_object_name , @mdt=modify_date FROM sys.synonyms WHERE name=''V_SHIP_TEMP'';
PRINT @@SERVERNAME+ ''.''+DB_NAME()+''[''+CONVERT(VARCHAR(19), GETDATE(),126)+''] | object to be affected: ''+@objectn+ '' | modified_date: (''+CONVERT(VARCHAR(19), @mdt,126)+'')''; 
exec v_ship_batch_sp;

', 
		@database_name=N'ais_replica', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'enable_batch_jobs', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'PRINT @@SERVERNAME+ ''.''+DB_NAME()+''[''+CONVERT(VARCHAR(19), GETDATE(),126)+''] '';
EXEC msdb.dbo.sp_update_job @job_name=''v_ship_diff'',@enabled = 1
EXEC msdb.dbo.sp_update_job @job_name=''v_pos_all_batch_job'',@enabled = 1', 
		@database_name=N'master', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'11hrs', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=126, 
		@freq_subday_type=1, 
		@freq_subday_interval=11, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20080919, 
		@active_end_date=99991231, 
		@active_start_time=81000, 
		@active_end_time=235959, 
		@schedule_uid=N'1eb82fce-2f49-4842-8b52-e56eb5810a1a'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

