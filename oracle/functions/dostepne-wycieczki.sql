-- FUNCTION DOSTEPNE WYCIECZKI
CREATE OR REPLACE
FUNCTION fnc_dostepne_wycieczki(kraj WYCIECZKI.KRAJ%TYPE,
                                data_od WYCIECZKI.DATA%TYPE,
                                data_do WYCIECZKI.DATA%TYPE)
    RETURN type_wycieczka_dostepna_table AS result_table type_wycieczka_dostepna_table;
    BEGIN
        IF data_od < CURRENT_DATE THEN
            raise_application_error(-20014, 'Data od nie moze byc wczesniej niz dzisiejsza data');
        END IF;

        IF data_od > data_do THEN
            raise_application_error(-20014, 'Data do nie moze byc wczesniej niz data od');
        END IF;

        SELECT type_wycieczka_dostepna(wd.ID_WYCIECZKI, wd.KRAJ, wd.DATA, wd.NAZWA, wd.LICZBA_MIEJSC,
                                            wd.LICZBA_WOLNYCH_MIEJSC)
            BULK COLLECT INTO result_table
        FROM VIEW_WYCIECZKI_DOSTEPNE wd
        WHERE wd.KRAJ = fnc_dostepne_wycieczki.kraj AND data_od <= wd.DATA
            AND wd.DATA <= data_do;

        RETURN result_table;
    END fnc_dostepne_wycieczki;
