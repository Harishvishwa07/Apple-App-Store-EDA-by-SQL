CREATE TABLE applestore_description_combined as 

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4;

** EXPLORATORY_DATA_ANALYSIS **

-- Check the no. of unique apps in both the applestore tablesAppleStore

SELECT COUNT (DISTINCT id) AS UniqueAppIDs
FROM AppleStore;

SELECT COUNT (DISTINCT id) AS UniqueAppIDs
FROM applestore_description_combined;

-- Check for any missing values

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL;


SELECT COUNT(*) AS MissingValues
FROM applestore_description_combined
WHERE app_desc IS NULL;

-- Find out the no. of apps per genre

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP By prime_genre
ORDER BY NumApps DESC;

-- Get an overview of the app's ratings

SELECT MIN(user_rating) AS MinRating,
       MAX(user_rating) AS MaxRating,
       AVG(user_rating) AS AvgRating
FROM AppleStore;

-- Determine whether paid apps have higher ratings than free appsAppleStore

SELECT CASE
            WHEN price > 0 THEN 'Paid'
            ELSE 'Free'
            END AS App_Type,
            avg(user_rating) AS AvgRating
FROM AppleStore
GROUP BY App_Type;

-- Check if apps with more supported languages have higher ratings

SELECT CASE
           WHEN lang_num < 10 THEN '< 10 languages'
           WHEN lang_num BETWEEN 10 AND 30 THEN '10 to 30 languages'
           ELSE '>30 languages'
         END AS Language_bucket,
         avg(user_rating) AS AvgRating
FROM AppleStore
GROUP BY Language_bucket
ORDER BY AvgRating DESC;

-- Check genre with low ratings

SELECT prime_genre,
       avg(user_rating) AS AvgRating
FROM AppleStore
GROUP BY prime_genre
ORDER BY AvgRating ASC
LIMIT 10;

-- Check if there is any correlation between the length of the app description and user rating

SELECT CASE
           WHEN length (B.app_desc) < 500 THEN 'Short'
           WHEN length(B.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
           ELSE 'Long'
END AS description_length_bucket,
avg(A.user_rating) AS AvgRating

FROM AppleStore A
JOIN
applestore_description_combined B
ON A.id = B.id

GROUP BY description_length_bucket
ORDER BY AvgRating DESC;

-- Check the top rated apps for each genreAppleStore

SELECT
      prime_genre,
      track_name,
      user_rating
FROM (
      SELECT
      prime_genre,
      track_name,
      user_rating,
      RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
      FROM
      AppleStore
      )
      AS A
WHERE
A.rank = 1;

** Conclusion **

-- Recommendation to client:

-- Paid Apps have better ratings.AppleStore.
-- Apps supporting between 10 to 30 languages have better ratings.
-- Finance and Book apps have low ratings. 
-- Apps with longer distance have better ratings.
-- A new app should aim for an average rating > 3.5 
-- Games and Entertainment have high competition.








            
            
            
            
            
          




