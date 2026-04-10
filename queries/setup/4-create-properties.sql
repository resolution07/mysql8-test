-- Генерация 20+ объектов недвижимости с помощью INSERT ... SELECT: хосты 2,3,4 (id = 2,3,4), города Moscow, SPB, Kazan, Sochi
-- В MySQL 8 можно использовать рекурсивный CTE.
-- CROSS JOIN - создает декартово произведение двух таблиц, соединяя каждую строку левой таблицы с каждой строкой правой
INSERT INTO properties (host_id, title, city, price, bedrooms, details)
SELECT host.id,
       CONCAT('Apartment in ', city.name, ' #', seq.n),
       city.name,
       ROUND(100 + RAND() * 300, 2), -- цена от 100 до 400
       FLOOR(1 + RAND() * 3),        -- спальни 1-3
       JSON_OBJECT(
               'wifi', IF(RAND() > 0.2, true, false),
               'parking', IF(RAND() > 0.5, true, false),
               'pets_allowed', IF(RAND() > 0.7, true, false)
       )
FROM (SELECT 2 AS id UNION SELECT 3 UNION SELECT 4) host
         CROSS JOIN(SELECT 'Minsk' AS name UNION SELECT 'Vitebsk' UNION SELECT 'Brest' UNION SELECT 'Pinsk') city
         CROSS JOIN (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) seq -- 5 объектов на хост/город
LIMIT 30; -- даст 4*3*5=60 записей, ограничим 30 для примера