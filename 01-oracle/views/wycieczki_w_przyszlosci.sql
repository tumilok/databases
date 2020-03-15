-- VIEW WYCIECZKI W PRZYSZLOSCI
CREATE OR REPLACE VIEW view_wycieczki_w_przyszlosci
    AS
        SELECT *
        FROM view_wycieczki_miejsca wm
        WHERE wm.DATA > CURRENT_DATE;