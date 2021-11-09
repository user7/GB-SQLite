.print \n-- задание 4, решение только через джойны --

SELECT
    name,
    surname,
    grade1      worst_grade,
    c1.title    worst_grade_course,
    grade2      best_grade,
    c2.title    best_grade_course,
    closest_start
FROM
    teachers t
    --
    -- worst grade part
    LEFT JOIN
    (SELECT
        tid1,
        grade1,
        MIN(stream_id) sid1 -- MIN instead of ANY
     FROM
        (SELECT
            id tid1,
            MIN(grade_avg) grade1 -- MIN = worst
         FROM
            teachers
            LEFT JOIN performance
            ON id = teacher_id
         GROUP BY tid1
        )
        LEFT JOIN performance 
        ON teacher_id = tid1 AND grade_avg = grade1
     GROUP BY tid1
    ) ON t.id = tid1
    LEFT JOIN streams s1
    ON sid1 = s1.id
    LEFT JOIN courses c1
    ON s1.course_id = c1.id
    --
    -- best grade part
    LEFT JOIN
    (SELECT
        tid2,
        grade2,
        MIN(stream_id) sid2 -- MIN instead of ANY
     FROM
        (SELECT
            id tid2,
            MAX(grade_avg) grade2 -- MAX = best
         FROM
            teachers
            LEFT JOIN performance
            ON id = teacher_id
         GROUP BY tid2
        )
        LEFT JOIN performance 
        ON teacher_id = tid2 AND grade_avg = grade2
     GROUP BY tid2
    )
    ON t.id = tid2
    LEFT JOIN streams s2
    ON sid2 = s2.id
    LEFT JOIN courses c2
    ON s2.course_id = c2.id
    --
    -- closest start 
    LEFT JOIN
    (SELECT tid3, MIN(CASE WHEN started_at > '2020-10-01' THEN started_at ELSE NULL END) closest_start
     FROM
        (SELECT
            t.id tid3,
            started_at
         FROM
            teachers t
            LEFT JOIN performance p
            ON p.teacher_id = t.id
            LEFT JOIN streams s
            ON p.stream_id = s.id
        )
     GROUP BY tid3
    )
    ON t.id = tid3
ORDER BY
    t.id
