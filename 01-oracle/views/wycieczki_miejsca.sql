-- VIEW WYCIECZKI MIEJSCA
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