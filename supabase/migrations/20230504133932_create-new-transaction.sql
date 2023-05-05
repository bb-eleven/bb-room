CREATE FUNCTION _update_location_quantity(_item_id integer, _location_id integer, delta_quantity integer) RETURNS integer AS $$
DECLARE
  _quantity integer;
BEGIN
  IF _location_id IS NOT NULL THEN
    IF EXISTS (SELECT 1 FROM item_location WHERE location_id = _location_id) THEN
      UPDATE item_location
      SET quantity = quantity + delta_quantity
      WHERE item_id = _item_id AND location_id = _location_id
      RETURNING quantity INTO _quantity;
      RETURN _quantity;
    ELSE
      INSERT INTO item_location (item_id, location_id, quantity)
      VALUES (_item_id, _location_id, delta_quantity);
      RETURN delta_quantity;
    END IF;
  END IF;
  RETURN 0;
END;
$$ LANGUAGE plpgsql;

CREATE TYPE create_transaction_detail AS (
  item_id integer,
  quantity integer,
  from_location_code citext,
  to_location_code citext
);

CREATE FUNCTION create_new_transaction(_author text, create_transaction_details create_transaction_detail[]) RETURNS integer AS $$
DECLARE
  _transaction_id integer;
  _from_location_id integer;
  _to_location_id integer;
  _count integer := 0;
  _ctd create_transaction_detail;
  _updated_quantity integer;
BEGIN
  INSERT INTO transaction (author) VALUES (_author) RETURNING id INTO _transaction_id;
  FOREACH _ctd IN ARRAY create_transaction_details LOOP
    SELECT id INTO _from_location_id FROM location WHERE code = _ctd.from_location_code;
    SELECT id INTO _to_location_id FROM location WHERE code = _ctd.to_location_code;
    
    INSERT INTO transaction_detail (transaction_id, item_id, quantity, from_location_id, to_location_id)
    VALUES (_transaction_id, _ctd.item_id, _ctd.quantity, _from_location_id, _to_location_id);
    
    SELECT _update_location_quantity(_ctd.item_id, _from_location_id, -abs(_ctd.quantity)) INTO _updated_quantity;
    RAISE LOG 'Updated "from location" quantity (item_id=%, location_id=%, quantity=%)', _ctd.item_id, _from_location_id, _updated_quantity;

    SELECT _update_location_quantity(_ctd.item_id, _to_location_id, _ctd.quantity) INTO _updated_quantity;
    RAISE LOG 'Updated "to location" quantity (item_id=%, location_id=%, quantity=%)', _ctd.item_id, _to_location_id, _updated_quantity;

    _count := _count + 1;
  END LOOP;
  RETURN _count;
END;
$$ LANGUAGE plpgsql;