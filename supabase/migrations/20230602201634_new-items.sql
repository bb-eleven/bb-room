-- Add new items
CREATE OR REPLACE PROCEDURE insert_item(
  _item_arr item[],
  _item_category_id_arr integer[]
)
  LANGUAGE plpgsql
  AS $$
DECLARE
  _i integer := 1;
  _item item := _item_arr[1];
  _item_id integer;
  _item_category_id integer;
BEGIN
  INSERT INTO item (name, variant_name, initial_quantity, quantity_metric)
  VALUES (_item.name, _item.variant_name, _item.initial_quantity, _item.quantity_metric)
  RETURNING id INTO _item_id;

  FOREACH _item_category_id IN ARRAY _item_category_id_arr LOOP
    INSERT INTO item_category VALUES (_item_id, _item_category_id);
  END LOOP;

  -- Use 'tbc' as initial location
  INSERT INTO item_location VALUES (_item_id, 3, _item.initial_quantity);
END;
$$;

-- ADVENTURE
CALL insert_item(
  '{"(,,1,aluminium wire,)"}'::item[],
  array[3, 4]
);
CALL insert_item(
  '{"(,,15,bicycle helmet,)"}'::item[],
  array[3, 4]
);
CALL insert_item(
  '{"(,,5,jerry can,)"}'::item[],
  array[3, 4]
);
CALL insert_item(
  '{"(,,5,tarpauline,)"}'::item[],
  array[3, 4, 23]
);
CALL insert_item(
  '{"(,,12,tent,)"}'::item[],
  array[3, 4, 23]
);

-- UNIFORM PARTS
DELETE FROM item_location WHERE item_id IN
(SELECT id FROM item WHERE name like '%chevron (no velcro)%');
DELETE FROM item_category WHERE item_id IN
(SELECT id FROM item WHERE name like '%chevron (no velcro)%');
DELETE FROM item WHERE name like '%chevron (no velcro)%';

CALL insert_item(
  '{"(,size 3,1,boots,)"}'::item[],
  array[6, 10]
);
CALL insert_item(
  '{"(,size 4,1,boots,)"}'::item[],
  array[6, 10]
);

-- Update gloves' categories
DELETE FROM item_category
WHERE item_id IN (SELECT id FROM item WHERE name LIKE 'glove%');
INSERT INTO item_category (item_id, category_id)
SELECT id AS item_id, 2 AS category_id FROM item
WHERE name = 'glove (new)';
SELECT id AS item_id, 1 AS category_id FROM item
WHERE name = 'glove (old)';

-- Delete duplicate pants (size 27)
DO
$$
DECLARE
  _id integer;
BEGIN
  SELECT id INTO _id FROM item WHERE name = 'pants' AND variant_name = 'size 27' LIMIT 1;

  DELETE FROM item_location WHERE item_id = _id;
  DELETE FROM item_category WHERE item_id = _id;
  DELETE FROM item WHERE id = _id;
END;
$$;

CALL insert_item(
  '{"(,size 3XL,1,polo tee,)"}'::item[],
  array[6, 10]
);

-- Sashes
UPDATE item SET variant_name = 'COS', initial_quantity = 1
WHERE name LIKE 'red sash';
CALL insert_item(
  '{"(,QM,1,red sash,)"}'::item[],
  array[6, 10]
);
CALL insert_item(
  '{"(,ACSM,1,red sash,)"}'::item[],
  array[6, 10]
);
CALL insert_item(
  '{"(,CSM,1,red sash,)"}'::item[],
  array[6, 10]
);

-- CQ EQUIPMENT

-- 1. Mahjong paper
UPDATE item SET variant_name = 'green', initial_quantity = 1, quantity_metric = 'roll'
WHERE name LIKE 'mahjong paper';

CALL insert_item(
  '{"(,orange,5,mahjong paper,roll)"}'::item[],
  array[3, 11]
);
CALL insert_item(
  '{"(,red,6,mahjong paper,roll)"}'::item[],
  array[3, 11]
);
CALL insert_item(
  '{"(,white,3,mahjong paper,roll)"}'::item[],
  array[3, 11]
);
CALL insert_item(
  '{"(,yellow,1,mahjong paper,roll)"}'::item[],
  array[3, 11]
);

-- COOKING AND CLEANING EQUIPMENT

-- 1. Bowls
UPDATE item SET name = 'bowl (ceramic)', variant_name = 'white', initial_quantity = 2
WHERE name LIKE 'bowl';

CALL insert_item(
  '{"(,thick,1,\"bowl (metal)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,thin,1,\"bowl (metal)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,orange,12,\"bowl (plastic)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,red,7,\"bowl (plastic)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,white,1,\"bowl (plastic)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,,1,\"bowl (wooden)\",)"}'::item[],
  array[3, 13]
);

-- new items
CALL insert_item(
  '{"(,,1,baking spoon set,)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,,4,\"bamboo skewer (pack of 50)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,,3,brush,)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,,4,\"brush (basting)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,,3,can opener,)"}'::item[],
  array[3, 13]
);
UPDATE item SET variant_name = 'plastic', initial_quantity = 1
WHERE name LIKE 'chopping board';
CALL insert_item(
  '{"(,wooden,1,chopping board,)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,pack of 10,2,\"cloth (disposable)\",)"}'::item[],
  array[3, 13, 14]
);
CALL insert_item(
  '{"(,small,14,cloth,)"}'::item[],
  array[3, 13, 14]
);
CALL insert_item(
  '{"(,white,1,\"cup (plastic)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,,2,\"cup (metal)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,,3,bamboo fan,)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,,65,\"fork & spoon set (disposable)\",)"}'::item[],
  array[3, 13]
);
UPDATE item SET variant_name = 'metal', initial_quantity = 14
WHERE name LIKE 'fork';
CALL insert_item(
  '{"(,plastic,70,fork,)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,,4,kitchen towl,roll)"}'::item[],
  array[3, 13]
);
UPDATE item SET initial_quantity = 1
WHERE name LIKE 'ladle (with holes)';
CALL insert_item(
  '{"(,large,4,ladle,)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,small,3,ladle,)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,,10,mess kit,)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,,4,paper towel,)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,large,67,\"cup (plastic + disposable)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,small,43,\"cup (plastic + disposable)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,\"small (pack of 30)\",2,\"spoon (plastic)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,thin,1,\"plate (metal)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,orange,10,\"plate (plastic)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,big,2,pot,)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,medium,1,pot,)"}'::item[],
  array[3, 13]
);

CALL insert_item(
  '{"(,pack of 100,1,serviette/napkin,)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,,1,sieve,)"}'::item[],
  array[3, 13]
);
UPDATE item SET name = 'spoon (metal)', initial_quantity = 19
WHERE name LIKE 'spoon';
CALL insert_item(
  '{"(,,32,\"spoon (plastic)\",)"}'::item[],
  array[3, 13]
);

DELETE FROM item_category
WHERE item_id IN (SELECT id FROM item WHERE name = 'tommy cooker' AND variant_name = 'old');
DELETE FROM item_location
WHERE item_id IN (SELECT id FROM item WHERE name = 'tommy cooker' AND variant_name = 'old');
DELETE FROM item WHERE name = 'tommy cooker' AND variant_name = 'old';
UPDATE item SET variant_name = null, initial_quantity = 84
WHERE name = 'tommy cooker';

CALL insert_item(
  '{"(,,5,\"tray (metal)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,blue,1,\"tray (plastic)\",)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,,1,whisk,)"}'::item[],
  array[3, 13]
);
CALL insert_item(
  '{"(,mini,3,wire mesh,)"}'::item[],
  array[3, 13]
);

-- FIRST AID
CALL insert_item(
  '{"(,small,2,CPR dummy,)"}'::item[],
  array[15]
);
CALL insert_item(
  '{"(,pack of 100,1,gauze,)"}'::item[],
  array[15]
);
CALL insert_item(
  '{"(,,5,plaster,piece)"}'::item[],
  array[15]
);
CALL insert_item(
  '{"(,,4,sodium chloride solution,)"}'::item[],
  array[15]
);
CALL insert_item(
  '{"(,,12,splint,)"}'::item[],
  array[15]
);
CALL insert_item(
  '{"(,,4,triangular bandage,)"}'::item[],
  array[15]
);

-- GAMES-RELATED
DELETE FROM item_category WHERE item_id IN
(SELECT id FROM item WHERE name = 'five-way pipe' OR name = 'tetrahedral pipe');
DELETE FROM item_location WHERE item_id IN
(SELECT id FROM item WHERE name = 'five-way pipe' OR name = 'tetrahedral pipe');
DELETE FROM item WHERE name = 'five-way pipe' OR name = 'tetrahedral pipe';

CALL insert_item(
  '{"(,4-way,12,grey joint,)"}'::item[],
  array[16]
);
CALL insert_item(
  '{"(,L-shaped,415,grey joint,)"}'::item[],
  array[16]
);
CALL insert_item(
  '{"(,T-shaped,161,grey joint,)"}'::item[],
  array[16]
);
CALL insert_item(
  '{"(,straight long,9,grey joint,)"}'::item[],
  array[16]
);
CALL insert_item(
  '{"(,straight short,117,grey joint,)"}'::item[],
  array[16]
);
CALL insert_item(
  '{"(,4-way,62,white joint,)"}'::item[],
  array[16]
);
CALL insert_item(
  '{"(,5-way,40,white joint,)"}'::item[],
  array[16]
);

CALL insert_item(
  '{"(,,23,marble pebble,)"}'::item[],
  array[16]
);
CALL insert_item(
  '{"(,large,16,marble,)"}'::item[],
  array[16]
);
CALL insert_item(
  '{"(,regular,174,marble,)"}'::item[],
  array[16]
);

CALL insert_item(
  '{"(,,25,Nerf gun,)"}'::item[],
  array[16]
);
CALL insert_item(
  '{"(,,9,Nerf gun part,)"}'::item[],
  array[16]
);

CALL insert_item(
  '{"(,,61,pipe cap,)"}'::item[],
  array[16]
);
CALL insert_item(
  '{"(,grey,279,pipe,)"}'::item[],
  array[16]
);
CALL insert_item(
  '{"(,white,34,pipe,)"}'::item[],
  array[16]
);
CALL insert_item(
  '{"(,white,41,\"pipe (short)\",)"}'::item[],
  array[16]
);

CALL insert_item(
  '{"(,,1,Realise,)"}'::item[],
  array[16, 17]
);
CALL insert_item(
  '{"(,,1,Ungame,)"}'::item[],
  array[16, 17]
);

-- MISCELLANEOUS
CALL insert_item(
  '{"(,,1,guitar,)"}'::item[],
  array[19]
);
CALL insert_item(
  '{"(,pack of 15,2,laundry clip,)"}'::item[],
  array[19]
);
CALL insert_item(
  '{"(,blue,4,pail,)"}'::item[],
  array[19]
);
CALL insert_item(
  '{"(,blue,4,\"pail (small)\",)"}'::item[],
  array[19]
);
CALL insert_item(
  '{"(,red,4,pail,)"}'::item[],
  array[19]
);
CALL insert_item(
  '{"(,red,5,\"pail (small)\",)"}'::item[],
  array[19]
);

-- STATIONERY
CALL insert_item(
  '{"(,AA,4,battery,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,AAA,2,battery,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,large,3,binder clip,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,medium,2,binder clip,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,small,2,binder clip,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,2,coloured blank card,pad)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,2,blue tack,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,1,coloured paper,stack)"}'::item[],
  array[20]
);

DELETE FROM item_location WHERE item_id IN (SELECT id FROM item WHERE name = 'tape');
DELETE FROM item_category WHERE item_id IN (SELECT id FROM item WHERE name = 'tape');
DELETE FROM item WHERE name = 'tape';

CALL insert_item(
  '{"(,large,16,clear tape,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,small,9,clear tape,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,1,correction tape,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,100,envelope,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,3,foolscap paper,pad)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,big,2,glue stick,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,small,1,glue stick,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,3,liquid glue,bottle)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,4,hole punch,)"}'::item[],
  array[20]
);

CALL insert_item(
  '{"(,big,14,marker,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,small,144,marker,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,large,7,masking tape,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,150,origami paper,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,7,paper clip,small box)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,7,pen,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,1,penknife,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,7,pin,small box)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,sticky,8,Post-it note,pad)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,2,poster colour,set)"}'::item[],
  array[20]
);

CALL insert_item(
  '{"(,pack of 6,2,reusable mounting strip,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,15cm,3,ruler,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,20cm,1,ruler,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,cross head,1,screwdriver,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,flat head,2,screwdriver,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,pack of 10,2,\"self-adhesive label (30 per piece)\",)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,1,sharpener,)"}'::item[],
  array[20]
);
CALL insert_item(
  '{"(,,1,stapler,)"}'::item[],
  array[20]
);
