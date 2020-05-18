-- Function freePlacesForConferenceDay
-- returns number of free places for a
-- given day of the conference
CREATE FUNCTION FUNCTION_freePlacesForConferenceDay
    (@ConferenceDayID int) RETURNS int
AS BEGIN

    DECLARE @totalPlaces int;
    SET @totalPlaces = (SELECT ParticipantsLimit
                        FROM ConferenceDays
                        WHERE ConferenceDayID = @ConferenceDayID)

    DECLARE @takenPlaces int;
    SET @takenPlaces = (SELECT SUM(ParticipantsNumber)
                        FROM DayReservations
                        WHERE ConferenceDayID = @ConferenceDayID
                        AND IsCancelled = 0)

    RETURN (@totalPlaces - @takenPlaces);

END


-- Function freePlacesForConferenceDayReservation
-- returns number of free places for a given
-- conference day reservation
CREATE FUNCTION FUNCTION_freePlacesForConferenceDayReservation
    (@DayReservationID int) RETURNS int
AS BEGIN

    DECLARE @totalPlaces int;
    SET @totalPlaces = (SELECT ParticipantsNumber
                        FROM DayReservations
                        WHERE DayReservationID = @DayReservationID)

    DECLARE @takenPlaces int;
    SET @takenPlaces = (SELECT COUNT(*)
                        FROM DayRegistrations
                        WHERE DayReservationID = @DayReservationID)

    RETURN (@totalPlaces - @takenPlaces);
END


-- Function freePlacesForWorkshop
-- return number of free places for a given workshop
CREATE FUNCTION FUNCTION_freePlacesForWorkshop
    (@WorkshopID int) RETURNS int
AS BEGIN

    DECLARE @totalPlaces int;
    SET @totalPlaces = (SELECT ParticipantsLimit
                        FROM Workshops
                        WHERE WorkshopID = @WorkshopID)

    DECLARE @takenPlaces int;
    SET @takenPlaces = (SELECT SUM(ParticipantsNumber)
                           FROM WorkshopReservations
                           WHERE WorkshopID = @WorkshopID
                           AND IsCancelled = 0)

    RETURN (@totalPlaces - @takenPlaces);
END


-- Function freePlacesForWorkshopReservation
-- returns number of free places for a given
-- workshop reservation
CREATE FUNCTION FUNCTION_freePlacesForWorkshopReservation
    (@WorkshopReservationID int) RETURNS int
AS BEGIN

    DECLARE @totalPlaces int;
    SET @totalPlaces = (SELECT ParticipantsNumber
                        FROM WorkshopReservations
                        WHERE WorkshopReservationID = @WorkshopReservationID)

    DECLARE @takenPlaces int;
    SET @takenPlaces = (SELECT COUNT(*)
                        FROM WorkshopRegistrations
                        WHERE WorkshopReservationID = @WorkshopReservationID)

    RETURN (@totalPlaces - @takenPlaces);
END


-- Function conferenceDayReservationPrice
-- returns price for a given conference day reservaton
CREATE FUNCTION FUNCTION_conferenceDayReservationPrice
    (@DayReservationID int) RETURNS money
AS BEGIN

    DECLARE @reservationDate datetime;
    SET @reservationDate = (SELECT ReservationDate
                            FROM Reservations as r
                            JOIN DayReservations d
                                on r.ReservationID = d.ReservationID
                            WHERE d.DayReservationID = @DayReservationID)

    DECLARE @studentDiscount real;
    SET @studentDiscount = (SELECT StudentDiscount
                            FROM Conferences as c
                            JOIN ConferenceDays as cd
                                on c.ConferenceID = cd.ConferenceID
                            JOIN DayReservations dr
                                on dr.ConferenceDayID = cd.ConferenceDayID
                            WHERE dr.DayReservationID = @DayReservationID)

    RETURN(
        SELECT SUM(p.Price*StudentsNumber*@studentDiscount)
                   + SUM(p.Price*(ParticipantsNumber-StudentsNumber))
        FROM DayReservations as dr
        JOIN Prices as p ON p.ConferenceDayID = dr.ConferenceDayID
                        AND p.untilDate = (
                            SELECT MIN(p2.untilDate) as soonestDate
                            FROM Prices as p2
                            WHERE p2.untilDate >= @reservationDate
                              AND p2.ConferenceDayID = dr.ConferenceDayID
                        )
        WHERE dr.DayReservationID = @DayReservationID
        )
END


-- Function reservedConferenceDaysPrice
-- returns price of given reservation for all
-- reserved days 
CREATE FUNCTION FUNCTION_reservedConferenceDaysPrice
    (@ReservationID int) RETURNS money
AS BEGIN
    RETURN(
        SELECT SUM(dbo.FUNCTION_conferenceDayReservationPrice(DayReservationID))
        FROM DayReservations as dr
        WHERE dr.ReservationID = @ReservationID
    )
END


-- Function workshopReservationPrice
-- returns price of a given workshop reservation
CREATE FUNCTION FUNCTION_workshopReservationPrice
    (@WorkshopReservationID int) RETURNS money
AS BEGIN
    RETURN(
        SELECT (w.Price*wr.ParticipantsNumber)
        FROM WorkshopReservations as wr
        JOIN Workshops w on wr.WorkshopID = w.WorkshopID
        WHERE wr.WorkshopReservationID = @WorkshopReservationID
    )
END


-- Function reservedWorkshopsPrice
-- returns price of all workshop reservations
-- for given reservation
CREATE FUNCTION FUNCTION_reservedWorkshopsPrice
    (@ReservationID int) RETURNS money
AS BEGIN
    RETURN(
        SELECT SUM(dbo.FUNCTION_workshopReservationPrice(WorkshopReservationID))
        FROM WorkshopReservations as wr
        JOIN DayReservations dr on dr.DayReservationID = wr.DayReservationID
        JOIN Reservations as r on dr.ReservationID = r.ReservationID
        WHERE r.ReservationID = @ReservationID
    )
END


-- Function conferenceReservationPrice
-- returns summary price for a given reservation
CREATE FUNCTION FUNCTION_conferenceReservationPrice
    (@ReservationID int) RETURNS money
AS BEGIN
    RETURN(dbo.FUNCTION_reservedConferenceDaysPrice(@ReservationID)
            + dbo.FUNCTION_reservedWorkshopsPrice(@ReservationID));
END


-- Function conferenceReservationBalance
-- returns balance of payments for a given reservation
CREATE FUNCTION FUNCTION_conferenceReservationBalance
	(@ReservationID int) RETURNS money
AS BEGIN
    RETURN(
        ISNULL(ROUND((SELECT SUM(Amount)
                        FROM Payments
                        WHERE ReservationID = @ReservationID)
                - dbo.FUNCTION_conferenceReservationPrice(@ReservationID), 2), 0)
    );
END


-- Function conferenceDayParticipantList
-- returns participant list for a given conference day
CREATE FUNCTION FUNCTION_conferenceDayParticipantsList
   (@ConferenceDayID int) RETURNS @DayParticipantsListTable TABLE
   (
      ParticipantID int,
      Firstname varchar(50),
      Lastname varchar(50)
   )
AS BEGIN

   INSERT @DayParticipantsListTable
      SELECT DISTINCT P.ParticipantID, P.Firstname, P.Lastname
      FROM DayReservations AS DRES
      JOIN DayRegistrations AS DREG
          ON DREG.DayReservationID = DRES.DayReservationID
      JOIN Participants AS P
          ON P.ParticipantID = DREG.ParticipantID
      WHERE DRES.ConferenceDayID = @ConferenceDayID AND DRES.IsCancelled = 0
      ORDER BY P.ParticipantID

   RETURN
END


-- Function workshopParticipantList
-- returns participant list for a given workshop
CREATE FUNCTION FUNCTION_workshopParticipantsList
   (@WorkshopID int) RETURNS @WorkshopParticipantListTable TABLE
   (
      ParticipantID int,
      Firstname varchar(50),
      Lastname varchar(50)
   )
AS BEGIN

   INSERT @WorkshopParticipantListTable
      SELECT DISTINCT P.ParticipantID, P.Firstname, P.Lastname
      FROM WorkshopReservations AS WRES
      JOIN WorkshopRegistrations AS WREG
          ON WREG.WorkshopReservationID = WRES.WorkshopReservationID
      JOIN DayRegistrations AS DREG
          ON DREG.DayRegistrationID = WREG.DayRegistrationID
      JOIN Participants AS P ON P.ParticipantID = DREG.ParticipantID
      WHERE WRES.WorkshopID = @WorkshopID AND WRES.isCancelled = 0
      ORDER BY P.ParticipantID

   RETURN
END


-- Function participantConferenceDayList
-- returns conference day list for a given participant
CREATE FUNCTION FUNCTION_participantConferenceDayList
   (@ParticipantID int) RETURNS @ParticipantConferenceDayListTable TABLE
   (ConferenceDayID int)
AS BEGIN

   INSERT @ParticipantConferenceDayListTable
      SELECT DISTINCT DRES.ConferenceDayID
      FROM Participants AS P
      JOIN DayRegistrations AS DREG ON
          DREG.ParticipantID = P.ParticipantID
      JOIN DayReservations AS DRES ON
          DRES.DayReservationID = DREG.DayRegistrationID
      WHERE P.ParticipantID = @ParticipantID
      ORDER BY DRES.ConferenceDayID

   RETURN
END


-- Function participantWorkshopList
-- returns workshop list for a given participant
CREATE FUNCTION FUNCTION_participantWorkshopList
   (@ParticipantID int) RETURNS @ParticipantWorkshopListTable TABLE
   (WorkshopID int)
AS BEGIN

   INSERT @ParticipantWorkshopListTable
      SELECT DISTINCT WRES.WorkshopID
      FROM Participants AS P
      JOIN DayRegistrations AS DREG ON DREG.ParticipantID = P.ParticipantID
      JOIN WorkshopRegistrations AS WREG
          ON WREG.DayRegistrationID = DREG.DayRegistrationID
      JOIN WorkshopReservations AS WRES
          ON WRES.WorkshopReservationID = WREG.WorkshopReservationID
      WHERE P.ParticipantID = @ParticipantID
      ORDER BY WRES.WorkshopID

   RETURN
END


-- Function workshopCollision
-- returns true if two given workshop are provided at the same time
CREATE FUNCTION FUNCTION_workshopCollision
   (@WorkshopID1 int, @WorkshopID2 int) RETURNS bit
AS BEGIN

   DECLARE @StartTime1 TIME(7);
   DECLARE @EndTime1 TIME(7);
   DECLARE @Date1 DATE;

   DECLARE @StartTime2 TIME(7);
   DECLARE @EndTime2 TIME(7);
   DECLARE @Date2 DATE;

   SET @StartTime1 = (SELECT StartTime
                       FROM Workshops
                       WHERE WorkshopID = @WorkshopID1)
   SET @EndTime1 = (SELECT EndTime
                       FROM Workshops
                       WHERE WorkshopID = @WorkshopID1)
   SET @Date1 = (SELECT D.Date
               FROM ConferenceDays AS D
               JOIN Workshops AS W
                   ON W.ConferenceDayID = D.ConferenceDayID
               WHERE W.WorkshopID = @WorkshopID1)

   SET @StartTime2 = (SELECT StartTime
                       FROM Workshops
                       WHERE WorkshopID = @WorkshopID2)
   SET @EndTime2 = (SELECT EndTime
                   FROM Workshops
                   WHERE WorkshopID = @WorkshopID2)
   SET @Date2 = (SELECT D.Date
               FROM ConferenceDays AS D
               JOIN Workshops AS W
                   ON W.ConferenceDayID = D.ConferenceDayID
               WHERE W.WorkshopID = @WorkshopID2)

   DECLARE @Collision BIT;
   IF(@StartTime1 > @EndTime2 OR @StartTime2 > @EndTime1 OR (@Date1 <> @Date2))
      SET @Collision = 0
   ELSE
      SET @Collision = 1

      RETURN @Collision

END 
