CREATE VIEW item_view AS
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
    array_agg(c.name) category_names,
    array_agg(c.id) category_ids
  FROM category c
  INNER JOIN item_category ic ON ic.category_id = c.id
  INNER JOIN item i ON i.id = ic.item_id
  GROUP BY i.id
) c ON c.item_id = i.id
LEFT JOIN (
  SELECT
    i.id item_id,
    array_agg(l.code) location_codes,
    array_agg(il.quantity) location_quantities
  FROM location l
  INNER JOIN item_location il ON il.location_id = l.id
  INNER JOIN item i ON i.id = il.item_id
  GROUP BY i.id
) l ON l.item_id = i.id;

CREATE FUNCTION filter_item_view(
  _name_query citext,
  _category_names citext[],
  _location_codes citext[]
) RETURNS
 TABLE (
  id integer,
  name citext,
  variant_name citext,
  category_ids integer[],
  category_names citext[],
  location_codes citext[],
  location_quantities integer[]
)
  LANGUAGE plpgsql
  AS $$
BEGIN
  RETURN QUERY
  SELECT * FROM item_view iv
  WHERE (iv.name || ' ' || coalesce(iv.variant_name, ''))::citext LIKE _name_query
  AND (cardinality(_category_names) = 0 OR iv.category_names && _category_names)
  AND (cardinality(_location_codes) = 0 OR iv.location_codes && _location_codes);
END;
$$;