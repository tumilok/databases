-- Index Payments improves the calculation of a customer balance of payments
CREATE NONCLUSTERED INDEX INDEX_Payments ON Payments (
    ReservationID ASC
)
WITH (PAD_INDEX = OFF,
    STATISTICS_NORECOMPUTE = OFF,
    SORT_IN_TEMPDB = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF,
    ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON
)

 
-- Index DayRegistration improves obtaining lists of participants assigned
-- to reservations for conference days
CREATE NONCLUSTERED INDEX INDEX_DayRegistration ON DayRegistrations (
    DayReservationID ASC
)
WITH (PAD_INDEX = OFF,
    STATISTICS_NORECOMPUTE = OFF,
    SORT_IN_TEMPDB = OFF,
    DROP_EXISTING = OFF,
    ONLINE = OFF,
    ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON
)


-- Index WorkshopRegistration improves obtaining lists of perticipants
-- assigned to workshop reservations
CREATE NONCLUSTERED INDEX INDEX_WorkshopRegistration ON WorkshopRegistrations (
    WorkshopReservationID ASC
)
WITH (PAD_INDEX = OFF,
    STATISTICS_NORECOMPUTE = OFF,
    SORT_IN_TEMPDB = OFF,
    DROP_EXISTING = OFF,
    ONLINE  =  OFF,
    ALLOW_ROW_LOCKS = ON,
    ALLOW_PAGE_LOCKS = ON
)
