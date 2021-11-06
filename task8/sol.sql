.mode column
.print \n-- задание 1 --

SELECT DISTINCT
    title course_title,
    SUM(s.students_n) OVER (PARTITION BY c.id)
FROM
    courses c JOIN streams s ON c.id = s.course_id
ORDER BY
    title
;

.print \n-- задание 2 --

SELECT DISTINCT
    t.id,
    name || ' ' || surname name,
    AVG(grade_avg) OVER (PARTITION BY t.id)
FROM
    teachers t
    LEFT JOIN performance p ON p.teacher_id = t.id
    LEFT JOIN streams s ON p.stream_id = s.id
;

.print \n-- задание 3 --

-- 3. Какие индексы надо создать для максимально быстрого выполнения представленного запроса?
-- 
-- SELECT
--   surname,
--   name,
--   number,
--   performance
-- FROM academic_performance
--   JOIN teachers
--     ON academic_performance.teacher_id = teachers.id
--   JOIN streams
--     ON academic_performance.stream_id = streams.id
-- WHERE number >= 200;

-- Индексы:
-- teachers id
-- academic_performance teacher_id
-- streams id
-- academic_performance stream_id

.print \n-- задание 5 --

SELECT DISTINCT
    name,
    surname,
    FIRST_VALUE(grade_avg) OVER win AS worst_grade,
    FIRST_VALUE(title) OVER win AS worst_grade_course,
    LAST_VALUE(grade_avg) OVER win AS best_grade,
    LAST_VALUE(title) OVER win AS best_grade_course,
    MIN(CASE WHEN started_at >= '2020-10-01' THEN started_at ELSE NULL END)
            OVER date_win AS closest_stream_start
FROM
    teachers t
    LEFT JOIN performance p ON p.teacher_id = t.id
    LEFT JOIN streams s ON p.stream_id = s.id
    LEFT JOIN courses c ON s.course_id = c.id
WINDOW
    win AS (
        PARTITION BY t.id
        ORDER BY grade_avg
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ),
    date_win AS (
        PARTITION BY t.id
        ORDER BY started_at
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    )
;
