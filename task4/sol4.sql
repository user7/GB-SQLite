#1
UPDATE streams SET
    started_at = 
        SUBSTR(started_at, 7, 4) || "-" ||
        SUBSTR(started_at, 4, 2) || "-" ||
        SUBSTR(started_at, 1, 2)
;

#2
SELECT id, number FROM streams ORDER BY started_at LIMIT 1;

#3
SELECT SUBSTR(started_at, 1, 4) year FROM streams GROUP BY year;

#4
SELECT count(id) total_teachers FROM teachers;

#5
SELECT started_at FROM streams ORDER BY started_at DESC LIMIT 2;

#6
SELECT AVG(grade_avg) FROM performance WHERE teacher_id = 1;

#7
SELECT id FROM (
    SELECT AVG(grade_avg) teacher_avg, id
    FROM teachers, performance
    WHERE teacher_id = id
    GROUP BY id
) WHERE teacher_avg < 4.8;
