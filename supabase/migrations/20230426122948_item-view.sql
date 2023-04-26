CREATE VIEW item_view AS
SELECT i.name item_name, array_agg(c.name) category_names, array_agg(c.id) category_ids FROM
item i
INNER JOIN item_category ic ON i.id = ic.item_id
INNER JOIN category c ON ic.category_id = c.id
GROUP BY i.id;

CREATE VIEW item_variant_view AS
SELECT i.name item_name,
       iv.name variant_name,
       array_agg(DISTINCT c.name) category_names,
       array_agg(DISTINCT c.id) category_ids
FROM item i
INNER JOIN item_variant iv ON i.id = iv.item_id
INNER JOIN item_category ic ON i.id = ic.item_id
INNER JOIN item_variant_category ivc ON iv.id = ivc.item_variant_id
INNER JOIN category c ON ic.category_id = c.id
OR ivc.category_id = c.id
GROUP BY i.id,
         iv.id;
