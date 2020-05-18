-- Editing clients email addresses for more appropriate ones
SELECT CONCAT(LOWER(REPLACE(SUBSTRING(Name, 0, LEN(Name)), ' ','')),
	'@contact.com') AS EmailName, ClientID
INTO #TableA
FROM Clients

UPDATE Clients
SET
	Email = A.EmailName
FROM #TableA A
WHERE Clients.ClientID = A.ClientID


-- Editing clients reservation dates to dates which are more appropriate
SELECT * INTO #TableA
FROM
	(
		SELECT C.StartDate, R.ReservationID
		FROM Conferences AS C
		JOIN ConferenceDays AS CD
			ON CD.ConferenceID = C.ConferenceID
		JOIN DayReservations AS DRES
			ON DRES.ConferenceDayID = CD.ConferenceDayID
		JOIN Reservations AS R
			ON R.ReservationID = DRES.ReservationID
	) T

UPDATE Reservations
SET
	ReservationDate = DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 30, A.StartDate)
FROM #TableA AS A
WHERE Reservations.ReservationID = A.ReservationID


-- Editing clients payment dates to dates which are more appropriate
SELECT * INTO #TableA
FROM
	(
		SELECT C.StartDate, R.ReservationID, R.ReservationDate
		FROM Conferences AS C
		JOIN ConferenceDays AS CD
			ON CD.ConferenceID = C.ConferenceID
		JOIN DayReservations AS DRES
			ON DRES.ConferenceDayID = CD.ConferenceDayID
		JOIN Reservations AS R
			ON R.ReservationID = DRES.ReservationID
	) T

UPDATE Payments
SET 
	PaymentDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % (13 - 1)
			+ 1, ReservationDate)
FROM #TableA AS A
WHERE Payments.ReservationID = A.ReservationID


-- Deleting prices tables which have UntilDate after actual Conference day
DELETE	TARGET
FROM	Prices AS TARGET
JOIN	ConferenceDays AS CD
ON		CD.ConferenceDayID = TARGET.ConferenceDayID
WHERE	TARGET.UntilDate >= CD.Date


-- Creating of ConferenceDays tables according to a number of days in Conference table
DECLARE @i INT = 0
DECLARE @j INT = 0
WHILE @i < (SELECT COUNT (*) FROM Conferences)
BEGIN
    SET @i = @i + 1
	SET @j = 0
    WHILE @j < (SELECT DATEDIFF(DAY, (SELECT StartDate FROM Conferences WHERE ConferenceID=@i), (SELECT EndDate FROM Conferences WHERE ConferenceID=@i)) AS datediff)
  BEGIN
    INSERT INTO ConferenceDays(ConferenceID, Date, ParticipantsLimit, Location, IsCancelled)
    VALUES (@i, DATEADD(DAY, @j, (SELECT StartDate FROM Conferences WHERE ConferenceID = @i)), FLOOR(RAND()*(100)+1), 'Somewhere'  ,FLOOR(RAND()*(2 - 1) + 1))
    SET @j = @j + 1
  END
END
