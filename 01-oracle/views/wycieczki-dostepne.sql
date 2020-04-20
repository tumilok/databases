-- VIEW WYCIECZKI_DOSTEPNE
CREATE OR REPLACE VIEW view_wycieczki_dostepne
    AS
        SELECT *
        FROM view_wycieczki_w_przyszlosci wm
        WHERE wm.LICZBA_WOLNYCH_MIEJSC > 0;