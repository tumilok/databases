-- VIEW WYCIECZKI W PRZYSZLOSCI2
CREATE OR REPLACE VIEW view_wycieczki_w_przyszlosci2
    AS
        SELECT *
        FROM view_wycieczki_miejsca2 wm
        WHERE wm.DATA > CURRENT_DATE;