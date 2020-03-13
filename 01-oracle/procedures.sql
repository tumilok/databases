-- PROCEDURES/FUNCTIONS RECEIVING DATA

-- Uczestnicy Wycieczki
CREATE OR REPLACE TYPE type_wycieczka_info
    AS OBJECT (
        ID_WYCIECZKI    INT,
        NAZWA           VARCHAR2(50),
        KRAJ            VARCHAR2(100),
        "DATA"          DATE,
        IMIE            VARCHAR2(50),
        NAZWISKO        VARCHAR2(50),
        STATUS          CHAR(1)
    );

CREATE OR REPLACE TYPE type_wycieczka_info_table
    IS TABLE OF type_wycieczka_info;

CREATE OR REPLACE
FUNCTION fnc_uczestnicy_wycieczki(id INT)
    return type_wycieczka_info_table as result_table type_wycieczka_info_table;
    is_table INTEGER;
    BEGIN
        SELECT COUNT(*) INTO is_table FROM WYCIECZKI w
            WHERE w.ID_WYCIECZKI = id;

        IF is_table = 0 THEN
          raise_application_error(-20014, 'Brak wycieczki o podanym id');
        END IF;

        SELECT type_wycieczka_info(rw.ID_WYCIECZKI, rw.NAZWA, rw.KRAJ, rw.DATA, rw.IMIE,
                                        rw.NAZWISKO, rw.STATUS)
            BULK COLLECT INTO result_table
        FROM VIEW_REZERWACJE_WSZYSTKIE rw
        WHERE rw.ID_WYCIECZKI = id AND rw.STATUS <> 'A';

        RETURN result_table;
    END fnc_uczestnicy_wycieczki;

SELECT * from TABLE(fnc_uczestnicy_wycieczki(3));

-- Rezerwacje Osoby
CREATE OR REPLACE TYPE type_osoba_info
    AS OBJECT (
        ID_OSOBY    INT,
        IMIE        VARCHAR2(50),
        NAZWISKO    VARCHAR2(50),
        KONTAKT     VARCHAR2(100),
        PESEL       VARCHAR2(11),
        NAZWA       VARCHAR2(50),
        KRAJ        VARCHAR2(100),
        "DATA"      DATE,
        STATUS      CHAR(1)
    );


CREATE OR REPLACE TYPE type_osoba_info_table
    IS TABLE OF type_osoba_info;

CREATE OR REPLACE
FUNCTION fnc_rezerwacje_osoby(id INT)
    return type_osoba_info_table as result_table type_osoba_info_table;
    is_table INTEGER;
    BEGIN
        SELECT COUNT(*) INTO is_table FROM OSOBY w
            WHERE w.ID_OSOBY = id;

        IF is_table = 0 THEN
          raise_application_error(-20014, 'Brak osoby o podanym id');
        END IF;

        SELECT type_osoba_info(wo.ID_OSOBY, wo.IMIE, wo.NAZWISKO, wo.KONTAKT, wo.PESEL,
                                    wo.NAZWA, wo.KRAJ, wo.DATA, wo.STATUS)
            BULK COLLECT INTO result_table
        FROM VIEW_WYCIECZKI_OSOBY wo
        WHERE wo.ID_OSOBY = id;

        RETURN result_table;
    END fnc_rezerwacje_osoby;

SELECT * from TABLE(FNC_REZERWACJE_OSOBY(1));