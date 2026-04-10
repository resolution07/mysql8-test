-- Функция service_fee (10% от суммы)
--
DELIMITER //

CREATE FUNCTION service_fee(amount DECIMAL(10, 2))
    RETURNS DECIMAL(10, 2)
    DETERMINISTIC
    NO SQL
BEGIN
    RETURN amount * 0.10;
END//

DELIMITER ;