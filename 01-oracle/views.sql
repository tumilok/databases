--VIEWS

CREATE OR REPLACE VIEW view_rezerwacje_wszystkie
    AS
        SELECT
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


CREATE OR REPLACE VIEW view_rezerwacje_potwierdzone
    AS
        SELECT *
        FROM view_rezerwacje_wszystkie rw
        WHERE rw.STATUS = 'P' OR rw.STATUS = 'Z';


CREATE OR REPLACE VIEW view_rezerwacje_w_przyszlosci
    AS
        SELECT *
        FROM view_rezerwacje_wszystkie rw
        WHERE rw.DATA > CURRENT_DATE
            AND rw.STATUS <> 'A';


CREATE OR REPLACE VIEW view_wycieczki_miejsca
    AS
        SELECT
            w.KRAJ,
            w.DATA,
            w.NAZWA,
            w.LICZBA_MIEJSC,
            (w.LICZBA_MIEJSC - (
                SELECT COUNT(*)
                FROM REZERWACJE r
                WHERE r.ID_WYCIECZKI = w.ID_WYCIECZKI
                    AND r.STATUS <> 'A'
            )) AS LICZBA_WOLNYCH_MIEJSC
        FROM WYCIECZKI w;


CREATE OR REPLACE VIEW view_wycieczki_dostepne
    AS
        SELECT *
        FROM view_wycieczki_miejsca wm
        WHERE wm.LICZBA_WOLNYCH_MIEJSC > 0
            AND wm.DATA > CURRENT_DATE;
