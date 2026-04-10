-- До создания FULLTEXT (можно сделать поиск по LIKE):
EXPLAIN
SELECT *
FROM properties
WHERE title LIKE '%apartment%';


-- Тетирование
-- После создания FULLTEXT (используем MATCH ... AGAINST):
EXPLAIN
SELECT *
FROM properties
WHERE MATCH(title) AGAINST('apartment');