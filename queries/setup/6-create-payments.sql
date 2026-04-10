-- Платежи
INSERT INTO payments (booking_id, amount)
SELECT b.id,
       (SELECT price FROM properties WHERE id = b.property_id) * DATEDIFF(b.end_date, b.start_date)
FROM bookings b
WHERE b.status IN ('confirmed', 'completed')
  AND NOT EXISTS (SELECT 1 FROM payments WHERE booking_id = b.id)
LIMIT 30;

-- Отзывы (после завершённых бронирований)
INSERT INTO reviews (booking_id, rating, comment)
SELECT b.id,
       FLOOR(3 + RAND() * 3), -- рейтинг 3-5
       CONCAT('Все было хорошо ', b.property_id)
FROM bookings b
WHERE b.status = 'completed'
  AND NOT EXISTS (SELECT 1 FROM reviews WHERE booking_id = b.id)
LIMIT 20;