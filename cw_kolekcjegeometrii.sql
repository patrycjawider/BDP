--zadanie1
CREATE TABLE obiekty(
id SERIAL PRIMARY KEY,
geometry GEOMETRY NOT NULL,
name VARCHAR(100)
);

INSERT INTO obiekty (geometry, name) 
VALUES (
    ST_Collect(ARRAY[
        ST_GeomFromText('LINESTRING(0 1, 1 1)', 0),
        ST_GeomFromText('CIRCULARSTRING(1 1, 2 0, 3 1)', 0),
        ST_GeomFromText('CIRCULARSTRING(3 1, 4 2, 5 1)', 0),
        ST_GeomFromText('LINESTRING(5 1, 6 1)', 0)
    ]), 
    'obiekt1'
),
	(ST_Collect(ARRAY[
        ST_GeomFromText('LINESTRING(10 6, 10 2)', 0),
        ST_GeomFromText('CIRCULARSTRING(10 2,12 0, 14 2)', 0),
        ST_GeomFromText('CIRCULARSTRING(14 2, 16 4, 14 6)', 0),
        ST_GeomFromText('LINESTRING(14 6, 10 6)', 0),
		ST_GeomFromText('CIRCULARSTRING(11 2, 13 2, 11 2)', 0)
    ]), 
    'obiekt2'
),
(ST_Collect(ARRAY[
        ST_GeomFromText('LINESTRING(10 17, 7 15)', 0),
        ST_GeomFromText('LINESTRING(7 15, 12 13)', 0),
        ST_GeomFromText('LINESTRING(12 13, 10 17)', 0)		
    ]), 
    'obiekt3'
),
(ST_Collect(ARRAY[
        ST_GeomFromText('LINESTRING(20 20, 25 25)', 0),
        ST_GeomFromText('LINESTRING(25 25, 27 24)', 0),
        ST_GeomFromText('LINESTRING(27 24, 25 22)', 0),
		ST_GeomFromText('LINESTRING(25 22, 26 21)', 0),
		ST_GeomFromText('LINESTRING(26 21, 22 19)', 0),
		ST_GeomFromText('LINESTRING(22 19, 20.5 19.5)', 0)
    ]), 
    'obiekt4'
),
(ST_Collect(ARRAY[
        ST_GeomFromText('POINT(30 30 59)', 0),
        ST_GeomFromText('POINT(38 42 234)', 0)
    ]), 
    'obiekt5'
	
),
(ST_Collect(ARRAY[
        ST_GeomFromText('LINESTRING(1 1, 3 2)', 0),
        ST_GeomFromText('POINT(4 2)', 0)
    ]), 
    'obiekt6'
);



---zadanie2

SELECT ST_ShortestLine(geometry1, geometry2) AS shortest_line
FROM (
    SELECT 
        (SELECT geometry FROM obiekty WHERE name = 'obiekt3') AS geometry1,
        (SELECT geometry FROM obiekty WHERE name = 'obiekt4') AS geometry2
) AS geometries;


SELECT ST_Area(ST_Buffer(ST_ShortestLine(geometry1, geometry2), 5)) AS buffer_area
FROM (
    SELECT 
        (SELECT geometry FROM obiekty WHERE name = 'obiekt3') AS geometry1,
        (SELECT geometry FROM obiekty WHERE name = 'obiekt4') AS geometry2
) AS geometries;


--zadanie3
--Aby obiekt4 mógł zostać poligon, musiałby być obiektem zamkniętym. Dlatego należało dodać
--odcinek łączący dwa końce obiektu, a powstał obiekt zamknięty. Następnie stworzono poligon

UPDATE obiekty
SET geometry = ST_Union(
    geometry,
    ST_GeomFromText('LINESTRING(20.5 19.5, 20 20)', 0)
)
WHERE name = 'obiekt4';


UPDATE obiekty
SET geometry = ST_LineMerge(geometry)
WHERE name = 'obiekt4';


--zadanie4

INSERT INTO obiekty (geometry, name)
SELECT ST_Union(geometry1, geometry2) AS combined_geometry, 'obiekt7'
FROM (
    SELECT 
        (SELECT geometry FROM obiekty WHERE name = 'obiekt3') AS geometry1,
        (SELECT geometry FROM obiekty WHERE name = 'obiekt4') AS geometry2
) AS geometries;


--zadanie5

SELECT id, name, geometry
FROM obiekty
WHERE NOT ST_HasArc(geometry);


SELECT name, ST_Area(ST_Buffer(geometry, 5)) AS buffer_area
FROM obiekty
WHERE NOT ST_HasArc(geometry);
