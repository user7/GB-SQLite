CREATE TABLE teachers (
    id          INTEGER     PRIMARY KEY,
    name        TEXT        NOT NULL,
    surname     TEXT        NOT NULL,
    email       TEXT        NOT NULL
);

CREATE TABLE courses (
    id          INTEGER     PRIMARY KEY,
    title       TEXT        NOT NULL
);

CREATE TABLE streams (
    id          INTEGER     PRIMARY KEY,
    course_id   INTEGER     NOT NULL,
    number      INTEGER     NOT NULL,
    started_at  TEXT        NOT NULL,
    students_n  INTEGER     NOT NULL,

    CONSTRAINT fk_course
        FOREIGN KEY (course_id)
        REFERENCES courses (id)
);

CREATE TABLE performance (
    teacher_id  INTEGER     NOT NULL,
    stream_id   INTEGER     NOT NULL,
    grade_avg   REAL        NOT NULL,

    CONSTRAINT pk_achievements
        PRIMARY KEY (teacher_id, stream_id),

    CONSTRAINT fk_teachers
        FOREIGN KEY (teacher_id)
        REFERENCES teachers (id),

    CONSTRAINT fk_streams
        FOREIGN KEY (stream_id)
        REFERENCES streams (id)
);

INSERT INTO teachers (id, name, surname, email) VALUES
    (1, 'Николай', 'Савельев', 'saveliev.n@mail.ru'),
    (2, 'Наталья', 'Петрова',  'petrova.n@ayndex.ru'),
    (3, 'Елена',   'Малышева', 'malisheva.e@google.com'),
    (4, 'Макарий', 'Старцев',  'e@example.com')
;

INSERT INTO courses (id, title) VALUES
    (1, 'Базы Данных'),
    (2, 'Основы Python'),
    (3, 'Linux. Рабочая станция')
;

INSERT INTO streams (id, course_id, number, started_at, students_n) VALUES
    (1, 3, 165, '2020-08-18', 34),
    (2, 2, 178, '2020-10-02', 37),
    (3, 1, 203, '2020-11-12', 35),
    (4, 2, 210, '2020-11-03', 41)
;

INSERT INTO performance (teacher_id, stream_id, grade_avg) VALUES
    (3, 1, '4.7'),
    (2, 2, '4.9'),
    (1, 3, '4.8'),
    (1, 4, '4.9')
;
