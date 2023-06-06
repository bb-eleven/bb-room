DELETE FROM item_category WHERE category_id = 23;
INSERT INTO item_category
SELECT id AS item_id, 23 AS category_id FROM item WHERE
name = 'glow battle lights'
OR name = 'groundsheet'
OR name = 'hiking bag'
OR name = 'tarpauline'
OR name = 'tent'
OR (name = 'rope' AND variant_name = 'thick (long)')
OR (name = 'rope' AND variant_name = 'thin')
OR name = 'mess kit'
OR name = 'cup (metal)'
OR (name = 'cup (plastic + disposable)' AND variant_name = 'large')
OR name = 'pot'
OR name = 'tommy cooker'
OR name = 'tray (metal)'
OR name = 'bowling pin'
OR name = 'battery'
OR name = 'envelope'
OR name = 'tennis shoe bag';