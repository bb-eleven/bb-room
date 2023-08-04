-- 1. Purpose of transaction
ALTER TABLE transaction ADD COLUMN purpose TEXT NULL;
UPDATE transaction SET purpose='Testing';
ALTER TABLE transaction ALTER COLUMN purpose SET NOT NULL;

-- 2. Updated quantity after transaction
ALTER TABLE transaction_detail ADD COLUMN new_from_quantity SMALLINT NULL;
ALTER TABLE transaction_detail ADD COLUMN new_to_quantity SMALLINT NULL;

ALTER TABLE transaction_detail RENAME COLUMN quantity TO quantity_moved;

-- 3. Update _update_location_quantity to return NULL instead of 0 if location_id doesn't exist
CREATE OR REPLACE FUNCTION public._update_location_quantity(_item_id integer, _location_id integer, delta_quantity integer)
 RETURNS integer
AS $$
DECLARE
  _quantity integer;
BEGIN
  RAISE LOG '_update_location_quantity(_item_id=%, _location_id=%, delta_quantity=%', _item_id, _location_id, delta_quantity;
  IF _location_id IS NOT NULL THEN
    IF EXISTS (SELECT 1 FROM item_location WHERE item_id = _item_id AND location_id = _location_id) THEN
      RAISE LOG '_update_location_quantity, found item_location record (location_id=%)', _location_id;
      UPDATE item_location
      SET quantity = quantity + delta_quantity
      WHERE item_id = _item_id AND location_id = _location_id
      RETURNING quantity INTO _quantity;
      RETURN _quantity;
    ELSE
      RAISE LOG '_update_location_quantity log, didn''t find item_location_record (location_id=%)', _location_id;
      INSERT INTO item_location (item_id, location_id, quantity)
      VALUES (_item_id, _location_id, abs(delta_quantity));
      RETURN abs(delta_quantity);
    END IF;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- 4. Update create_new_transaction
CREATE OR REPLACE FUNCTION public.create_new_transaction(_author text, _purpose text, create_transaction_details create_transaction_detail[]) RETURNS integer AS $$
DECLARE
  _transaction_id integer;
  _from_location_id integer;
  _to_location_id integer;
  _count integer := 0;
  _ctd create_transaction_detail;
  _new_from_quantity integer;
  _new_to_quantity integer;
BEGIN
  INSERT INTO transaction (author, purpose) VALUES (_author, _purpose) RETURNING id INTO _transaction_id;
  FOREACH _ctd IN ARRAY create_transaction_details LOOP
    SELECT id INTO _from_location_id FROM location WHERE code = _ctd.from_location_code;
    SELECT id INTO _to_location_id FROM location WHERE code = _ctd.to_location_code;
    
    SELECT _update_location_quantity(_ctd.item_id, _from_location_id, -abs(_ctd.quantity)) INTO _new_from_quantity;
    RAISE LOG 'Updated "from location" quantity (item_id=%, location_id=%, quantity=%)', _ctd.item_id, _from_location_id, _new_from_quantity;


    SELECT _update_location_quantity(_ctd.item_id, _to_location_id, _ctd.quantity) INTO _new_to_quantity;
    RAISE LOG 'Updated "to location" quantity (item_id=%, location_id=%, quantity=%)', _ctd.item_id, _to_location_id, _new_to_quantity;

    INSERT INTO transaction_detail (transaction_id, item_id, quantity_moved, new_from_quantity, new_to_quantity, from_location_id, to_location_id)
    VALUES (_transaction_id, _ctd.item_id, _ctd.quantity, _new_from_quantity, _new_to_quantity, _from_location_id, _to_location_id);

    _count := _count + 1;
  END LOOP;
  RETURN _count;
END;
$$ LANGUAGE plpgsql;
