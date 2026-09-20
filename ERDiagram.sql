--Customer_Demographics
SET search_path TO ecom;
with customer_count as(
select 
count(*) as Total_no_Customers,country
from customers
group by country
)
select country,Total_no_Customers,
round(Total_no_Customers::numeric/sum(Total_no_Customers)over()*100,2) as pct_per_country,
dense_rank() over (order by Total_no_Customers desc) as cc
from customer_count;


SELECT
    constraint_schema,
    table_name,
    constraint_name
FROM information_schema.table_constraints
WHERE constraint_type = 'FOREIGN KEY'
  AND constraint_schema = 'ecom';

  SELECT
    tc.table_name,
    kcu.column_name,
    tc.constraint_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
    AND tc.table_name = kcu.table_name
WHERE tc.constraint_type = 'PRIMARY KEY'
  AND tc.table_schema = 'ecom'
ORDER BY tc.table_name;

SET search_path TO ecom;

SELECT
    child_table.relname AS child_table,
    child_column.attname AS child_column,
    parent_table.relname AS parent_table,
    parent_column.attname AS parent_column,
    constraint_info.conname AS constraint_name
FROM pg_constraint constraint_info
JOIN pg_class child_table
    ON child_table.oid = constraint_info.conrelid
JOIN pg_class parent_table
    ON parent_table.oid = constraint_info.confrelid
JOIN pg_namespace schema_info
    ON schema_info.oid = child_table.relnamespace
JOIN LATERAL unnest(constraint_info.conkey)
    WITH ORDINALITY AS child_keys(attnum, position)
    ON TRUE
JOIN LATERAL unnest(constraint_info.confkey)
    WITH ORDINALITY AS parent_keys(attnum, position)
    ON parent_keys.position = child_keys.position
JOIN pg_attribute child_column
    ON child_column.attrelid = child_table.oid
    AND child_column.attnum = child_keys.attnum
JOIN pg_attribute parent_column
    ON parent_column.attrelid = parent_table.oid
    AND parent_column.attnum = parent_keys.attnum
WHERE constraint_info.contype = 'f'
  AND schema_info.nspname = 'ecom'
ORDER BY child_table.relname, constraint_info.conname;




SELECT
    c.table_name,
    c.column_name,
    c.data_type,
    c.is_nullable,
    CASE
        WHEN pk.column_name IS NOT NULL THEN 'PK'
        WHEN fk.column_name IS NOT NULL THEN 'FK'
        ELSE ''
    END AS key_type
FROM information_schema.columns c

LEFT JOIN (
    SELECT
        kcu.table_name,
        kcu.column_name
    FROM information_schema.table_constraints tc
    JOIN information_schema.key_column_usage kcu
        ON tc.constraint_name = kcu.constraint_name
        AND tc.table_schema = kcu.table_schema
        AND tc.table_name = kcu.table_name
    WHERE tc.constraint_type = 'PRIMARY KEY'
      AND tc.table_schema = 'ecom'
) pk
    ON c.table_name = pk.table_name
    AND c.column_name = pk.column_name

LEFT JOIN (
    SELECT
        kcu.table_name,
        kcu.column_name
    FROM information_schema.table_constraints tc
    JOIN information_schema.key_column_usage kcu
        ON tc.constraint_name = kcu.constraint_name
        AND tc.table_schema = kcu.table_schema
        AND tc.table_name = kcu.table_name
    WHERE tc.constraint_type = 'FOREIGN KEY'
      AND tc.table_schema = 'ecom'
) fk
    ON c.table_name = fk.table_name
    AND c.column_name = fk.column_name

WHERE c.table_schema = 'ecom'
ORDER BY c.table_name, c.ordinal_position;