CALL insert_item(
  '{"(,black,20,A4 folder,)"}'::item[],
  array[2, 20]
);
CALL insert_item(
  '{"(,white,20,A4 folder,)"}'::item[],
  array[2, 20]
);

DO
$$
DECLARE
  _id integer;
BEGIN
  -- Move 2 new 'Stage 2 cloth' out
  SELECT id INTO _id FROM item WHERE name = 'cloth' AND variant_name = 'Stage 2' LIMIT 1;
  SELECT create_new_transaction('system'::text, array[(_id, 2, 'tbc', null)]::create_transaction_detail[]) into _id;
  
  -- Move 2 'Total Defence Bronze' out
  SELECT id INTO _id FROM item WHERE name = 'Total Defence' AND variant_name = 'Bronze' LIMIT 1;
  SELECT create_new_transaction('system'::text, array[(_id, 2, 'tbc', null)]::create_transaction_detail[]) into _id;
  
  -- -- Move 1 'Total Defence Gold' out
  SELECT id INTO _id FROM item WHERE name = 'Total Defence' AND variant_name = 'Gold' LIMIT 1;
  SELECT create_new_transaction('system'::text, array[(_id, 1, 'tbc', null)]::create_transaction_detail[]) into _id;
  
  -- -- Move 20 'A4 folder blue' in
  SELECT id INTO _id FROM item WHERE name = 'A4 folder' AND variant_name = 'blue' AND id IN (SELECT item_id FROM item_category WHERE category_id = 2) LIMIT 1;
  SELECT create_new_transaction('system'::text, array[(_id, 20, null, 'tbc')]::create_transaction_detail[]) into _id;
END;
$$;