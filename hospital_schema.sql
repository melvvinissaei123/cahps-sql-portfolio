
CREATE TABLE Employee_T
(EmployeeID			VARCHAR(10) NOT NULL,
EmployeeFirstName	VARCHAR (25) ,
EmployeeLastName	VARCHAR (25) ,
EmployeeAddress		VARCHAR (30) , 
EmployeeCity 		VARCHAR (20) , 
EmployeeState		CHAR(2) , 
EmployeeZipCode		VARCHAR (5) ,
EmployeeRole		CHAR (1)	NOT NULL,
EmployeePhoneNumber VARCHAR(20),
CONSTRAINT Employee_PK PRIMARY KEY (EmployeeID));

CREATE TABLE Nurse_T
(EmployeeID		VARCHAR(10)	NOT NULL,
Certification	VARCHAR(3) NOT NULL,
CONSTRAINT Nurse_PK PRIMARY KEY (EmployeeID),
CONSTRAINT Nurse_FK1 FOREIGN KEY (EmployeeID) REFERENCES Employee_T(EmployeeID));

CREATE TABLE Doctor_T
(EmployeeID			VARCHAR (10) NOT NULL,
Specialty 			VARCHAR (40),
CONSTRAINT Doctor_PK PRIMARY KEY (EmployeeID),
CONSTRAINT Doctor_FK1 FOREIGN KEY (EmployeeID) REFERENCES Employee_T(EmployeeID));

CREATE TABLE Receptionist_T
(EmployeeID		VARCHAR(10)	NOT NULL,
DoctorID 		VARCHAR(10)	NOT NULL,
Bilingual		VARCHAR(20),
CONSTRAINT Receptionist_PK PRIMARY KEY (EmployeeID),
CONSTRAINT Receptionist_FK1 FOREIGN KEY (EmployeeID) REFERENCES Employee_T(EmployeeID),
CONSTRAINT Receptionist_FK2 FOREIGN KEY (DoctorID) REFERENCES Doctor_T(EmployeeID));

CREATE TABLE Patient_T
(PatientID			VARCHAR(10) NOT NULL,
PatientFirstName	VARCHAR(25) NOT NULL,
PatientLastName		VARCHAR(25) NOT NULL,
PatientAddress		VARCHAR(30) NOT NULL,
PatientCity 		VARCHAR(20) NOT NULL,
PatientState		CHAR(2) 	 NOT NULL,
PatientZipCode		VARCHAR(10) NOT NULL,
DoB					DATE		NOT NULL,
CONSTRAINT Patient_PK PRIMARY KEY (PatientID));


CREATE TABLE Treatment_T
(TreatmentID	INT		     NOT NULL AUTO_INCREMENT,
PatientID		VARCHAR(10)	 NOT NULL,
DoctorID		VARCHAR (10) NOT NULL,
NurseID			VARCHAR (10) NOT NULL,
TreatmentDate	DATE		 NOT NULL,
TreatmentDescription VARCHAR (30) NOT NULL,
CONSTRAINT Treatment_PK PRIMARY KEY (TreatmentID),
CONSTRAINT Treatment_FK1 FOREIGN KEY (PatientID) REFERENCES Patient_T(PatientID),
CONSTRAINT Treatment_FK2 FOREIGN KEY (DoctorID) REFERENCES Doctor_T(EmployeeID),
CONSTRAINT Treatment_FK3 FOREIGN KEY (NurseID) REFERENCES Nurse_T(EmployeeID));

CREATE TABLE Appointment_T
(AppointmentID VARCHAR(10)	NOT NULL, 
PatientID	VARCHAR (10) NOT NULL,
DoctorID	VARCHAR (10) NOT NULL,
ReceptionistID VARCHAR (10) NOT NULL, 
AppointmentTime	TIMESTAMP	NOT NULL,
VisitReason 	VARCHAR (50) NOT NULL, 
CONSTRAINT Appointment_PK PRIMARY KEY (AppointmentID),
CONSTRAINT Appointment_FK1 FOREIGN KEY (PatientID) REFERENCES Patient_T(PatientID),
CONSTRAINT Appointment_FK2 FOREIGN KEY (DoctorID) REFERENCES Doctor_T(EmployeeID),
CONSTRAINT Appointment_FK3 FOREIGN KEY (ReceptionistID) REFERENCES Receptionist_T(EmployeeID));

INSERT INTO Employee_T(EmployeeID, EmployeeFirstName, EmployeeLastName, EmployeeAddress	, EmployeeCity , EmployeeState, EmployeeZipCode, EmployeeRole,EmployeePhoneNumber)
VALUES
('2378126456', 'Esha', 'Dickinson', '435 Jackson St', 'Montrose', 'CA', '84932', 'D','(818)-234-2123'),
('7892445736', 'Vache', 'Sarkissian','859 Country Club Road', 'Montrose', 'CA', '83913', 'D','(494)338-1719'),
('2893495739', 'Tanvir', 'Davenport', '094 King Street', 'Alhambra', 'CA', '74849', 'D','(782)363-6632'),
('8384394039', 'Federico' ,'Cisneros' , '234 Crescent Street', 'Los Angeles', 'CA', '94058', 'N','(531) 918-8041'),
('8534450305', 'Areeba', 'Hagan', '983 Atlantic Avenue', 'Montrose', 'CA', '85047', 'N','(243)763-4005'),
('3435348503', 'Charmaine' ,'Drummond','542 White Street', 'Montrose', 'CA','50932', 'N','(278)238-1388'),
('7593856473', 'Teegan', 'Barron','562 Laurel Lane','Montrose', 'CA', '85034','N','(765)306-3090'),
('8593759385','Beatrix', 'Alcock', '624 Warren Avenue' ,'Montrose', 'CA', '58593', 'R','(580)902-4806'),
('8594857459','Sneha', 'Crossley', '038 River Street', 'Montrose','CA', '85945', 'R','(433)623-1459'),
('7494748475','Bernard', 'Blackmore', '894 Atlantic Avenue', 'Montrose','CA', '85946', 'R','(823)-323-2344'),
('8594759585','Huey', 'Barnett', '592 Crescent Street','Montrose','CA', '37484', 'R','(838)-378-4747');

INSERT INTO Patient_T (PatientID, PatientFirstName, PatientLastName ,PatientAddress, PatientCity, PatientState, PatientZipCode,DoB)
VALUES
('9494923929', 'Avi', 'Camacho', '948 Pleasant Street', 'Montrose', 'CA', '99394','1990-04-10'),
('0283945754', 'Sia', 'Leblanc', '959 Rose Street', 'Los Angeles', 'CA', '84923','1991-05-08'),
('2345976435', 'Jaspal', 'Hahn', '859 Linden Avenue', 'Alhanbra', 'CA', '75858','1990-04-10'),
('2039847554', 'Johnnie', 'Gross', '475 Maiden Lane', 'Pasadena', 'CA', '84584','1989-08-08');

INSERT INTO Doctor_T (EmployeeID, Specialty) VALUES 
 ((SELECT EmployeeID FROM Employee_T WHERE EmployeeID = '2378126456'), 'Surgeon'),
 ((SELECT EmployeeID FROM Employee_T WHERE EmployeeID = '7892445736'), 'Anesthesiologist'), 
 ((SELECT EmployeeID FROM Employee_T WHERE EmployeeID = '2893495739'), 'Otolaryngologist');
 
 INSERT INTO Nurse_T (EmployeeID, Certification) VALUES 
 ((SELECT EmployeeID FROM Employee_T WHERE EmployeeID = '8384394039'), 'Yes'),
 ((SELECT EmployeeID FROM Employee_T WHERE EmployeeID = '8534450305'), 'Yes'), 
 ((SELECT EmployeeID FROM Employee_T WHERE EmployeeID = '3435348503'), 'No'),
 ((SELECT EmployeeID FROM Employee_T WHERE EmployeeID = '7593856473'), 'Yes');
 
 INSERT INTO Receptionist_T (EmployeeID, DoctorID, Bilingual) VALUES 
 ((SELECT EmployeeID FROM Employee_T WHERE EmployeeID = '8593759385'), 
 (SELECT EmployeeID FROM Doctor_T WHERE EmployeeID = '2893495739'), 'Spanish'), 
 ((SELECT EmployeeID FROM Employee_T WHERE EmployeeID = '8594857459'), 
 (SELECT EmployeeID FROM Doctor_T WHERE EmployeeID = '7892445736'), 'Chinese'),
 ((SELECT EmployeeID FROM Employee_T WHERE EmployeeID = '7494748475'), 
 (SELECT EmployeeID FROM Doctor_T WHERE EmployeeID = '2893495739'), 'French'),
 ((SELECT EmployeeID FROM Employee_T WHERE EmployeeID = '8594759585'), 
 (SELECT EmployeeID FROM Doctor_T WHERE EmployeeID = '2378126456'), 'Spanish');

INSERT INTO Appointment_T (PatientID, DoctorID, ReceptionistID, AppointmentTime, VisitReason, AppointmentID) VALUES
((SELECT PatientID FROM Patient_T WHERE PatientID = '9494923929'),
 (SELECT EmployeeID FROM Doctor_T WHERE EmployeeID = '2378126456'),
 (SELECT EmployeeID FROM Receptionist_T WHERE EmployeeID = '8593759385'), '2020-03-22 04:30:04', 'Migrains', 1234177712),
((SELECT PatientID FROM Patient_T WHERE PatientID = '0283945754'),
 (SELECT EmployeeID FROM Doctor_T WHERE EmployeeID = '7892445736'),
 (SELECT EmployeeID FROM Receptionist_T WHERE EmployeeID = '8594857459'), '2020-01-12 05:23:02', 'Anxeity', 7485937583),
((SELECT PatientID FROM Patient_T WHERE PatientID = '2345976435'),
 (SELECT EmployeeID FROM Doctor_T WHERE EmployeeID = '2893495739'),
 (SELECT EmployeeID FROM Receptionist_T WHERE EmployeeID = '7494748475'), '2020-03-03 02:32:08', 'Cholesterol', 7584950385),
((SELECT PatientID FROM Patient_T WHERE PatientID = '2039847554'),
 (SELECT EmployeeID FROM Doctor_T WHERE EmployeeID = '7892445736'),
 (SELECT EmployeeID FROM Receptionist_T WHERE EmployeeID = '8594759585'), '2020-05-02 12:13:14', 'Cysts', 8574893858),
((SELECT PatientID FROM Patient_T WHERE PatientID = '0283945754'),
 (SELECT EmployeeID FROM Doctor_T WHERE EmployeeID = '2893495739'),
 (SELECT EmployeeID FROM Receptionist_T WHERE EmployeeID = '8593759385'), '2020-01-21 04:32:11', 'Acne', 7474839384),
((SELECT PatientID FROM Patient_T WHERE PatientID = '2345976435'),
 (SELECT EmployeeID FROM Doctor_T WHERE EmployeeID = '2378126456'),
 (SELECT EmployeeID FROM Receptionist_T WHERE EmployeeID = '7494748475'), '2020-02-23 09:45:00', 'Back problems',7894637485);
 
INSERT INTO Treatment_T (PatientID, DoctorID, NurseID, TreatmentDate, TreatmentDescription) VALUES
((SELECT PatientID FROM Patient_T WHERE PatientID = '9494923929'),
 (SELECT EmployeeID FROM Doctor_T WHERE EmployeeID = '2378126456'),
 (SELECT EmployeeID FROM Nurse_T WHERE EmployeeID =  '8534450305'), '2019-12-12', 'Flu Vaccination'),
((SELECT PatientID FROM Patient_T WHERE PatientID = '2345976435'),
 (SELECT EmployeeID FROM Doctor_T WHERE EmployeeID = '2893495739'),
 (SELECT EmployeeID FROM Nurse_T WHERE EmployeeID =  '3435348503'), '2019-01-03', 'Hip Replacemtn'),
 ((SELECT PatientID FROM Patient_T WHERE PatientID = '2345976435'),
 (SELECT EmployeeID FROM Doctor_T WHERE EmployeeID = '2378126456'),
 (SELECT EmployeeID FROM Nurse_T WHERE EmployeeID =  '7593856473'), '2020-02-02', 'Heart valve');

