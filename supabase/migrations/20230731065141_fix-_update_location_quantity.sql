-- Bug: Query for checking for existing item_location record was only using
-- location_id in the where clause.
-- Fix: The query was updated to use item_id as well. Additionally, logs were added
CREATE OR REPLACE FUNCTION public._update_location_quantity(_item_id integer, _location_id integer, delta_quantity integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
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
  RETURN 0;
END;
$function$