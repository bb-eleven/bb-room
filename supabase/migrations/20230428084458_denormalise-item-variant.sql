-- Add name column, update from item table
ALTER TABLE item_variant RENAME COLUMN name TO variant_name;
ALTER TABLE item_variant ADD COLUMN name TEXT NULL;
UPDATE item_variant
SET name = (
  SELECT name
  FROM item
  WHERE id = item_variant.item_id);

-- Add quantity_metric column, update from item table
ALTER TABLE item_variant ADD COLUMN quantity_metric TEXT NULL;
UPDATE item_variant
SET quantity_metric = (
  SELECT quantity_metric
  FROM item
  WHERE id = item_variant.item_id);

-- Merge item_category with item_variant_category
INSERT INTO item_variant_category (item_variant_id, category_id)
SELECT iv.id, c.id
FROM item_variant iv
INNER JOIN item i ON i.id = iv.item_id
INNER JOIN item_category ic ON ic.item_id = i.id
INNER JOIN category c ON c.id = ic.category_id;

-- Drop tables
DROP VIEW item_view;
DROP VIEW item_variant_view;
DROP TABLE item_category;
ALTER TABLE item_variant DROP COLUMN item_id;
DROP TABLE item CASCADE; -- lol

-- Rename tables
ALTER TABLE item_variant RENAME TO item;
ALTER TABLE item_variant_category RENAME TO item_category;
ALTER TABLE item_variant_location RENAME TO item_location;

-- Rename columns
ALTER TABLE item_category RENAME COLUMN item_variant_id TO item_id;
ALTER TABLE item_location RENAME COLUMN item_variant_id TO item_id;
ALTER TABLE transaction_detail RENAME COLUMN item_variant_id TO item_id;
