-- PROCEDURE ZMIEN_STATUS_REZERWACJI
CREATE OR REPLACE
PROCEDURE prc_zmien_status_rezerwacji
    (nr_rezerwacji REZERWACJE.NR_REZERWACJI%TYPE, status REZERWACJE.STATUS%TYPE) AS
    is_table    INTEGER;
    past_status REZERWACJE.STATUS%TYPE;
    BEGIN
        SELECT COUNT(*) INTO is_table
        FROM REZERWACJE r
        WHERE r.NR_REZERWACJI = prc_zmien_status_rezerwacji.nr_rezerwacji;

        IF is_table = 0 THEN
            raise_application_error(-20014, 'Brak rezerwacji o podanym nr');
        END IF;

        SELECT COUNT(*) INTO is_table
        FROM VIEW_REZERWACJE_W_PRZYSZLOSCI rwp
        WHERE rwp.NR_REZERWACJI = prc_zmien_status_rezerwacji.nr_rezerwacji;

        IF is_table = 0 THEN
            raise_application_error(-20014, 'Status rezerwacji mozna zmieniac tylko ' ||
                                            'dla wycieczek przyszlosci');
        END IF;

        SELECT COUNT(*) INTO is_table
        FROM VIEW_WYCIECZKI_DOSTEPNE wd
            JOIN REZERWACJE r ON r.ID_WYCIECZKI = wd.ID_WYCIECZKI
        WHERE r.NR_REZERWACJI = prc_zmien_status_rezerwacji.nr_rezerwacji;

        SELECT r.STATUS INTO past_status
        FROM REZERWACJE r
        WHERE r.NR_REZERWACJI = prc_zmien_status_rezerwacji.nr_rezerwacji;

        IF prc_zmien_status_rezerwacji.past_status = 'A' AND is_table = 0 THEN
          raise_application_error(-20014, 'Brak dostempnych miejsc');
        END IF;

        IF prc_zmien_status_rezerwacji.past_status = prc_zmien_status_rezerwacji.status THEN
            raise_application_error(-20014, 'Nie mozna zamienic status na taki sam');
        END IF;

        UPDATE REZERWACJE r
        SET STATUS = prc_zmien_status_rezerwacji.status
        WHERE r.NR_REZERWACJI = prc_zmien_status_rezerwacji.nr_rezerwacji;

        INSERT INTO REZERWACJE_LOG (ID_REZERWACJI, DATA, STATUS)
        VALUES (prc_zmien_status_rezerwacji.nr_rezerwacji, CURRENT_DATE, prc_zmien_status_rezerwacji.status);
    END prc_zmien_status_rezerwacji;
