-- Table: Clients
CREATE TABLE Clients (
    ClientID int identity(1,1) NOT NULL,
    Name varchar(40) NOT NULL,
    Phone varchar(20) NOT NULL,
    Email varchar(40) NOT NULL,
    IsCompany bit NOT NULL,
    CONSTRAINT Clients_pk PRIMARY KEY (ClientID)
);


-- Table: Conferences
CREATE TABLE Conferences (
    ConferenceID int identity(1,1) NOT NULL,
    ConferenceName nvarchar(40) NOT NULL,
    StartDate datetime NOT NULL,
    EndDate datetime NOT NULL,
    StudentDiscount real NOT NULL,
    CONSTRAINT Conferences_pk PRIMARY KEY (ConferenceID)
);

ALTER TABLE Conferences
WITH CHECK ADD CONSTRAINT StudentDiscountBetweenZeroAndOne
    CHECK (StudentDiscount >= 0 AND StudentDiscount <= 1)


-- Table: ConferenceDays
CREATE TABLE ConferenceDays (
    ConferenceDayID int identity(1,1) NOT NULL,
    ConferenceID int NOT NULL,
    Date datetime NOT NULL,
    ParticipantsLimit int NOT NULL,
    Location nvarchar(60) NOT NULL,
    IsCancelled bit NOT NULL DEFAULT 0,
    CONSTRAINT ConferenceDays_pk PRIMARY KEY (ConferenceDayID)
);

ALTER TABLE ConferenceDays
WITH CHECK ADD CONSTRAINT ParticipantsLimitGreaterThanZero
    CHECK (ParticipantsLimit > 0)

ALTER TABLE ConferenceDays ADD CONSTRAINT ConferenceDay_Conference_fk
    FOREIGN KEY (ConferenceID)
    REFERENCES Conferences (ConferenceID);


-- Table: Reservations
CREATE TABLE Reservations (
    ReservationID int identity(1,1)  NOT NULL,
    ReservationDate datetime NOT NULL,
    ClientID int NOT NULL,
    IsCancelled bit NOT NULL DEFAULT 0,
    CONSTRAINT Reservations_pk PRIMARY KEY (ReservationID)
);

ALTER TABLE Reservations ADD CONSTRAINT Reservation_Client_fk
    FOREIGN KEY (ClientID)
    REFERENCES Clients (ClientID);


-- Table: DayReservations
CREATE TABLE DayReservations (
    DayReservationID int identity(1,1) NOT NULL,
    ReservationID int NOT NULL,
    ConferenceDayID int NOT NULL,
    StudentsNumber int NOT NULL,
    ParticipantsNumber int NOT NULL,
    IsCancelled bit NOT NULL DEFAULT 0,
    CONSTRAINT DayReservations_pk PRIMARY KEY (DayReservationID)
);

ALTER TABLE DayReservations
WITH CHECK ADD CONSTRAINT StudentsNumberGreaterEqualsZero
    CHECK (StudentsNumber >= 0)

ALTER TABLE DayReservations
WITH CHECK ADD CONSTRAINT ParticipantsNumberGreaterThanZero
    CHECK (ParticipantsNumber > 0)

ALTER TABLE DayReservations ADD CONSTRAINT DayReservation_Reservation_fk
    FOREIGN KEY (ReservationID)
    REFERENCES Reservations (ReservationID);

ALTER TABLE DayReservations ADD CONSTRAINT DayReservation_ConferenceDay_fk
    FOREIGN KEY (ConferenceDayID)
    REFERENCES ConferenceDays (ConferenceDayID);


-- Table: Workshops
CREATE TABLE Workshops (
    WorkshopID int identity(1,1) NOT NULL,
    ConferenceDayID int NOT NULL,
    Title nvarchar(40) NOT NULL,
    ParticipantsLimit int NOT NULL,
    StartTime time NOT NULL,
    EndTime time NOT NULL,
    Location nvarchar(60) NOT NULL,
    Price money NOT NULL,
    CONSTRAINT Workshops_pk PRIMARY KEY (WorkshopID)
);

ALTER TABLE Workshops WITH CHECK ADD CONSTRAINT Workshop_WorkshopConferenceDay_fk
FOREIGN KEY(ConferenceDayID) REFERENCES ConferenceDays (ConferenceDayID)

ALTER TABLE Workshops WITH CHECK ADD CONSTRAINT
    WorkshopsPriceGreaterEqualsZero
    CHECK ((Price >= (0)));

ALTER TABLE Workshops WITH CHECK ADD CONSTRAINT
    WorkshopsParticipantsLimitGreaterEqualsZero
    CHECK ((ParticipantsLimit >= (0)));

ALTER TABLE Workshops WITH CHECK ADD CONSTRAINT
    WorkshopsStartTimeLesserEqualsEndTime
    CHECK ((StartTime <= EndTime));


-- Table: WorkshopReservations
CREATE TABLE WorkshopReservations (
    WorkshopReservationID int identity(1,1) NOT NULL,
    WorkshopID int NOT NULL,
    DayReservationID int NOT NULL,
    ParticipantsNumber int NOT NULL,
    IsCancelled bit NOT NULL DEFAULT 0,
    CONSTRAINT WorkshopReservations_pk PRIMARY KEY (WorkshopReservationID)
);

ALTER TABLE WorkshopReservations ADD CONSTRAINT
    WorkshopReservation_DayReservation_fk FOREIGN KEY(DayReservationID)
    REFERENCES DayReservations (DayReservationID)

ALTER TABLE WorkshopReservations ADD CONSTRAINT
    WorkshopReservation_Workshop_fk FOREIGN KEY(WorkshopID)
    REFERENCES Workshops (WorkshopID)

ALTER TABLE WorkshopReservations WITH CHECK ADD CONSTRAINT
    WorkshopReservationsParticipantsNumberGreaterThanZero
    CHECK ((ParticipantsNumber > (0)));


-- Table: DayRegistrations
CREATE TABLE DayRegistrations (
    DayRegistrationID int identity(1,1) NOT NULL,
    DayReservationID int NOT NULL,
    ParticipantID int NOT NULL,
    IsStudent bit NOT NULL,
    CONSTRAINT DayRegistrations_pk PRIMARY KEY (DayRegistrationID)
);

ALTER TABLE DayRegistrations ADD CONSTRAINT
    DayRegistration_Participant_fk FOREIGN KEY (ParticipantID)
    REFERENCES Participants (ParticipantID);

ALTER TABLE DayRegistrations ADD CONSTRAINT
    DayRegistration_DayReservation_fk FOREIGN KEY (DayReservationID)
    REFERENCES DayReservations (DayReservationID);


-- Table: WorkshopRegistrations
CREATE TABLE WorkshopRegistrations (
    WorkshopRegistrationID int identity(1,1) NOT NULL,
    DayRegistrationID int NOT NULL,
    WorkshopReservationID int NOT NULL,
    CONSTRAINT WorkshopRegistrations_pk PRIMARY KEY (WorkshopRegistrationID)
);

ALTER TABLE WorkshopRegistrations ADD CONSTRAINT
    WorkshopRegistration_DayRegistration_fk FOREIGN KEY(DayRegistrationID)
    REFERENCES DayRegistrations (DayRegistrationID)

ALTER TABLE WorkshopRegistrations ADD CONSTRAINT
    WorkshopRegistration_WorkshopReservation_fk FOREIGN KEY(WorkshopReservationID)
    REFERENCES WorkshopReservations (WorkshopReservationID)


-- Table: Participants
CREATE TABLE Participants (
    ParticipantID int identity(1,1) NOT NULL,
    Firstname nvarchar(40) NOT NULL,
    Lastname nvarchar(40) NOT NULL,
    Address nvarchar(40) NOT NULL,
    City nvarchar(20) NOT NULL,
    PostalCode nvarchar(10) NOT NULL,
    Country nvarchar(20) NOT NULL,
    Phone nvarchar(20) NOT NULL,
    CONSTRAINT Participants_pk PRIMARY KEY (ParticipantID)
);


-- Table: Payments
CREATE TABLE Payments (
    PaymentID int identity(1,1) NOT NULL,
    ReservationID int NOT NULL,
    Amount money NOT NULL,
    PaymentDate datetime NOT NULL,
    CONSTRAINT Payments_pk PRIMARY KEY (PaymentID)
);

ALTER TABLE Payments ADD CONSTRAINT
    Payment_Reservation_fk FOREIGN KEY(ReservationID)
    REFERENCES Reservations (ReservationID)

ALTER TABLE Payments WITH CHECK ADD CONSTRAINT
    PaymentAmountNotZero
    CHECK ((Amount <> (0)));


-- Table: Prices
CREATE TABLE Prices (
    PriceID int identity(1,1) NOT NULL,
    ConferenceDayID int NOT NULL,
    Price money NOT NULL,
    UntilDate datetime NOT NULL,
    CONSTRAINT Prices_pk PRIMARY KEY (PriceID)
);

ALTER TABLE Prices ADD CONSTRAINT
    Price_ConferenceDay_fk FOREIGN KEY(ConferenceDayID)
    REFERENCES ConferenceDays (ConferenceDayID)

ALTER TABLE Prices WITH CHECK ADD CONSTRAINT
    PricesPriceGreaterEqualsZero
    CHECK ((Price >= (0)));
