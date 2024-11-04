--zadanie 1
SELECT SUM(ST_Length(geometry)) AS dlugosc_drog FROM roads;

--zadanie 2
SELECT ST_AsText(geometry) AS wkt, ST_Area(geometry) AS powierzchnia, ST_Perimeter(geometry) AS obwod
FROM buildings
WHERE name = 'BuildingA';

--zadanie 3
SELECT name AS nazwa, ST_Area(geometry) AS powierzchnia FROM buildings
ORDER BY name ASC;

--zadanie 4
SELECT name AS nazwa, ST_Perimeter(geometry) AS obwod FROM buildings
ORDER BY ST_Area(geometry) DESC
LIMIT 2;

--zadanie 5
SELECT ST_Distance(b.geometry, p.geometry) AS distance
FROM buildings b, poi p
WHERE b.name = 'BuildingC' AND p.name = 'K';

--zadanie 6
SELECT ST_Area(ST_Difference(bc.geometry, ST_Buffer(bb.geometry, 0.5))) AS area
FROM buildings bc, buildings bb
WHERE bc.name = 'BuildingC' AND bb.name = 'BuildingB';

--zadanie 7
SELECT b.name AS nazwa, ST_Centroid(b.geometry) AS centroid
FROM buildings b
WHERE ST_Y(ST_Centroid(b.geometry)) > 4.5;

--zadanie 8
SELECT ST_Area(ST_Difference(bc.geometry, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))', 0))) AS area
FROM buildings bc
WHERE bc.name = 'BuildingC';