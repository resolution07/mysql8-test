-- должна подтвердить бронирование, если оплата существует и сумма соответствует полной стоимости
--

DELIMITER //

CREATE PROCEDURE confirm_booking(IN bookingId INT)
BEGIN
    DECLARE payment_amount DECIMAL(10, 2);
    DECLARE total_price DECIMAL(10, 2);
    DECLARE current_status VARCHAR(20);

    -- Получаем статус бронирования
    SELECT status INTO current_status FROM bookings WHERE id = bookingId;

    IF current_status IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking not found';
    END IF;

    IF current_status != 'pending' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Booking is not pending';
    END IF;

    -- Считаем полную стоимость (цена * кол-во дней)
    SELECT p.price * DATEDIFF(b.end_date, b.start_date)
    INTO total_price
    FROM bookings b
             JOIN properties p ON b.property_id = p.id
    WHERE b.id = bookingId;

    -- Проверяем наличие платежа
    SELECT amount
    INTO payment_amount
    FROM payments
    WHERE booking_id = bookingId;

    IF payment_amount IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment not found';
    END IF;

    IF payment_amount < total_price THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment amount is insufficient';
    END IF;

    -- Подтверждаем бронирование
    UPDATE bookings SET status = 'confirmed' WHERE id = bookingId;
END//

DELIMITER ;


-- Тестирование
-- Допустим, есть бронирование id=5 со статусом 'pending' и соответствующим платежом
CALL confirm_booking(5);
-- Проверим статус
SELECT status
FROM bookings
WHERE id = 5;