
USE [master]                                                                                                           
GO                                                                                                                     
CREATE DATABASE [model]                                                                                                
CONTAINMENT = NONE                                                                                                     
ON  PRIMARY                                                                                                            
( NAME = N'modeldev', FILENAME = N'D:\sysdbsdata\MSSQL13.MSSQLSERVER\MSSQL\DATA\model.mdf', SIZE = 10240KB , MAXSIZE = 
1024MB, FILEGROWTH = 262144KB )                                                                                        
LOG ON                                                                                                                 
( NAME = N'modellog', FILENAME = N'D:\sysdbsdata\MSSQL13.MSSQLSERVER\MSSQL\DATA\modellog.ldf', SIZE = 8192KB , MAXSIZE 
= 1024MB, FILEGROWTH = 262144KB )                                                                                      
GO                                                                                                                     
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))                                                                
BEGIN                                                                                                                  
EXEC [model].[dbo].[sp_fulltext_database] @action = 'enable'                                                           
END                                                                                                                    
GO                                                                                                                     
ALTER DATABASE [model] SET AUTO_CLOSE OFF                                                                              
GO                                                                                                                     
ALTER DATABASE [model] SET AUTO_SHRINK OFF                                                                             
GO                                                                                                                     
ALTER DATABASE [model] SET READ_COMMITTED_SNAPSHOT OFF                                                                 
GO                                                                                                                     
ALTER DATABASE [model] SET AUTO_CREATE_STATISTICS ON                                                                   
GO                                                                                                                     
ALTER DATABASE [model] SET AUTO_UPDATE_STATISTICS ON                                                                   
GO                                                                                                                     
ALTER DATABASE [model] SET AUTO_UPDATE_STATISTICS_ASYNC OFF                                                            
GO                                                                                                                     
ALTER DATABASE [model] SET ANSI_NULL_DEFAULT OFF                                                                       
GO                                                                                                                     
ALTER DATABASE [model] SET ANSI_NULLS OFF                                                                              
GO                                                                                                                     
ALTER DATABASE [model] SET ANSI_PADDING OFF                                                                            
GO                                                                                                                     
ALTER DATABASE [model] SET ANSI_WARNINGS OFF                                                                           
GO                                                                                                                     
ALTER DATABASE [model] SET ARITHABORT OFF                                                                              
GO                                                                                                                     
ALTER DATABASE [model] SET CONCAT_NULL_YIELDS_NULL OFF                                                                 
GO                                                                                                                     
ALTER DATABASE [model] SET NUMERIC_ROUNDABORT OFF                                                                      
GO                                                                                                                     
ALTER DATABASE [model] SET QUOTED_IDENTIFIER OFF                                                                       
GO                                                                                                                     
ALTER DATABASE [model] SET RECURSIVE_TRIGGERS OFF                                                                      
GO                                                                                                                     
ALTER DATABASE [model] SET CURSOR_CLOSE_ON_COMMIT OFF                                                                  
GO                                                                                                                     
ALTER DATABASE [model] SET TRUSTWORTHY OFF                                                                             
GO                                                                                                                     
ALTER DATABASE [model] SET DB_CHAINING OFF                                                                             
GO                                                                                                                     
ALTER DATABASE [model] SET DATE_CORRELATION_OPTIMIZATION OFF                                                           
GO                                                                                                                     
ALTER DATABASE [model] SET HONOR_BROKER_PRIORITY OFF                                                                   
GO                                                                                                                     
ALTER DATABASE [model] SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF                                                  
GO                                                                                                                     
ALTER DATABASE [model] SET MIXED_PAGE_ALLOCATION ON                                                                    
GO                                                                                                                     
ALTER DATABASE [model] SET MULTI_USER                                                                                  
GO                                                                                                                     
ALTER DATABASE [model] SET  READ_WRITE                                                                                 
GO                                                                                                                     
ALTER DATABASE [model] SET  DISABLE_BROKER                                                                             
GO                                                                                                                     
ALTER DATABASE [model] SET CHECKSUM                                                                                    
GO                                                                                                                     
ALTER DATABASE [model] SET TARGET_RECOVERY_TIME = 60 SECONDS                                                           
GO                                                                                                                     
ALTER DATABASE [model] SET COMPATIBILITY_LEVEL = 130                                                                   
GO                                                                                                                     
ALTER DATABASE [model] SET RECOVERY SIMPLE                                                                             
GO                                                                                                                     
ALTER DATABASE [model] SET DELAYED_DURABILITY  = DISABLED                                                              
GO                                                                                                                     
ALTER DATABASE [model] SET ALLOW_SNAPSHOT_ISOLATION OFF                                                                
GO                                                                                                                     


