-- TYPE WYCIECZKA_DOSTEPNA
CREATE OR REPLACE TYPE type_wycieczka_dostepna
    AS OBJECT (
        ID_WYCIECZKI            INT,
        KRAJ                    VARCHAR2(100),
        "DATA"                  DATE,
        NAZWA                   VARCHAR2(50),
        LICZBA_MIEJSC           INT,
        LICZBA_WOLNYCH_MIEJSC   INT
    );

-- TYPE WYCIECZKA DOSTEPNA TABLE
CREATE OR REPLACE TYPE type_wycieczka_dostepna_table
    IS TABLE OF type_wycieczka_dostepna;