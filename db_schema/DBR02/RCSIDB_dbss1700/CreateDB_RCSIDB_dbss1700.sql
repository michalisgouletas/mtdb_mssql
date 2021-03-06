
USE [master]                                                                                                           
GO                                                                                                                     
CREATE DATABASE [RCSIDB_dbss1700]                                                                                      
CONTAINMENT = NONE                                                                                                     
ON  PRIMARY                                                                                                            
( NAME = N'RCSIDB', FILENAME = N'H:\data\tmpx_RCSIDB.mdf', SIZE = 102400KB , MAXSIZE = 5000MB, FILEGROWTH = 102400KB ) 
LOG ON                                                                                                                 
( NAME = N'RCSIDB_log', FILENAME = N'H:\data\tmpx_RCSIDB_log.ldf', SIZE = 51200KB , MAXSIZE = 2097152MB, FILEGROWTH =  
102400KB )                                                                                                             
GO                                                                                                                     
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))                                                                
BEGIN                                                                                                                  
EXEC [RCSIDB_dbss1700].[dbo].[sp_fulltext_database] @action = 'enable'                                                 
END                                                                                                                    
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET AUTO_CLOSE OFF                                                                    
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET AUTO_SHRINK OFF                                                                   
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET READ_COMMITTED_SNAPSHOT ON                                                        
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET AUTO_CREATE_STATISTICS ON                                                         
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET AUTO_UPDATE_STATISTICS ON                                                         
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET AUTO_UPDATE_STATISTICS_ASYNC OFF                                                  
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET ANSI_NULL_DEFAULT OFF                                                             
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET ANSI_NULLS OFF                                                                    
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET ANSI_PADDING OFF                                                                  
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET ANSI_WARNINGS OFF                                                                 
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET ARITHABORT OFF                                                                    
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET CONCAT_NULL_YIELDS_NULL OFF                                                       
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET NUMERIC_ROUNDABORT OFF                                                            
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET QUOTED_IDENTIFIER OFF                                                             
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET RECURSIVE_TRIGGERS OFF                                                            
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET CURSOR_CLOSE_ON_COMMIT OFF                                                        
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET TRUSTWORTHY OFF                                                                   
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET DB_CHAINING OFF                                                                   
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET DATE_CORRELATION_OPTIMIZATION OFF                                                 
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET HONOR_BROKER_PRIORITY OFF                                                         
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF                                        
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET MIXED_PAGE_ALLOCATION OFF                                                         
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET MULTI_USER                                                                        
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET  READ_ONLY                                                                        
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET  DISABLE_BROKER                                                                   
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET CHECKSUM                                                                          
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET TARGET_RECOVERY_TIME = 60 SECONDS                                                 
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET COMPATIBILITY_LEVEL = 130                                                         
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET RECOVERY SIMPLE                                                                   
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET DELAYED_DURABILITY  = DISABLED                                                    
GO                                                                                                                     
ALTER DATABASE [RCSIDB_dbss1700] SET ALLOW_SNAPSHOT_ISOLATION ON                                                       
GO                                                                                                                     


