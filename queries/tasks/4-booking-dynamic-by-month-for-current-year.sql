-- Динамика бронирований по месяцам (CTE) за текущий год
-- тут делаем с CTE
WITH monthly_stats AS
         (SELECT YEAR(start_date)  AS yr,
                 MONTH(start_date) AS mon,
                 COUNT(*)          AS booking_count
          FROM bookings
          WHERE YEAR(start_date) = YEAR(CURDATE())
          GROUP BY YEAR(start_date), MONTH(start_date))
SELECT CONCAT(yr, '-', LPAD(mon, 2, '0')) AS month,
       booking_count
FROM monthly_stats
ORDER BY yr, mon;