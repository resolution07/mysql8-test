-- Партиционирование таблицы bookings по году start_date
-- Партиционирование требует чтобы колонка была частью первичного ключа поэтому сначала модифицируем ключ.

-- Удалим внешние ключи, зависящие от bookings
ALTER TABLE payments
    DROP FOREIGN KEY payments_ibfk_1;
ALTER TABLE reviews
    DROP FOREIGN KEY reviews_ibfk_1;
ALTER TABLE booking_history
    DROP FOREIGN KEY booking_history_ibfk_1;

-- Изменим первичный ключ, включив start_date
ALTER TABLE bookings
    DROP PRIMARY KEY;
ALTER TABLE bookings
    ADD PRIMARY KEY (id, start_date);

-- Создаём партиции по годам (предположим, данные за 2023-2025)
ALTER TABLE bookings
    PARTITION BY RANGE (YEAR(start_date)) (
        PARTITION p2023 VALUES LESS THAN (2024),
        PARTITION p2024 VALUES LESS THAN (2025),
        PARTITION p2025 VALUES LESS THAN (2026),
        PARTITION p_future VALUES LESS THAN MAXVALUE
        );

-- Восстановим внешние ключи
ALTER TABLE payments
    ADD CONSTRAINT payments_ibfk_1 FOREIGN KEY (booking_id) REFERENCES bookings (id);
ALTER TABLE reviews
    ADD CONSTRAINT reviews_ibfk_1 FOREIGN KEY (booking_id) REFERENCES bookings (id);
ALTER TABLE booking_history
    ADD CONSTRAINT booking_history_ibfk_1 FOREIGN KEY (booking_id) REFERENCES bookings (id);

-- тетирование
SELECT TABLE_NAME, PARTITION_NAME, TABLE_ROWS
FROM INFORMATION_SCHEMA.PARTITIONS
WHERE TABLE_NAME = 'bookings';