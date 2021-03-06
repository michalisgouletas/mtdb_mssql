
USE [master]                                                                                                           
GO                                                                                                                     
CREATE DATABASE [DBA_t01_00]                                                                                           
CONTAINMENT = NONE                                                                                                     
ON  PRIMARY                                                                                                            
( NAME = N'ais_replica', FILENAME = N'D:\data\DBA_t01_00.mdf', SIZE = 40108032KB , MAXSIZE = UNLIMITED, FILEGROWTH =   
262144KB )                                                                                                             
LOG ON                                                                                                                 
( NAME = N'ais_replica_log', FILENAME = N'G:\logs\DBA_t01_00_log.ldf', SIZE = 17956864KB , MAXSIZE = 2097152MB,        
FILEGROWTH = 131072KB )                                                                                                
GO                                                                                                                     
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))                                                                
BEGIN                                                                                                                  
EXEC [DBA_t01_00].[dbo].[sp_fulltext_database] @action = 'enable'                                                      
END                                                                                                                    
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET AUTO_CLOSE OFF                                                                         
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET AUTO_SHRINK OFF                                                                        
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET READ_COMMITTED_SNAPSHOT OFF                                                            
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET AUTO_CREATE_STATISTICS ON                                                              
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET AUTO_UPDATE_STATISTICS ON                                                              
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET AUTO_UPDATE_STATISTICS_ASYNC OFF                                                       
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET ANSI_NULL_DEFAULT OFF                                                                  
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET ANSI_NULLS OFF                                                                         
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET ANSI_PADDING OFF                                                                       
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET ANSI_WARNINGS OFF                                                                      
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET ARITHABORT OFF                                                                         
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET CONCAT_NULL_YIELDS_NULL OFF                                                            
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET NUMERIC_ROUNDABORT OFF                                                                 
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET QUOTED_IDENTIFIER OFF                                                                  
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET RECURSIVE_TRIGGERS OFF                                                                 
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET CURSOR_CLOSE_ON_COMMIT OFF                                                             
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET TRUSTWORTHY OFF                                                                        
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET DB_CHAINING OFF                                                                        
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET DATE_CORRELATION_OPTIMIZATION OFF                                                      
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET HONOR_BROKER_PRIORITY OFF                                                              
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF                                             
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET MIXED_PAGE_ALLOCATION OFF                                                              
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET MULTI_USER                                                                             
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET  READ_WRITE                                                                            
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET  DISABLE_BROKER                                                                        
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET CHECKSUM                                                                               
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET TARGET_RECOVERY_TIME = 0 SECONDS                                                       
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET COMPATIBILITY_LEVEL = 130                                                              
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET RECOVERY SIMPLE                                                                        
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET DELAYED_DURABILITY  = DISABLED                                                         
GO                                                                                                                     
ALTER DATABASE [DBA_t01_00] SET ALLOW_SNAPSHOT_ISOLATION OFF                                                           
GO                                                                                                                     


