create table FIGURY
(
    id      number(1) primary key,
    ksztalt MDSYS.SDO_GEOMETRY
);

insert into FIGURY values(
    1, SDO_GEOMETRY(2007, NULL, NULL,
        SDO_ELEM_INFO_ARRAY(1, 1003, 4),
        SDO_ORDINATE_ARRAY(5,7, 3,5, 5,3))
                         );

insert into FIGURY values(
    4, SDO_GEOMETRY(2007, NULL, NULL,
        SDO_ELEM_INFO_ARRAY(1, 1003, 1),
        SDO_ORDINATE_ARRAY(1,1, 5,1, 5,5, 1,5, 1,1))
                         );

insert into FIGURY values(
    5, SDO_GEOMETRY(2002, NULL, NULL,
        SDO_ELEM_INFO_ARRAY(1,4,2, 1,2,1, 5,2,2),
        SDO_ORDINATE_ARRAY(3,2, 6,2, 7,3, 8,2, 7,1))
                         );

Insert into FIGURY values (
    6, SDO_GEOMETRY(2003, NULL, NULL,
        SDO_ELEM_INFO_ARRAY(1, 1003, 1),
        SDO_ORDINATE_ARRAY(0,1, -0.5,0.3, -1,0, -0.5,-0.3, -0.5,-1, 0,-0.5, 0.5,-1, 0.5,-0.3, 1,0, 0.5,0.3, 0,1))
);


Select id, SDO_GEOM.VALIDATE_GEOMETRY_WITH_CONTEXT(ksztalt, 0.005)
       from FIGURY;

Delete from FIGURY where ID in (2,3);

commit ;