-- Поиск жилья: Minsk, цена 150-300 и спальни ≥2
SELECT id, title, city, price, bedrooms, details
FROM properties
WHERE city = 'Minsk'
  AND price BETWEEN 150 AND 300
  AND bedrooms >= 2;