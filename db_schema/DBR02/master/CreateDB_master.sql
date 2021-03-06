
USE [master]                                                                                                           
GO                                                                                                                     
CREATE DATABASE [master]                                                                                               
CONTAINMENT = NONE                                                                                                     
ON  PRIMARY                                                                                                            
( NAME = N'master', FILENAME = N'D:\sysdbsdata\MSSQL13.MSSQLSERVER\MSSQL\DATA\master.mdf', SIZE = 5504KB , MAXSIZE =   
UNLIMITED, FILEGROWTH = 80KB )                                                                                         
LOG ON                                                                                                                 
( NAME = N'mastlog', FILENAME = N'D:\sysdbsdata\MSSQL13.MSSQLSERVER\MSSQL\DATA\mastlog.ldf', SIZE = 2304KB , MAXSIZE = 
UNLIMITED, FILEGROWTH = 80KB )                                                                                         
GO                                                                                                                     
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))                                                                
BEGIN                                                                                                                  
EXEC [master].[dbo].[sp_fulltext_database] @action = 'enable'                                                          
END                                                                                                                    
GO                                                                                                                     
ALTER DATABASE [master] SET AUTO_CLOSE OFF                                                                             
GO                                                                                                                     
ALTER DATABASE [master] SET AUTO_SHRINK OFF                                                                            
GO                                                                                                                     
ALTER DATABASE [master] SET READ_COMMITTED_SNAPSHOT OFF                                                                
GO                                                                                                                     
ALTER DATABASE [master] SET AUTO_CREATE_STATISTICS ON                                                                  
GO                                                                                                                     
ALTER DATABASE [master] SET AUTO_UPDATE_STATISTICS ON                                                                  
GO                                                                                                                     
ALTER DATABASE [master] SET AUTO_UPDATE_STATISTICS_ASYNC OFF                                                           
GO                                                                                                                     
ALTER DATABASE [master] SET ANSI_NULL_DEFAULT OFF                                                                      
GO                                                                                                                     
ALTER DATABASE [master] SET ANSI_NULLS OFF                                                                             
GO                                                                                                                     
ALTER DATABASE [master] SET ANSI_PADDING OFF                                                                           
GO                                                                                                                     
ALTER DATABASE [master] SET ANSI_WARNINGS OFF                                                                          
GO                                                                                                                     
ALTER DATABASE [master] SET ARITHABORT OFF                                                                             
GO                                                                                                                     
ALTER DATABASE [master] SET CONCAT_NULL_YIELDS_NULL OFF                                                                
GO                                                                                                                     
ALTER DATABASE [master] SET NUMERIC_ROUNDABORT OFF                                                                     
GO                                                                                                                     
ALTER DATABASE [master] SET QUOTED_IDENTIFIER OFF                                                                      
GO                                                                                                                     
ALTER DATABASE [master] SET RECURSIVE_TRIGGERS OFF                                                                     
GO                                                                                                                     
ALTER DATABASE [master] SET CURSOR_CLOSE_ON_COMMIT OFF                                                                 
GO                                                                                                                     
ALTER DATABASE [master] SET TRUSTWORTHY OFF                                                                            
GO                                                                                                                     
ALTER DATABASE [master] SET DB_CHAINING ON                                                                             
GO                                                                                                                     
ALTER DATABASE [master] SET DATE_CORRELATION_OPTIMIZATION OFF                                                          
GO                                                                                                                     
ALTER DATABASE [master] SET HONOR_BROKER_PRIORITY OFF                                                                  
GO                                                                                                                     
ALTER DATABASE [master] SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF                                                 
GO                                                                                                                     
ALTER DATABASE [master] SET MIXED_PAGE_ALLOCATION ON                                                                   
GO                                                                                                                     
ALTER DATABASE [master] SET MULTI_USER                                                                                 
GO                                                                                                                     
ALTER DATABASE [master] SET  READ_WRITE                                                                                
GO                                                                                                                     
ALTER DATABASE [master] SET  DISABLE_BROKER                                                                            
GO                                                                                                                     
ALTER DATABASE [master] SET CHECKSUM                                                                                   
GO                                                                                                                     
ALTER DATABASE [master] SET TARGET_RECOVERY_TIME = 0 SECONDS                                                           
GO                                                                                                                     
ALTER DATABASE [master] SET COMPATIBILITY_LEVEL = 130                                                                  
GO                                                                                                                     
ALTER DATABASE [master] SET RECOVERY SIMPLE                                                                            
GO                                                                                                                     
ALTER DATABASE [master] SET DELAYED_DURABILITY  = DISABLED                                                             
GO                                                                                                                     
ALTER DATABASE [master] SET ALLOW_SNAPSHOT_ISOLATION ON                                                                
GO                                                                                                                     


