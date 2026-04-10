-- Событие для отмены неоплаченных бронирований старше 24 часов

-- Сначала включим планировщик событий (глобально или в сессии):
SET GLOBAL event_scheduler = ON;

DELIMITER //

CREATE EVENT ev_cancel_unpaid_bookings
    ON SCHEDULE EVERY 1 DAY
        STARTS CURRENT_TIMESTAMP
    DO
    BEGIN
        UPDATE bookings
        SET status = 'cancelled'
        WHERE status = 'pending'
          AND created_at < NOW() - INTERVAL 24 HOUR
          AND NOT EXISTS (SELECT 1
                          FROM payments
                          WHERE booking_id = bookings.id);
    END//

DELIMITER ;


-- Тестирование
-- Создадим тестовое просроченное бронирование без оплаты
INSERT INTO bookings (property_id, guest_id, status, start_date, end_date, created_at)
VALUES (1, 5, 'pending', CURDATE() + 10, CURDATE() + 15, NOW() - INTERVAL 25 HOUR);
-- Запустим событие вручную
ALTER EVENT ev_cancel_unpaid_bookings ON COMPLETION PRESERVE ENABLE;
-- В MySQL нет прямого "EXECUTE EVENT", но можно эмулировать, обновив время или вызвав тело события.
-- Проще выполнить апдейт вручную для проверки:
UPDATE bookings
SET status = 'cancelled'
WHERE status = 'pending'
  AND created_at < NOW() - INTERVAL 24 HOUR
  AND NOT EXISTS (SELECT 1 FROM payments WHERE booking_id = bookings.id);
-- Проверим результат
SELECT *
FROM bookings
WHERE guest_id = 5;