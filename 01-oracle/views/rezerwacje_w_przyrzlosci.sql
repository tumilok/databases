-- VIEW REZERWACJE W PRZYSZLOSCI
CREATE OR REPLACE VIEW view_rezerwacje_w_przyszlosci
    AS
        SELECT *
        FROM view_rezerwacje_wszystkie rw
        WHERE rw.DATA > CURRENT_DATE;

