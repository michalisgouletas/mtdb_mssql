BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Maint_healthc_0', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'healthcs {''sp_chk_Batch_Mem - xp_fixeddrives''}, {''sp_chk_os_stwaits''} , {sp_chk_Blocked_Deadl}, {''sp_chk_ErrLog''}', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'dbadmin', 
		@notify_email_operator_name=N'MT_yannis.batistakis', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'sp_chk_BatchMem_xp_fixed', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @strSubj as varchar(100) = ''(''+@@SERVERNAME+'') sp_chk_Batch_Mem, OS,  xp_fixeddrives - '' + convert(varchar(10), getdate(), 126);
EXEC msdb.dbo.sp_send_dbmail
	@profile_name = ''smtp'',
	@recipients = ''yannis.batistakis@marinetraffic.com'',
	@subject = @strSubj,
	@query = N''EXEC master.dbo.sp_chk_Batch_Mem;
	EXEC master.dbo.sp_chk_os_stwaits;
	EXEC master.dbo.sp_chk_zbx_CliProc @strDBname=''''ais_replica'''', @vExt = 1;
	PRINT ''''.''''; EXEC master.dbo.xp_fixeddrives;'',
	@attach_query_result_as_file = 0,
	@query_result_width=640,  @query_result_no_padding=1
;', 
		@database_name=N'master', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'sp_chk_Blocked_Deadl', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @strSubj as varchar(100) = ''(''+@@SERVERNAME+'') sp_chk_Blocked_Deadl - '' + convert(varchar(10), getdate(), 126);
DECLARE @strAttf as nvarchar(200) = REPLACE(REPLACE(replace(@strSubj,'' '',''''),''-'',''''), ''\'', ''_'')+replace(cast(getdate() as time(0)),'':'','''')+''.csv'';
EXEC msdb.dbo.sp_send_dbmail
	@profile_name = ''smtp'',
	@recipients = ''yannis.batistakis@marinetraffic.com'',
	@subject = @strSubj,
	@query = N''EXEC master..sp_chk_Blocked_Deadl @ShowDeadLockRpt=1;'',
	@attach_query_result_as_file = 1,
	@query_attachment_filename= @strAttf,
	@query_result_separator='';'', @query_result_width=640, @query_result_no_padding=1
;', 
		@database_name=N'master', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'sp_chk_ErrLog', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=1, 
		@retry_interval=1, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'DECLARE @strSubj as varchar(100) = ''(''+@@SERVERNAME+'') sp_chk_ErrLog - '' + convert(varchar(10), getdate(), 126);
EXEC msdb.dbo.sp_send_dbmail
	@profile_name = ''smtp'',
	@recipients = ''yannis.batistakis@marinetraffic.com'',
	@subject = @strSubj,
	@query = N''EXEC master.dbo.sp_chk_ErrLog;'',
	@attach_query_result_as_file = 0,
	@query_result_width=640,  @query_result_no_padding=1
;', 
		@database_name=N'master', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Maint_healthc_0_day', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=8, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20150416, 
		@active_end_date=99991231, 
		@active_start_time=40800, 
		@active_end_time=200800, 
		@schedule_uid=N'39a4d623-5553-4307-b8d3-b00b2d9bc8ec'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Maint_healthc_0_Mon-day', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=2, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20150420, 
		@active_end_date=99991231, 
		@active_start_time=800, 
		@active_end_time=30800, 
		@schedule_uid=N'30fa2b69-1ec3-47ba-b6e7-fa8da3437f3e'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Maint_healthc_0_night', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=62, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20150416, 
		@active_end_date=99991231, 
		@active_start_time=200800, 
		@active_end_time=30800, 
		@schedule_uid=N'd0703774-9235-4047-abc3-4f3d1d79e2ce'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Maint_healthc_0_WEnd', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=65, 
		@freq_subday_type=8, 
		@freq_subday_interval=1, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20150416, 
		@active_end_date=99991231, 
		@active_start_time=800, 
		@active_end_time=235959, 
		@schedule_uid=N'b34a71dc-87f0-4783-a1c5-ee53bd6b8b8b'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

