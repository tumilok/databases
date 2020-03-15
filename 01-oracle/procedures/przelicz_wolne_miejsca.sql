-- PROCEDURE PRZELICZ_WOLNE_MIEJSCA
CREATE OR REPLACE
PROCEDURE prc_przelicz_wolne_miejsca
    AS
    BEGIN
        UPDATE WYCIECZKI w
        SET w.LICZBA_WOLNYCH_MIEJSC = w.LICZBA_MIEJSC -
                (SELECT COUNT(*) FROM REZERWACJE r
                    WHERE r.ID_WYCIECZKI = w.ID_WYCIECZKI
                        AND r.STATUS <> 'A');
    END;