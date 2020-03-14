--VIEWS

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


CREATE OR REPLACE VIEW view_rezerwacje_potwierdzone
    AS
        SELECT *
        FROM view_rezerwacje_wszystkie rw
        WHERE rw.STATUS = 'P' OR rw.STATUS = 'Z';


CREATE OR REPLACE VIEW view_rezerwacje_w_przyszlosci
    AS
        SELECT *
        FROM view_rezerwacje_wszystkie rw
        WHERE rw.DATA > CURRENT_DATE;


CREATE OR REPLACE VIEW view_wycieczki_miejsca
    AS
        SELECT
            w.ID_WYCIECZKI,
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


CREATE OR REPLACE VIEW view_wycieczki_w_przyszlosci
    AS
        SELECT *
        FROM view_wycieczki_miejsca wm
        WHERE wm.DATA > CURRENT_DATE;


CREATE OR REPLACE VIEW view_wycieczki_dostepne
    AS
        SELECT *
        FROM view_wycieczki_w_przyszlosci wm
        WHERE wm.LICZBA_WOLNYCH_MIEJSC > 0;


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
