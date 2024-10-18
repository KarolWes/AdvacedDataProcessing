create table DOKUMENTY(
id NUMBER(12) PRIMARY KEY ,
document CLOB
);

DECLARE
    v_document CLOB;
Begin
    DBMS_LOB.createTemporary(v_document, TRUE);

    FOR i in 1..10000 LOOP
        v_document := v_document || 'Oto tekst ';
        end loop;

    INSERT INTO DOKUMENTY VALUES (1, v_document);
    COMMIT;
    DBMS_LOB.freeTemporary(v_document);
end;

SELECT * FROM DOKUMENTY;
SELECT id, UPPER(document) FROM DOKUMENTY;
SELECT id, LENGTH(document) FROM DOKUMENTY;
SELECT id, DBMS_LOB.getLength(document) FROM DOKUMENTY;
SELECT id, SUBSTR(document, 5, 1000) FROM DOKUMENTY;
SELECT id, DBMS_LOB.SUBSTR(document, 1000, 5) FROM DOKUMENTY;

INSERT INTO DOKUMENTY VALUES (2, EMPTY_CLOB());
INSERT INTO DOKUMENTY VALUES (3, NULL);
COMMIT;

DECLARE
    data CLOB;
    plik BFILE := BFILENAME('TPD_DIR', 'dokument.txt');
    dest_off integer := 1;
    src_off integer := 1;
    lang_ctx integer := 0;
    warning integer := null;
Begin
    SELECT document into data
        from DOKUMENTY
        where id = 2
        for update;
    DBMS_LOB.fileopen(plik, DBMS_LOB.file_readonly);
    DBMS_LOB.loadClobFromFile(data, plik, DBMS_LOB.LOBMAXSIZE, dest_off, src_off, 0, lang_ctx, warning);
    DBMS_LOB.FILECLOSE(plik);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status: ' || warning);
end;

update DOKUMENTY
set document = TO_CLOB(BFILENAME('TPD_DIR', 'dokument.txt'))
where id = 3;

SELECT * FROM DOKUMENTY;
SELECT id, DBMS_LOB.getLength(document) FROM DOKUMENTY;

DROP TABLE DOKUMENTY;

CREATE OR REPLACE PROCEDURE CLOB_CENSOR(
    data IN OUT CLOB,
    text_to_replace IN VARCHAR2
)
IS
    start_pos INTEGER := 1;
    word_len INTEGER;
    dots VARCHAR2(1000);
BEGIN
    word_len := length(text_to_replace);
    IF word_len > 0 THEN
        dots := LPAD('.', word_len, '.');
        LOOP
            start_pos := INSTR(data, text_to_replace, start_pos);
            EXIT WHEN start_pos = 0;
            DBMS_LOB.WRITE(data, word_len, start_pos, dots);
            start_pos := start_pos + word_len;
        end loop;
    end if;
end;

CREATE table BIOGRAPHIES as select * from ZTPD.BIOGRAPHIES;

DECLARE
    data clob;
Begin
    SELECT bio into data from BIOGRAPHIES where id = 1 for update ;
    CLOB_CENSOR(data, 'Cimrman');
    UPDATE BIOGRAPHIES set BIO = data where id = 1;
    COMMIT;
end;

select *
from BIOGRAPHIES;

DROP TABLE BIOGRAPHIES;