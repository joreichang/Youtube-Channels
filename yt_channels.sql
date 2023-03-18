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


