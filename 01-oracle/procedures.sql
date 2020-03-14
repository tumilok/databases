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

SELECT * from TABLE(FNC_REZERWACJE_OSOBY(1));


-- Dostempne Wycieczki
CREATE OR REPLACE TYPE type_wycieczka_dostepna
    AS OBJECT (
        ID_WYCIECZKI            INT,
        KRAJ                    VARCHAR2(100),
        "DATA"                  DATE,
        NAZWA                   VARCHAR2(50),
        LICZBA_MIEJSC           INT,
        LICZBA_WOLNYCH_MIEJSC   INT
    );

CREATE OR REPLACE TYPE type_wycieczka_dostepna_table
    IS TABLE OF type_wycieczka_dostepna;

CREATE OR REPLACE
FUNCTION fnc_dostepne_wycieczki(kraj WYCIECZKI.KRAJ%TYPE,
                                data_od WYCIECZKI.DATA%TYPE,
                                data_do WYCIECZKI.DATA%TYPE)
    RETURN type_wycieczka_dostepna_table AS result_table type_wycieczka_dostepna_table;
    BEGIN
        IF data_od < CURRENT_DATE THEN
            raise_application_error(-20014, 'Data od nie może być wcześniej niż dzisiejsza data');
        END IF;

        IF data_od > data_do THEN
            raise_application_error(-20014, 'Data do nie może być wcześniej niż data od');
        END IF;

        SELECT type_wycieczka_dostepna(wd.ID_WYCIECZKI, wd.KRAJ, wd.DATA, wd.NAZWA, wd.LICZBA_MIEJSC,
                                            wd.LICZBA_WOLNYCH_MIEJSC)
            BULK COLLECT INTO result_table
        FROM VIEW_WYCIECZKI_DOSTEPNE wd
        WHERE wd.KRAJ = kraj AND data_od <= wd.DATA
          AND wd.DATA <= data_do;

        RETURN result_table;
    END fnc_dostepne_wycieczki;

SELECT * from TABLE(FNC_DOSTEPNE_WYCIECZKI('Polska', DATE '2020-04-01', DATE '2020-07-02'));


-- PROCEDURES/FUNCTIONS MODIFYING DATA

-- Dodaj Rezerwacje
CREATE OR REPLACE
PROCEDURE prc_dodaj_rezerwacje
    (id_wycieczki WYCIECZKI.ID_WYCIECZKI%TYPE, id_osoby OSOBY.ID_OSOBY%TYPE) AS
    is_table INTEGER;
    BEGIN
        SELECT COUNT(*) INTO is_table
        FROM OSOBY o
        WHERE o.ID_OSOBY = prc_dodaj_rezerwacje.id_osoby;

        IF is_table = 0 THEN
            raise_application_error(-20014, 'Brak osoby o podanym id');
        END IF;

        SELECT COUNT(*) INTO is_table
        FROM VIEW_WYCIECZKI_DOSTEPNE wd
        WHERE wd.ID_WYCIECZKI = prc_dodaj_rezerwacje.id_wycieczki;

        IF is_table = 0 THEN
          raise_application_error(-20014, 'Brak dostępnej wycieczki o podanym id');
        END IF;

        SELECT COUNT(*) INTO is_table
        FROM REZERWACJE r
        WHERE r.ID_WYCIECZKI = prc_dodaj_rezerwacje.id_wycieczki
            AND r.ID_OSOBY = prc_dodaj_rezerwacje.id_osoby;

        IF is_table > 0 THEN
          raise_application_error(-20014, 'Rezerwacja juz istnieje');
        END IF;

        INSERT INTO REZERWACJE (id_wycieczki, id_osoby, STATUS)
        VALUES (id_wycieczki, id_osoby, 'N');
    END prc_dodaj_rezerwacje;

CALL prc_dodaj_rezerwacje(4, 8);


-- Zmien Status Rezerwacji
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

        UPDATE REZERWACJE
        SET STATUS = prc_zmien_status_rezerwacji.status
        WHERE NR_REZERWACJI = prc_zmien_status_rezerwacji.nr_rezerwacji;
    END prc_zmien_status_rezerwacji;

CALL prc_zmien_status_rezerwacji(8, 'Z');


-- Zmien Liczbe Miejsc
CREATE OR REPLACE
PROCEDURE prc_zmien_liczbe_miejsc
    (id_wycieczki WYCIECZKI.ID_WYCIECZKI%TYPE, liczba_miejsc WYCIECZKI.LICZBA_MIEJSC%TYPE) AS
    is_table    INTEGER;
    places      INTEGER;
    free_places INTEGER;
    BEGIN
        SELECT COUNT(*) INTO is_table
        FROM WYCIECZKI w
        WHERE w.ID_WYCIECZKI = prc_zmien_liczbe_miejsc.id_wycieczki;

        IF is_table = 0 THEN
                  raise_application_error(-20014, 'Nie istnieje wycieczki o podanym id');
        END IF;

        SELECT COUNT(*) INTO is_table
        FROM VIEW_WYCIECZKI_W_PRZYSZLOSCI wwp
        WHERE wwp.ID_WYCIECZKI = prc_zmien_liczbe_miejsc.id_wycieczki;

        IF is_table = 0 THEN
                  raise_application_error(-20014, 'Nie można zmieniąc liczbę miejsc skonczonej' ||
                                                  ' wycieczki');
        END IF;

        SELECT wd.LICZBA_MIEJSC INTO places
        FROM VIEW_WYCIECZKI_DOSTEPNE wd
        WHERE wd.ID_WYCIECZKI = prc_zmien_liczbe_miejsc.id_wycieczki;

        IF prc_zmien_liczbe_miejsc.liczba_miejsc < places THEN

            SELECT wd.LICZBA_WOLNYCH_MIEJSC INTO free_places
            FROM VIEW_WYCIECZKI_DOSTEPNE wd
            WHERE wd.ID_WYCIECZKI = prc_zmien_liczbe_miejsc.id_wycieczki;

            IF places - free_places > prc_zmien_liczbe_miejsc.liczba_miejsc THEN
                  raise_application_error(-20014, 'Nie można zmienić liczbe miejsc na mniejszą' ||
                                                  ' niż zarejstrowanych uczestników');
            END IF;
        END IF;

        UPDATE WYCIECZKI
        SET LICZBA_MIEJSC = prc_zmien_liczbe_miejsc.liczba_miejsc
        WHERE ID_WYCIECZKI = prc_zmien_liczbe_miejsc.id_wycieczki;
    END prc_zmien_liczbe_miejsc;

CALL prc_zmien_liczbe_miejsc(6, 4);

SELECT * FROM WYCIECZKI;