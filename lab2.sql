CREATE table MOVIES_CP as select * from ZTPD.MOVIES;

select *
from MOVIES_CP
FETCH FIRST 10 ROWS ONLY;

select id, title from MOVIES_CP
where COVER is null;

select id, title, LENGTHB(COVER) as FILESIZE
from MOVIES_CP
where COVER is not null;

select DIRECTORY_PATH, DIRECTORY_NAME from ALL_DIRECTORIES;

update MOVIES_CP
set COVER = EMPTY_BLOB(), MIME_TYPE = 'image/jpeg'
where id = 66;

DECLARE
    data BLOB;
    okladka BFILE := BFILENAME('TPD_DIR', 'escape.jpg');
    BEGIN
        SELECT COVER into  data
        from MOVIES_CP
        where id = 66
        for update;
        DBMS_LOB.fileopen(okladka, DBMS_LOB.file_readonly);
        DBMS_LOB.LOADFROMFILE(data, okladka, DBMS_LOB.GETLENGTH(okladka));
        DBMS_LOB.FILECLOSE(okladka);
        COMMIT;
end;

create table TEMP_COVERS (
    movie_id NUMBER(12),
    image BLOB,
    mime_time VARCHAR2(50)
)
lob (image)
store as (
 disable storage in row
 chunk 4096
 pctversion 20
 nocache
 nologging);

insert into TEMP_COVERS
values (65, BFILENAME('TPD_DIR', 'eagles.jpg'), 'image/jpg');

select movie_id,image
from TEMP_COVERS;

DECLARE
    v_mime varchar2(50);
    v_okladka BFILE;
    v_blob_temp BLOB;

    BEGIN
        SELECT image, mime_time
        into v_okladka, v_mime
        from TEMP_COVERS
        where movie_id = 65;

        DBMS_LOB.createtemporary(v_blob_temp, TRUE);
        DBMS_LOB.fileopen(v_okladka, DBMS_LOB.file_readonly);
        DBMS_LOB.loadfromfile(v_blob_temp, v_okladka, DBMS_LOB.getlength(v_okladka));
        DBMS_LOB.fileclose(v_okladka);

        UPDATE MOVIES_CP
        SET cover = v_blob_temp,
        MIME_TYPE = v_mime
        WHERE id = 65;

        DBMS_LOB.freetemporary(v_blob_temp);
        COMMIT;
end;