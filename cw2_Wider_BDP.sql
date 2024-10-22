--1
SELECT matchid, player FROM gole WHERE teamid='POL';

--2

SELECT id, player
FROM mecze
JOIN gole ON mecze.id = gole.matchid
WHERE gole.player = 'Jakub Blaszczykowski' AND gole.matchid = 1004;

--3
SELECT gole.player AS zawodnik, druzyny.teamname AS druzyna, mecze.stadium, mecze.mdate
FROM gole
JOIN mecze ON gole.matchid = mecze.id
JOIN druzyny ON gole.teamid = druzyny.id
WHERE gole.teamid = 'POL';

--4
SELECT gole.player AS zawodnik, mecze.team1, mecze.team2, mecze.stadium, mecze.mdate
FROM gole
JOIN mecze ON gole.matchid = mecze.id
JOIN druzyny ON gole.teamid = druzyny.id
WHERE gole.player LIKE 'Mario%'

--5
SELECT gole.player AS Zawodnik, gole.teamid AS Zespol, druzyny.coach AS trener, gole.gtime AS Czas
FROM gole
JOIN mecze ON gole.matchid=mecze.id
JOIN druzyny ON gole.teamid=druzyny.id
WHERE gtime < 10;

--6
SELECT gole.teamid AS Zespol, druzyny.coach AS trener, mecze.mdate AS data_spotkania
FROM gole
JOIN druzyny ON gole.teamid=druzyny.id
JOIN mecze ON gole.matchid=mecze.id
WHERE druzyny.coach = 'Franciszek Smuda';

--7
SELECT gole.player AS zawodnik, mecze.stadium AS stadion
FROM gole
JOIN mecze ON gole.matchid=mecze.id
WHERE mecze.stadium='National Stadium, Warsaw';

--8
SELECT gole.player AS zawodnik, druzyny.teamname AS druzyna, mecze.team1, mecze.team2, mecze.stadium, mecze.mdate
FROM gole
JOIN mecze ON gole.matchid = mecze.id
JOIN druzyny ON gole.teamid = druzyny.id
WHERE (mecze.team1 = 'GER' OR mecze.team2 = 'GER') 
  AND gole.teamid != 'GER';

--9
SELECT druzyny.teamname AS drużyna, COUNT(gole.player) AS liczba_goli
FROM gole
JOIN druzyny ON gole.teamid = druzyny.id
GROUP BY druzyny.teamname
ORDER BY liczba_goli DESC;

--10
SELECT mecze.stadium AS stadion, COUNT(gole.player) AS liczba_goli
FROM mecze
JOIN gole ON gole.matchid = mecze.id
GROUP BY mecze.stadium
ORDER BY liczba_goli DESC;

