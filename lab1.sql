create TYPE SAMOCHOD as object (
    nazwa varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji DATE,
    cena NUMBER(10,2)
);

create table SAMOCHODY of SAMOCHOD;


select *
from SAMOCHODY;

insert into SAMOCHODY values ('FIAT', 'BRAVA', 60000, TO_DATE('30-11-1999', 'DD-MM-YYYY'), 25000);
insert into SAMOCHODY values ('FORD', 'MONDEO', 80000, TO_DATE('10-05-1997', 'DD-MM-YYYY'), 45000);
insert into SAMOCHODY values ('MAZDA', '323', 12000, TO_DATE('22-09-2000', 'DD-MM-YYYY'), 52000);

create table WLASCICIELE(
    imie varchar2(100),
    nazwisko varchar2(100),
    auto SAMOCHOD
);

insert into WLASCICIELE values ('JAN', 'KOWALSKI', SAMOCHOD('FIAT', 'SEICENTO', 30000, TO_DATE('02-12-2010', 'DD-MM-YYYY'), 19500));
insert into WLASCICIELE values ('ADAM', 'NOWAK', SAMOCHOD('OPEL', 'ASTRA', 34000, TO_DATE('01-06-2009', 'DD-MM-YYYY'), 33700));

select *
from WLASCICIELE;

alter TYPE SAMOCHOD replace as object (
    nazwa varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji DATE,
    cena NUMBER(10,2),
    MEMBER FUNCTION wartosc RETURN NUMBER
);

create or replace type body SAMOCHOD as
    MEMBER FUNCTION wartosc RETURN NUMBER is
        BEGIN
            return cena*power(0.9,
                extract(year from current_date) - extract(year from DATA_PRODUKCJI));
        end wartosc;
end;

select s.nazwa, s.cena, s.wartosc() from SAMOCHODY s;

alter type SAMOCHOD add map member function odwzoruj
return number cascade including table data;

create or replace type body SAMOCHOD as
    MEMBER FUNCTION wartosc RETURN NUMBER is
        BEGIN
            return cena*power(0.9,
                extract(year from current_date) - extract(year from DATA_PRODUKCJI));
        end wartosc;

    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER is
    Begin
        RETURN extract(year from current_date) - extract(year from DATA_PRODUKCJI) +
               KILOMETRY/10000;
    end odwzoruj;
end;

    select * from SAMOCHODY s order by VALUE(s);

create TYPE WLASCICIEL as object (
    imie VARCHAR2(100),
    nazwisko VARCHAR2(100)
);

create table WLASCICIELE of WLASCICIEL;

drop table SAMOCHODY;
drop type SAMOCHOD;

create TYPE SAMOCHOD as object (
    nazwa varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji DATE,
    cena NUMBER(10,2),
    sWlasciciel REF WLASCICIEL,
    MEMBER FUNCTION wartosc RETURN NUMBER
);

alter type SAMOCHOD add map member function odwzoruj
return number cascade including table data;

create table SAMOCHODY of SAMOCHOD;

Alter table SAMOCHODY Add scope for ( SWLASCICIEL ) is WLASCICIELE;

INSERT INTO WLASCICIELE VALUES
    (new WLASCICIEL('Karol', 'Wesolowski'));
INSERT INTO WLASCICIELE VALUES
    (new WLASCICIEL('Jan', 'Nowak'));
INSERT INTO WLASCICIELE VALUES
    (new WLASCICIEL('Tomasz', 'Gawronik'));

select * from WLASCICIELE;

insert into SAMOCHODY values ('FIAT', 'BRAVA', 60000, TO_DATE('30-11-1999', 'DD-MM-YYYY'), 25000, null);
insert into SAMOCHODY values ('FORD', 'MONDEO', 80000, TO_DATE('10-05-1997', 'DD-MM-YYYY'), 45000, null);
insert into SAMOCHODY values ('MAZDA', '323', 12000, TO_DATE('22-09-2000', 'DD-MM-YYYY'), 52000, null);

select * from SAMOCHODY;

update SAMOCHODY s set s.SWLASCICIEL = (
    SELECT REF(w) from WLASCICIELE w
    where w.imie = 'Jan'
    );

select nazwa, deref(SWLASCICIEL) from SAMOCHODY;


-- kolekcje

DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
 moje_przedmioty(1) := 'MATEMATYKA';
 moje_przedmioty.EXTEND(9);
 FOR i IN 2..10 LOOP
 moje_przedmioty(i) := 'PRZEDMIOT_' || i;
 END LOOP;
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 moje_przedmioty.TRIM(2);
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.EXTEND();
 moje_przedmioty(9) := 9;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.DELETE();
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

create type t_ksiazki as varray(10) of varchar2(50);
create table seria (tytul varchar2(50), ksiazki t_ksiazki);
insert into seria values ('Piesni lodu i ognia', T_KSIAZKI('gra o tron', 'nawalnica miczy'));
insert into seria values ('Harry Potter', T_KSIAZKI('Kamien filozoficzny', 'komnata tajemnic', 'wiezien azkabanu'));

select *
from seria;

update seria set ksiazki = t_ksiazki('gra o tron', 'starcie krolow' ,'nawalnica mieczy') where tytul = 'Piesni lodu i ognia';

create type msc as object (
    nazwa varchar2(30),
    skrot varchar2(3),
    dlugosc number,
    wartosc number
                          );

create type t_msc as TABLE OF msc;

create table sezony (nazwa varchar2(30), miesiac t_msc)
nested table miesiac store as miesiace;

insert into sezony values ('monsun', new t_msc(new msc('Styczen', 'JAN', 31, 0), new msc('Luty', 'FEB', 28, 12)));
select *
from sezony;
select s.miesiac. from sezony s;


CREATE TYPE instrument AS OBJECT (
 nazwa VARCHAR2(20),
 dzwiek VARCHAR2(20),
 MEMBER FUNCTION graj RETURN VARCHAR2 ) NOT FINAL;
CREATE TYPE BODY instrument AS
 MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN dzwiek;
 END;
END;
/
CREATE TYPE instrument_dety UNDER instrument (
 material VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_dety AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'dmucham: '||dzwiek;
 END;
 MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
 BEGIN
 RETURN glosnosc||':'||dzwiek;
 END;
END;
/
CREATE TYPE instrument_klawiszowy UNDER instrument (
 producent VARCHAR2(20),
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 );
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
 OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
 BEGIN
 RETURN 'stukam w klawisze: '||dzwiek;
 END;
END;
/
DECLARE
 tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
 trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
 fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','pingping','steinway');
BEGIN
 dbms_output.put_line(tamburyn.graj);
 dbms_output.put_line(trabka.graj);
 dbms_output.put_line(trabka.graj('glosno'));
 dbms_output.put_line(fortepian.graj);
END;

CREATE TYPE istota AS OBJECT (
 nazwa VARCHAR2(20),
 NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR )
 NOT INSTANTIABLE NOT FINAL;
CREATE TYPE lew UNDER istota (
 liczba_nog NUMBER,
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR );
CREATE OR REPLACE TYPE BODY lew AS
 OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
 BEGIN
 RETURN 'upolowana ofiara: '||ofiara;
 END;
END;
DECLARE
 KrolLew lew := lew('LEW',4);
--  InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
 DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

DECLARE
 tamburyn instrument;
 cymbalki instrument;
 trabka instrument_dety;
 saksofon instrument_dety;
BEGIN
 tamburyn := instrument('tamburyn','brzdek-brzdek');
 cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
 trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
 -- saksofon := instrument('saksofon','tra-taaaa');
 -- saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);

 dbms_output.put_line(trabka.graj);
END;

CREATE TABLE instrumenty OF instrument;
INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa')
);
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','pingping','steinway') );
SELECT i.nazwa, i.graj() FROM instrumenty i;
