-- VIEW WYCIECZKI OSOBY
CREATE OR REPLACE VIEW view_wycieczki_osoby
    AS
        SELECT
            o.ID_OSOBY,
            o.IMIE,
            o.NAZWISKO,
            o.KONTAKT,
            o.PESEL,
            w.NAZWA,
            w.KRAJ,
            w.DATA,
            r.STATUS
        FROM OSOBY o
            JOIN REZERWACJE r on o.ID_OSOBY = r.ID_OSOBY
            JOIN WYCIECZKI w on r.ID_WYCIECZKI = w.ID_WYCIECZKI;