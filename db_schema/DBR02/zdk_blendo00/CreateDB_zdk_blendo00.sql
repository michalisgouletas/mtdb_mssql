
USE [master]                                                                                                           
GO                                                                                                                     
CREATE DATABASE [zdk_blendo00]                                                                                         
CONTAINMENT = NONE                                                                                                     
ON  PRIMARY                                                                                                            
( NAME = N'zdk_blendo00_01', FILENAME = N'H:\data\zdk_blendo00_01.mdf', SIZE = 2097152KB , MAXSIZE = 10240MB,          
FILEGROWTH = 262144KB ),                                                                                               
FILEGROUP [FG_DATA_00] DEFAULT                                                                                         
( NAME = N'zdk_blendo00_02', FILENAME = N'H:\data\zdk_blendo00_02.ndf', SIZE = 4227072KB , MAXSIZE = 30720MB,          
FILEGROWTH = 524288KB )                                                                                                
LOG ON                                                                                                                 
( NAME = N'zdk_blendo00_log', FILENAME = N'H:\logs\zdk_blendo00_log.ldf', SIZE = 2097152KB , MAXSIZE = 20480MB,        
FILEGROWTH = 262144KB )                                                                                                
GO                                                                                                                     
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))                                                                
BEGIN                                                                                                                  
EXEC [zdk_blendo00].[dbo].[sp_fulltext_database] @action = 'enable'                                                    
END                                                                                                                    
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET AUTO_CLOSE OFF                                                                       
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET AUTO_SHRINK OFF                                                                      
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET READ_COMMITTED_SNAPSHOT OFF                                                          
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET AUTO_CREATE_STATISTICS ON                                                            
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET AUTO_UPDATE_STATISTICS ON                                                            
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET AUTO_UPDATE_STATISTICS_ASYNC OFF                                                     
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET ANSI_NULL_DEFAULT OFF                                                                
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET ANSI_NULLS OFF                                                                       
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET ANSI_PADDING OFF                                                                     
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET ANSI_WARNINGS OFF                                                                    
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET ARITHABORT OFF                                                                       
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET CONCAT_NULL_YIELDS_NULL OFF                                                          
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET NUMERIC_ROUNDABORT OFF                                                               
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET QUOTED_IDENTIFIER OFF                                                                
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET RECURSIVE_TRIGGERS OFF                                                               
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET CURSOR_CLOSE_ON_COMMIT OFF                                                           
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET TRUSTWORTHY OFF                                                                      
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET DB_CHAINING OFF                                                                      
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET DATE_CORRELATION_OPTIMIZATION OFF                                                    
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET HONOR_BROKER_PRIORITY OFF                                                            
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF                                           
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET MIXED_PAGE_ALLOCATION OFF                                                            
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET MULTI_USER                                                                           
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET  READ_WRITE                                                                          
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET  ENABLE_BROKER                                                                       
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET CHECKSUM                                                                             
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET TARGET_RECOVERY_TIME = 60 SECONDS                                                    
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET COMPATIBILITY_LEVEL = 130                                                            
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET RECOVERY SIMPLE                                                                      
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET DELAYED_DURABILITY  = DISABLED                                                       
GO                                                                                                                     
ALTER DATABASE [zdk_blendo00] SET ALLOW_SNAPSHOT_ISOLATION OFF                                                         
GO                                                                                                                     


