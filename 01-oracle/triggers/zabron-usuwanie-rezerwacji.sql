CREATE OR REPLACE
TRIGGER trigger_zabron_usuwanie_rezerwacji
    BEFORE DELETE
    ON REZERWACJE
    FOR EACH ROW
BEGIN
    raise_application_error(-20014, 'Removing reservation forbidden.');
END;