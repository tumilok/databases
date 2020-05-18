-- widok paymentsBalance
-- wyświetla klientów i ich bilans wpłat
CREATE VIEW VIEW_paymentsBalance AS
    SELECT C.ClientID, C.Name, C.Phone, C.Email,C.IsCompany,
           ISNULL(ROUND(SUM(Total)
            - SUM(dbo.FUNCTION_conferenceReservationPrice(R.ReservationID))
               ,2), 0)
            AS Balance
    FROM Reservations AS R
    JOIN (
        SELECT ReservationID, sum(Amount) AS Total
        from Payments
        GROUP BY ReservationID
    ) AS P
    ON P.ReservationID = R.ReservationID
    RIGHT JOIN Clients AS C
    ON C.ClientID = R.ClientID
    GROUP BY C.ClientID, C.Name, C.Phone, C.Email, C.IsCompany


-- widok clientsWithDebt
-- wyświetla klientów którzy zalegają z płatnościami za rezerwacje
-- korzysta z widoku paymentsBalance
CREATE VIEW VIEW_clientsWithDebt AS
    SELECT *
    FROM VIEW_paymentsBalance
    WHERE Balance < 0


-- widok clientsWithOverpayment
-- wyświetla klientów którzy zapłacili zbyt dużo za rezerwacje
-- korzysta z widoku paymentsBalance
CREATE VIEW VIEW_clientsWithOverpayment AS
    SELECT *
    FROM VIEW_paymentsBalance
    WHERE Balance > 0


-- widok participantsStats
-- wyświetla statystyki uczestników konferencji i warsztatów
-- (liczbę dni i warsztatów w których brali udział)
CREATE VIEW VIEW_participantsStats AS
    SELECT P.ParticipantID,
           COUNT(DR.DayRegistrationID) AS 'NumberOfRegistartions',
           'DAYS' AS ActivityType
    FROM Participants AS P
    LEFT OUTER JOIN DayRegistrations AS DR
        ON DR.ParticipantID = P.ParticipantID
    LEFT OUTER JOIN DayReservations AS DR2
        ON DR.DayReservationID = DR2.DayReservationID
               AND DR2.isCancelled = '0'
    GROUP BY P.ParticipantID

    UNION

    SELECT P.ParticipantID,
           COUNT(WR.WorkshopRegistrationID) AS 'NumberOfRegistrations',
           'WORKSHOPS' AS ActivityType
    FROM Participants AS P
    LEFT OUTER JOIN DayRegistrations AS DR
        ON DR.ParticipantID = P.ParticipantID
    LEFT OUTER JOIN WorkshopRegistrations AS WR
        ON DR.DayRegistrationID = WR.DayRegistrationID
    LEFT OUTER JOIN WorkshopReservations WR2
        ON WR.WorkshopReservationID = WR2.DayReservationID
               AND WR2.IsCancelled = '0'
    LEFT OUTER JOIN DayReservations AS DR2
        ON DR.DayReservationID = DR2.DayReservationID
               AND DR2.isCancelled = '0'
    GROUP BY P.ParticipantID


-- Widok ClientsStats
-- wyświetla ilość rezerwacji
-- (które nie zostały anulowane)
-- dokonanych przez każdego klienta
CREATE VIEW VIEW_ClientsStats AS
    SELECT  c.ClientID, COUNT(ReservationID) as NumberOfReservations
    FROM Clients AS c
    JOIN Reservations AS r ON c.ClientID = r.ClientID AND r.isCancelled = 0
    GROUP BY c.ClientID


-- Widok conferenceReservationsNotPaid
-- wyświetla rezerwacje na konferencje, które nie zostały opłacone
-- w terminie 7 dni od rezerwacji i powinny zostać anulowane
CREATE VIEW VIEW_conferenceReservationsNotPaid AS
    SELECT ReservationID, ClientID,
           dbo.FUNCTION_conferenceReservationBalance(ReservationID)
               AS debt FROM Reservations
    WHERE  DATEDIFF(day, ReservationDate, GETDATE()) > 7
    GROUP BY ReservationID, ClientID
    HAVING dbo.FUNCTION_conferenceReservationBalance(ReservationID) < 0


-- Widok clientsWithFreePlacesOnReservations
-- wyświetla klientów, którzy nie podali
-- jeszcze wszystkich uczestników warsztatów lub dni konferencji,
-- a konferencja zaczyna się za co najwyżej 14 dni,
-- wraz z informacją o pozostałej liczbie miesc dla danej rezerwacji
CREATE VIEW VIEW_clientsWithFreePlacesOnReservations AS

    SELECT  c.ClientID,  c.name,  c.email,  c.phone, r.ReservationID,
        'DAY' AS ReservationType, dr.DayReservationID,
        dbo.FUNCTION_freePlacesForConferenceDayReservation(dr.DayReservationID) AS freePlaces
    FROM Reservations AS r
    JOIN DayReservations AS dr ON dr.ReservationID = r.ReservationID AND dr.isCancelled = '0'
    JOIN ConferenceDays AS cd ON dr.ConferenceDayID = cd.ConferenceDayID
    JOIN Conferences AS conf ON conf.ConferenceID = cd.ConferenceID
    JOIN Clients AS c ON c.ClientID = r.ClientID
    WHERE dbo.FUNCTION_freePlacesForConferenceDayReservation(dr.DayReservationID) > 0
      AND DATEDIFF(day, GETDATE(), conf.startDate) BETWEEN 0 AND 14
      AND r.isCancelled = '0'

    UNION

    SELECT  c.ClientID,  c.name,  c.email,  c.phone, r.ReservationID,
        'WORKSHOP' AS ReservationType, wr.WorkshopReservationID,
        dbo.FUNCTION_freePlacesForWorkshopReservation(wr.WorkshopReservationID) AS freePlaces
    FROM Reservations AS r
    JOIN DayReservations AS dr ON dr.ReservationID = r.ReservationID AND dr.IsCancelled = '0'
    JOIN ConferenceDays as cd ON cd.ConferenceDayID = dr.ConferenceDayID
    JOIN Conferences AS conf ON conf.ConferenceID = cd.conferenceID
    JOIN WorkshopReservations AS wr ON wr.DayReservationID = dr.DayReservationID AND wr.isCancelled = '0'
    JOIN Clients AS c ON c.ClientID = r.ClientID
    WHERE dbo.FUNCTION_freePlacesForWorkshopReservation(wr.WorkshopReservationID) > 0
      AND DATEDIFF(day, GETDATE(), conf.StartDate) BETWEEN 0 AND 14
    AND r.isCancelled = '0'


-- widok conferenceDaysPlaces
-- wyświetla dni konferencji wraz z informacją
-- o ilości wolnych i zajętych miejsc
CREATE VIEW VIEW_conferenceDayPlaces AS
    SELECT ConferenceDayID,
           dbo.FUNCTION_freePlacesForConferenceDay(ConferenceDayID) as FreePlaces,
           (ParticipantsLimit - dbo.FUNCTION_freePlacesForConferenceDay(ConferenceDayID)) as ReservedPlaces
    from ConferenceDays


-- widok conferenceDaysWithFreePlaces
-- wyświetla dni konferencji na które
-- są jeszcze miejsca i podaje ich liczbę
CREATE VIEW VIEW_conferenceDaysWithFreePlaces AS
    SELECT * from VIEW_conferenceDayPlaces
    where FreePlaces > 0


-- widok workshopsPlaces
-- wyświetla warsztaty wraz z informacją o ilości wolnych i zajętych miejsc
CREATE VIEW VIEW_workshopsPlaces AS
    SELECT WorkshopID,
           dbo.FUNCTION_freePlacesForWorkshop(WorkshopID) as FreePlaces,
           (ParticipantsLimit - dbo.FUNCTION_freePlacesForWorkshop(WorkshopID)) as ReservedPlaces
    from Workshops


-- widok workshopsWithFreePlaces
-- wyświetla dni konferencji na które są jeszcze miejsca
-- i podaje ich liczbę
CREATE VIEW VIEW_workshopsWithFreePlaces AS
    SELECT * from VIEW_workshopsPlaces
    where FreePlaces > 0
