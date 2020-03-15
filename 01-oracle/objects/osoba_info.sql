-- TYPE OSOBA_INFO
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

-- TYPE OSOBA_INFO_TABLE
CREATE OR REPLACE TYPE type_osoba_info_table
    IS TABLE OF type_osoba_info;