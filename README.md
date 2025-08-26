# BookMyShow Database Design 


---

## Scope (as per prompt)
For a given theatre, users can view the next 7 dates; upon choosing a date, they see all shows running in that theatre along with show timings.

---

## Entities & Attributes

### 1) `theatre`
- `theatre_id` (PK)
- `theatre_name` (NOT NULL)
- `city`
- `address` (optional street/mall name)

### 2) `screen`
- `screen_id` (PK)
- `theatre_id` (FK → theatre.theatre_id)
- `screen_name` (e.g., Screen 1, Gold, Playhouse)

### 3) `movie`
- `movie_id` (PK)
- `title` (NOT NULL)
- `language` (e.g., Hindi, Telugu, English)
- `certificate` (e.g., UA, U, A)
- `video_format` (e.g., 2D, 3D, IMAX 2D)

### 4) `show`
Each scheduled run of a movie on a screen at a specific date & time.
- `show_id` (PK)
- `movie_id` (FK → movie.movie_id)
- `screen_id` (FK → screen.screen_id)
- `show_date` (DATE)
- `show_time` (TIME)
- `audio_format` (e.g., Dolby 7.1, 4K ATMOS, 4K Dolby 7.1)
- `base_price` (DECIMAL)

**Candidate keys / constraints**
- A screen cannot have two shows starting at the exact same instant → `UNIQUE(screen_id, show_date, show_time)`.

---

## Normalization (1NF → BCNF)
- **1NF:** All attributes are atomic (no repeating groups; each row has single-valued columns).
- **2NF:** Non-key attributes in `show` depend on the whole key; our primary key is `show_id` (surrogate), with a uniqueness constraint on `(screen_id, show_date, show_time)` to model the natural key. No partial dependency exists.
- **3NF:** No transitive dependencies; theatre details are in `theatre`, screens in `screen`, movies in `movie`, and scheduling in `show`.
- **BCNF:** All functional dependencies have a superkey on the left; the only determinants for row values are the table keys (e.g., `(screen_id, show_date, show_time)` identifies a show).





---

## Sample Rows (from `schema.sql`)
- **Theatre:** PVR: Nexus (Forum Mall) in Bangalore
- **Movies:** Dasara (Telugu, UA, 2D), Kisi Ka Bhai Kisi Ki Jaan (Hindi, UA, 2D), Tu Jhoothi Main Makkaar (Hindi, UA, 2D), Avatar: The Way of Water (English, UA, 3D)
- **Screens:** Screen 1, Screen 2
- **Shows (25-Apr-2023):** Multiple times across screens with audio formats like Dolby 7.1, 4K ATMOS.

---
## Files
- `schema.sql` – run directly on MySQL (DDL + DML + P2 Query)
- `README.md` – this document
- ---