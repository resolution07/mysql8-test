-- Топ-10 хостов по доходу с использованием через RANK
-- тут делаем с CTE
WITH host_income AS
         (SELECT u.id                         AS host_id,
                 u.name                       AS host_name,
                 COALESCE(SUM(pay.amount), 0) AS total_income
          FROM users u
                   LEFT JOIN properties prop ON prop.host_id = u.id
                   LEFT JOIN bookings b ON b.property_id = prop.id AND b.status = 'completed'
                   LEFT JOIN payments pay ON pay.booking_id = b.id
          WHERE u.role = 'host'
          GROUP BY u.id, u.name)
SELECT host_id,
       host_name,
       total_income,
       RANK() OVER (ORDER BY total_income DESC) AS income_rank -- присваивает порядковый номер (ранг) каждой строке в результате запроса на основе сортировки, заданной в ORDER BY
FROM host_income
ORDER BY income_rank
LIMIT 10;