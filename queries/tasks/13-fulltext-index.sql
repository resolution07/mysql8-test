-- До создания FULLTEXT (можно сделать поиск по LIKE):
-- FULLTEXT индекс на поле title
ALTER TABLE properties ADD FULLTEXT INDEX ft_title (title);