-- Procedura addConference
-- dodawanie konferencji
CREATE PROCEDURE PROCEDURE_addConference
    @ConferenceName nvarchar(40), @StartDate datetime,
    @EndDate datetime, @StudentDiscount real AS
BEGIN
    SET NOCOUNT ON;

    IF(@StartDate > @EndDate) BEGIN
        THROW 51000, 'EndDate should not be earlier than StartDate.', 1
    END

    IF(@StudentDiscount < 0 OR @StudentDiscount > 1) BEGIN
        THROW 51000, 'The discount must be between 0 and  1.', 1
    END

    INSERT INTO Conferences(ConferenceName, StartDate, EndDate, studentDiscount)
    VALUES(@ConferenceName, @StartDate, @EndDate, @StudentDiscount)

END


-- procedura addWorkshopRegistration
-- dodawanie rejestracji na warsztat
CREATE PROCEDURE PROCEDURE_addWorkshopRegistration
@dayRegistrationID int, @workshopReservationID int
AS
BEGIN
SET NOCOUNT ON;
    DECLARE @dayRegistration int = (
        SELECT DayRegistrationID
        FROM DayRegistrations
        WHERE DayRegistrationID = @dayRegistrationID
    )
    IF (@dayRegistration IS NULL) BEGIN
        THROW 51000, 'There is no such DayRegistration.', 1
    END

    DECLARE @workshopReservation int = (
        SELECT WorkshopReservationID
        FROM WorkshopReservations
        WHERE WorkshopReservationID = @workshopReservationID
    )
    IF (@workshopReservation IS NULL) BEGIN
        THROW 51000, 'There is no such WorkshopReservation.', 1
    END

    INSERT INTO WorkshopRegistrations(DayRegistrationID, WorkshopReservationID)
    VALUES (@dayRegistrationID, @workshopReservationID)
END


-- Procedura addConferenceDay
-- dodawanie dnia konferencji
CREATE PROCEDURE PROCEDURE_addConferenceDay
    @ConferenceID int, @Date datetime,
    @ParticipantsLimit int, @Location nvarchar(60) AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Conference int = (
        SELECT ConferenceID FROM Conferences
        WHERE ConferenceID = @ConferenceID
    )
    IF(@Conference IS NULL) BEGIN
        THROW 51000, 'Conference does not exist.', 1
    END

    DECLARE @SecondDay int = (
        SELECT ConferenceID FROM ConferenceDays
        WHERE ConferenceID = @ConferenceID AND Date = @Date
    )
    IF(@SecondDay IS NOT NULL) BEGIN
        THROW 51000, 'This day of conference already exists.', 1
    END

    IF((@Date < (SELECT StartDate
                FROM Conferences
                WHERE ConferenceID = @ConferenceID)) or
       (@Date > (SELECT EndDate
                FROM Conferences
                WHERE ConferenceID = @ConferenceID))) BEGIN
        THROW 51000, 'Invalid ConferenceDay date, selected conference starts earlier or ends later.', 1
    END

    INSERT INTO ConferenceDays(ConferenceID, Date,
            ParticipantsLimit, Location, IsCancelled)
    VALUES(@ConferenceID, @Date, @ParticipantsLimit, @Location, 0)

END


-- Procedura addParticipant
-- dodawanie uczestnika konferencji
CREATE PROCEDURE PROCEDURE_addParticipant
    @Firstname nvarchar(40), @Lastname varchar(40), @Address nvarchar(40),
    @City varchar(20), @PostalCode nvarchar(10), @Country varchar(20), @Phone nvarchar(20)
AS BEGIN
SET NOCOUNT ON;

    INSERT INTO Participants(Firstname, Lastname, Address,
            City, PostalCode, Country, Phone)
    VALUES(@Firstname, @Lastname, @Address,
            @City,@PostalCode, @Country, @Phone)

END


-- Procedura addClient
-- dodawanie klienta
CREATE PROCEDURE PROCEDURE_addClient
    @Name varchar(40), @Phone varchar(20),
    @Email varchar(40), @IsCompany bit AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Clients(Name, Phone, Email, IsCompany)
    VALUES(@Name, @Phone, @Email, @IsCompany)

END


-- Procedura addPayment
-- dodawanie płatności
CREATE PROCEDURE PROCEDURE_addPayment
    @reservationID int, @amount money, @paymentDate datetime
AS
BEGIN
SET NOCOUNT ON;
    IF (@amount = 0) BEGIN
        THROW 51000, 'The amount cannot be equal to 0.00.', 1
    END

    DECLARE @reservations int = (
        SELECT ReservationID
        FROM Reservations
        WHERE ReservationID = @reservationID
    )
    IF(@reservations IS NULL) BEGIN
        THROW 51000, 'There is no such a Reservation.', 1
    END

    INSERT INTO Payments(ReservationID, Amount, PaymentDate)
    VALUES (@reservationID, @amount, @paymentDate)
END


-- Procedura addDayRegistration
-- dodawanie rejestracji na dzień konferencji
CREATE PROCEDURE PROCEDURE_addDayRegistration
    @DayReservationID int, @ParticipantID int, @IsStudent bit AS
BEGIN
SET NOCOUNT ON;

    DECLARE @Participant int = (
        SELECT participantID FROM Participants
        WHERE participantID = @ParticipantID
    )
    IF(@Participant IS NULL) BEGIN
        THROW 51000, 'Selected participant does not exist.', 1
    END

    DECLARE @DayReservation int = (
        SELECT @DayReservationID FROM DayReservations
        WHERE DayReservationID = @DayReservationID
    )
    IF(@DayReservation IS NULL) BEGIN
        THROW 51000, 'There is no such reservation.', 1
    END

    DECLARE @IsCancelled int = (
        SELECT isCancelled FROM DayReservations
        WHERE DayReservationID = @DayReservationID
    )
    IF(@IsCancelled = 1) BEGIN
        THROW 51000, 'This conference reservation was cancelled.', 1
    END

    DECLARE @ReservedPlacesNumber int = (
        SELECT ParticipantsNumber FROM DayReservations
        WHERE @DayReservationID = @DayReservationID
    )
    DECLARE @RegisteredPlacesNumber int = (
        SELECT  COUNT(*)
        FROM DayRegistrations
        WHERE DayReservationID = @DayReservationID
    )
    IF(@ReservedPlacesNumber = @RegisteredPlacesNumber ) BEGIN
        THROW  51000, 'You can not register more participants. All reserved places are already taken.', 1
    END

    DECLARE @ReservedPlacesForStudentsNumber int = (
        SELECT StudentsNumber FROM DayReservations
        WHERE @DayReservationID = @DayReservationID
    )
    DECLARE @RegisteredPlacesForStudentsNumber int = (
        SELECT  COUNT(*)
        FROM DayRegistrations
        WHERE DayReservationID = @DayReservationID and IsStudent = 1
    )
    IF(@ReservedPlacesForStudentsNumber = @RegisteredPlacesForStudentsNumber)
    BEGIN
        THROW  51000, 'You can not register more student participants. All places reserved for students are already taken.', 1
    END

    DECLARE @SecondParticipant int = (
        SELECT @ParticipantID FROM DayRegistrations
        WHERE ParticipantID = @ParticipantID AND DayReservationID = @DayReservationID
        GROUP BY participantID
    )
    IF(@SecondParticipant IS NOT NULL) BEGIN
        THROW  51000, 'This participant has been already registered.', 1
    END

    INSERT INTO DayRegistrations(DayReservationID, ParticipantID, isStudent)
    VALUES(@DayReservationID, @ParticipantID, @IsStudent)

END


-- Procedura addWorkshopReservation
-- dodawanie rezerwacji warsztatu
CREATE PROCEDURE PROCEDURE_addWorkshopReservation
    @workshopID int, @dayReservationID int, @participantsNumber int
AS
BEGIN
SET NOCOUNT ON;

    DECLARE @workshop int = (
        SELECT WorkshopID
        FROM Workshops
        WHERE WorkshopID = @workshopID
    )
    IF (@workshop IS NULL) BEGIN
        THROW 51000, 'There is no such Workshop.', 1
    END

    DECLARE @dayReservation int = (
        SELECT DayReservationID
        FROM DayReservations
        WHERE DayReservationID = @dayReservationID
    )
    IF (@dayReservation IS NULL) BEGIN
        THROW 51000, 'There is no such DayReservation.',1
    END

    IF (@participantsNumber <= 0) BEGIN
        THROW 51000, 'The ParticipantsNumber cannot be lesser than 1.', 1
    END

    INSERT INTO WorkshopReservations(WorkshopID, DayReservationID,
                                     ParticipantsNumber, IsCancelled)
    VALUES (@workshopID, @dayReservationID,@participantsNumber, 0)
END


    -- procedura addReservation
-- dodawanie rezerwacji
CREATE PROCEDURE PROCEDURE_addReservation
    @reservationDate datetime, @clientID int
AS
BEGIN
SET NOCOUNT ON;
    DECLARE @clients int = (
        SELECT ClientID
        FROM Clients
        WHERE ClientID = @clientID
    )
    IF (@clients IS NULL) BEGIN
        THROW 51000, 'There is no such a Client.',1
    END

    INSERT INTO Reservations(ReservationDate, ClientID, IsCancelled)
    VALUES (@reservationDate, @clientID, 0)
END


-- Procedura addPrice
-- dodawanie ceny
CREATE PROCEDURE PROCEDURE_addPrice
    @conferenceDayID int, @price money, @untilDate datetime
AS
BEGIN
    SET NOCOUNT ON;

    IF (@price < 0) BEGIN
        THROW 51000, 'The price cannot be lesser than 0.', 1
    END

    DECLARE @conferenceDays int = (
        SELECT ConferenceDayID
        FROM ConferenceDays
        WHERE ConferenceDayID = @conferenceDayID
    )
    IF (@conferenceDays IS NULL) BEGIN
        THROW 51000, 'There is no such a ConferenceDay.', 1
    END

    DECLARE @beginDate datetime = (
            SELECT DATEADD(day, CD.Date - 1, C.StartDate)
            FROM ConferenceDays AS CD
            JOIN Conferences C ON C.ConferenceID = CD.ConferenceID
    )
    IF (@untilDate >= @beginDate) BEGIN
        THROW 51000, 'The UntilDate is too late.', 1
    END
    IF (@untilDate < GETDATE()) BEGIN
        THROW 51000, 'The UntilDate is too early.', 1
    END

    DECLARE @anotherPrice int = (
        SELECT ConferenceDayID
        FROM Prices
        WHERE ConferenceDayID = @conferenceDayID AND UntilDate = @untilDate
    )
    IF (@anotherPrice IS NOT NULL) BEGIN
       THROW 51000, 'The price already exists.', 1
    END

    INSERT INTO Prices(ConferenceDayID, Price, UntilDate)
    VALUES (@conferenceDayID, @price, @untilDate)
END


-- Procedura addDayReservation
-- dodawanie rezerwacji na dzień konferencji
CREATE PROCEDURE PROCEDURE_addDayReservation
    @ReservationID int, @ConferenceDayID int, @StudentsNumber int,
    @ParticipantsNumber int AS
BEGIN
SET NOCOUNT ON;

    IF(@ParticipantsNumber <= 0) BEGIN
        THROW 51000, 'The number of participants must be greater than 0.', 1
    END
    IF(@StudentsNumber < 0) BEGIN
        THROW 51000, 'The number of students cannot be less than 0.', 1
    END

    DECLARE @ConferenceReservation int = (
        SELECT ReservationID FROM Reservations
        WHERE ReservationID = @ReservationID
    )
    IF(@ConferenceReservation IS NULL) BEGIN
        THROW 51000, 'You cannot reserve conference day, if you did not make reservation for conference.', 1
    END

    DECLARE @ConferenceDayIsCancelled int = (
        SELECT isCancelled FROM ConferenceDays
        WHERE ConferenceDayID = @ConferenceDayID
    )
    IF(@ConferenceDayIsCancelled = 1) BEGIN
        THROW 51000, 'This conference day was cancelled.', 1
    END

    DECLARE @ConferenceReservationIsCancelled int = (
        SELECT isCancelled FROM Reservations
        WHERE ReservationID = @ReservationID
    )
    IF(@ConferenceReservationIsCancelled = 1) BEGIN
        THROW 51000, 'Reservation for this conference was cancelled.', 1
    END

    DECLARE @ConferenceDay int = (
        SELECT @ConferenceDayID
        FROM ConferenceDays
        WHERE ConferenceDayID = @ConferenceDayID
    )
    IF(@ConferenceDay IS NULL) BEGIN
        THROW 51000, 'There is no such conference day.', 1
    END

    DECLARE @FreePlacesNumber int = (
        SELECT dbo.FUNCTION_freePlacesForConferenceDay(@ConferenceDayID)
    )
    IF(@FreePlacesNumber = 0) BEGIN
        THROW 51000, 'All places for this day have been already taken.', 1
    END

    IF(@FreePlacesNumber < @ParticipantsNumber) BEGIN
        DECLARE @errorAlert NVARCHAR(2048)
        SET @errorAlert = 'Not enough places. This day has only '
                    + CAST(@FreePlacesNumber AS varchar)
                    + ' free places.';
        THROW 51000, @errorAlert, 1
    END

    INSERT INTO DayReservations(ReservationID, ConferenceDayID,
                                StudentsNumber, ParticipantsNumber, IsCancelled)
    VALUES (@ReservationID, @ConferenceDayID,
                                @StudentsNumber, @ParticipantsNumber, 0)
END


-- procedura addWorkshop
-- dodawanie warsztatu
CREATE PROCEDURE PROCEDURE_addWorkshop
    @conferenceDayID int, @title nvarchar(40), @participantsLimit int,
    @startTime time, @endTime time, @location nvarchar(60), @price money
AS
BEGIN
SET NOCOUNT ON;

    DECLARE @conferenceDay int = (
        SELECT ConferenceDayID
        FROM ConferenceDays
        WHERE ConferenceDayID = @conferenceDayID
    )
    IF (@conferenceDay IS NULL) BEGIN
        THROW 51000, 'There is no such ConferenceDay.',1
    END

    IF (@participantsLimit < 0) BEGIN
        THROW 51000, 'The ParticipantsLimit cannot be lesser than 0.',1
    END

    IF (@startTime >= @endTime) BEGIN
        THROW 51000, 'The StartTime cannot be after the EndTime.',1
    END

    IF (@price < 0) BEGIN
        THROW 51000, 'The price cannot be lesser than 0.',1
    END

    INSERT INTO Workshops(ConferenceDayID, Title, ParticipantsLimit, StartTime,
                          EndTime, Location, Price)
    VALUES (@conferenceDayID, @title, @participantsLimit, @startTime,
                            @endTime, @location, @price)
END


-- procedura changeParticipantsLimitForConferenceDay
-- służy do zmiany limitu uczestników dnia konferencji
-- Nie pozwala zmniejszyć limitu uczestników poniżej liczby miejsc
-- która została już zarezerwowana
CREATE PROCEDURE PROCEDURE_changeParticipantsLimitForConferenceDay
    @ConferenceDayID int, @NewParticipantsLimit int
AS
BEGIN
SET NOCOUNT ON;

    IF(@NewParticipantsLimit <= 0) BEGIN
        THROW 51000, 'ParticipantsLimit must be greater than zero.', 1
    END

    DECLARE @OldParticipantsLimit int = (
       SELECT ParticipantsLimit
       FROM ConferenceDays
       WHERE ConferenceDayID = @ConferenceDayID
    )
    IF(@OldParticipantsLimit IS NULL) BEGIN
        THROW 51000, 'There is no ConferenceDay with inserted ID', 1
    END

    DECLARE @FreePlacesForConferenceDay int =
        dbo.FUNCTION_freePlacesForConferenceDay(@ConferenceDayID);
    DECLARE @OccupiedPlacesForConferenceDay int =
        @OldParticipantsLimit - @FreePlacesForConferenceDay;

    IF(@NewParticipantsLimit < @OccupiedPlacesForConferenceDay) BEGIN
        DECLARE @errorAlert NVARCHAR(2048)
        SET @errorAlert = 'You cannot add ParticipantsLimit equal'
                         + @NewParticipantsLimit
                         + ', because '
                         + @OccupiedPlacesForConferenceDay
                         + ' places have been already reserved.';
        THROW 51000, @errorAlert, 1
    END
END


-- Procedura changeParticipantsLimitForWorkshop
-- służy do zmiany limitu uczestników na warsztat
-- Nie pozwala zmniejszyć limitu uczestników poniżej liczby miejsc
-- która została już zarezerwowana
CREATE PROCEDURE PROCEDURE_changeParticipantsLimitForWorkshop
    @WorkshopID int, @NewParticipantsLimit int
AS
BEGIN
SET NOCOUNT ON;

    IF(@NewParticipantsLimit <= 0) BEGIN
        THROW 51000, 'ParticipantsLimit must be greater than zero.', 1
    END

    DECLARE @OldParticipantsLimit int = (
       SELECT ParticipantsLimit
       FROM Workshops
       WHERE WorkshopID = @WorkshopID
    )
    IF(@OldParticipantsLimit IS NULL) BEGIN
        THROW 51000, 'There is no Workshop with inserted ID', 1
    END

    DECLARE @FreePlacesForWorkshop int =
        dbo.FUNCTION_freePlacesForWorkshop(@WorkshopID);

    DECLARE @OccupiedPlacesForWorkshop int =
        @OldParticipantsLimit - @FreePlacesForWorkshop;

    IF(@NewParticipantsLimit < @OccupiedPlacesForWorkshop) BEGIN
        DECLARE @errorAlert NVARCHAR(2048)
        SET @errorAlert = 'You cannot add ParticipantsLimit equal'
                         + @NewParticipantsLimit
                         + ', because '
                         + @OccupiedPlacesForWorkshop
                         + ' places have been already reserved.';
        THROW 51000, @errorAlert ,1
    END
END


-- procedura cancelReservation
-- anulowanie rezerwacji
CREATE PROCEDURE cancelReservation
@reservationID int
AS
BEGIN
SET NOCOUNT ON;
    UPDATE Reservations
    SET IsCancelled = '1'
    WHERE ReservationID = @reservationID
END


-- procedura mostActiveClients
-- zwraca klientów uporządkowanych malejąco ze względu na
-- ilość dokonanych rezerwacji
CREATE PROCEDURE mostActiveClients
AS
BEGIN
    SELECT C.ClientID, C.Name, CS.Number
    FROM ClientsStats AS CS
    JOIN Clients AS C
        ON C.ClientID = CS.ClientID
    ORDER BY CS.Number DESC
END


-- procedura mostActiveDayParticipants
-- zwraca uczestników uporządkowanych malejąco ze względu na
-- liczbe dni konferencji w których brali udział
CREATE PROCEDURE PROCEDURE_mostActiveDayParticipants
AS
BEGIN
    SELECT P.ParticipantID, P.Firstname, P.Lastname, PS.Number
    FROM ParticipantsStats AS PS
    JOIN Participants AS P
        ON P.ParticipantID = PS.ParticipantID
    WHERE ActivityType = 'DAYS'
    ORDER BY Number DESC
END


-- procedura mostActiveWorkshopParticipants
-- zwraca uczestników uporządkowanych malejąco ze względu na
-- liczbe warsztatów w których brali udział
CREATE PROCEDURE PROCEDURE_mostActiveWorkshopParticipants
AS
BEGIN
    SELECT P.ParticipantID, P.Firstname, P.Lastname, PS.Number
    FROM ParticipantsStats AS PS
    JOIN Participants AS P
        ON P.ParticipantID = PS.ParticipantID
    WHERE ActivityType = 'WORKSHOPS'
    ORDER BY Number DESC
END
