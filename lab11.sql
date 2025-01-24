-- 1
CREATE table CYTATY as select * from ZTPD.CYTATY;

-- 2
SELECT AUTOR, TEKST
from CYTATY
where lower(TEKST) like '%pesymista%' and lower(TEKST) like '%optymista%';

-- 3
create index CYTATY_IDX on TPD148116.CYTATY(TEKST)
indextype is CTXSYS.CONTEXT;

-- 4
select AUTOR, TEKST
from TPD148116.CYTATY
where CTXSYS.CONTAINS(lower(TEKST), 'pesymista and optymista') > 0;

-- 5
select AUTOR, TEKST
from TPD148116.CYTATY
where CTXSYS.CONTAINS(lower(TEKST), 'pesymista not optymista') > 0;

-- 6
select AUTOR, TEKST
from TPD148116.CYTATY
where CTXSYS.CONTAINS(lower(TEKST), 'near((pesymista, optymista),3)') > 0;

-- 7
select AUTOR, TEKST
from TPD148116.CYTATY
where CTXSYS.CONTAINS(lower(TEKST), 'near((pesymista, optymista),10)') > 0;

-- 8
select AUTOR, TEKST
from TPD148116.CYTATY
where CTXSYS.CONTAINS(lower(TEKST), 'życi%') > 0;

-- 9
select AUTOR, TEKST, SCORE(1)
from TPD148116.CYTATY
where CTXSYS.CONTAINS(lower(TEKST), 'życi%', 1) > 0;

-- 10
select AUTOR, TEKST, SCORE(1) as score
from TPD148116.CYTATY
where CTXSYS.CONTAINS(lower(TEKST), 'życi%', 1) > 0
ORDER BY score
FETCH FIRST 1 ROWS ONLY;

-- 11
select AUTOR, TEKST, SCORE(1)
from TPD148116.CYTATY
where CTXSYS.CONTAINS(lower(TEKST), 'FUZZY(probelm)', 1) > 0;

-- 12
Insert INTO TPD148116.CYTATY
values (39, 'Bertrand Russel', 'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości')

-- 13
select AUTOR, TEKST
from TPD148116.CYTATY
where CTXSYS.CONTAINS(lower(TEKST), 'głupcy') > 0;

-- 17
drop index CYTATY_IDX;
drop table CYTATY;

-- 2.1
CREATE table QUOTES as select * from ZTPD.QUOTES;

-- 2.2
create index QUOTES_IDX on TPD148116.QUOTES(TEXT)
indextype is CTXSYS.CONTEXT;

-- 2.3
select AUTHOR, TEXT
from TPD148116.QUOTES
where CTXSYS.CONTAINS(lower(TEXT), '$working') > 0;

-- 2.4
select AUTHOR, TEXT
from TPD148116.QUOTES
where CTXSYS.CONTAINS(lower(TEXT), 'it') > 0;
-- zapytanie nie zwróci odpowiedzi, ponieważ słowo 'it' należy do stopwordów i zostanie pominięte.

-- 2.5
SELECT * from CTX_STOPLISTS;

-- 2.6
Select * from CTX_STOPWORDS;


-- 2.7
drop index QUOTES_IDX;
create index QUOTES_IDX on TPD148116.QUOTES(TEXT)
indextype is CTXSYS.CONTEXT
parameters ( 'stoplist CTXSYS.EMPTY_STOPLIST' );

-- 2.8
select AUTHOR, TEXT
from TPD148116.QUOTES
where CTXSYS.CONTAINS(lower(TEXT), 'it') > 0;

-- 2.9
select AUTHOR, TEXT
from TPD148116.QUOTES
where CTXSYS.CONTAINS(lower(TEXT), 'fool and humans') > 0;

-- 2.10
select AUTHOR, TEXT
from TPD148116.QUOTES
where CTXSYS.CONTAINS(lower(TEXT), 'fool and computers') > 0;

-- 2.11

select AUTHOR, TEXT
from TPD148116.QUOTES
where CTXSYS.CONTAINS(lower(TEXT), 'fool and humans WITHIN SENTENCE') > 0;

-- 2.12
drop index QUOTES_IDX;

-- 2.13
begin
    ctx_dll.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_dll.add_special_section('nullgroup', 'SENTENCE');
    ctx_dll.add_special_section('nullgroup', 'PARAGRAPH');
end;

-- 2.14
create index QUOTES_IDX on QUOTES(TEXT)
indextype is ctxsys.context
parameters ( 'datastore COMMON_DIR section group nullgroup' );

-- 2.15
select AUTHOR, TEXT
from TPD148116.QUOTES
where CTXSYS.CONTAINS(lower(TEXT), 'fool and humans WITHIN SENTENCE') > 0;
select AUTHOR, TEXT
from TPD148116.QUOTES
where CTXSYS.CONTAINS(lower(TEXT), 'fool and computer WITHIN SENTENCE') > 0;

-- 2.16
select AUTHOR, TEXT
from TPD148116.QUOTES
where CTXSYS.CONTAINS(lower(TEXT), 'humans') > 0;

--2.17
drop index QUOTES_IDX;
begin
    ctx_dll.create_preference('lex_with_hyphens', 'BASIC_LEXER');
    ctx_dll.set_attribute('lex_with_hyphens', 'printjoins', '_-');
    ctx_dll.set_attribute('lex_with_hyphens', 'index_text', 'YES');
end;

create index QUOTES_IDX on QUOTES(TEXT)
indextype is CTXSYS.context
parameters ( 'LEXER lex_with_hyphens' );

-- 2.18
select AUTHOR, TEXT
from TPD148116.QUOTES
where CTXSYS.CONTAINS(lower(TEXT), 'humans') > 0;

-- 2.19
select AUTHOR, TEXT
from TPD148116.QUOTES
where CTXSYS.CONTAINS(lower(TEXT), 'non\-humans') > 0;

-- 2.20
drop index QUOTES_IDX;
drop table QUOTES;