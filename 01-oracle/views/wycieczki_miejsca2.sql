-- VIEW WYCIECZKI MIEJSCA2
CREATE OR REPLACE VIEW view_wycieczki_miejsca2
    AS
        SELECT
            w.ID_WYCIECZKI,
            w.KRAJ,
            w.DATA,
            w.NAZWA,
            w.LICZBA_MIEJSC,
            w.LICZBA_WOLNYCH_MIEJSC
        FROM WYCIECZKI w;