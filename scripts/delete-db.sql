
IF OBJECT_ID(N'dbo.Zones', N'U') IS NOT NULL
BEGIN
    DROP TABLE Zones
END

IF OBJECT_ID(N'dbo.ForHire', N'U') IS NOT NULL
BEGIN
    DROP TABLE ForHire
END

IF OBJECT_ID(N'dbo.YellowCab', N'U') IS NOT NULL
BEGIN
    DROP TABLE YellowCab
END

IF OBJECT_ID(N'dbo.GreenCab', N'U') IS NOT NULL
BEGIN
    DROP TABLE GreenCab
END
