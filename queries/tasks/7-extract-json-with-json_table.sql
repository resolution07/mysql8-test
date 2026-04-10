-- Разбор JSON в табличный вид с JSON_TABLE
--
SELECT p.id, p.title, jt.*
FROM properties p,
     JSON_TABLE(
             p.details,
             '$' COLUMNS (
                 wifi BOOLEAN PATH '$.wifi',
                 parking BOOLEAN PATH '$.parking',
                 pets_allowed BOOLEAN PATH '$.pets_allowed'
                 )
     ) AS jt;