
USE [master]                                                                                                           
GO                                                                                                                     
CREATE DATABASE [tempdb]                                                                                               
CONTAINMENT = NONE                                                                                                     
ON  PRIMARY                                                                                                            
( NAME = N'tempdev', FILENAME = N'G:\sysdbsdata\tempdb.mdf', SIZE = 4194304KB , MAXSIZE = UNLIMITED, FILEGROWTH = 0KB )
LOG ON                                                                                                                 
( NAME = N'templog', FILENAME = N'H:\logs\templog.ldf', SIZE = 1048576KB , MAXSIZE = UNLIMITED, FILEGROWTH = 262144KB )
GO                                                                                                                     
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))                                                                
BEGIN                                                                                                                  
EXEC [tempdb].[dbo].[sp_fulltext_database] @action = 'enable'                                                          
END                                                                                                                    
GO                                                                                                                     
ALTER DATABASE [tempdb] SET AUTO_CLOSE OFF                                                                             
GO                                                                                                                     
ALTER DATABASE [tempdb] SET AUTO_SHRINK OFF                                                                            
GO                                                                                                                     
ALTER DATABASE [tempdb] SET READ_COMMITTED_SNAPSHOT OFF                                                                
GO                                                                                                                     
ALTER DATABASE [tempdb] SET AUTO_CREATE_STATISTICS ON                                                                  
GO                                                                                                                     
ALTER DATABASE [tempdb] SET AUTO_UPDATE_STATISTICS ON                                                                  
GO                                                                                                                     
ALTER DATABASE [tempdb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF                                                           
GO                                                                                                                     
ALTER DATABASE [tempdb] SET ANSI_NULL_DEFAULT OFF                                                                      
GO                                                                                                                     
ALTER DATABASE [tempdb] SET ANSI_NULLS OFF                                                                             
GO                                                                                                                     
ALTER DATABASE [tempdb] SET ANSI_PADDING OFF                                                                           
GO                                                                                                                     
ALTER DATABASE [tempdb] SET ANSI_WARNINGS OFF                                                                          
GO                                                                                                                     
ALTER DATABASE [tempdb] SET ARITHABORT OFF                                                                             
GO                                                                                                                     
ALTER DATABASE [tempdb] SET CONCAT_NULL_YIELDS_NULL OFF                                                                
GO                                                                                                                     
ALTER DATABASE [tempdb] SET NUMERIC_ROUNDABORT OFF                                                                     
GO                                                                                                                     
ALTER DATABASE [tempdb] SET QUOTED_IDENTIFIER OFF                                                                      
GO                                                                                                                     
ALTER DATABASE [tempdb] SET RECURSIVE_TRIGGERS OFF                                                                     
GO                                                                                                                     
ALTER DATABASE [tempdb] SET CURSOR_CLOSE_ON_COMMIT OFF                                                                 
GO                                                                                                                     
ALTER DATABASE [tempdb] SET TRUSTWORTHY OFF                                                                            
GO                                                                                                                     
ALTER DATABASE [tempdb] SET DB_CHAINING ON                                                                             
GO                                                                                                                     
ALTER DATABASE [tempdb] SET DATE_CORRELATION_OPTIMIZATION OFF                                                          
GO                                                                                                                     
ALTER DATABASE [tempdb] SET HONOR_BROKER_PRIORITY OFF                                                                  
GO                                                                                                                     
ALTER DATABASE [tempdb] SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF                                                 
GO                                                                                                                     
ALTER DATABASE [tempdb] SET MIXED_PAGE_ALLOCATION OFF                                                                  
GO                                                                                                                     
ALTER DATABASE [tempdb] SET MULTI_USER                                                                                 
GO                                                                                                                     
ALTER DATABASE [tempdb] SET  READ_WRITE                                                                                
GO                                                                                                                     
ALTER DATABASE [tempdb] SET  ENABLE_BROKER                                                                             
GO                                                                                                                     
ALTER DATABASE [tempdb] SET CHECKSUM                                                                                   
GO                                                                                                                     
ALTER DATABASE [tempdb] SET TARGET_RECOVERY_TIME = 60 SECONDS                                                          
GO                                                                                                                     
ALTER DATABASE [tempdb] SET COMPATIBILITY_LEVEL = 130                                                                  
GO                                                                                                                     
ALTER DATABASE [tempdb] SET RECOVERY SIMPLE                                                                            
GO                                                                                                                     
ALTER DATABASE [tempdb] SET DELAYED_DURABILITY  = DISABLED                                                             
GO                                                                                                                     
ALTER DATABASE [tempdb] SET ALLOW_SNAPSHOT_ISOLATION OFF                                                               
GO                                                                                                                     


