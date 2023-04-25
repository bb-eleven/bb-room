CREATE FUNCTION update_location_quantity(
  _location_id integer, _item_variant_id integer, delta_quantity integer
) RETURNS integer AS $$
DECLARE
  _quantity integer;
BEGIN
  UPDATE item_variant_location
  SET quantity = quantity + delta_quantity
  WHERE location_id = _location_id AND item_variant_id = _item_variant_id
  RETURNING quantity INTO _quantity;
  RETURN _quantity;
END;
$$ LANGUAGE plpgsql;

-- CREATE OR REPLACE FUNCTION create_new_transaction(
--   author text,
--   -- transaction_details transaction_detail[]
--   data json
-- ) RETURNS integer
--   AS $$
-- DECLARE
--   _transaction_id integer;
--   -- _transaction_detail_arr transaction_detail[] := array[];
--   _count integer;
-- BEGIN
--   SELECT SUM(ISNULL(itemVariantId)) INTO _count FROM (SELECT json_populate_recordset(null::record, data)) a;
--   IF _count > 0 THEN
--     RAISE EXCEPTION '% null itemVariantIds', _count;
--     RETURN -1;
--   END IF;

-- --   INSERT INTO transactions (author) VALUES (_author) RETURNING id INTO _transaction_id;

-- --   _transation_detail_arr
--   RETURN 0;
-- END;
-- $$ LANGUAGE plpgsql;

-- -- CREATE OR REPLACE FUNCTION update_item(
-- --   _author text,
-- --   _ jsonb
-- -- ) RETURNS innteger
-- --   AS $$
-- -- DECLARE
-- -- BEGIN

-- -- END;
-- -- $$;