-- VIEW WYCIECZKI_DOSTEPNE2
CREATE OR REPLACE VIEW view_wycieczki_dostepne2
    AS
        SELECT *
        FROM view_wycieczki_w_przyszlosci2 wm
        WHERE wm.LICZBA_WOLNYCH_MIEJSC > 0;