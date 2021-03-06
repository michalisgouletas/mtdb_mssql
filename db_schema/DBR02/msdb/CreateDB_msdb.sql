
USE [master]                                                                                                           
GO                                                                                                                     
CREATE DATABASE [msdb]                                                                                                 
CONTAINMENT = NONE                                                                                                     
ON  PRIMARY                                                                                                            
( NAME = N'MSDBData', FILENAME = N'D:\sysdbsdata\MSSQL13.MSSQLSERVER\MSSQL\DATA\MSDBData.mdf', SIZE = 325184KB ,       
MAXSIZE = UNLIMITED, FILEGROWTH = 80KB )                                                                               
LOG ON                                                                                                                 
( NAME = N'MSDBLog', FILENAME = N'D:\sysdbsdata\MSSQL13.MSSQLSERVER\MSSQL\DATA\MSDBLog.ldf', SIZE = 29504KB , MAXSIZE  
= 2097152MB, FILEGROWTH = 80KB )                                                                                       
GO                                                                                                                     
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))                                                                
BEGIN                                                                                                                  
EXEC [msdb].[dbo].[sp_fulltext_database] @action = 'enable'                                                            
END                                                                                                                    
GO                                                                                                                     
ALTER DATABASE [msdb] SET AUTO_CLOSE OFF                                                                               
GO                                                                                                                     
ALTER DATABASE [msdb] SET AUTO_SHRINK OFF                                                                              
GO                                                                                                                     
ALTER DATABASE [msdb] SET READ_COMMITTED_SNAPSHOT OFF                                                                  
GO                                                                                                                     
ALTER DATABASE [msdb] SET AUTO_CREATE_STATISTICS ON                                                                    
GO                                                                                                                     
ALTER DATABASE [msdb] SET AUTO_UPDATE_STATISTICS ON                                                                    
GO                                                                                                                     
ALTER DATABASE [msdb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF                                                             
GO                                                                                                                     
ALTER DATABASE [msdb] SET ANSI_NULL_DEFAULT OFF                                                                        
GO                                                                                                                     
ALTER DATABASE [msdb] SET ANSI_NULLS OFF                                                                               
GO                                                                                                                     
ALTER DATABASE [msdb] SET ANSI_PADDING OFF                                                                             
GO                                                                                                                     
ALTER DATABASE [msdb] SET ANSI_WARNINGS OFF                                                                            
GO                                                                                                                     
ALTER DATABASE [msdb] SET ARITHABORT OFF                                                                               
GO                                                                                                                     
ALTER DATABASE [msdb] SET CONCAT_NULL_YIELDS_NULL OFF                                                                  
GO                                                                                                                     
ALTER DATABASE [msdb] SET NUMERIC_ROUNDABORT OFF                                                                       
GO                                                                                                                     
ALTER DATABASE [msdb] SET QUOTED_IDENTIFIER OFF                                                                        
GO                                                                                                                     
ALTER DATABASE [msdb] SET RECURSIVE_TRIGGERS OFF                                                                       
GO                                                                                                                     
ALTER DATABASE [msdb] SET CURSOR_CLOSE_ON_COMMIT OFF                                                                   
GO                                                                                                                     
ALTER DATABASE [msdb] SET TRUSTWORTHY ON                                                                               
GO                                                                                                                     
ALTER DATABASE [msdb] SET DB_CHAINING ON                                                                               
GO                                                                                                                     
ALTER DATABASE [msdb] SET DATE_CORRELATION_OPTIMIZATION OFF                                                            
GO                                                                                                                     
ALTER DATABASE [msdb] SET HONOR_BROKER_PRIORITY OFF                                                                    
GO                                                                                                                     
ALTER DATABASE [msdb] SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF                                                   
GO                                                                                                                     
ALTER DATABASE [msdb] SET MIXED_PAGE_ALLOCATION ON                                                                     
GO                                                                                                                     
ALTER DATABASE [msdb] SET MULTI_USER                                                                                   
GO                                                                                                                     
ALTER DATABASE [msdb] SET  READ_WRITE                                                                                  
GO                                                                                                                     
ALTER DATABASE [msdb] SET  ENABLE_BROKER                                                                               
GO                                                                                                                     
ALTER DATABASE [msdb] SET CHECKSUM                                                                                     
GO                                                                                                                     
ALTER DATABASE [msdb] SET TARGET_RECOVERY_TIME = 60 SECONDS                                                            
GO                                                                                                                     
ALTER DATABASE [msdb] SET COMPATIBILITY_LEVEL = 130                                                                    
GO                                                                                                                     
ALTER DATABASE [msdb] SET RECOVERY SIMPLE                                                                              
GO                                                                                                                     
ALTER DATABASE [msdb] SET DELAYED_DURABILITY  = DISABLED                                                               
GO                                                                                                                     
ALTER DATABASE [msdb] SET ALLOW_SNAPSHOT_ISOLATION ON                                                                  
GO                                                                                                                     


