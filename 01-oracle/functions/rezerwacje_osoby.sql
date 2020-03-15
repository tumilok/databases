-- FUNCTION REZERWACJE_OSOBY
CREATE OR REPLACE
FUNCTION fnc_rezerwacje_osoby(id_osoby OSOBY.ID_OSOBY%TYPE)
    RETURN type_osoba_info_table AS result_table type_osoba_info_table;
    is_table INTEGER;
    BEGIN
        SELECT COUNT(*) INTO is_table
        FROM OSOBY w
        WHERE w.ID_OSOBY = fnc_rezerwacje_osoby.id_osoby;

        IF is_table = 0 THEN
          raise_application_error(-20014, 'Brak osoby o podanym id');
        END IF;

        SELECT type_osoba_info(wo.ID_OSOBY, wo.IMIE, wo.NAZWISKO, wo.KONTAKT, wo.PESEL,
                                    wo.NAZWA, wo.KRAJ, wo.DATA, wo.STATUS)
            BULK COLLECT INTO result_table
        FROM VIEW_WYCIECZKI_OSOBY wo
        WHERE wo.ID_OSOBY = fnc_rezerwacje_osoby.id_osoby;

        RETURN result_table;
    END fnc_rezerwacje_osoby;
