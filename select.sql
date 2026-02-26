
-- PART 1: Basic SELECT queries


-- 1. Title and duration of the longest track
SELECT title, duration
FROM tracks
ORDER BY duration DESC
LIMIT 1;

-- 2. Titles of tracks with duration of at least 3.5 minutes (210 seconds)
SELECT title, duration
FROM tracks
WHERE duration >= 210
ORDER BY duration;

-- 3. Titles of compilations released between 2018 and 2020 inclusive
SELECT title, year
FROM compilations
WHERE year BETWEEN 2018 AND 2020
ORDER BY year;

-- 4. Artists whose name consists of a single word (contains no spaces)
SELECT name
FROM artists
WHERE name NOT LIKE '% %'
ORDER BY name;

-- 5. Titles of tracks that contain the word "my" or "tu" (FIXED VERSION)
--    Using ILIKE with proper word boundary checks (8 conditions total)

SELECT title
FROM tracks
WHERE 
    -- For word "my" (4 conditions)
    title ILIKE 'my'           -- exact match
    OR title ILIKE 'my %'       -- at the beginning
    OR title ILIKE '% my'       -- at the end
    OR title ILIKE '% my %'     -- in the middle
    -- For word "tu" (4 conditions)
    OR title ILIKE 'tu'
    OR title ILIKE 'tu %'
    OR title ILIKE '% tu'
    OR title ILIKE '% tu %'
ORDER BY title;



-- PART 2: JOIN queries
-- 1. Number of artists in each genre
SELECT g.name AS genre, COUNT(ag.artist_id) AS artist_count
FROM genres g
LEFT JOIN artist_genre ag ON g.id = ag.genre_id
GROUP BY g.id, g.name
ORDER BY artist_count DESC;

-- 2. Number of tracks included in albums from 2019–2020
SELECT COUNT(t.id) AS track_count
FROM tracks t
JOIN albums a ON t.album = a.id
WHERE a.year BETWEEN 2019 AND 2020;

-- 3. Average track duration by album
SELECT 
    a.title AS album,
    ROUND(AVG(t.duration), 2) AS avg_duration_sec,
    CONCAT(ROUND(AVG(t.duration) / 60, 2), ' min') AS avg_duration_min
FROM albums a
JOIN tracks t ON a.id = t.album
GROUP BY a.id, a.title
ORDER BY AVG(t.duration) DESC;

-- 4. All artists who did not release albums in 2020
SELECT DISTINCT ar.name AS artist
FROM artists ar
WHERE ar.name NOT IN (
    SELECT DISTINCT aa.artist_id
    FROM album_artist aa
    JOIN albums a ON aa.album_id = a.id
    WHERE a.year = 2020
)
ORDER BY ar.name;

-- 5. Names of compilations that feature a specific artist (Zemfira)
SELECT DISTINCT c.title AS compilation, c.year AS release_year
FROM compilations c
JOIN compilation_track tc ON c.id = tc.compilation_id
JOIN tracks t ON tc.track_id = t.id
JOIN albums a ON t.album = a.id
JOIN album_artist aa ON a.id = aa.album_id
JOIN artists ar ON aa.artist_id = ar.name
WHERE ar.name = 'Zemfira'
ORDER BY c.year;
