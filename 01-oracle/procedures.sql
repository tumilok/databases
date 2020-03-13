-- PROCEDURES/FUNCTIONS RECEIVING DATA

CREATE OR REPLACE TYPE wycieczki_info_type
    AS OBJECT (
        ID_WYCIECZKI    INT,
        NAZWA           VARCHAR2(50),
        KRAJ            DATE,
        "DATA"          VARCHAR2(100),
        IMIE            VARCHAR2(50),
        NAZWISKO        VARCHAR2(50),
        STATUS          CHAR(1)
    );

CREATE OR REPLACE TYPE wycieczki_info_table_type
    IS TABLE OF wycieczki_info_type;


CREATE OR REPLACE
FUNCTION uczestnicy_wycieczki(id INT)
  return wycieczki_info_table_type as result_table wycieczki_info_table_type;
  is_table INTEGER;
  BEGIN
    SELECT COUNT(*) INTO is_table FROM WYCIECZKI w
        WHERE w.ID_WYCIECZKI = id;

    IF is_table = 0 THEN
      raise_application_error(-20014, 'Brak wycieczki o podanym id');
    END IF;

    SELECT wycieczki_info_type(rw.ID_WYCIECZKI, rw.KRAJ, rw.DATA, rw.NAZWA, rw.IMIE,
                             rw.NAZWISKO, rw.STATUS)
        BULK COLLECT INTO result_table
    FROM REZERWACJEWSZYSTKIE rw
    WHERE rw.ID_WYCIECZKI = id AND rw.STATUS <> 'A';
    return result_table;
  end uczestnicy_wycieczki;



SELECT * from TABLE(uczestnicy_wycieczki(4));

