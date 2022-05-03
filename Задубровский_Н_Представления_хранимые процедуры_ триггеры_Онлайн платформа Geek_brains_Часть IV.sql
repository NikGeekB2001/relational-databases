

-- Хранимые процедуры
-- Задача 1
-- Необходимо написать хранимую процедуру, где выявляются курсы
-- по интересам пользователя просмотра вебинаров
-- Показать 5  курсов в случайной комбинации

use geekbrains;

-- обновим данные в базе, чтобы появились пользователи из одного города
UPDATE webinars 
SET name_webinar = 'analist'
WHERE webinar_programs = 'et';


DROP procedure if exists sp_webinars;
delimiter //
create procedure sp_webinars(for_user_id BIGINT)
begin
-- 	общие вебинары
select w2.user_id 
from webinars w1 
join webinars w2 on w1.name_webinar = w2.name_webinar 
 where w1.user_id = for_user_id and w2.user_id <> for_user_id
UNION 
--    Общие курсы
   select c2.users_id 
from courses c1 
join courses c2 on  c1.name_courses = c2.name_courses 
where c1.users_id = for_user_id and c2.users_id <>for_user_id
ORDER BY rand()
LIMIT 5; 
 
end //
 
delimiter ;

-- Вызов процедуры

call sp_webinars(1);


-- Хранимые процедуры
-- Задача 2
-- Необходимо написать хранимую процедуру, где подсчитываются общее 
-- количество курсов

DELIMITER //

DROP PROCEDURE IF EXISTS sp_numcourses//
CREATE PROCEDURE sp_numcourses (OUT total INT)
BEGIN
  SELECT COUNT(*) INTO total FROM courses;
END//
-- Вызов процедуры
CALL sp_numcourses(@a)
-- Проверка
SELECT @a

-- Хранимые процедуры
-- Задача 3

DELIMITER //

DROP TABLE IF EXISTS upcase_catalogs//
CREATE TABLE upcase_catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела'
) COMMENT = 'Разделы интернет-магазина'//

-- Хранимые процедуры
-- Задача 4
-- Написать процедуру, где при вставки значения, которое уже есть в таблице, процедура выдавала
-- бы ошибку - Ошибка значения

-- Просмотр таблицы
SELECT id, users_id, name_courses, description, duration
FROM courses;

-- Удаление строк (пример)
DELETE FROM courses
WHERE id>90;

-- Описание процедуры

DELIMITER //

DROP PROCEDURE IF EXISTS  sp_insert_to_courses//
CREATE PROCEDURE sp_insert_to_courses (IN id INT, IN users_id INT,IN name_courses VARCHAR(100), 
IN description VARCHAR(300), IN duration VARCHAR(50))
BEGIN
  DECLARE CONTINUE HANDLER FOR SQLSTATE '28000' SET @error = 'Ошибка значения';
  INSERT INTO courses VALUES(id, users_id, name_courses, description , duration);
  IF @error IS NOT NULL THEN
    SELECT @error;
  END IF;
END//

-- Просмотр таблицы
SELECT id, users_id, name_courses, description, duration
FROM courses;

-- Вызов процедуры
CALL sp_insert_to_courses(101, 101, 'UX дизайнер', 'Обучение на дизайнера', '12')
CALL sp_insert_to_courses(91, 91, 'дизайнер', 'Обучение', '12')

-- Повтор ошибка
CALL sp_insert_to_courses(101, 101, 'UX дизайнер', 'Обучение на дизайнера', '12')

-- Просмотр таблицы

SELECT id, users_id, name_courses, description, duration
FROM courses;




-- Триггеры 
-- Задача 1
-- Написать триггер, который удаляет название и текст из таблицы "карьера"
-- от 1 значения (id)

-- Просмотр таблицы "карьера"
SELECT id, name, body
FROM career;

-- Описание треггера

DELIMITER //
drop trigger IF EXISTS new_career//
CREATE TRIGGER new_career BEFORE DELETE ON career
FOR EACH ROW BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM career;
  IF total <= 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DELETE canceled';
  END IF;
END//


-- Использования триггера, лимит установлен от 1

DELETE FROM career LIMIT 1; -- возможно устанавливать лимиты от 1

-- Тестирование результата

SELECT id, name, body
FROM career;

-- Триггеры 
-- Задача 2
-- Написать триггер, который извлекает количество записей в таблице курсы 
-- и поместить данное значение в переменную "total"
-- 
-- Описание треггера


DELIMITER //
drop trigger IF EXISTS total_courses//
CREATE TRIGGER total_courses after insert on courses
FOR EACH ROW 
BEGIN
    SELECT COUNT(*) INTO @total FROM courses;
  END//
  
--   Просмотр таблицы  
 SELECT id, users_id, name_courses, description, duration
FROM courses; 
  
--   Проверка триггера
  select @total


-- Добавление записей
  INSERT INTO courses
(users_id, name_courses, description, duration)
VALUES(100, 'SQL', 'учеба', 'описание');
  
--   Проверка триггера
  select @total
  
  

-- Функция Задача 1
-- Найти коэффициент (соотношение) отправленных 
-- и полученых сообщений


-- обновим данные в базе, чтобы появились пользователи из одного города
UPDATE messages
SET to_user_id ='100'
WHERE to_user_id >='5';

SELECT id, from_user_id, to_user_id, body, created_at
FROM messages;

-- Описание функции
DROP FUNCTION IF EXISTS geekbrains.geekbrains_direction;

DELIMITER $$
$$
CREATE FUNCTION geekbrains.geekbrains_direction(sol_user_id BIGINT)
RETURNS FLOAT READS SQL DATA 
BEGIN
    DECLARE messages_to_user INT; -- сообщения к пользователю
	DECLARE messages_from_user INT; -- сообщения от пользователя

	SET messages_to_user = (
		SELECT count(*) 
		FROM messages
		WHERE to_user_id = sol_user_id
		);
	
	SET messages_from_user = (
		SELECT count(*) 
		FROM messages
		WHERE from_user_id = sol_user_id
		);
	
	RETURN messages_to_user / messages_from_user;
	
	END$$
DELIMITER ;

select truncate(geekbrains_direction(100), 2) as 'Коэффициэнт';

-- Представление Задача 1
-- Необходимо сделать представление обьединяющее имя юзера Kassandra 
-- и Durward (id = 99), ниже представлено представление сформированное 
-- посредством Dbeaver

-- Определение базы

use geekbrains;

-- Представление
create or replace
algorithm = UNDEFINED view `geekbrains`.`view_job_openings` as
select
    `u`.`id` as `id`,
    `u`.`firstname` as `firstname`,
    `u`.`lastname` as `lastname`,
    `u`.`email` as `email`,
    `u`.`password_hash` as `password_hash`,
    `u`.`phone` as `phone`,
    `u`.`is_deleted` as `is_deleted`
from
    `geekbrains`.`users` `u`
where
    (`u`.`firstname` = 'Kassandra')
union
select
    `u`.`id` as `id`,
    `u`.`firstname` as `firstname`,
    `u`.`lastname` as `lastname`,
    `u`.`email` as `email`,
    `u`.`password_hash` as `password_hash`,
    `u`.`phone` as `phone`,
    `u`.`is_deleted` as `is_deleted`
from
    `geekbrains`.`users` `u`
where
    (`u`.`id` = 99)
    
--    Вызов представления 
    select * 
   from view_job_openings;
    
  
 -- Представление Задача 2   
-- Необходимо найти пользователя с firstname - Pearlie, lastname - Considine,
-- который просматривал вакансию компании Paucek, Kris and Heller
-- (подсказка  разработчик)
  
--   Скрипт представления написан без помощи  Dbeaver

Drop view IF EXISTS view_job;
CREATE or replace VIEW view_job
AS 
  select *
  FROM users u
    JOIN `work` w ON u.id = w.user_id 
  WHERE 
  w.user_id = 22

  	union
  	
  select *
  FROM users u
    JOIN `work` w ON u.id = w.the_company 
  WHERE 
  w.the_company = 'Paucek, Kris and Heller'
  
--   Вызов представления
  select *
from view_job

 -- Представление Задача 3
 
--   Подсчитать количество курсов, сгруппировать и провести агрегацию 



Drop view IF EXISTS view_Name;
CREATE VIEW view_Name
--        AS SELECT name_webinar, COUNT(*) as 'вебинары'
--        FROM webinars
--        GROUP BY name_webinar;
          
      AS SELECT name_courses, COUNT(*) as cnt
       FROM courses c 
       GROUP BY name_courses
       ORDER BY cnt DESC;
          
 select *
from view_Name     
     


-- Спасибо за внимание!






