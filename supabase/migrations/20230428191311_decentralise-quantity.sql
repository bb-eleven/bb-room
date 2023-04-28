INSERT INTO item_location (location_id, item_id, quantity)
SELECT
  (SELECT id
   FROM location
   WHERE code = 'tbc') location_id,
       i.id,
       i.current_quantity
FROM item i;

ALTER TABLE item DROP COLUMN current_quantity;
