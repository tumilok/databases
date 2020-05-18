-- trigger conferenceDayParticipantsLimitExceeded
-- sprawdzenie czy ilość miejsc na dany dzień konferencji
-- nie jest mniejsza od rezerwowanej ilości miejsc
CREATE TRIGGER TRIGGER_conferenceDayParticipantsLimitExceeded ON DayReservations
AFTER INSERT, UPDATE
AS BEGIN
    SET NOCOUNT ON

    IF((SELECT COUNT(*) from INSERTED) > 1)
            OR ((SELECT COUNT(*) from DELETED) > 1) BEGIN
        RAISERROR('You cannot insert or update more than one DayReservation at once', 1, 1)
        ROLLBACK TRANSACTION
    END

    DECLARE @placesWantedToReserve int;
    SET @placesWantedToReserve = (SELECT ParticipantsNumber FROM INSERTED);

    DECLARE @freePlaces int;
    SET @freePlaces = dbo.FUNCTION_freePlacesForConferenceDay(
                        (SELECT ConferenceDayID FROM INSERTED)
                      );

    IF(@freePlaces < @placesWantedToReserve) BEGIN
        RAISERROR('You tried to reserve %d places, but only %d are available',
            1, 1, @placesWantedToReserve, @freePlaces)
        ROLLBACK TRANSACTION
    END

END


-- Trigger cancelConferenceReservation
-- przy anulowaniu rezerwacji na konferencję automatycznie
-- anuluje wszystkie przypisane do niej rezerwacje na dni konferencji.
CREATE TRIGGER TRIGGER_cancelConferenceReservation ON Reservations AFTER UPDATE
AS BEGIN
    SET NOCOUNT ON;
    IF((SELECT COUNT(*) from INSERTED) > 1)
            OR ((SELECT COUNT(*) from DELETED) > 1) BEGIN
        RAISERROR('You cannot update more than one Reservation at once', 1, 1)
        ROLLBACK TRANSACTION
    END

    UPDATE DayReservations
    SET isCancelled = 1
    WHERE ReservationID IN(
        SELECT I.ReservationID FROM INSERTED as I, DELETED as D
        WHERE I.isCancelled = 1 AND D.isCancelled = 0
    )
END


-- Trigger workshopParticipantsLimitExceeded
-- sprawdza, czy ilość uczestników podanych w rezerwacji na
-- warsztat nie przekracza ilości miejsc dostępnych na dany warsztat,
-- a także czy nie przekracza ilości miejsc zadeklarowanej w DayReservations.
CREATE TRIGGER TRIGGER_workshopParticipantsLimitExceeded ON WorkshopReservations
AFTER INSERT, UPDATE
AS BEGIN

    IF((SELECT COUNT(*) from INSERTED) > 1)
            OR ((SELECT COUNT(*) from DELETED) > 1) BEGIN
        RAISERROR('You cannot insert or update more than one WorkshopReservation at once', 1, 1)
        ROLLBACK TRANSACTION
    END

    DECLARE @workshopPlacesWantedToReserve int;
    DECLARE @freePlacesForWorkshop int;

    SET @workshopPlacesWantedToReserve = (SELECT ParticipantsNumber
                                          FROM INSERTED);
    SET @freePlacesForWorkshop = dbo.FUNCTION_freePlacesForWorkshop(
                                    (SELECT WorkshopID FROM INSERTED)
                                 )
                                    + @workshopPlacesWantedToReserve;

    IF(@freePlacesForWorkshop < @workshopPlacesWantedToReserve) BEGIN
        RAISERROR('You tried to reserve %d places for workshop, but only %d are available',
            1, 1, @workshopPlacesWantedToReserve, @freePlacesForWorkshop)
        ROLLBACK TRANSACTION
    END

    DECLARE @placesReservedForDay int;
    SET @placesReservedForDay = (SELECT participantsNumber
                                    FROM DayReservations
                                    WHERE DayReservations.DayReservationID =
                                          (SELECT DayReservationID
                                           FROM INSERTED));

    IF(@placesReservedForDay < @workshopPlacesWantedToReserve) BEGIN
        RAISERROR('You tried to reserve %d places for workshop, but only %d places are reserved for this conference day!',
            1, 1, @workshopPlacesWantedToReserve, @placesReservedForDay)
        ROLLBACK TRANSACTION
    END
END


-- trigger cancelDayReservation
-- przy anulowaniu rezerwacji na dany dzien
-- anuluje rezerwacje na warsztaty
-- powiazane z tą rezerwacją dnia konferencji
CREATE TRIGGER TRIGGER_cancelDayReservation On DayReservations
AFTER UPDATE
AS
BEGIN
    IF((SELECT COUNT(*) from INSERTED) > 1)
            OR ((SELECT COUNT(*) from DELETED) > 1) BEGIN
        RAISERROR('You cannot update more than one DayReservation at once', 1, 1)
        ROLLBACK TRANSACTION
    END

    UPDATE WorkshopReservations SET IsCancelled = 1
    WHERE DayReservationID IN (
        SELECT I.DayReservationID
        FROM INSERTED AS I, DELETED AS D
        WHERE I.isCancelled = 1 AND D.isCancelled = 0
    )
END


-- trigger createWorkshop
-- sprawdza czy przy tworzeniu warsztatu podano limit uczestników
-- mniejszy lub rowny limitowi uczestników na dany dzien
CREATE TRIGGER TRIGGER_createWorkshop ON Workshops
AFTER INSERT
AS
BEGIN
    DECLARE @workshopLimit int;
    DECLARE @dayLimit int;
    SET @workshopLimit = (SELECT ParticipantsLimit FROM INSERTED);
    SET @dayLimit = (SELECT ParticipantsLimit
                     FROM ConferenceDays
                     WHERE ConferenceDayID = (SELECT ConferenceDayID
                                              FROM INSERTED));

    IF(@dayLimit < @workshopLimit)
        BEGIN
            RAISERROR('You tried to create a workshop with participants limit of %d places, but %d is the limit of places for this day!', 1, 1,
                        @workshopLimit, @dayLimit)
            ROLLBACK TRANSACTION
        END
END


-- trigger registerForConferenceDay
-- uruchamia się kiedy próbujemy zarejestrować osobę na rezerwację dnia
-- Konferencji w której wykorzystano już wszystkie miejsca
CREATE TRIGGER TRIGGER_registerForConferenceDay On DayRegistrations
AFTER INSERT
AS
BEGIN
    IF(dbo.FUNCTION_freePlacesForConferenceDayReservation((SELECT DayReservationID
                                                            FROM INSERTED)) = 0)
        BEGIN
            RAISERROR('All places for this reservation are already taken', 1, 1)
            ROLLBACK TRANSACTION
        END
END


-- trigger registerForWorkshop
-- uruchamia się kiedy próbujemy zarejestrować osobę na rezerwację warsztatu
-- w której wykorzystano już wszystkie miejsca
CREATE TRIGGER TRIGGER_registerForWorkshop On WorkshopRegistrations
AFTER INSERT
AS
BEGIN
    IF(dbo.FUNCTION_freePlacesForWorkshopReservation((SELECT WorkshopReservationID
                                                    FROM INSERTED)) = 0)
        BEGIN
            RAISERROR('All places for this reservation are already taken', 1, 1)
            ROLLBACK TRANSACTION
        END
END


-- Trigger reservationWorkshopReservationsCollision
-- sprawdza, czy warsztat na który użytkownik rezerwuję miejsce
-- nie przecina się z innymi warsztatami na które ten użytkownik
-- jest już zarejestrowany
CREATE TRIGGER TRIGGER_workshopReservationsCollision
   ON WorkshopRegistrations
   AFTER INSERT
AS
BEGIN
   SET NOCOUNT ON;
   IF EXISTS
   (
      SELECT * FROM INSERTED AS wr
      JOIN DayRegistrations AS dr ON dr.DayRegistrationID = wr.DayRegistrationID
      CROSS APPLY dbo.FUNCTION_participantWorkshopList(dr.ParticipantID) AS w1
      JOIN WorkshopReservations wres
          on wr.WorkshopReservationID = wres.WorkshopReservationID
      JOIN Workshops AS w ON w.WorkshopID = wres.WorkshopID
      WHERE dbo.FUNCTION_workshopCollision(w1.WorkshopID, w.WorkshopID) = 1
         AND w1.WorkshopID <> w.WorkshopID
   )
   BEGIN
      THROW 51000, 'You cannot register participant for this workshop,
                   because selected participant is already registered
                   for workshop on this time', 1
      ROLLBACK TRANSACTION;
   END
END
