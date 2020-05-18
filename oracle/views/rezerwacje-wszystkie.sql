-- VIEW REZERWACJE WSZYSTKIE
CREATE OR REPLACE VIEW view_rezerwacje_wszystkie
    AS
        SELECT
            r.NR_REZERWACJI,
            w.ID_WYCIECZKI,
            w.NAZWA,
            w.KRAJ,
            w.DATA,
            o.IMIE,
            o.NAZWISKO,
            r.STATUS
        FROM WYCIECZKI w
            JOIN REZERWACJE r ON w.ID_WYCIECZKI = r.ID_WYCIECZKI
            JOIN OSOBY o ON r.ID_OSOBY = o.ID_OSOBY;