-- Пользователи с >5 отзывов, но без собственных бронирований
--

SELECT u.id, u.name, u.email
FROM users u
WHERE u.id IN (
    -- пользователи, оставившие >5 отзывов
    SELECT b.guest_id
    FROM bookings b
             JOIN reviews r ON r.booking_id = b.id
    GROUP BY b.guest_id
    HAVING COUNT(r.id) > 5)
  AND u.id NOT IN (
    -- пользователи, которые бронировали жильё
    SELECT DISTINCT guest_id
    FROM bookings);