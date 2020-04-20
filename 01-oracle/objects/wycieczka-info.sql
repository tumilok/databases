-- TYPE WYCIECZKA_INFO
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

-- TYPE WYCIECZKA_INFO_TABLE
CREATE OR REPLACE TYPE type_wycieczka_info_table
    IS TABLE OF type_wycieczka_info;