CREATE EXTENSION citext;

ALTER TABLE item ALTER COLUMN name TYPE citext;
ALTER TABLE item ALTER COLUMN variant_name TYPE citext;
ALTER TABLE category ALTER COLUMN name TYPE citext;
ALTER TABLE location ALTER COLUMN code TYPE citext;
