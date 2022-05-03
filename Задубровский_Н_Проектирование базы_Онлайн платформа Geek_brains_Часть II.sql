-- Часть II_Проект базы данных_geekbrains

DROP DATABASE IF EXISTS geekbrains;
CREATE DATABASE geekbrains;

USE geekbrains;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, 
    firstname VARCHAR(100)COMMENT 'Имя', 
    lastname VARCHAR(100) COMMENT 'Фамилия', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(100) UNIQUE,
    password_hash varchar(100),
    phone BIGINT,
    is_deleted bit default 0,
    -- INDEX _таблица_первое поле_второе поле часто используемое
    INDEX users_firstname_lastname_idx(firstname, lastname)
);

-- 1-1
DROP TABLE IF EXISTS  `profiles`;
CREATE TABLE `profiles` (
	user_id SERIAL PRIMARY KEY,
	age VARCHAR(3) COMMENT 'возраст',
    city VARCHAR(100) COMMENT 'Город',
    gender CHAR(1) COMMENT 'пол', 
    birthday DATE COMMENT 'День рождение',
	accounts_id BIGINT UNSIGNED NULL,
	-- 	cour_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100),
    CONSTRAINT fk_user_id
--     FOREIGN KEY (accounts_id) REFERENCES accounts (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE);
    
      
-- 1-1
DROP TABLE IF EXISTS `courses`;
CREATE TABLE `courses` (
	 id SERIAL PRIMARY KEY,
     users_id BIGINT UNSIGNED NOT NULL,
     cour_id BIGINT UNSIGNED NULL,     
 	 name_courses VARCHAR(100) COMMENT 'Название курса',
 	 description VARCHAR(300) COMMENT 'Описание курса',
     duration VARCHAR(50) COMMENT 'Продолжительность курса',
     FOREIGN KEY (users_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
     FOREIGN KEY (cour_id) REFERENCES profiles(user_id) ON UPDATE CASCADE ON DELETE CASCADE
    );
     
        
   
--   1-m     
 
 DROP TABLE IF EXISTS `accounts`; -- Личный кабинет
 CREATE TABLE `accounts` (
    user_id BIGINT UNSIGNED NOT NULL,
	account_id BIGINT UNSIGNED NOT NULL,
	name_webinar VARCHAR(100) COMMENT 'Имя вебинара',
    programs VARCHAR(200) COMMENT 'Программа',
    events VARCHAR(250) COMMENT 'Мероприятия',
  	PRIMARY KEY (user_id), 
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (account_id) REFERENCES profiles(user_id) ON UPDATE CASCADE ON DELETE CASCADE
);  
  
  
    
-- 1-m    
DROP TABLE IF EXISTS `Webinars`;
CREATE TABLE `Webinars` (
	 id SERIAL PRIMARY KEY,
     user_id BIGINT UNSIGNED NOT NULL,
     accoun_id BIGINT UNSIGNED NULL,
     name_webinar VARCHAR(150) COMMENT 'Имя вебинара',
     webinar_programs VARCHAR(200) COMMENT 'Программа вебинара',
     link  VARCHAR(150) UNIQUE COMMENT 'Ссылка',
     description VARCHAR(350) COMMENT 'Описание вебинара',
    FOREIGN KEY (accoun_id) REFERENCES accounts(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
   );  
 
    
-- 1-m   
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), 
    FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
   );
  
    
--   1-m  
DROP TABLE IF EXISTS `programs`;
CREATE TABLE `programs` (
	 id SERIAL PRIMARY KEY,
     user_id BIGINT UNSIGNED NOT NULL,
     acco_id BIGINT UNSIGNED NULL,
     my_training_link  VARCHAR(150) UNIQUE COMMENT 'Ссылка на мое обучение',
     testing_link  VARCHAR(150) UNIQUE COMMENT 'Ссылка тестирование',
     events_link  VARCHAR(150) UNIQUE COMMENT 'Ссылка мероприятия',
    FOREIGN KEY (acco_id) REFERENCES accounts (user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
   );  
   
    
--  m-m  
DROP TABLE IF EXISTS events;
CREATE TABLE  events(
	id SERIAL PRIMARY KEY,
	name VARCHAR (150) COMMENT 'Имя Вебинара', 
	body TEXT,
	created_at DATETIME DEFAULT NOW(), 
	INDEX events_name_idx(name)   -- INDEX _таблица_первое поле_второе поле часто используемое
);

DROP TABLE IF EXISTS knowledge_base;
CREATE TABLE knowledge_base(
	success_story text COMMENT 'История успеха',
	for_children text COMMENT 'Для детей',
    user_id BIGINT UNSIGNED NOT NULL,
	career_id BIGINT UNSIGNED NOT NULL,
  	PRIMARY KEY (user_id, career_id), 
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (career_id) REFERENCES events(id) ON UPDATE CASCADE ON DELETE CASCADE
);   
   

--  m-m  
DROP TABLE IF EXISTS career;
CREATE TABLE  career(
	id SERIAL PRIMARY KEY,
	name VARCHAR (180),
	body TEXT,
	INDEX career_name_idx(name)   -- INDEX _таблица_первое поле_второе поле часто используемое
);

DROP TABLE IF EXISTS work;
CREATE TABLE work(
	the_company VARCHAR (180) COMMENT 'Компании',
	job_openings VARCHAR (900) COMMENT 'Вакансии',
    user_id BIGINT UNSIGNED NOT NULL,
	career_id BIGINT UNSIGNED NOT NULL,
  	PRIMARY KEY (user_id, career_id), 
    FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (career_id) REFERENCES career(id) ON UPDATE CASCADE ON DELETE CASCADE
); 


-- Спасибо за внимание