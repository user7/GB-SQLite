.mode column
.print \n-- задание 1 --

CREATE TEMP VIEW courses_view AS
SELECT
    c.title course_title,
    s.number stream_number,
    d.last_started_date,
    g.course_grade_avg
FROM
    courses c -- курсы

    -- добавим дату потока, начавшегося последними
    JOIN (
        SELECT
            course_id,
            MAX(started_at) last_started_date
        FROM
            streams
        GROUP BY
            course_id
    ) AS d
    ON c.id = d.course_id

    -- добавим айди потока, начавшегося последним
    JOIN streams s ON s.course_id = c.id AND s.started_at = last_started_date

    -- добавим среднюю успеваемость по курсу
    JOIN (
        SELECT
            course_id,
            AVG(grade_avg) course_grade_avg
        FROM
            streams JOIN performance ON id = stream_id
        GROUP BY
            course_id
    ) AS g ON c.id = g.course_id
;
SELECT * FROM courses_view;


.print \n-- задание 2 --

CREATE TEMP VIEW check_teacher AS 
SELECT
    t.id teacher_id, t.name, t.surname, p.stream_id, p.grade_avg
FROM
    performance p LEFT JOIN teachers t ON t.id = p.teacher_id
;

.print \n-- до удаления, учитель #3:
SELECT * FROM check_teacher WHERE teacher_id = 3;

BEGIN TRANSACTION;
    DELETE FROM streams WHERE id IN (SELECT stream_id FROM performance WHERE teacher_id = 3);
    DELETE FROM performance WHERE teacher_id = 3;
    DELETE FROM teachers WHERE id = 3;
COMMIT;

.print \n-- после удаления, учитель #3:
SELECT * FROM check_teacher WHERE teacher_id = 3;


.print \n-- задание 3 --

CREATE TRIGGER check_grade_range BEFORE INSERT ON performance
BEGIN
    SELECT CASE
        WHEN NEW.grade_avg > 5 THEN RAISE(ABORT, 'grade_avg must be <= 5')
        WHEN NEW.grade_avg < 1 THEN RAISE(ABORT, 'grade_avg must be >= 1')
    END;
END;

.print \n-- перед вставкой
SELECT * FROM performance;

INSERT INTO performance VALUES (1, 2, 99);

.print \n-- после вставки 99
SELECT * FROM performance;

INSERT INTO performance VALUES (1, 2, 5);

.print \n-- после вставки 5
SELECT * FROM performance;

