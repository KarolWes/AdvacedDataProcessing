select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
 and prior t.owner = t.owner;

select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;

create table MYST_MAJOR_CITIES
(
    FIPS_CNTRY varchar2(2),
    CITY_NAME varchar2(40),
    STGEOM ST_POINT
);

insert into MYST_MAJOR_CITIES
select FIPS_CNTRY, CITY_NAME,
       TREAT(ST_POINT.FROM_SDO_GEOM(GEOM) AS ST_POINT) STGEOM
from MAJOR_CITIES;

select C.FIPS_CNTRY, C.CITY_NAME,
    C.STGEOM.GET_WKT() WKT
    from MYST_MAJOR_CITIES C

insert into MYST_MAJOR_CITIES
values('PL', 'Szczyrk', NEW ST_POINT(19.036107, 49.718655, null))

create table MYST_COUNTRY_BOUNDARIES
(
    FIPS_CNTRY varchar2(2),
    CITY_NAME varchar2(40),
    STGEOM ST_MULTIPOLYGON
);

insert into MYST_COUNTRY_BOUNDARIES
    select B.FIPS_CNTRY, B.CNTRY_NAME, ST_MULTIPOLYGON(B.GEOM)
    from COUNTRY_BOUNDARIES B;

select b.STGEOM.st_geometryType(), count(CNTRY_NAME)
    from MYST_COUNTRY_BOUNDARIES B
group by b.STGEOM.st_geometryType();


select b.STGEOM.st_isSimple(), count(CNTRY_NAME)
    from MYST_COUNTRY_BOUNDARIES B
group by b.STGEOM.st_isSimple();

select b.CNTRY_NAME, count(c.city_name)
from MYST_COUNTRY_BOUNDARIES b, MYST_MAJOR_CITIES c
where c.STGEOM.ST_WITHIN(b.STGEOM) = 1
group by b.CNTRY_NAME;

delete from MYST_MAJOR_CITIES where CITY_NAME = 'Szczyrk';

select A.CNTRY_NAME A_NAME, B.CNTRY_NAME B_NAME
from MYST_COUNTRY_BOUNDARIES A,
 MYST_COUNTRY_BOUNDARIES B
where A.STGEOM.ST_TOUCHES(B.STGEOM) = 1
and B.CNTRY_NAME = 'Czech Republic';

select distinct B.CNTRY_NAME, R.name
from MYST_COUNTRY_BOUNDARIES B, RIVERS R
where B.CNTRY_NAME = 'Czech Republic'
and ST_LINESTRING(R.GEOM).ST_INTERSECTS(B.STGEOM) = 1;

select Treat(A.STGEOM.ST_UNION(B.STGEOM) as ST_POLYGON).ST_AREA() CZECHOSLOWACJA
from MYST_COUNTRY_BOUNDARIES A, MYST_COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Czech Republic'
and B.CNTRY_NAME = 'Slovakia';

select B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)) WEGRY_BEZ, B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)).st_geometryType() Typ
from MYST_COUNTRY_BOUNDARIES B, WATER_BODIES W
where B.CNTRY_NAME = 'Hungary'
and W.name = 'Balaton';

select B.CNTRY_NAME A_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM, 'distance=100 unit=km') = 'TRUE'
and B.CNTRY_NAME = 'Poland'
group by B.CNTRY_NAME;

insert into USER_SDO_GEOM_METADATA
 select 'MYST_MAJOR_CITIES', 'STGEOM',
 T.DIMINFO, T.SRID
 from USER_SDO_GEOM_METADATA T
 where T.TABLE_NAME = 'MAJOR_CITIES';

create index MYST_MAJOR_CITIES_IDX on
 MYST_MAJOR_CITIES(STGEOM)
indextype IS MDSYS.SPATIAL_INDEX;