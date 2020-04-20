-- VIEW REZERWACJE_POTWIERDZONE
CREATE OR REPLACE VIEW view_rezerwacje_potwierdzone
    AS
        SELECT *
        FROM view_rezerwacje_wszystkie rw
        WHERE rw.STATUS = 'P' OR rw.STATUS = 'Z';
