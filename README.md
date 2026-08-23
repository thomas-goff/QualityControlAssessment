# Quality Control Measurement Capture

Internal tool that replaces the daily Excel capture of shop-floor quality readings. ASP.NET Web Forms (.NET Framework 4.8) with SQL Server, using ADO.NET and stored procedures.

## Running it

Requirements: .NET Framework 4.8, Visual Studio 2022 or later (runs under IIS Express), SQL Server (LocalDB or a full instance), and SSMS for the restore.

1. Restore the database (see below).
2. Point `ConnectionStrings:DefaultConnection` in `Web.config` at your instance.
3. Press F5 in Visual Studio, or run the project under IIS Express.
4. Open `https://localhost:44309` and sign in with any account below.

## What it does

- Sign-in uses Forms authentication with PBKDF2 hashed passwords.
- You capture a measurement through a modal: production line, temperature, humidity, weight, width, length, depth, and a pass or fail result.
- Every capture stores a UTC timestamp and the user who captured it.
- All records show in a GridView. Everyone can see every record.
- You can edit and delete only your own records.
- The statistics (lowest, highest, sum, mean, variance, standard deviation) sit at the top of the page. They recalculate after every insert, update, and delete.

## Seeded users

All five seeded users share the same demo password: `123`.

| ID | Name | Email |
|----|------|-------|
| 1 | Thomas Goff | tgoff@inambu.co.za |
| 2 | Mark Freedman | mfreedman@inambu.co.za |
| 3 | Pieter Venter | pventer@inambu.co.za |
| 4 | Thato Dlamini | tdlamini@inambu.co.za |
| 5 | Kelly Patterson | kpatterson@inambu.co.za |

Three production lines are also seeded: Production Line 1, Production Line 2, and Production Line 3.

## Project structure

```
Default.aspx / .cs        Home page: record grid, statistics, edit and delete wiring
CaptureModal.ascx / .cs   Reusable add and edit modal, raises MeasurementSaved
Login.aspx / .cs          Sign in
PasswordHasher.cs         PBKDF2 hashing and verification
Web.config                Connection string, Forms auth, culture
Database/                 The .bak backup and the SQL scripts
```

Who can change a record is enforced in the stored procedures, not the page. The page only decides which buttons to show.

## Restoring the database

The `.bak` is the full, working restore. It contains the tables, the stored procedures, and the seed data.

1. Open SSMS and connect to your local SQL Server instance.
2. Right-click Databases, then Restore Database.
3. Choose Device, click the browse button, click Add, and select `Database/QualityControlAssessment.bak`.
4. Click OK, then OK again to restore.
5. Open `Web.config` and set `ConnectionStrings:DefaultConnection` to point at your instance and the restored database.
6. Run the project and sign in with any of the test accounts above.

## Building it from scratch instead

If you would rather create the database by hand, run the two scripts in `Database/` in order:

1. `TableCreationScript.sql` creates the database, the three tables, their constraints, and the indexes.
2. `DataSeedScript.sql` inserts the five users and the three production lines.

Important: the scripts do not create the stored procedures. The application calls seven procedures (`GetAllMeasurements`, `GetCalculatedMeasurements`, `GetAllProductionLines`, `InsertMeasurement`, `UpdateMeasurement`, `DeleteMeasurement`, and `GetUsersByEmail`), and none of them are in these scripts. A scripts-only database will not run the app. Use the `.bak` for a working setup, or script the procedures separately.

Both scripts are one-shot. They do not drop or clear anything, so run them against a fresh database only.

<img width="1913" height="981" alt="image" src="https://github.com/user-attachments/assets/25da2288-8173-4af5-9b65-976714ff1f4d" />
<img width="1889" height="978" alt="image" src="https://github.com/user-attachments/assets/fa451e97-c350-4a09-a214-71599175d8a1" />
<img width="1909" height="982" alt="image" src="https://github.com/user-attachments/assets/b0e51899-3371-4b0f-af36-19c73101bb82" />
<img width="1910" height="979" alt="image" src="https://github.com/user-attachments/assets/9d771fac-5865-4045-8d13-b1a8c09e8228" />



