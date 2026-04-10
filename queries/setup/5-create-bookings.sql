-- Гости (id >=5) и созданные объекты (id >=1). Генерируем бронирования за последние 2 года.

INSERT INTO bookings (property_id, guest_id, status, start_date, end_date, created_at)
SELECT p.id,
       g.id,
       ELT(FLOOR(1 + RAND() * 4), 'pending', 'confirmed', 'cancelled', 'completed') AS status,
       DATE_ADD(CURDATE(), INTERVAL -FLOOR(RAND() * 730) DAY)                       AS start_date,
       NULL, -- end_date заполним позже
       NOW() - INTERVAL FLOOR(RAND() * 365) DAY
FROM properties p
         CROSS JOIN
         (SELECT id FROM users WHERE role = 'guest') g
WHERE RAND() < 0.3 -- случайно беру 30% комбинаций
ORDER BY RAND()
LIMIT 80;
-- ограничу 80 бронированиями

-- Обновим end_date: он должен быть после start_date
UPDATE bookings
SET end_date = DATE_ADD(start_date, INTERVAL FLOOR(2 + RAND() * 7) DAY)
WHERE end_date IS NULL;