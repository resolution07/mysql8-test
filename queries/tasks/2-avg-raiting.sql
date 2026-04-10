-- Средняя цена и рейтинг по городам (города с >5 отзывами)
SELECT p.city,
       AVG(p.price)  AS avg_price,
       AVG(r.rating) AS avg_rating,
       COUNT(r.id)   AS review_count
FROM properties p
         JOIN bookings b ON b.property_id = p.id
         JOIN reviews r ON r.booking_id = b.id
GROUP BY p.city
HAVING COUNT(r.id) > 5;