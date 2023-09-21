CREATE TABLE applestore_description_combined as 

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4;

** EXPLORATORY DATA ANALYSIS **

-- Check the no. of unique apps in both the applestore tablesAppleStore

SELECT count (DISTINCT id) as UniqueAppIDs
from AppleStore;

SELECT count (DISTINCT id) as UniqueAppIDs
from applestore_description_combined;

-- Check for any missing values

SELECT COUNT(*) as MissingValues
from AppleStore
where track_name is null or user_rating is null or prime_genre is NULL;


SELECT COUNT(*) as MissingValues
from applestore_description_combined
where app_desc is NULL;

-- Find out the no. of apps per genre

SELECT prime_genre, COUNT(*) as NumApps
from AppleStore
GROUP by prime_genre
order BY NumApps DESC;

-- Get an overview of the app's ratings

SELECT min(user_rating) as MinRating,
       max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
FROM AppleStore;

-- Determine whether paid apps have higher ratings than free appsAppleStore

SELECT CASE
            when price > 0 then 'Paid'
            ELSE 'Free'
            end as App_Type,
            avg(user_rating) as AvgRating
FROM AppleStore
GROUP BY App_Type;

-- Check if apps with more supported languages have higher ratings

SELECT CASE
           when lang_num < 10 THEN '< 10 languages'
           WHEn lang_num BETWEEN 10 and 30 THEN '10 to 30 languages'
           else '>30 languages'
         end as Language_bucket,
         avg(user_rating) as AvgRating
FROM AppleStore
GROUP BY Language_bucket
ORDER BY AvgRating DESC;

-- Check genre with low ratings

SELECT prime_genre,
       avg(user_rating) as AvgRating
FROM AppleStore
GROUP BY prime_genre
ORDER BY AvgRating ASC
LIMIT 10;

-- Check if there is any correlation between the length of the app description and user rating

SELECT CASE
           when length (B.app_desc) < 500 THEN 'Short'
           WHEN length(B.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
           ELSE 'Long'
end as description_length_bucket,
avg(A.user_rating) as AvgRating

from AppleStore A
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
      RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) as rank
      FROM
      AppleStore
      )
      as A
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








            
            
            
            
            
          




