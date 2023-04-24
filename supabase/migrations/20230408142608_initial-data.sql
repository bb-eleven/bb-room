INSERT INTO category (name) VALUES
  -- 1
  ('old'),
  ('new'),
  ('equipment'),
  ('adventure'),
  ('badges'),
  -- 6
  ('boy'),
  ('officer'),
  ('primer'),
  ('rank'),
  ('uniform'),
  -- 11
  ('character quest'),
  ('Christian'),
  ('cooking'),
  ('cleaning'),
  ('first aid'),
  -- 16
  ('game'),
  ('board game'),
  ('adventure'), -- TODO: delete
  ('miscellaneous'),
  ('stationery'),
  -- 21
  ('recruitment'),
  ('sports'),
  ('verify'),
  ('phased out'),
  ('restricted');

INSERT INTO location (code) VALUES ('out'), ('a1'), ('a2');

CREATE OR REPLACE PROCEDURE insert_item(
  _item_arr item[],
  _item_variant_arr item_variant[],
  _item_category_id_arr integer[],
  _item_variant_category_id_arr_arr integer[][]
)
  LANGUAGE plpgsql
  AS $$
DECLARE
  _i integer := 1;
  _item item := _item_arr[1];
  _item_id integer;
  _item_variant item_variant;
  _item_variant_id integer;
  _item_variant_id_arr integer[];
  _item_category_id integer;
  _item_variant_category_id_arr integer[];
  _item_variant_category_id_arr_arr_2 integer[][];
  _item_variant_category_id integer;
BEGIN
  INSERT INTO item (name, quantity_metric, description) VALUES (_item.name, _item.quantity_metric, _item.description) RETURNING id INTO _item_id;

  FOREACH _item_category_id IN ARRAY _item_category_id_arr LOOP
    INSERT INTO item_category VALUES (_item_id, _item_category_id);
  END LOOP;

  FOREACH _item_variant IN ARRAY _item_variant_arr LOOP
    INSERT INTO item_variant (item_id, name, initial_quantity, current_quantity) VALUES
        (_item_id, _item_variant.name, _item_variant.initial_quantity, _item_variant.current_quantity)
        RETURNING id INTO _item_variant_id;

    IF _item_variant_category_id_arr_arr IS NOT NULL AND _item_variant_category_id_arr_arr[_i:_i] IS NOT NULL THEN
      FOREACH _item_variant_category_id IN ARRAY _item_variant_category_id_arr_arr[_i:_i] LOOP
        IF _item_variant_category_id = 0 THEN
          EXIT;
        END IF;
        INSERT INTO item_variant_category VALUES (_item_variant_id, _item_variant_category_id);
      END LOOP;
    END IF;

    _i := _i + 1;
  END LOOP;
END;
$$;

-- item(_id, name, quantity metric)
-- item_variant(_item_id, _id,
-- name, init_qty, curr_qty);

-- ADVENTURE EQUIPMENT
CALL insert_item(
  '{"(1,bicycle pump,,)"}'::item[],
  '{"(1,1,,8,8)"}'::item_variant[],
  array[3, 4],
  array[[23]]
);
CALL insert_item(
  '{"(,bicycle tyre,,)"}'::item[],
  '{"(,,,8,8)"}'::item_variant[],
  array[3, 4],
  array[[23]]
);
CALL insert_item(
  '{"(,blaze race pack,,)"}'::item[],
  '{"(,,red,2,2)","(,,blue,2,2)","(,,clear,5,5)"}'::item_variant[],
  array[3, 4],
  null
);
CALL insert_item(
  '{"(,camping bag,,)"}'::item[],
  '{"(,,,6,6)"}'::item_variant[],
  array[3, 4],
  array[[23]]
);
CALL insert_item(
  '{"(,commscord,,)"}'::item[],
  '{"(,,,4,4)"}'::item_variant[],
  array[3, 4],
  null
);

CALL insert_item(
  '{"(,compass,,)"}'::item[],
  '{"(,,new,10,10)","(,,old,17,17)"}'::item_variant[],
  array[3, 4],
  array[[2], [1]]
);
CALL insert_item(
  '{"(,compass base plate,,)"}'::item[],
  '{"(,,no housing,12,12)"}'::item_variant[],
  array[3, 4],
  null
);
CALL insert_item(
  '{"(,compass housing,,)"}'::item[],
  '{"(,,red,12,12)"}'::item_variant[],
  array[3, 4],
  null
);
CALL insert_item(
  '{"(,compass mini,,)"}'::item[],
  '{"(,,new,6,6)"}'::item_variant[],
  array[3, 4],
  array[[2]]
);
CALL insert_item(
  '{"(,danger tape,rolls,)"}'::item[],
  '{"(,,,5,5)"}'::item_variant[],
  array[3, 4],
  null
);

CALL insert_item(
  '{"(,glow battle lights,,)"}'::item[],
  '{"(,,green,4,4)","(,,blue,4,4)"}'::item_variant[],
  array[3, 4],
  array[[23], [23]]
);
CALL insert_item(
  '{"(,groundsheet,,)"}'::item[],
  '{"(,,new,0,0)","(,,old,0,0)"}'::item_variant[],
  array[3, 4],
  array[[2, 23], [1, 23]]
);
CALL insert_item(
  '{"(,map,,)"}'::item[],
  '{"(,,\"Pulau Ubin (2008)\",1,1)","(,,\"Singapore (2010)\",6,6)","(,,\"Singapore (2015)\",4,4)"}'::item_variant[],
  array[3, 4],
  null
);
CALL insert_item(
  '{"(,zoomed in map,,)"}'::item[],
  '{"(,,Bedok,4,4)","(,,CBD,4,4)","(,,ECP Zone B,3,3)"}'::item_variant[],
  array[3, 4],
  null
);
CALL insert_item(
  '{"(,pocket compass,,)"}'::item[],
  '{"(,,,9,8)"}'::item_variant[],
  array[3, 4],
  null
);

CALL insert_item(
  '{"(,pocket counter,,)"}'::item[],
  '{"(,,,7,7)"}'::item_variant[],
  array[3, 4],
  null
);
CALL insert_item(
  '{"(,poncho,,)"}'::item[],
  '{"(,,,43,43)"}'::item_variant[],
  array[3, 4],
  null
);
CALL insert_item(
  '{"(,raffia string,,)"}'::item[],
  '{"(,,,10,10)"}'::item_variant[],
  array[3, 4],
  null
);
CALL insert_item(
  '{"(,tent peg,,)"}'::item[],
  '{"(,,,190,190)"}'::item_variant[],
  array[3, 4],
  null
);
CALL insert_item(
  '{"(,the kage,,)"}'::item[],
  '{"(,,,2,2)"}'::item_variant[],
  array[3, 4],
  null
);

CALL insert_item(
  '{"(,rope,,)"}'::item[],
  '{"(,,thick,10,10)","(,,\"thick (long)\",2,2)","(,,thin,20,9)"}'::item_variant[],
  array[3, 4],
  array[[23], [0], [23]]
);
CALL insert_item(
  '{"(,torch,,)"}'::item[],
  '{"(,,,7,2)"}'::item_variant[],
  array[3, 4],
  null
);
CALL insert_item(
  '{"(,whistle,,)"}'::item[],
  '{"(,,,2,2)"}'::item_variant[],
  array[3, 4],
  null
);
CALL insert_item(
  '{"(,zip tie,,)"}'::item[],
  '{"(,,black,45,22)","(,,white,73,73)"}'::item_variant[],
  array[3, 4],
  null
);
CALL insert_item(
  '{"(,aluminium wire,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[3, 4],
  null
);

-- BADGES
CALL insert_item(
  '{"(,Adventure,,)"}'::item[],
  '{"(,,,26,26)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Arts,,)"}'::item[],
  '{"(,,,13,13)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Athletics,,)"}'::item[],
  '{"(,,,27,27)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Bandsman,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Bugler,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[5, 6],
  null
);

CALL insert_item(
  '{"(,Christian Education,,)"}'::item[],
  '{"(,,,10,10)"}'::item_variant[],
  array[5, 6],
  array[[24]]
);
CALL insert_item(
  '{"(,Citizenship,,)"}'::item[],
  '{"(,,,18,18)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Community Service,,)"}'::item[],
  '{"(,,,16,16)"}'::item_variant[],
  array[5, 6]::integer[],
  array[]::integer[][]
);
CALL insert_item(
  '{"(,Crafts,,)"}'::item[],
  '{"(,,,10,10)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Drill,,)"}'::item[],
  '{"(,,,25,25)"}'::item_variant[],
  array[5, 6],
  null
);

CALL insert_item(
  '{"(,Drummer''s,,)"}'::item[],
  '{"(,,,5,5)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Environmentalist,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Fireman,,)"}'::item[],
  '{"(,,,6,6)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,First Aid,,)"}'::item[],
  '{"(,,,43,43)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Gymnastics,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[5, 6],
  null
);

CALL insert_item(
  '{"(,Hobbies,,)"}'::item[],
  '{"(,,,27,27)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,\"Intermediate Proficiency Award (IPA)\",,)"}'::item[],
  '{"(,,,18,18)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,International Relations,,)"}'::item[],
  '{"(,,,9,9)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Kayaking,,)"}'::item[],
  '{"(,,,21,21)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,\"Leadership (NCO Star)\",,)"}'::item[],
  '{"(,,,20,20)"}'::item_variant[],
  array[5, 6],
  null
);

CALL insert_item(
  '{"(,Life Skills,,)"}'::item[],
  '{"(,,,11,11)"}'::item_variant[],
  array[5, 6],
  array[[24]]
);
CALL insert_item(
  '{"(,Link,,)"}'::item[],
  '{"(,,,5,5)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Long Year Service,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Musketry,,)"}'::item[],
  '{"(,,,15,15)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,National Event,,)"}'::item[],
  '{"(,,,15,15)"}'::item_variant[],
  array[5, 6],
  null
);

CALL insert_item(
  '{"(,Naturalist,,)"}'::item[],
  '{"(,,,20,20)"}'::item_variant[],
  array[5, 6],
  array[[24]]
);
CALL insert_item(
  '{"(,One Year Service,,)"}'::item[],
  '{"(,,,48,48)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Piper''s,,)"}'::item[],
  '{"(,,,7,7)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Sailing,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,SANA,,)"}'::item[],
  '{"(,,,7,7)"}'::item_variant[],
  array[5, 6],
  null
);

CALL insert_item(
  '{"(,\"Senior Proficiency Award (SPA)\",,)"}'::item[],
  '{"(,,,16,16)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Sportsman,,)"}'::item[],
  '{"(,,,16,16)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Cloth,,)"}'::item[],
  '{"(,,Stage 2,21,21)","(,,Stage 3,36,36)"}'::item_variant[],
  array[5, 6],
  array[[0], [24]]
);
CALL insert_item(
  '{"(,Swimming,,)"}'::item[],
  '{"(,,,25,25)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Target,,)"}'::item[],
  '{"(,,,65,65)"}'::item_variant[],
  array[5, 6],
  null
);

CALL insert_item(
  '{"(,Three Year Service,,)"}'::item[],
  '{"(,,,17,17)"}'::item_variant[],
  array[5, 6],
  null
);
CALL insert_item(
  '{"(,Total Defence,,)"}'::item[],
  '{"(,,Bronze,9,9)","(,,Silver,6,6)","(,,Gold,6,6)"}'::item_variant[],
  array[5, 6],
  null
);

-- BOYS' RANKS
CALL insert_item(
  '{"(,chevron,,)"}'::item[],
  '{"(,,PTE,58,58)","(,,LCP,29,29)","(,,CPL,26,26)","(,,SGT,18,18)","(,,SSG,12,12)"}'::item_variant[],
  array[6, 9, 10],
  null
);
CALL insert_item(
  '{"(,\"chevron (no velcro)\",,)"}'::item[],
  '{"(,,PTE,8,8)","(,,LCP,9,9)","(,,CPL,10,10)","(,,SGT,11,11)","(,,SSG,3,3)"}'::item_variant[],
  array[6, 9, 10],
  null
);
CALL insert_item(
  '{"(,crest,,)"}'::item[],
  '{"(,,WO,5,5)"}'::item_variant[],
  array[6, 9, 10],
  null
);
CALL insert_item(
  '{"(,field rank,,)"}'::item[],
  '{"(,,LCP,32,32)","(,,CPL,5,5)","(,,SGT,17,17)","(,,SSG,11,11)","(,,WO,5,5)"}'::item_variant[],
  array[6, 9, 10],
  null
);

-- BOYS' UNIFORM PARTS
CALL insert_item(
  '{"(,anklet,,)"}'::item[],
  '{"(,,left,12,12)","(,,right,12,12)"}'::item_variant[],
  array[6, 10],
  null
);
CALL insert_item(
  '{"(,belt,,)"}'::item[],
  '{"(,,new,0,0)","(,,old,2,2)"}'::item_variant[],
  array[6, 10],
  array[[2, 0], [1, 23]]
);
CALL insert_item(
  '{"(,boots,,)"}'::item[],
  '{"(,,size 6,0,0)","(,,size 7,0,0)","(,,size 8,1,1)","(,,size 9,0,0)","(,,size 10,0,0)","(,,size 11,0,0)","(,,size 12,0,0)"}'::item_variant[],
  array[6, 10],
  array[[23], [23], [0], [23], [23], [23], [23]]
);
CALL insert_item(
  '{"(,cap badge,,)"}'::item[],
  '{"(,,,7,7)"}'::item_variant[],
  array[6, 10],
  null
);
CALL insert_item(
  '{"(,\"cap (new)\",,)"}'::item[],
  '{"(,,size S,0,0)","(,,size M,0,0)","(,,size L,0,0)"}'::item_variant[],
  array[2, 6, 10],
  array[[23], [23], [23]]
);

CALL insert_item(
  '{"(,\"cap (old)\",,)"}'::item[],
  '{"(,,size S,0,0)","(,,size M,0,0)","(,,size L,0,0)"}'::item_variant[],
  array[1, 6, 10],
  array[[23], [23], [23]]
);
CALL insert_item(
  '{"(,cross belt,,)"}'::item[],
  '{"(,,new,4,4)","(,,old,1,1)"}'::item_variant[],
  array[6, 10],
  array[[2], [1]]
);
CALL insert_item(
  '{"(,drill cane,,)"}'::item[],
  '{"(,,,4,4)"}'::item_variant[],
  array[6, 10],
  null
);
CALL insert_item(
  '{"(,glove,,)"}'::item[],
  '{"(,,left,9,9)","(,,right,9,9)"}'::item_variant[],
  array[6, 10],
  null
);
CALL insert_item(
  '{"(,haversack,,)"}'::item[],
  '{"(,,,2,2)"}'::item_variant[],
  array[6, 10],
  null
);

CALL insert_item(
  '{"(,haversack button,,)"}'::item[],
  '{"(,,,12,12)"}'::item_variant[],
  array[6, 10],
  null
);
CALL insert_item(
  '{"(,haversack runner,,)"}'::item[],
  '{"(,,,13,13)"}'::item_variant[],
  array[6, 10],
  null
);
CALL insert_item(
  '{"(,haversack slide,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[6, 10],
  array[[23]]
);
CALL insert_item(
  '{"(,NCO lanyard,,)"}'::item[],
  '{"(,,new,29,29)","(,,old,1,1)"}'::item_variant[],
  array[6, 10],
  array[[2], [1]]
);
CALL insert_item(
  '{"(,pants,,)"}'::item[],
  '{"(,,size 25,0,0)","(,,size 26,0,0)","(,,size 27,0,0)","(,,size 27,0,0)","(,,size 28,0,0)","(,,size 29,0,0)","(,,size 30,0,0)","(,,size 31,0,0)","(,,size 32,0,0)","(,,size 33,0,0)","(,,size 34,0,0)","(,,size 35,0,0)","(,,size 36,0,0)"}'::item_variant[],
  array[6, 10],
  array[[23], [23], [23], [23], [23], [23], [23], [23], [23], [23], [23], [23]]
);

CALL insert_item(
  '{"(,polo tee,,)"}'::item[],
  '{"(,,size 3XS,0,0)","(,,size 2XS,0,0)","(,,size XS,0,0)","(,,size S,0,0)","(,,size M,0,0)","(,,size L,0,0)","(,,size XL,0,0)","(,,size 2XL,0,0)"}'::item_variant[],
  array[6, 10],
  array[[23], [23], [23], [23], [23], [23], [23], [23]]
);
CALL insert_item(
  '{"(,red sash,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[6, 10],
  array[[23]]
);
CALL insert_item(
  '{"(,shorts,,)"}'::item[],
  '{"(,,size S,0,0)","(,,size M,0,0)","(,,size L,0,0)"}'::item_variant[],
  array[6, 10],
  array[[23], [23], [23]]
);
CALL insert_item(
  '{"(,uniform shirt,,)"}'::item[],
  '{"(,,size 13,0,0)","(,,size 14,0,0)","(,,size 15,0,0)","(,,size 16,0,0)","(,,size 17,0,0)","(,,size 18,0,0)","(,,size 19,0,0)","(,,size 20,0,0)"}'::item_variant[],
  array[6, 10],
  array[[23], [23], [23], [23], [23], [23], [23], [23]]
);
CALL insert_item(
  '{"(,white glove,,)"}'::item[],
  '{"(,,new,0,0)","(,,old,0,0)"}'::item_variant[],
  array[6, 10],
  array[[2, 23], [1, 23]]
);

-- CHARACTER QUEST EQUIPMENT
CALL insert_item(
  '{"(,Action Bible,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[3, 11],
  null
);
CALL insert_item(
  '{"(,An Anchor for the Soul,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[3, 11, 12],
  null
);
CALL insert_item(
  '{"(,BB Mentoring in Youth Handbook,,)"}'::item[],
  '{"(,,,4,4)"}'::item_variant[],
  array[3, 11],
  null
);
CALL insert_item(
  '{"(,Bible DVD,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[3, 11],
  null
);
CALL insert_item(
  '{"(,chapteh,,)"}'::item[],
  '{"(,,,11,11)"}'::item_variant[],
  array[3, 11],
  null
);

CALL insert_item(
  '{"(,cloth,,)"}'::item[],
  '{"(,,black,1,1)"}'::item_variant[],
  array[3, 11],
  null
);
CALL insert_item(
  '{"(,country eraser,,)"}'::item[],
  '{"(,,,377,377)"}'::item_variant[],
  array[3, 11],
  null
);
CALL insert_item(
  '{"(,Holy Bible,,)"}'::item[],
  '{"(,,,12,12)"}'::item_variant[],
  array[3, 11],
  null
);
CALL insert_item(
  '{"(,ice-cream sticks,,)"}'::item[],
  '{"(,,\"coloured, packed of 50\",11,11)"}'::item_variant[],
  array[3, 11],
  null
);
CALL insert_item(
  '{"(,mahjong paper,rolls,)"}'::item[],
  '{"(,,,13,13)"}'::item_variant[],
  array[3, 11],
  null
);

CALL insert_item(
  '{"(,manga,,)"}'::item[],
  '{"(,,Messiah,3,3)","(,,Metamorphosis,1,1)","(,,Mutiny,7,7)"}'::item_variant[],
  array[3, 11, 12],
  null
);
CALL insert_item(
  '{"(,One Minute Bible,,)"}'::item[],
  '{"(,,,11,11)"}'::item_variant[],
  array[3, 11],
  null
);
CALL insert_item(
  '{"(,sunglasses,,)"}'::item[],
  '{"(,,black,13,13)","(,,red,2,2)"}'::item_variant[],
  array[3, 11],
  null
);
CALL insert_item(
  '{"(,The Action Bible Devotion,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[3, 11],
  null
);
CALL insert_item(
  '{"(,The God in Your Bible Studies Series,,)"}'::item[],
  '{"(,,,9,9)"}'::item_variant[],
  array[3, 11, 12],
  null
);

CALL insert_item(
  '{"(,The World in Your Pocket,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[3, 11, 12],
  null
);
CALL insert_item(
  '{"(,What On Earth Am I Here For?,,)"}'::item[],
  '{"(,,,16,16)"}'::item_variant[],
  array[3, 11, 12],
  null
);

--COOKING AND CLEANING EQUIPMENT
CALL insert_item(
  '{"(,bowl,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);
CALL insert_item(
  '{"(,bunsen burner,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);
CALL insert_item(
  '{"(,butter knife,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);
CALL insert_item(
  '{"(,chopping board,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);
CALL insert_item(
  '{"(,chopstick,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);

CALL insert_item(
  '{"(,cup,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);
CALL insert_item(
  '{"(,dishwashing liquid,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 14],
  array[[23]]
);
CALL insert_item(
  '{"(,firestarter,,)"}'::item[],
  '{"(,,pack of 40,1,1)"}'::item_variant[],
  array[3, 13],
  null
);
CALL insert_item(
  '{"(,fork,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);
CALL insert_item(
  '{"(,gun lighted,,)"}'::item[],
  '{"(,,,2,2)"}'::item_variant[],
  array[3, 13],
  array[[25]]
);

CALL insert_item(
  '{"(,induction stove,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);
CALL insert_item(
  '{"(,knife,,)"}'::item[],
  '{"(,,,3,3)"}'::item_variant[],
  array[3, 13],
  array[[25]]
);
CALL insert_item(
  '{"(,ladle,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);
CALL insert_item(
  '{"(,lighter,,)"}'::item[],
  '{"(,,,24,24)"}'::item_variant[],
  array[3, 13],
  array[[25]]
);
CALL insert_item(
  '{"(,matchbox,,)"}'::item[],
  '{"(,,,41,41)"}'::item_variant[],
  array[3, 13],
  array[[25]]
);

CALL insert_item(
  '{"(,mess tin,,)"}'::item[],
  '{"(,,,46,46)"}'::item_variant[],
  array[3, 13],
  null
);
CALL insert_item(
  '{"(,\"steel wool (metal sponge)\",,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 14],
  array[[23]]
);
CALL insert_item(
  '{"(,plate,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);
CALL insert_item(
  '{"(,saucepan,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);
CALL insert_item(
  '{"(,solid fuel,,)"}'::item[],
  '{"(,,pack of 8,11,11)"}'::item_variant[],
  array[3, 13],
  null
);

CALL insert_item(
  '{"(,spatula,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);
CALL insert_item(
  '{"(,sponge,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);
CALL insert_item(
  '{"(,spoon,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23]]
);
CALL insert_item(
  '{"(,tommy cooker,,)"}'::item[],
  '{"(,,new,0,0)","(,,old,0,0)"}'::item_variant[],
  array[3, 13],
  array[[2, 23], [1, 23]]
);
CALL insert_item(
  '{"(,tongs,,)"}'::item[],
  '{"(,,long,0,0)","(,,short,0,0)"}'::item_variant[],
  array[3, 13],
  array[[23], [23]]
);

-- FIRST AID
CALL insert_item(
  '{"(,bandage,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[15],
  array[[23]]
);
CALL insert_item(
  '{"(,first aid kit,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[15],
  array[[23]]
);
CALL insert_item(
  '{"(,Little Anne dummy,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[15],
  array[[23]]
);

-- GAMES
CALL insert_item(
  '{"(,balloon,,)"}'::item[],
  '{"(,,,121,121)"}'::item_variant[],
  array[16],
  null
);
CALL insert_item(
  '{"(,bowling pin,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[16],
  array[[23]]
);
CALL insert_item(
  '{"(,Cluedo,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[16, 17],
  null
);
CALL insert_item(
  '{"(,Exploding Kittens,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[16, 17],
  null
);
CALL insert_item(
  '{"(,Monopoly Deal,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[16, 17],
  array[[23]]
);

CALL insert_item(
  '{"(,Nemesis,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[16, 17],
  array[[23]]
);
CALL insert_item(
  '{"(,Nerf bullet,,)"}'::item[],
  '{"(,,,350,350)"}'::item_variant[],
  array[16],
  null
);

-- MISCELLANEOUS
CALL insert_item(
  '{"(,five-way pipe,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[19],
  array[[23]]
);
CALL insert_item(
  '{"(,tetrahedral pipe,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[19],
  array[[23]]
);
CALL insert_item(
  '{"(,flag hoist,,)"}'::item[],
  '{"(,,,3,3)"}'::item_variant[],
  array[19],
  null
);

-- STATIONERY
CALL insert_item(
  '{"(,A4 folder,,)"}'::item[],
  '{"(,,blue,4,4)","(,,green,2,2)","(,,grey/gray,7,7)","(,,purple,8,8)","(,,red,14,14)"}'::item_variant[],
  array[2, 20],
  null
);
CALL insert_item(
  '{"(,\"A4 folder (old)\",,)"}'::item[],
  '{"(,,blue,17,17)"}'::item_variant[],
  array[1, 20],
  null
);
CALL insert_item(
  '{"(,tape,,)"}'::item[],
  '{"(,,clear,0,0)","(,,double-sided,0,0)","(,,duct,0,0)","(,,masking,0,0)","(,,scotch,0,0)"}'::item_variant[],
  array[20],
  array[[23], [23], [23], [23], [23]]
);
CALL insert_item(
  '{"(,clipboard,,)"}'::item[],
  '{"(,,,2,2)"}'::item_variant[],
  array[20],
  null
);
CALL insert_item(
  '{"(,colour pencil,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[20],
  array[[23]]
);

CALL insert_item(
  '{"(,eraser,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[20],
  array[[23]]
);
CALL insert_item(
  '{"(,marker,,)"}'::item[],
  '{"(,,colouring,0,0)","(,,whiteboard,0,0)","(,,permanent,0,0)"}'::item_variant[],
  array[20],
  array[[23], [23], [23]]
);
CALL insert_item(
  '{"(,pencil,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[20],
  array[[23]]
);
CALL insert_item(
  '{"(,scissors,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[20],
  array[[23]]
);

-- OFFICERS' UNIFORM PARTS
CALL insert_item(
  '{"(,Officer''s lanyard,,)"}'::item[],
  '{"(,,,2,2)"}'::item_variant[],
  array[7, 10],
  null
);

-- PRIMERS' RANKS
CALL insert_item(
  '{"(,\"Cadet Lieutenant (CLT) Epaulattes\",,)"}'::item[],
  '{"(,,new,15,15)","(,,old,3,3)"}'::item_variant[],
  array[8, 9, 10],
  array[[2], [1]]
);
CALL insert_item(
  '{"(,\"Senior Cadet Lieutenant (SCL) Epaulattes\",,)"}'::item[],
  '{"(,,,2,2)"}'::item_variant[],
  array[8, 9, 10],
  null
);
CALL insert_item(
  '{"(,field rank,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[8, 9, 10],
  array[[23]]
);

-- PRIMERS' UNIFORM PARTS
CALL insert_item(
  '{"(,chrome belt buckle,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[8, 10],
  array[[23]]
);
CALL insert_item(
  '{"(,cap badge,,)"}'::item[],
  '{"(,,,0,0)"}'::item_variant[],
  array[8, 10],
  array[[23]]
);
CALL insert_item(
  '{"(,cap,,)"}'::item[],
  '{"(,,size S,0,0)","(,,size M,0,0)","(,,size L,0,0)"}'::item_variant[],
  array[8, 10],
  array[[23], [23], [23]]
);
CALL insert_item(
  '{"(,\"uniform shirt (short sleeve)\",,)"}'::item[],
  '{"(,,size S,0,0)","(,,size M,0,0)","(,,size L,0,0)"}'::item_variant[],
  array[8, 10],
  array[[23], [23], [23]]
);
CALL insert_item(
  '{"(,uniform shirt,,)"}'::item[],
  '{"(,,size S,0,0)","(,,size M,0,0)","(,,size L,0,0)"}'::item_variant[],
  array[8, 10],
  array[[23], [23], [23]]
);

CALL insert_item(
  '{"(,lanyard,,)"}'::item[],
  '{"(,,,3,3)"}'::item_variant[],
  array[8, 10],
  null
);
CALL insert_item(
  '{"(,polo tee,,)"}'::item[],
  '{"(,,size XS,0,0)","(,,size S,0,0)","(,,size M,0,0)","(,,size L,0,0)","(,,XL,0,0)"}'::item_variant[],
  array[8, 10],
  array[[23], [23], [23], [23], [23]]
);

-- RECRUITMENT
CALL insert_item(
  '{"(,BB Maskk,,)"}'::item[],
  '{"(,,,20,20)"}'::item_variant[],
  array[21],
  null
);
CALL insert_item(
  '{"(,\"Boys'' uniform leaflet\",,)"}'::item[],
  '{"(,,,68,68)"}'::item_variant[],
  array[21],
  null
);
CALL insert_item(
  '{"(,family starter kit,,)"}'::item[],
  '{"(,,,34,34)"}'::item_variant[],
  array[21],
  null
);
CALL insert_item(
  '{"(,Guardian of The City,,)"}'::item[],
  '{"(,,,10,10)"}'::item_variant[],
  array[21],
  null
);
CALL insert_item(
  '{"(,Guardian of The City 2,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[21],
  null
);

CALL insert_item(
  '{"(,notepad,,)"}'::item[],
  '{"(,,small,41,40)"}'::item_variant[],
  array[21],
  null
);
CALL insert_item(
  '{"(,\"Officers''/Volunteers'' uniform leaflet\",,)"}'::item[],
  '{"(,,,22,22)"}'::item_variant[],
  array[21],
  null
);
CALL insert_item(
  '{"(,\"Primers'' uniform leaflet\",,)"}'::item[],
  '{"(,,,13,13)"}'::item_variant[],
  array[21],
  null
);

-- SPORTS EQUIPMENT
CALL insert_item(
  '{"(,basketball,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[3, 22],
  null
);
CALL insert_item(
  '{"(,\"flat marker (flat disc cone)\",,)"}'::item[],
  '{"(,,,38,38)"}'::item_variant[],
  array[3, 22],
  array[[23]]
);
CALL insert_item(
  '{"(,frisbee,,)"}'::item[],
  '{"(,,,6,6)"}'::item_variant[],
  array[3, 22],
  null
);
CALL insert_item(
  '{"(,plastic cone,,)"}'::item[],
  '{"(,,,27,27)"}'::item_variant[],
  array[3, 22],
  null
);
CALL insert_item(
  '{"(,\"table tennis (ping pong) ball\",,)"}'::item[],
  '{"(,,,189,189)"}'::item_variant[],
  array[3, 22],
  null
);

CALL insert_item(
  '{"(,\"table tennis (ping pong) bat\",,)"}'::item[],
  '{"(,,,7,7)"}'::item_variant[],
  array[3, 22],
  null
);
CALL insert_item(
  '{"(,\"table tennis (ping pong) net\",,)"}'::item[],
  '{"(,,,2,2)"}'::item_variant[],
  array[3, 22],
  null
);
CALL insert_item(
  '{"(,tennis shoe bag,,)"}'::item[],
  '{"(,,,2,2)"}'::item_variant[],
  array[3, 22],
  array[[23]]
);
CALL insert_item(
  '{"(,volleyball,,)"}'::item[],
  '{"(,,,1,1)"}'::item_variant[],
  array[3, 22],
  null
);