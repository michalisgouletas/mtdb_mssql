BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'refr_batches_replc_D', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=3, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'[7/2/2018] (CORE-5100) Daily refresh replica tbs on [ais_replica] on [ais]', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'sa', 
		@notify_email_operator_name=N'MT_dbadmin_gmail', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'imo_history_batch_sp', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'PRINT ''-- (spid ''+CONVERT(VARCHAR(10),@@SPID)+'') : ''+ @@SERVERNAME+ ''.''+DB_NAME()+ ''.''+USER_NAME()+'' [''+CONVERT(VARCHAR(19), GETDATE(),126)+''] **** [imo_history_batch_sp]'';
GO
EXEC dbo.[imo_history_batch_sp];
GO', 
		@database_name=N'ais_replica', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'refrs_SHIPGTMASTER_batch', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'PRINT ''-- (spid ''+CONVERT(VARCHAR(10),@@SPID)+'') : ''+ @@SERVERNAME+ ''.''+DB_NAME()+ ''.''+USER_NAME()+'' [''+CONVERT(VARCHAR(19), GETDATE(),126)+''] **** [refrs_SHIPGTMASTER_batch_usp]'';
GO
EXEC dbo.[refrs_SHIPGTMASTER_batch_usp];
GO', 
		@database_name=N'ais_replica', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'refrs_VLIGHTHOUSEB_batch', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'PRINT ''-- (spid ''+CONVERT(VARCHAR(10),@@SPID)+'') : ''+ @@SERVERNAME+ ''.''+DB_NAME()+ ''.''+USER_NAME()+'' [''+CONVERT(VARCHAR(19), GETDATE(),126)+''] **** [refrs_VLIGHTHOUSEB_batch_usp]'';
GO
EXEC dbo.[refrs_VLIGHTHOUSEB_batch_usp];
GO', 
		@database_name=N'ais_replica', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'refr_batches_replc_D', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20180207, 
		@active_end_date=99991231, 
		@active_start_time=90400, 
		@active_end_time=235959, 
		@schedule_uid=N'f7ab80e7-c5f5-427b-a8f0-be1bf3754ad9'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

