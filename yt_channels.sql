CREATE DATABASE youtube_channels;

CREATE SCHEMA data;
USE data;

CREATE TABLE `yt_channels` (
    `index` INT NOT NULL PRIMARY KEY,
    `rank` INT NOT NULL,
    `channel_name` VARCHAR(50) NOT NULL,
    `subscriber_count` INT,
    `video_views` BIGINT,
    `video_count` INT,
    `genre` VARCHAR(50) NOT NULL,
    `channel_started` YEAR
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\top-300-youtube-channels.csv'
INTO TABLE yt_channels
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- We want to celebrate the 10 year anniversary of channels created in 2013. Which channels should we celebrate?
SELECT 
	channel_name, 
    channel_started
FROM yt_channels
WHERE channel_started = 2013;

-- Which three channels have posted the greatest number of videos?
SELECT
	channel_name, 
    video_count
FROM yt_channels
ORDER BY video_count DESC
LIMIT 3;

-- What is the average number of views for each genre? Sort from largest to smallest average number of views.
SELECT
	genre,
    AVG(video_views)
FROM yt_channels
GROUP BY genre
ORDER BY AVG(video_views) DESC;

-- Provide a table with which we can easily compare the average, minimum, and maximum subscriber count against each channel.
SELECT 
	channel_name, 
	genre, 
    subscriber_count, 
    AVG(subscriber_count) OVER(),
    MIN(subscriber_count) OVER(),
    MAX(subscriber_count) OVER()
FROM yt_channels;

-- Which creators are the most active in terms of posting? Provide the rank (dense and regular) for each channel based on number of videos both within its genre and overall.
SELECT
   channel_name,
   genre,
   video_count,
   RANK() OVER(PARTITION BY genre ORDER BY video_count DESC) as genre_video_count_rank,
   RANK() OVER(ORDER BY video_count DESC) as overall_rank,
   DENSE_RANK() OVER(ORDER BY video_count DESC) as overall_dense_rank
FROM yt_channels ORDER BY overall_rank;

-- What is the highest # of subscribers in each channel's respective genre as well as overall highest subscriber count?
SELECT
   channel_name,
   genre,
   subscriber_count,
   FIRST_VALUE(channel_name) OVER(PARTITION BY genre ORDER BY subscriber_count DESC) as most_subscribers_genre,
   FIRST_VALUE(channel_name) OVER(ORDER BY subscriber_count DESC) as most_subscribers_overall
FROM yt_channels;

-- For each channel, show the difference between its view count and the next highest view count in the same genre.
SELECT
   channel_name,
   genre,
   video_views,
   video_views - LAG(video_views) OVER(PARTITION BY genre ORDER BY video_views DESC) as genre_views_diff
FROM yt_channels;
