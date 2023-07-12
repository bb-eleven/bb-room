CREATE OR REPLACE VIEW item_view AS
SELECT
  i.id,
  i.name,
  i.variant_name,
  c.category_ids,
  c.category_names,
  l.location_codes,
  l.location_quantities
FROM item i
LEFT JOIN (
  SELECT
    i.id item_id,
    array_agg(c.name ORDER BY c.name) category_names,
    array_agg(c.id ORDER BY c.name) category_ids
  FROM category c
  INNER JOIN item_category ic ON ic.category_id = c.id
  INNER JOIN item i ON i.id = ic.item_id
  GROUP BY i.id
) c ON c.item_id = i.id
LEFT JOIN (
  SELECT
    i.id item_id,
    array_agg(l.code ORDER BY l.code) location_codes,
    array_agg(il.quantity ORDER BY l.code) location_quantities
  FROM location l
  INNER JOIN item_location il ON il.location_id = l.id
  INNER JOIN item i ON i.id = il.item_id
  GROUP BY i.id
) l ON l.item_id = i.id;