SELECT char(10) || '-- задание 1 --';

CREATE TEMP VIEW stream_teacher_grade
AS
SELECT
    id teacher_id,
    name || ' ' || surname teacher_name,
    grade_avg,
    stream_id
FROM
    teachers t, performance p
WHERE
    t.id = p.teacher_id
;

SELECT
    number,
    (SELECT title FROM courses WHERE id = course_id) course_name,
    (SELECT teacher_name FROM stream_teacher_grade WHERE id = stream_id),
    students_n
FROM streams s
WHERE students_n >= 40;

SELECT char(10) || '-- задание 2 --';

SELECT
    number,
    (SELECT title FROM courses WHERE id = course_id) course_name,
    teacher_name,
    grade_avg
FROM
    streams s, stream_teacher_grade stg
WHERE
    s.id = stg.stream_id
ORDER BY
    grade_avg
LIMIT 2
;

SELECT char(10) || '-- задание 3 --';

SELECT
    teacher_id,
    AVG(grade_avg)
FROM
    stream_teacher_grade
WHERE
    teacher_name = 'Николай Савельев'
GROUP BY
    teacher_id
;

SELECT char(10) || '-- задание 4 --';

SELECT
    stream_id,
    teacher_name
FROM
    stream_teacher_grade
WHERE
    teacher_name = 'Наталья Петрова'
UNION
SELECT
    stream_id,
    teacher_name
FROM
    stream_teacher_grade
WHERE
    grade_avg < 4.8
;

SELECT char(10) || '-- задание 5 --';
SELECT MAX(grade) - MIN(grade) FROM (
    SELECT
        teacher_id,
        AVG(grade_avg) grade
    FROM
        stream_teacher_grade
    GROUP BY
        teacher_name
);
