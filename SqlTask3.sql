CREATE DATABASE TaskSql33;
USE TaskSql33;

CREATE TABLE Doctor
(
  Doctor_ID INT NOT NULL,
  Name VARCHar(50) NOT NULL,
  Email VARCHar(50) NULL,
  years_Of_exp INT  NULL,
  Phone  VARCHar(30)  NULL,
  Speciait  VARCHar(50)  NULL,
  PRIMARY KEY (Doctor_ID)
);

CREATE TABLE Patient
(
  UR_Name  VARCHar(50) NOT NULL,
  Name VARCHar(50) NOT NULL,
  Age INT  NULL,
  Email VARCHar(50) NULL,
  Medicare_name  VARCHar(50)  NULL,
   Phone  VARCHar(30)  NULL,
  Address VARCHar(50) NULL,

  PRIMARY KEY (UR_Name)
);

CREATE TABLE Pharma_Comp
(
  Comp_ID INT NOT NULL,
  Name VARCHar(50) NOT NULL,
  Address VARCHar(50) NULL,
  Phone VARCHar(30)  NULL,
  PRIMARY KEY (Comp_ID)
);

CREATE TABLE Drug
(
  Drug_ID INT NOT NULL,
  Trade_name VARCHar(50) NOT NULL,
  Strength VARCHar(100) NOT NULL,
  Comp_ID INT NULL,
  PRIMARY KEY (Drug_ID),
  FOREIGN KEY (Comp_ID) REFERENCES Pharma_Comp(Comp_ID)
);

CREATE TABLE Prescription_R_Sh
(
  Prescription_ID INT PRIMARY KEY NOT NULL,
  Prescription_Date DATE NULL,
  Quantity DECIMAL(10,2) NULL,
  Doctor_ID INT NULL,
  UR_Name  VARCHar(50) NULL,
  Drug_ID INT NULL,
  FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID),
  FOREIGN KEY (UR_Name) REFERENCES Patient(UR_Name),
  FOREIGN KEY (Drug_ID) REFERENCES Drug(Drug_ID)
);

--===========================================================
--===========================================================

-- 1. SELECT: Retrieve all columns from the Doctor table.
SELECT * FROM Doctor;

-- 2. ORDER BY: List patients in the Patient table in ascending order of their ages.
SELECT * FROM Patient
ORDER BY Age ASC;

-- 3. OFFSET FETCH: Retrieve the first 10 patients from the Patient table, starting from the 5th record.
SELECT * FROM Patient
ORDER BY Age
OFFSET 4 ROWS FETCH NEXT 10 ROWS ONLY;

-- 4. SELECT TOP: Retrieve the top 5 doctors from the Doctor table.
SELECT TOP 5 * FROM Doctor;

-- 5. SELECT DISTINCT: Get a list of unique address from the Patient table.
SELECT DISTINCT Address FROM Patient;

-- 6. WHERE: Retrieve patients from the Patient table who are aged 25.
SELECT * FROM Patient
WHERE Age = 25;

-- 7. NULL: Retrieve patients whose email is not provided.
SELECT * FROM Patient
WHERE Email IS NULL;

-- 8. AND: Retrieve doctors who have >5 years experience AND specialize in 'Cardiology'.
SELECT * FROM Doctor
WHERE years_Of_exp > 5 AND Speciait = 'Cardiology';

-- 9. IN: Retrieve doctors whose speciality is Dermatology or Oncology.
SELECT * FROM Doctor
WHERE Speciait IN ('Dermatology', 'Oncology');

-- 10. BETWEEN: Retrieve patients whose ages are between 18 and 30.
SELECT * FROM Patient
WHERE Age BETWEEN 18 AND 30;

-- 11. LIKE: Retrieve doctors whose names start with 'Dr.'.
SELECT * FROM Doctor
WHERE Name LIKE 'Dr.%';

-- 12. Column & Table Aliases: Select doctor name and email with aliases.
SELECT Name AS DoctorName, Email AS DoctorEmail FROM Doctor;

-- 13. Joins: Retrieve all prescriptions with patient names.
SELECT p.UR_Name AS PatientName, r.Prescription_Date, r.Quantity, d.Trade_name AS DrugName
FROM Prescription_R_Sh r
JOIN Patient p ON r.UR_Name = p.UR_Name
JOIN Drug d ON r.Drug_ID = d.Drug_ID;

-- 14. GROUP BY: Retrieve the count of patients grouped by Address.
SELECT Address, COUNT(*) AS PatientCount
FROM Patient
GROUP BY Address;

-- 15. HAVING: Retrieve addresses with more than 3 patients.
SELECT Address, COUNT(*) AS PatientCount
FROM Patient
GROUP BY Address
HAVING COUNT(*) > 3;

-- 16. GROUPING SETS: Counts grouped by Address and Age.
SELECT Address, Age, COUNT(*) AS PatientCount
FROM Patient
GROUP BY GROUPING SETS ((Address), (Age));

-- 17. CUBE: Counts considering all combinations of Address and Age.
SELECT Address, Age, COUNT(*) AS PatientCount
FROM Patient
GROUP BY CUBE(Address, Age);

-- 18. ROLLUP: Counts rolled up by Address.
SELECT Address, COUNT(*) AS PatientCount
FROM Patient
GROUP BY ROLLUP(Address);

-- 19. EXISTS: Retrieve patients who have at least one prescription.
SELECT * FROM Patient p
WHERE EXISTS (SELECT 1 FROM Prescription_R_Sh r WHERE r.UR_Name = p.UR_Name);

-- 20. UNION: Retrieve a combined list of doctor names and patient names.
SELECT Name FROM Doctor
UNION
SELECT UR_Name FROM Patient;

-- 21. CTE: Retrieve patients along with their doctors.
WITH PatientDoctors AS (
    SELECT p.UR_Name, p.Age, d.Name AS DoctorName
    FROM Patient p
    JOIN Prescription_R_Sh r ON p.UR_Name = r.UR_Name
    JOIN Doctor d ON r.Doctor_ID = d.Doctor_ID
)
SELECT * FROM PatientDoctors;

-- 22. INSERT: Insert a new doctor.
INSERT INTO Doctor (Doctor_ID, Name, years_Of_exp, Phone, Speciait)
VALUES (1, 'Dr. Ahmed', 10, '0100000000', 'Cardiology');

-- 23. INSERT Multiple Rows: Insert multiple patients.
INSERT INTO Patient (UR_Name, Name, Age, Email, Medicare_name, Address)
VALUES 
('Patient1', 'Ali', 25, 'p1@example.com', 'Medicare1', 'Cairo'),
('Patient2', 'Ahmed_Sh', 30, 'p2@example.com', 'Medicare2', 'Alex');

-- 24. UPDATE: Update doctor phone.
UPDATE Doctor
SET Phone = '01210298592'
WHERE Doctor_ID = 1;

-- 25. UPDATE JOIN: Update patient address based on doctor name.
UPDATE p
SET p.Address = 'Minia'
FROM Patient p
JOIN Prescription_R_Sh r ON p.UR_Name = r.UR_Name
JOIN Doctor d ON r.Doctor_ID = d.Doctor_ID
WHERE d.Name = 'Dr. Ahmed';

-- 26. DELETE: Delete a patient.
DELETE FROM Patient
WHERE UR_Name = 'Patient1';

-- 27. Transaction: Insert doctor and patient together.
BEGIN TRANSACTION;

INSERT INTO Doctor (Doctor_ID, Name, years_Of_exp, Phone, Speciait)
VALUES (2, 'Dr. Sara', 8, '0123456789', 'Oncology');

INSERT INTO Patient (UR_Name, Name, Age, Email, Medicare_name, Address)
VALUES ('Patient3', 'Khaled', 28, 'p3@example.com', 'Medicare3', 'Cairo');

COMMIT TRANSACTION;

-- 28. View: Create a view combining patient and doctor information.

CREATE VIEW PatientDoctorView AS
SELECT p.UR_Name, p.Age, d.Name AS DoctorName, d.Speciait
FROM Patient p
JOIN Prescription_R_Sh r ON p.UR_Name = r.UR_Name
JOIN Doctor d ON r.Doctor_ID = d.Doctor_ID;

-- 29. Index: Create index on patient phone.
CREATE INDEX idx_PatientPhone ON Patient(Phone);

-- 30. Backup: Perform a backup of the database.
BACKUP DATABASE TaskSql33
TO DISK = 'C:\Backup\TaskSql33.bak';
