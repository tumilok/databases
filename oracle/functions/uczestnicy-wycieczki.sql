-- FUNCTION UCZESTNICY_WYCIECZKI
CREATE OR REPLACE
FUNCTION fnc_uczestnicy_wycieczki(id_wycieczki WYCIECZKI.ID_WYCIECZKI%TYPE)
    RETURN type_wycieczka_info_table AS result_table type_wycieczka_info_table;
    is_table INTEGER;
    BEGIN
        SELECT COUNT(*) INTO is_table
        FROM WYCIECZKI w
        WHERE w.ID_WYCIECZKI = fnc_uczestnicy_wycieczki.id_wycieczki;

        IF is_table = 0 THEN
          raise_application_error(-20014, 'Brak wycieczki o podanym id');
        END IF;

        SELECT type_wycieczka_info(rw.ID_WYCIECZKI, rw.NAZWA, rw.KRAJ, rw.DATA, rw.IMIE,
                                        rw.NAZWISKO, rw.STATUS)
            BULK COLLECT INTO result_table
        FROM VIEW_REZERWACJE_WSZYSTKIE rw
        WHERE rw.ID_WYCIECZKI = fnc_uczestnicy_wycieczki.id_wycieczki
            AND rw.STATUS <> 'A';

        RETURN result_table;
    END fnc_uczestnicy_wycieczki;