
USE [master]                                                                                                           
GO                                                                                                                     
CREATE DATABASE [ais_replica]                                                                                          
CONTAINMENT = NONE                                                                                                     
ON  PRIMARY                                                                                                            
( NAME = N'ais_replica', FILENAME = N'D:\data\ais_replica_FG00PR.mdf', SIZE = 12582912KB , MAXSIZE = UNLIMITED,        
FILEGROWTH = 131072KB ),                                                                                               
FILEGROUP [FG01DT] DEFAULT                                                                                             
( NAME = N'ais_replica_FG01DT', FILENAME = N'D:\data\ais_replica_FG01DT.ndf', SIZE = 25165824KB , MAXSIZE = UNLIMITED, 
FILEGROWTH = 262144KB )                                                                                                
LOG ON                                                                                                                 
( NAME = N'ais_replica_log', FILENAME = N'G:\logs\ais_replica_log.ldf', SIZE = 5242880KB , MAXSIZE = 2097152MB,        
FILEGROWTH = 131072KB )                                                                                                
GO                                                                                                                     
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))                                                                
BEGIN                                                                                                                  
EXEC [ais_replica].[dbo].[sp_fulltext_database] @action = 'enable'                                                     
END                                                                                                                    
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET AUTO_CLOSE OFF                                                                        
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET AUTO_SHRINK OFF                                                                       
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET READ_COMMITTED_SNAPSHOT ON                                                            
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET AUTO_CREATE_STATISTICS ON                                                             
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET AUTO_UPDATE_STATISTICS ON                                                             
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET AUTO_UPDATE_STATISTICS_ASYNC OFF                                                      
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET ANSI_NULL_DEFAULT OFF                                                                 
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET ANSI_NULLS OFF                                                                        
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET ANSI_PADDING OFF                                                                      
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET ANSI_WARNINGS OFF                                                                     
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET ARITHABORT OFF                                                                        
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET CONCAT_NULL_YIELDS_NULL OFF                                                           
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET NUMERIC_ROUNDABORT OFF                                                                
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET QUOTED_IDENTIFIER OFF                                                                 
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET RECURSIVE_TRIGGERS OFF                                                                
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET CURSOR_CLOSE_ON_COMMIT OFF                                                            
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET TRUSTWORTHY OFF                                                                       
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET DB_CHAINING OFF                                                                       
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET DATE_CORRELATION_OPTIMIZATION OFF                                                     
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET HONOR_BROKER_PRIORITY OFF                                                             
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET MEMORY_OPTIMIZED_ELEVATE_TO_SNAPSHOT = OFF                                            
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET MIXED_PAGE_ALLOCATION OFF                                                             
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET MULTI_USER                                                                            
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET  READ_WRITE                                                                           
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET  DISABLE_BROKER                                                                       
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET CHECKSUM                                                                              
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET TARGET_RECOVERY_TIME = 0 SECONDS                                                      
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET COMPATIBILITY_LEVEL = 130                                                             
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET RECOVERY SIMPLE                                                                       
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET DELAYED_DURABILITY  = DISABLED                                                        
GO                                                                                                                     
ALTER DATABASE [ais_replica] SET ALLOW_SNAPSHOT_ISOLATION OFF                                                          
GO                                                                                                                     


--testing

