-- Задача I
-- Определить кто больше просматривает вебинары (общее количество), 
-- провести группировку и агрегацию данных: мужчины или женщины.

-- Вложенный запрос
  use geekbrains;

  select 
      gender, 
      count(*) as total
 from (
      select 
      user_id as user,
      (select gender from geekbrains.profiles
       where user_id = user ) as gender 
 from  webinars 
 ) as пол
 group by gender
 order by total desc;

-- JOIN
 
SELECT p.gender,
COUNT(*) as total
 	FROM profiles p
 		JOIN webinars w 
 			ON w.user_id = p.user_id 
  	GROUP BY gender
 	ORDER BY total DESC;         
 	
--  Задача II	
--  Определить программы вебинаров для каждого пользователя, 
-- провести агрегацию данных.
 
 -- Вложенный запрос
 	-- Данные пользователя с заглушками
SELECT 
firstname,
lastname,
	 'программа вебинара', 
	 'название вебинара'
FROM users;



-- Расписываем заглушки

SELECT 
id, 
CONCAT(firstname, ' ', lastname)  AS 'Пользователь',
(select programs from accounts where user_id = users.id) as 'программа вебинара', 
(select name_webinar from webinars where accoun_id = 
(select user_id from accounts where user_id = users.id)) as 'название вебинара'

FROM users
order by id; 

 
-- JOIN

select 
u.id,
CONCAT(u.firstname, ' ', u.lastname)  AS 'Пользователь',
-- u.firstname,
-- u.lastname,
a.programs as 'программа вебинара', 
w.name_webinar as 'название вебинара'
from users u 
join accounts a on u.id = a.user_id 
join webinars w on a.user_id = w.accoun_id 
order by u.id;


--  Задача III
-- Определить количество проведенных курсов (какие курсы больше всего востребованы), 
-- с отправленными сообщениями (тело) пользователей, провести группировку и агрегацию данных

- Вложенный запрос
 	-- Данные пользователя с заглушками
SELECT 
firstname,
lastname,
'отправленные сообщения' 
'название курса'

FROM users;



-- Расписываем заглушки

SELECT 
id,
COUNT(*) cnt,
CONCAT(firstname, ' ', lastname)  AS 'От кого',
(select body from messages where from_user_id = users.id) as 'отправленные сообщения',
(select name_courses from courses where users_id in
(select  users_id from courses where users_id = users.id)) as 'название курса'
FROM users 
GROUP BY id 
order by cnt desc;  



-- то же с JOIN

SELECT 
m.body ,
c.name_courses,
CONCAT(u.firstname, ' ', u.lastname)  AS 'От кого', 
COUNT(*) cnt
FROM messages m 
join users u on m.from_user_id = u.id 
JOIN courses c on u.id = c.users_id 
GROUP BY c.name_courses
order by cnt desc; 



--  Задача IV

-- В направляемых сообщениях по трудоустройству от компаний к пользователю,
-- узнать текст письма, агрегировать данные по компании. 

SELECT 
u.id,
CONCAT(u.firstname, ' ', u.lastname)  AS 'Кому',
w.the_company,
m.body
  FROM `work` w 
  join users u on w.user_id = u.id 
  join messages m on u.id = m.to_user_id
order by w.the_company;


--  Задача V
-- Необходимо собрать всех пользователей, которые отправляли сообщения

 select u.*, m.* from users u 
 left join messages m on u.id =m.from_user_id 
 union 
 select u.*, m.* from  messages m
right join users u on u.id =m.from_user_id;

 
--  Задача VI

-- Найти сообщения, которые были отправлены к пользователю id = 99 
-- с указанием даты отправления и текстом письма
-- Вложенный
SELECT 
	body,
	created_at,
	to_user_id
FROM messages 
WHERE to_user_id IN (SELECT id FROM users WHERE id = 99);

-- join
SELECT 
  m.body, 
  u.firstname, 
  u.lastname, 
  m.created_at
   FROM messages m
    JOIN users u ON u.id = m.to_user_id
  where u.id = 99;
 
--  Задача VII
 -- Найти название вебинара пользователя (d=1) с количеством ссылок 
--  и группировков по id
SELECT 
	w.name_webinar,
	w.link, 
	COUNT(*) AS 'cnt',
	CONCAT(u.firstname, ' ', u.lastname) AS 'пользователь'
	FROM webinars w 
	JOIN accounts a ON w.accoun_id = a.user_id 
	JOIN users u ON u.id = a.user_id 
WHERE u.id=1
GROUP BY w.id;

--  Задача VIII

-- Определить количество событий базы знаний у пользователей, провести группировку и агрегацию данных 
SELECT 
u.firstname, u.lastname, 
  COUNT(*) AS cnt_events
  FROM users u 
    JOIN events e ON u.id = e.id 
  GROUP BY u.id
  ORDER BY cnt_events DESC;


--  Задача IX
 
 -- Определить среднее количество событий базы знаний у пользователей, провести группировку и агрегацию данных    
 
 SELECT AVG(cnt_events) AS very_events
 from (
 SELECT u.firstname, u.lastname,  COUNT(*) AS cnt_events
  FROM users u 
    JOIN events e ON u.id = e.id 
  GROUP BY u.id
  ORDER BY cnt_events DESC) as ripli;
 
--  Задача X
 
 -- количество открытых вакансий (работа)
SELECT 
	COUNT(*) AS cnt,
	w.job_openings 
FROM `work` w_c 
	JOIN  `work` w ON w.user_id =w_c.user_id 
GROUP BY w.job_openings 
ORDER BY cnt DESC;
  

 