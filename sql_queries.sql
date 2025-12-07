-- Average rating per year
SELECT
  review_year,
  AVG(rating) AS avg_rating
FROM main.default.clean_zomato_reviews
GROUP BY review_year
ORDER BY review_year;

-- Average helpful votes per rating
SELECT
  rating,
  AVG(helpful) AS avg_helpful
FROM main.default.clean_zomato_reviews
GROUP BY rating
ORDER BY rating;
