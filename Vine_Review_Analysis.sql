-- Temp Table
SELECT * INTO VINE_TEMP_TABLE 
FROM VINE_TABLE
WHERE TOTAL_VOTES >= 20
AND CAST(HELPFUL_VOTES AS FLOAT)/CAST(TOTAL_VOTES AS FLOAT) >= 0.5;

-- Vine Analysis Table

DROP TABLE IF EXISTS VINE_ANALYSIS;
CREATE TABLE VINE_ANALYSIS (
  VINE TEXT,
  ALL_REVIEWS INTEGER,
  FIVE_STAR_REVIEWS INTEGER,
  FIVE_STAR_REVIEWS_PERCENTAGE FLOAT DEFAULT 0
);

INSERT INTO VINE_ANALYSIS
SELECT * FROM (
	SELECT 
	VINE,
	COUNT(*) ALL_REVIEWS,
	COUNT(CASE WHEN STAR_RATING = 5 THEN 1 ELSE NULL END) FIVE_STAR_REVIEWS
	FROM VINE_TEMP_TABLE
	WHERE VINE = 'Y'
	GROUP BY VINE
	UNION
	SELECT 
	VINE,
	COUNT(*) ALL_REVIEWS,
	COUNT(CASE WHEN STAR_RATING = 5 THEN 1 ELSE NULL END) FIVE_STAR_REVIEWS
	FROM VINE_TEMP_TABLE
	WHERE VINE = 'N'
	GROUP BY VINE
	) A;

UPDATE VINE_ANALYSIS
SET FIVE_STAR_REVIEWS_PERCENTAGE = ROUND(CAST(FIVE_STAR_REVIEWS AS NUMERIC)/CAST(ALL_REVIEWS AS NUMERIC) * 100,2);

SELECT * FROM VINE_ANALYSIS;