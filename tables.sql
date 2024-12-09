CREATE TABLE FitnessCenters (
    FitnessCenterID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    OpeningHour VARCHAR(50),
	ClosingHour VARCHAR(50)
);


CREATE TABLE Countries (
    CountryID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Population INT,
    AveragePay DECIMAL(10, 2)
);


CREATE TABLE Coaches (
    CoachID INT PRIMARY KEY,
    Name VARCHAR(255),
    Surname VARCHAR(255),
	DateOfBirth DATE,
    Sex VARCHAR(10) CHECK (Sex IN ('Male', 'Female')),
    CountryID INT,
    FitnessCenterID INT,
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID),
    FOREIGN KEY (FitnessCenterID) REFERENCES FitnessCenters(FitnessCenterID)
);


CREATE TABLE Activities (
    ActivityID INT PRIMARY KEY,
    Title VARCHAR(255),
    Type VARCHAR(50) CHECK (Type IN ('strenght training', 'cardio', 'yoga', 'dance', 'injury rehabilitation'))
);
ALTER TABLE Activities
	ADD COLUMN PricePerAppointment DECIMAL(10, 2)

ALTER TABLE Activities
DROP CONSTRAINT activities_type_check;

ALTER TABLE Activities
ADD CONSTRAINT activities_type_check
CHECK (Type IN ('strength training', 'cardio', 'yoga', 'dance', 'injury rehabilitation'));



CREATE TABLE ActivitySchedules (
    ScheduleID INT PRIMARY KEY,
    ActivityID INT,
    FitnessCenterID INT,
    Appointment DATE,
    Occupancy BOOLEAN,
	Capacity INT,
    FOREIGN KEY (ActivityID) REFERENCES Activities(ActivityID),
    FOREIGN KEY (FitnessCenterID) REFERENCES FitnessCenters(FitnessCenterID)
);


CREATE TABLE CoachActivities (
    CoachActivityID INT PRIMARY KEY,
    CoachID INT,
    ScheduleID INT,
    CoachType VARCHAR(20) CHECK (CoachType IN ('head', 'assistant')),
    FOREIGN KEY (CoachID) REFERENCES Coaches(CoachID),
    FOREIGN KEY (ScheduleID) REFERENCES ActivitySchedules(ScheduleID)
);

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    Name VARCHAR(255),
    ScheduleID INT,
    FOREIGN KEY (ScheduleID) REFERENCES ActivitySchedules(ScheduleID)
);
