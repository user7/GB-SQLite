.mode column
.print \n-- задание 1 --

SELECT
    number,
    title,
    started_at
FROM
    streams JOIN courses c ON course_id = c.id
;

.print \n-- задание 2 --

SELECT
    title,
    SUM(students_n)
FROM
    streams JOIN courses c ON course_id = c.id
GROUP BY
    title
;

.print \n-- задание 3 --

SELECT
    t.id,
    name || ' ' || surname name,
    AVG(grade_avg)
FROM
    teachers t
    LEFT JOIN performance p ON p.teacher_id = t.id
    LEFT JOIN streams s ON p.stream_id = s.id
GROUP BY
    t.id 
;

.print \n-- задание 4, решение через оконные функции --

# Для каждого преподавателя выведите
#  имя,
#  фамилию,
#  минимальное значение успеваемости по всем потокам преподавателя,
#  название курса, соответствующего потоку с минимальным значением успеваемости,
#  максимальное значение успеваемости по всем потокам преподавателя,
#  название курса, соответствующего потоку с максимальным значением успеваемости,
#  дату начала следующего потока

# вместо DATE('now') захардкодил '2020-10-01', чтобы пример не менялся со временем

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

.print \n-- задание 4, решение через джойны --


# связка teachers-performance-stream
CREATE TEMP VIEW tps AS
SELECT
    t.id teacher_id,
    grade_avg,
    started_at
FROM
    teachers t
    LEFT JOIN performance p ON p.teacher_id = t.id
    LEFT JOIN streams s ON p.stream_id = s.id
;


# худшая оценка каждого учителя twg = Teacher`s Worst Grade
CREATE TEMP VIEW twg AS
SELECT
    teacher_id,
    MIN(grade_avg) worst_grade
FROM
    tps
GROUP BY
    teacher_id
;


# лучшая оценка каждого учителя tbg = Teacher`s Best Grade
CREATE TEMP VIEW tbg AS
SELECT
    teacher_id,
    MAX(grade_avg) best_grade
FROM
    tps
GROUP BY
    teacher_id
;


# худшая оценка и её стрим
CREATE TEMP VIEW twgs AS
SELECT
    twg.teacher_id,
    worst_grade,
    MIN(stream_id) stream_id
FROM
    twg LEFT JOIN performance p ON p.teacher_id = twg.teacher_id AND p.grade_avg = twg.worst_grade
GROUP BY
    twg.teacher_id, worst_grade
;


# лучшая оценка и её стрим
CREATE TEMP VIEW tbgs AS
SELECT
    tbg.teacher_id,
    best_grade,
    MIN(stream_id) stream_id
FROM
    tbg LEFT JOIN performance p ON p.teacher_id = tbg.teacher_id AND p.grade_avg = tbg.best_grade
GROUP BY
    tbg.teacher_id, best_grade
;


# связка teacher - ближайшая дата начала курса, может быть NULL
CREATE TEMP VIEW t_start AS
SELECT
    teacher_id,
    MIN(CASE WHEN started_at > '2020-10-01' THEN started_at ELSE NULL END) closest_stream_start
FROM
    tps
GROUP BY
    teacher_id
;


SELECT 
    name,
    surname,
    worst_grade,
    cw.title,
    best_grade,
    cb.title,
    closest_start
FROM
    teachers t

    JOIN twgs ON t.id = twgs.teacher_id
    JOIN streams sw ON sw.id = twgs.stream_id
    JOIN courses cw ON sw.course_id = cw.id

    JOIN tbgs ON t.id = tbgs.teacher_id
    JOIN streams sb ON sb.id = tbgs.stream_id
    JOIN courses cb ON sb.course_id = cb.id

    JOIN t_start ON t.id = t_start.teacher_id
;

# TODO: то ли задача ненормальная, то ли я не вижу нормального решения,
#       если решение действительно такое сложное, то автору задачи двойка.
