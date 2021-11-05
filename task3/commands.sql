# 1. Переименовать start_date в started_at.
ALTER TABLE streams RENAME COLUMN start_date TO started_at;

# 2. Добавить в streams колонку finished_at
ALTER TABLE streams ADD COLUMN finished_at TEXT NOT NULL;

# 3. Привести данные в соответствие с методичкой.
INSERT INTO teachers (id, name, surname, email) VALUES
    (1, 'Николай', 'Савельев', 'saveliev.n@mail.ru'),
    (2, 'Наталья', 'Петрова', 'petrova.n@ayndex.ru'),
    (3, 'Елена', 'Малышева', 'malisheva.e@google.com')
;

INSERT INTO courses (id, title) VALUES
    (1, 'Базы Данных'),
    (2, 'Основы Python'),
    (3, 'Linux. Рабочая станция')
;

# убираем лишнюю колонку из п2, для неё нет данных в методичке
ALTER TABLE streams DROP COLUMN finished_at;

INSERT INTO streams (id, course_id, number, started_at, students_n) VALUES
    (1, 3, 165, '18.08.2020', 34),
    (2, 2, 178, '02.10.2020', 37),
    (3, 1, 203, '12.11.2020', 35),
    (4, 1, 210, '03.11.2020', 41)
;

# косметика, более лучшее имя
ALTER TABLE achievements RENAME TO performance;

INSERT INTO performance (teacher_id, stream_id, grade_avg) VALUES
    (3, 1, '4.7'),
    (2, 2, '4.9'),
    (1, 3, '4.8'),
    (1, 4, '4.9')
;

# 4. "Дополнительное задание (выполняется по желанию): в таблице успеваемости измените
# тип столбца «Ключ потока» на REAL. Выполните задание на таблице с данными."
#
# Непонятен смысл задания. Во-первых, зачем менять тип ключа на REAL, этот тип не 
# предназначен для ключей и не подходит для них. Во-вторых, ALTER TABLE в SQLite не 
# поддерживает такую операцию, таблицу придётся пересоздать:

PRAGMA foreign_keys=off;
BEGIN TRANSACTION;

# создаём новую таблицу
CREATE TABLE p2 (
	teacher_id INTEGER NOT NULL,
	stream_id REAL NOT NULL,
	grade_avg REAL NOT NULL,
	
	CONSTRAINT pk_performance PRIMARY KEY (teacher_id, stream_id),
	CONSTRAINT fk_teachers2 FOREIGN KEY (teacher_id) REFERENCES teachers (id),
	CONSTRAINT fk_streams2 FOREIGN KEY (stream_id) REFERENCES streams (id)
);

# копируем данные из старой, дропаем старую, переименовываем новую
INSERT INTO p2 (teacher_id, stream_id, grade_avg) SELECT * FROM performance;
DROP TABLE performance;
ALTER TABLE p2 RENAME TO performance;

COMMIT;
PRAGMA foreign_keys=on;

# Это ли имелось в виду?