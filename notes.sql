
CREATE TABLE dim_author (
	author varchar(256) NOT NULL
)

INSERT INTO dim_author
SELECT DISTINCT author
FROM dim_book_star;

-----------------------

-- Create a new table for dim_author with an author column
CREATE TABLE dim_author (
    author varchar(256)  NOT NULL
);

-- Insert authors 
INSERT INTO dim_author
SELECT DISTINCT author FROM dim_book_star;

-- Add a primary key 
ALTER TABLE dim_author ADD COLUMN author_id SERIAL PRIMARY KEY;

-- Output the new table
SELECT * FROM dim_author;

-----------------------

-- Output each state and their total sales_amount
SELECT dim_store_star.state, SUM(sales_amount)
FROM fact_booksales
	-- Join to get book information
    JOIN dim_book_star on dim_store_star.book_id = fact_booksales.book_id
	-- Join to get store information
    JOIN dim_store_star on ___.store_id = ___.store_id
-- Get all books with in the novel genre
WHERE  
    dim_book_star.genre = 'novel'
-- Group results by state
GROUP BY
    dim_store_star.state;



-- Query Star Scheme
SELECT dim_store_star.state, SUM(sales_amount)
FROM fact_booksales
JOIN dim_book_star 
ON fact_booksales.book_id = dim_book_star.book_id
JOIN dim_store_star 
ON fact_booksales.store_id = dim_store_star.store_id
WHERE dim_book_star.genre = 'novel'
GROUP BY dim_store_star.state;


-- Query Snowflake Scheme
SELECT dim_state_sf.state, SUM(sales_amount)
FROM fact_booksales
JOIN dim_book_sf
ON fact_booksales.book_id = dim_book_sf.book_id
JOIN dim_genre_sf
ON dim_book_sf.genre_id = dim_genre_sf.genre_id
JOIN dim_store_sf
ON fact_booksales.store_id = dim_store_sf.store_id
JOIN dim_city_sf 
ON dim_store_sf.city_id = dim_city_sf.city_id
JOIN dim_state_sf 
ON dim_city_sf.state_id = dim_state_sf.state_id
WHERE dim_genre_sf.genre = 'novel'
GROUP BY dim_state_sf.state;

SELECT * FROM information_schema.views
WHERE is_updatable = 'YES';

-- Create a new table called film_descriptions
CREATE TABLE film_descriptions (
    film_id INT,
    long_description TEXT
);

-- Create a new table called film_descriptions
CREATE TABLE film_descriptions (
    film_id INT,
    long_description TEXT
);

-- Create a new table called film_descriptions
CREATE TABLE film_descriptions (
    film_id INT,
    long_description TEXT
);

-- Create a new table called film_descriptions
CREATE TABLE film_descriptions (
    film_id INT,
    long_description TEXT
);

-- Copy the descriptions from the film table
INSERT INTO film_descriptions
SELECT film_id, long_description FROM film;
    
-- Drop the descriptions from the original table
ALTER TABLE film
DROP COLUMN long_description;

-- Join to view the original table
SELECT * FROM film_descriptions 
JOIN film USING(film_id);




-- Partitioning
CREATE TABLE film_partitioned (
  film_id INT,
  title TEXT NOT NULL,
  release_year TEXT
)
PARTITION BY LIST (release_year);

-- Create the partitions for 2019, 2018, and 2017
CREATE TABLE film_2019
	PARTITION OF film_partitioned FOR VALUES IN ('2019');

CREATE TABLE film_2018
	PARTITION OF film_partitioned FOR VALUES IN ('2018');

CREATE TABLE film_2017
	PARTITION OF film_partitioned FOR VALUES IN ('2017');

-- Insert the data into film_partitioned
INSERT INTO film_partitioned
SELECT film_id, title, release_year FROM film;

-- View film_partitioned
SELECT * FROM film_partitioned;



-- Aliases
SELECT c.code AS country_code, name, year, inflation_rate
FROM countries AS c
  -- Join to economies (alias e)
  INNER JOIN economies AS e
    -- Match on code
    ON c.code = e.code;


-- Inner Join
SELECT c.code, name, region, e.year, fertility_rate, unemployment_rate
  -- From countries (alias as c)
  FROM countries AS c
  -- Join to populations (as p)
  INNER JOIN populations AS p
    -- Match on country code
    ON c.code = p.country_code
  -- Join to economies (as e)
  INNER JOIN economies AS e
    -- Match on country code and year
    ON c.code = e.code
    AND e.year = p.year;


-- USING
SELECT c.name AS country, continent, l.name AS language, official
  -- From countries (alias as c)
  FROM countries AS c
  -- Join to languages (as l)
  INNER JOIN languages AS l
    -- Match using code
    USING (code);



-- Self-Join
SELECT p1.country_code,
       p1.size AS size2010, 
       p2.size AS size2015,
       -- Calculate growth_perc
       ((p2.size - p1.size)/p1.size * 100.0) AS growth_perc
-- From populations (alias as p1)
FROM populations AS p1
  -- Join to itself (alias as p2)
  INNER JOIN populations AS p2
    -- Match on country code
    ON p1.country_code = p2.country_code
        -- and year (with calculation)
        AND p1.year = p2.year - 5;

-- CASE
SELECT name, continent, code, surface_area,
    -- First case
    CASE WHEN surface_area > 2000000 THEN 'large'
        -- Second case
        WHEN surface_area > 350000 THEN 'medium'
        -- Else clause + end
        ELSE 'small' END
        -- Alias name
        AS geosize_group
-- From table
FROM countries;

-----  SUMMARY

SELECT country_code, size,
  CASE WHEN size > 50000000
            THEN 'large'
       WHEN size > 1000000
            THEN 'medium'
       ELSE 'small' END
       AS popsize_group
INTO pop_plus       
FROM populations
WHERE year = 2015;

-- Select fields
SELECT name, continent, geosize_group, popsize_group
-- From countries_plus (alias as c)
FROM countries_plus AS c
  -- Join to pop_plus (alias as p)
  INNER JOIN pop_plus AS p
    -- Match on country code
    ON c.code = p.country_code
-- Order the table    
ORDER BY geosize_group;


-----  SUMMARY
