-- Some initial data to play with.  These INSERT statements should succeed.
-- Do NOT modify these.
INSERT INTO RegisteredUser VALUES(1, 'Ned Flanders', 'flanders@vegas.com');
INSERT INTO RegisteredUser VALUES(2, 'Apu Nahasapeemapetilon', 'apu@yahoo.com');
INSERT INTO RegisteredUser VALUES(3, 'Crazy Vaclav', 'vaclav@hotmail.com');
INSERT INTO Seller VALUES(2, '9728287011');
INSERT INTO Seller VALUES(3, '800GOCRAZY');
INSERT INTO Dealer VALUES(3, '1 Crazy Pl., Springfield');
INSERT INTO Automobile VALUES('1G1FP31E2KL169285',
  'Bugatti', 'Vision Gran Turismo', 2015,
  'blue', 0, 'other',
  3, 549999.99);
INSERT INTO Automobile VALUES('1G1FP31E2KL169286',
  'Rolls-Royce', 'Phantom', 2018,
  'black', 0, 'other',
  3, 1549999.99);
INSERT INTO Review VALUES(1,
  'Bugatti', 'Vision Gran Turismo', 2015,
  1, 'Owning this car makes you a god!', '2015-09-01');
INSERT INTO Review VALUES(2,
  'Rolls-Royce', 'Phantom', 2019,
  3, 'My 1985 Yugo GV runs better than this!', '2019-09-01');
INSERT INTO Review VALUES(3,
  'Bugatti', 'classic', 2015,
  1, 'Owning this car makes you a god!', '2015-09-01');
~                                                                                         
~                                                                                         
~                                                                    