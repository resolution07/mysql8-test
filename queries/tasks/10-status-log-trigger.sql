DELIMITER //

CREATE TRIGGER trg_booking_status_update
    AFTER UPDATE
    ON bookings
    FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO booking_history (booking_id, old_status, new_status)
        VALUES (NEW.id, OLD.status, NEW.status);
    END IF;
END//

DELIMITER ;


-- Тестирование
-- Изменим статус
UPDATE bookings
SET status = 'cancelled'
WHERE id = 1;
-- Посмотрим историю
SELECT *
FROM booking_history
WHERE booking_id = 1;