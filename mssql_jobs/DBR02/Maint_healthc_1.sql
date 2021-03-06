BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Maint_healthc_1', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'healthcs {''sp_chk_inst_DBs - sp_chk_DBMail''} - sp_chk_JobsLast''}', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'dbadmin', 
		@notify_email_operator_name=N'MT_yannis.batistakis', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'sp_chk_inst_DBs_DBMail', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @strSubj as varchar(100) = ''(''+@@SERVERNAME+'') sp_chk_inst_DBs , _DBMail - '' + convert(varchar(10), getdate(), 126);
DECLARE @strAttf as nvarchar(200) = REPLACE(REPLACE(replace(@strSubj,'' '',''''),''-'',''''), ''\'', ''_'')+replace(cast(getdate() as time(0)),'':'','''')+''.csv'';
EXEC msdb.dbo.sp_send_dbmail
	@profile_name = ''smtp'',
	@recipients = ''yannis.batistakis@marinetraffic.com'',
	@subject = @strSubj,
	@query = N''EXEC master.dbo.sp_chk_inst_DBs;
	EXEC master.dbo.sp_chk_DBMail;'',
	@attach_query_result_as_file = 1,
	@query_attachment_filename= @strAttf,
	@query_result_separator='';'', @query_result_width=840, @query_result_no_padding=1
;', 
		@database_name=N'master', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'sp_chk_JobsStatus_failed', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @strSubj as nvarchar(200) = N''(''+@@SERVERNAME+'') sp_chk_JobsStatus_failed - '' + convert(varchar(10), getdate(), 126);
DECLARE @strAttf as nvarchar(200) = REPLACE(REPLACE(replace(@strSubj,'' '',''''),''-'',''''), ''\'', ''_'')+replace(cast(getdate() as time(0)),'':'','''')+''.csv'';
EXEC msdb.dbo.sp_send_dbmail
	@profile_name = ''smtp'',
	@recipients = ''yannis.batistakis@marinetraffic.com'',
	@subject = @strSubj,
	@query = N''EXEC master.dbo.sp_chk_JobsLast;
	EXEC master.[dbo].sp_chk_JobsStatus_detail @intHourssBefore=2, @bitAllSteps=1, @bitFailedOnly=1;'',
	@attach_query_result_as_file = 1,
	@query_attachment_filename= @strAttf,
	@query_result_separator='';'', @query_result_width=840, @query_result_no_padding=1
;', 
		@database_name=N'master', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'sp_chk_JobsStatus_detl', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @strSubj as nvarchar(200) = N''(''+@@SERVERNAME+'') sp_chk_JobsStatus_detl - '' + convert(varchar(10), getdate(), 126);
DECLARE @strAttf as nvarchar(200) = REPLACE(REPLACE(replace(@strSubj,'' '',''''),''-'',''''), ''\'', ''_'')+replace(cast(getdate() as time(0)),'':'','''')+''.csv'';
EXEC msdb.dbo.sp_send_dbmail
	@profile_name = ''smtp'',
	@recipients = ''yannis.batistakis@marinetraffic.com'',
	@subject = @strSubj,
	@query = N''EXEC master.[dbo].sp_chk_JobsStatus_detail @ShowCheckRunning=0, @intHourssBefore=1, @bitAllSteps=1 ;'',
	@attach_query_result_as_file = 1,
	@query_attachment_filename= @strAttf,
	@query_result_separator='';'', @query_result_width=840, @query_result_no_padding=1
;', 
		@database_name=N'master', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Maint_healthc_1_night', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=127, 
		@freq_subday_type=8, 
		@freq_subday_interval=4, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20150420, 
		@active_end_date=99991231, 
		@active_start_time=200900, 
		@active_end_time=83900, 
		@schedule_uid=N'e3051d5e-7d81-4c42-a408-b469c65ee00e'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Maint_healthc_1_WdayAdHoc', 
		@enabled=0, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=8, 
		@freq_subday_interval=2, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20170724, 
		@active_end_date=99991231, 
		@active_start_time=100900, 
		@active_end_time=183900, 
		@schedule_uid=N'8a27661f-e253-4f66-bec7-f60df1cbe08b'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Maint_healthc_1_WEnd', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=65, 
		@freq_subday_type=8, 
		@freq_subday_interval=4, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20150420, 
		@active_end_date=99991231, 
		@active_start_time=100900, 
		@active_end_time=183900, 
		@schedule_uid=N'ce9f4c70-6c32-4c1c-ba7e-d12bfad88c82'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

