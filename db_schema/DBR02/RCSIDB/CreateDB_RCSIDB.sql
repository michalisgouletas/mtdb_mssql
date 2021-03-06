
USE [master]                                                                                                           
GO                                                                                                                     
CREATE DATABASE [RCSIDB]                                                                                               
CONTAINMENT = NONE                                                                                                     
ON  PRIMARY                                                                                                            
( NAME = N'RCSIDB', FILENAME = N'H:\data\tmpx_RCSIDB.mdf', SIZE = 102400KB , MAXSIZE = 5000MB, FILEGROWTH = 102400KB ) 
LOG ON                                                                                                                 
( NAME = N'RCSIDB_log', FILENAME = N'H:\data\tmpx_RCSIDB_log.ldf', SIZE = 51200KB , MAXSIZE = 2097152MB, FILEGROWTH =  
102400KB )                                                                                                             
GO                                                                                                                     
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))                                                                
BEGIN                                                                                                                  
EXEC [RCSIDB].[dbo].[sp_fulltext_database] @action = 'enable'                                                          
END                                                                                                                    
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET AUTO_CLOSE OFF                                                                             
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET AUTO_SHRINK OFF                                                                            
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET READ_COMMITTED_SNAPSHOT ON                                                                 
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET AUTO_CREATE_STATISTICS ON                                                                  
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET AUTO_UPDATE_STATISTICS ON                                                                  
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF                                                           
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET ANSI_NULL_DEFAULT OFF                                                                      
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET ANSI_NULLS OFF                                                                             
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET ANSI_PADDING OFF                                                                           
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET ANSI_WARNINGS OFF                                                                          
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET ARITHABORT OFF                                                                             
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET CONCAT_NULL_YIELDS_NULL OFF                                                                
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET NUMERIC_ROUNDABORT OFF                                                                     
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET QUOTED_IDENTIFIER OFF                                                                      
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET RECURSIVE_TRIGGERS OFF                                                                     
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET CURSOR_CLOSE_ON_COMMIT OFF                                                                 
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET TRUSTWORTHY OFF                                                                            
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET DB_CHAINING OFF                                                                            
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET DATE_CORRELATION_OPTIMIZATION OFF                                                          
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET HONOR_BROKER_PRIORITY OFF                                                                  
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF                                                 
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET MIXED_PAGE_ALLOCATION OFF                                                                  
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET MULTI_USER                                                                                 
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET  READ_WRITE                                                                                
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET  ENABLE_BROKER                                                                             
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET CHECKSUM                                                                                   
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET TARGET_RECOVERY_TIME = 60 SECONDS                                                          
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET COMPATIBILITY_LEVEL = 130                                                                  
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET RECOVERY SIMPLE                                                                            
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET DELAYED_DURABILITY  = DISABLED                                                             
GO                                                                                                                     
ALTER DATABASE [RCSIDB] SET ALLOW_SNAPSHOT_ISOLATION OFF                                                               
GO                                                                                                                     


