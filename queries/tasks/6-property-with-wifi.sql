-- Объекты с WiFi
--
SELECT id, title, details
FROM properties
WHERE JSON_EXTRACT(details, '$.wifi') = true;
-- или более кратко:
-- WHERE details->'$.wifi' = true;