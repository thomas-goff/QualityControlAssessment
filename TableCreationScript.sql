IF DB_ID('QualityControlAssessment') IS NULL
    CREATE DATABASE QualityControlAssessment;
GO
 
USE QualityControlAssessment;
GO

--User Table 
CREATE TABLE dbo.Users
(
    UserId        INT            IDENTITY(1,1) NOT NULL,
    UserName      NVARCHAR(50)   NOT NULL,
    Email         NVARCHAR(256)  NOT NULL,
    PasswordHash  VARBINARY(32)  NOT NULL,
    PasswordSalt  VARBINARY(16)  NOT NULL,  
 
    CONSTRAINT PK_Users           PRIMARY KEY CLUSTERED (UserId),
    CONSTRAINT UQ_Users_Email     UNIQUE (Email)
);
GO

-- Production Lines Table
CREATE TABLE dbo.ProductionLines
(
    ProductionLineId    INT            IDENTITY(1,1) NOT NULL,
    ProductionLineName  NVARCHAR(100)  NOT NULL,
 
    CONSTRAINT PK_ProductionLines            PRIMARY KEY CLUSTERED (ProductionLineId),
    CONSTRAINT UQ_ProductionLines_Name       UNIQUE (ProductionLineName)
);
GO

-- Quality Measurement table
CREATE TABLE dbo.QualityMeasurements
(
    QualityMeasurementId  INT           IDENTITY(1,1) NOT NULL,
    ProductionLineId      INT           NOT NULL,
    UserId                INT           NOT NULL,
    Temperature           DECIMAL(9,3)  NOT NULL,
    Humidity              DECIMAL(9,3)  NOT NULL,
    Weight                DECIMAL(9,3)  NOT NULL,
    Width                 DECIMAL(9,3)  NOT NULL,
    Length                DECIMAL(9,3)  NOT NULL,
    Depth                 DECIMAL(9,3)  NOT NULL,
    CapturedAtUtc         DATETIME2(3)  NOT NULL
        CONSTRAINT DF_QualityMeasurements_CapturedAtUtc DEFAULT SYSUTCDATETIME(),
    Passed                BIT           NOT NULL,
 
    CONSTRAINT PK_QualityMeasurements PRIMARY KEY CLUSTERED (QualityMeasurementId),
 
    CONSTRAINT FK_QualityMeasurements_ProductionLines
        FOREIGN KEY (ProductionLineId) REFERENCES dbo.ProductionLines (ProductionLineId),
 
    CONSTRAINT FK_QualityMeasurements_Users
        FOREIGN KEY (UserId) REFERENCES dbo.Users (UserId),
 
    CONSTRAINT CK_QualityMeasurements_Humidity CHECK (Humidity >= 0 AND Humidity <= 100),
    CONSTRAINT CK_QualityMeasurements_Weight   CHECK (Weight > 0),
    CONSTRAINT CK_QualityMeasurements_Width    CHECK (Width  > 0),
    CONSTRAINT CK_QualityMeasurements_Length   CHECK (Length > 0),
    CONSTRAINT CK_QualityMeasurements_Depth    CHECK (Depth  > 0)
);
GO
 
CREATE NONCLUSTERED INDEX IX_QualityMeasurements_Line_CapturedAtUtc
    ON dbo.QualityMeasurements (ProductionLineId, CapturedAtUtc DESC);
 
CREATE NONCLUSTERED INDEX IX_QualityMeasurements_UserId
    ON dbo.QualityMeasurements (UserId);

CREATE NONCLUSTERED INDEX IX_Users_Email
    ON dbo.Users (Email);
GO
