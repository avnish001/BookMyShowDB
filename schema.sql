-- BookMyShow Database Design – MySQL Schema & Sample Data
-- Safe to run multiple times: drops and recreates objects

DROP TABLE IF EXISTS showtime;
DROP TABLE IF EXISTS screen;
DROP TABLE IF EXISTS movie;
DROP TABLE IF EXISTS theatre;

-- ========================
-- Tables (DDL)
-- ========================

CREATE TABLE theatre (
    theatre_id   INT AUTO_INCREMENT PRIMARY KEY,
    theatre_name VARCHAR(120) NOT NULL,
    city         VARCHAR(80),
    address      VARCHAR(200),
    UNIQUE KEY uk_theatre_name_city (theatre_name, city)
) ENGINE=InnoDB;

CREATE TABLE screen (
    screen_id   INT AUTO_INCREMENT PRIMARY KEY,
    theatre_id  INT NOT NULL,
    screen_name VARCHAR(80) NOT NULL,
    CONSTRAINT fk_screen_theatre
        FOREIGN KEY (theatre_id) REFERENCES theatre(theatre_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE KEY uk_screen_per_theatre (theatre_id, screen_name)
) ENGINE=InnoDB;

CREATE TABLE movie (
    movie_id     INT AUTO_INCREMENT PRIMARY KEY,
    title        VARCHAR(160) NOT NULL,
    language     VARCHAR(40)  NOT NULL,
    certificate  VARCHAR(10),
    video_format VARCHAR(30)  NOT NULL,
    KEY idx_movie_title_lang (title, language)
) ENGINE=InnoDB;

CREATE TABLE showtime (
    show_id      INT AUTO_INCREMENT PRIMARY KEY,
    movie_id     INT NOT NULL,
    screen_id    INT NOT NULL,
    show_date    DATE NOT NULL,
    show_time    TIME NOT NULL,
    audio_format VARCHAR(40),
    base_price   DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT fk_show_movie
        FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_show_screen
        FOREIGN KEY (screen_id) REFERENCES screen(screen_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE KEY uk_screen_datetime (screen_id, show_date, show_time),
    KEY idx_show_date (show_date),
    KEY idx_show_movie (movie_id)
) ENGINE=InnoDB;

-- ========================
-- Sample Data (DML)
-- ========================

INSERT INTO theatre (theatre_name, city, address) VALUES
('PVR: Nexus (Forum Mall)', 'Bangalore', 'Forum Mall, Koramangala');

INSERT INTO movie (title, language, certificate, video_format) VALUES
('Dasara', 'Telugu', 'UA', '2D'),
('Kisi Ka Bhai Kisi Ki Jaan', 'Hindi', 'UA', '2D'),
('Tu Jhoothi Main Makkaar', 'Hindi', 'UA', '2D'),
('Avatar: The Way of Water', 'English', 'UA', '3D');

-- Assuming the inserted theatre_id = 1
INSERT INTO screen (theatre_id, screen_name) VALUES
(1, 'Screen 1'),
(1, 'Screen 2');

-- Map movie titles to ids for clarity
-- (In real use, fetch IDs after insert. Here we assume auto-increment order.)
-- 1: Dasara, 2: Kisi Ka Bhai Kisi Ki Jaan, 3: Tu Jhoothi Main Makkaar, 4: Avatar: The Way of Water

INSERT INTO showtime (movie_id, screen_id, show_date, show_time, audio_format, base_price) VALUES
(1, 1, '2023-04-25', '12:15:00', '4K Dolby 7.1', 250.00),
(2, 1, '2023-04-25', '13:00:00', '4K ATMOS', 300.00),
(2, 1, '2023-04-25', '16:10:00', '4K ATMOS', 300.00),
(2, 2, '2023-04-25', '19:20:00', '4K ATMOS', 300.00),
(2, 2, '2023-04-25', '22:30:00', '4K ATMOS', 320.00),
(3, 1, '2023-04-25', '13:15:00', 'Dolby 7.1', 280.00),
(4, 2, '2023-04-25', '13:20:00', 'Playhouse', 350.00);

-- ========================
-- P2 – Query: all shows on a given date at a given theatre
-- ========================

-- Parameters (change as needed)
SET @p_theatre_name = 'PVR: Nexus (Forum Mall)';
SET @p_date = '2023-04-25';

SELECT
    t.theatre_name,
    s.screen_name,
    m.title       AS movie_title,
    m.language,
    sh.show_date,
    sh.show_time,
    sh.audio_format,
    sh.base_price
FROM showtime sh
JOIN movie m   ON sh.movie_id  = m.movie_id
JOIN screen s  ON sh.screen_id = s.screen_id
JOIN theatre t ON s.theatre_id = t.theatre_id
WHERE sh.show_date = @p_date
  AND t.theatre_name = @p_theatre_name
ORDER BY s.screen_name, sh.show_time;