DELETE FROM item_location
WHERE location_id IN (
  SELECT id FROM location WHERE code IN ('a1', 'a2')
);
DELETE FROM location WHERE code IN ('a1', 'a2');

INSERT INTO location (code) VALUES
('LOC-01-C01'),
('LOC-01-C02'),
('LOC-01-B01'),
('LOC-01-B02'),
('LOC-01-A01'),
('LOC-01-A02'),
('LOC-02-F01'),
('LOC-02-F02'),
('LOC-02-E01'),
('LOC-02-E02'),
('LOC-02-D01'),
('LOC-02-D02'),
('LOC-02-C01'),
('LOC-02-C02'),
('LOC-02-B01'),
('LOC-02-B02'),
('LOC-02-A01'),
('LOC-02-A02'),
('LOC-03-E01'),
('LOC-03-E02'),
('LOC-03-D01'),
('LOC-03-D02'),
('LOC-03-C01');