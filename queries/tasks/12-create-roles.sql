-- Создание ролей
CREATE ROLE 'admin_role', 'host_role', 'guest_role';

-- Права администратора
GRANT ALL PRIVILEGES ON test_db.* TO 'admin_role';

-- Права хоста (CRUD только для своих объектов)
GRANT SELECT, INSERT, UPDATE, DELETE ON test_db.properties TO 'host_role';
GRANT SELECT ON test_db.bookings TO 'host_role'; -- просмотр бронирований на свои объекты
GRANT SELECT ON test_db.payments TO 'host_role';
GRANT SELECT ON test_db.reviews TO 'host_role';

-- Права гостя
GRANT SELECT ON test_db.properties TO 'guest_role';
GRANT INSERT, SELECT ON test_db.bookings TO 'guest_role';
GRANT INSERT, SELECT ON test_db.reviews TO 'guest_role';
GRANT SELECT ON test_db.payments TO 'guest_role';

-- Создадим тестовых пользователей для БД
CREATE USER IF NOT EXISTS 'host1'@'%' IDENTIFIED BY 'host1pass';
CREATE USER IF NOT EXISTS 'guest1'@'%' IDENTIFIED BY 'guest1pass';

-- Назначим роли
GRANT 'host_role' TO 'host1'@'%';
GRANT 'guest_role' TO 'guest1'@'%';

-- Активируем роли для пользователей (необходимо, чтобы роли применялись при подключении)
SET DEFAULT ROLE 'host_role' TO 'host1'@'%';
SET DEFAULT ROLE 'guest_role' TO 'guest1'@'%';

FLUSH PRIVILEGES;



-- Тестирование
-- подключаемся от имени guest1
DELETE FROM properties WHERE id = 1;   -- Должно быть отказно