INSERT INTO USER_SDO_GEOM_METADATA VALUES (
    'FIGURY',
    'ksztalt',
    SDO_DIM_ARRAY(                 -- Wymiary
        SDO_DIM_ELEMENT('X', -10, 10, 0.01),
        SDO_DIM_ELEMENT('Y', -10, 10, 0.01)
    ),
    NULL
);

select SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000,8192,10,2,0)
from dual;

create index PT_IDX
on TPD148116.FIGURY(KSZTALT)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

select ID
from FIGURY
where SDO_FILTER(KSZTALT,
SDO_GEOMETRY(2001,null,
 SDO_POINT_TYPE(3,3,null),
 null,null)) = 'TRUE';

select ID
from FIGURY
where SDO_RELATE(KSZTALT,
 SDO_GEOMETRY(2001,null,
 SDO_POINT_TYPE(3,3,null),
 null,null),
 'mask=ANYINTERACT') = 'TRUE';

select *
from MAJOR_CITIES;

select A.CITY_NAME, ROUND(SDO_NN_DISTANCE(1)) DISTANCE
from MAJOR_CITIES A
where SDO_NN(GEOM,(select geom from MAJOR_CITIES where ADMIN_NAME = 'Warszawa'),
 'sdo_num_res=9 unit=km',1) = 'TRUE' and ROUND(SDO_NN_DISTANCE(1)) > 0
order by Distance;

SELECT CITY_NAME
    From MAJOR_CITIES
where SDO_WITHIN_DISTANCE(GEOM,
 (select geom from MAJOR_CITIES where ADMIN_NAME = 'Warszawa'),
 'distance=100 unit=km') = 'TRUE';


select c.CNTRY_NAME, m.city_name
from COUNTRY_BOUNDARIES c,  MAJOR_CITIES m
where c.CNTRY_NAME = 'Slovakia'
and SDO_GEOM.RELATE(c.GEOM, 'DETERMINE', m.GEOM, 1) = 'CONTAINS';

select c.Cntry_name, ROUND(SDO_GEOM.SDO_DISTANCE(c.GEOM, (
    select geom from COUNTRY_BOUNDARIES where CNTRY_NAME = 'Poland'
    ), 1, 'unit=km')) ODL
from COUNTRY_BOUNDARIES c
where SDO_GEOM.RELATE(c.GEOM, 'DETERMINE', (
    select geom from COUNTRY_BOUNDARIES where CNTRY_NAME = 'Poland'
    ), 1) = 'DISJOINT';

select B.CNTRY_NAME,
 SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=km') as granica
from COUNTRY_BOUNDARIES A,
 COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Poland' and SDO_GEOM.RELATE(B.Geom, 'DETERMINE', A.Geom, 1) = 'TOUCH';

select A.CNTRY_NAME,
 ROUND(SDO_GEOM.sdo_area(A.GEOM, 1, 'unit=SQ_KM')) POWIERZCHNIA
from COUNTRY_BOUNDARIES A
order by 2 desc
fetch first 1 row only;

select SDO_GEOM.SDO_AREA((SDO_GEOM.SDO_MBR(SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM))), 1, 'unit=SQ_KM') POW
from MAJOR_CITIES A, MAJOR_CITIES B
where A.CITY_NAME = 'Warsaw' and B.CITY_NAME = 'Lodz';

select SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 1).SDO_GTYPE as GTYPE
from COUNTRY_BOUNDARIES A, MAJOR_CITIES B
where A.CNTRY_NAME = 'Poland'
and B.CITY_NAME = 'Prague';

select * from (select B.CNTRY_Name, SDO_GEOM.SDO_DISTANCE(SDO_GEOM.SDO_CENTROID(B.GEOM,1), c.GEOM) dist, c.city_name
from COUNTRY_BOUNDARIES B join MAJOR_CITIES c
on (B.CNTRY_NAME = C.CNTRY_NAME))
order by dist
fetch first 1 row only;

select B.CNTRY_NAME, R.name,
sum(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(B.GEOM, R.GEOM, 1), 1, 'unit=km'))
from COUNTRY_BOUNDARIES B, RIVERS R
where B.CNTRY_NAME = 'Poland'
and SDO_GEOM.RELATE(B.GEOM, 'DETERMINE', R.GEOM, 1) != 'DISJOINT'
group by B.CNTRY_NAME, R.name;