-- PROCEDURE ZMIEN LICZBE MIEJSC2
CREATE OR REPLACE
PROCEDURE prc_zmien_liczbe_miejsc2
    (id_wycieczki WYCIECZKI.ID_WYCIECZKI%TYPE, liczba_miejsc WYCIECZKI.LICZBA_MIEJSC%TYPE) AS
    is_table    INTEGER;
    places      INTEGER;
    free_places INTEGER;
    BEGIN
        SELECT COUNT(*) INTO is_table
        FROM WYCIECZKI w
        WHERE w.ID_WYCIECZKI = prc_zmien_liczbe_miejsc2.id_wycieczki;

        IF is_table = 0 THEN
                  raise_application_error(-20014, 'Nie istnieje wycieczki o podanym id');
        END IF;

        SELECT COUNT(*) INTO is_table
        FROM VIEW_WYCIECZKI_W_PRZYSZLOSCI2 wwp
        WHERE wwp.ID_WYCIECZKI = prc_zmien_liczbe_miejsc2.id_wycieczki;

        IF is_table = 0 THEN
                  raise_application_error(-20014, 'Nie mozna zmieniac liczbe miejsc skonczonej' ||
                                                  ' wycieczki');
        END IF;

        SELECT wd.LICZBA_MIEJSC INTO places
        FROM VIEW_WYCIECZKI_DOSTEPNE2 wd
        WHERE wd.ID_WYCIECZKI = prc_zmien_liczbe_miejsc2.id_wycieczki;

        IF prc_zmien_liczbe_miejsc2.liczba_miejsc < places THEN

            SELECT wd.LICZBA_WOLNYCH_MIEJSC INTO free_places
            FROM VIEW_WYCIECZKI_DOSTEPNE2 wd
            WHERE wd.ID_WYCIECZKI = prc_zmien_liczbe_miejsc2.id_wycieczki;

            IF places - free_places > prc_zmien_liczbe_miejsc2.liczba_miejsc THEN
                  raise_application_error(-20014, 'Nie mozna zmienic liczbe miejsc na mniejsza' ||
                                                  ' niz zarejstrowanych uczestnikow');
            END IF;
        END IF;

        UPDATE WYCIECZKI w
        SET w.LICZBA_MIEJSC = prc_zmien_liczbe_miejsc2.liczba_miejsc,
            w.LICZBA_WOLNYCH_MIEJSC = w.LICZBA_WOLNYCH_MIEJSC +
            (prc_zmien_liczbe_miejsc2.liczba_miejsc - w.LICZBA_MIEJSC)
        WHERE ID_WYCIECZKI = prc_zmien_liczbe_miejsc2.id_wycieczki;
    END prc_zmien_liczbe_miejsc2;
