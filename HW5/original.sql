-- Modify the CREATE TABLE statements as needed to add constraints.
-- Do not otherwise change the columns or their types.
-- Notes: Every seller is a user, and every dealer is a seller
-- Any registered user can post reviews
-- Each review is about one particular model, make, and year
-- but not about a particular vehicle (can have two of the same)
-- Reviews distinguished by dates
-- Can't use CHECK or CREATE ASSERTION
-- Reference document for date manipulation functions


CREATE TABLE Automobile
(vin CHAR(17) NOT NULL PRIMARY KEY,
 make VARCHAR(32) NOT NULL,
 CHECK make = 'Honda' OR 'Bugatti' OR 'Rolls-Royce' OR 'Toyota' OR 'Ford' OR 'Jeep' OR 'other',
 model VARCHAR(32) NOT NULL,
 year INTEGER NOT NULL,
 color VARCHAR(32) NOT NULL,
 mileage INTEGER NOT NULL,
 body_style VARCHAR(16) NOT NULL,
 sellerid INTEGER NOT NULL REFERENCES Seller(id),
 price DECIMAL(10, 2) NOT NULL);


CREATE TABLE RegisteredUser
(id INTEGER NOT NULL PRIMARY KEY,
 name VARCHAR(256) NOT NULL,
 email VARCHAR(256) NOT NULL);


CREATE TABLE Seller
(id INTEGER NOT NULL REFERENCES RegisteredUser(id) PRIMARY KEY ,
 phone CHAR(10) NOT NULL);


CREATE TABLE Dealer
(id INTEGER NOT NULL PRIMARY KEY REFERENCES Seller(id),
 address VARCHAR(256) NOT NULL);


CREATE TABLE Review
(reviewid INTEGER NOT NULL PRIMARY KEY,
 make VARCHAR(32) NOT NULL,
 CHECK make = 'Honda' OR 'Bugatti' OR 'Rolls-Royce' OR 'Toyota' OR 'Ford' OR 'Jeep' OR 'other',
 model VARCHAR(32) NOT NULL,
 year INTEGER NOT NULL,
 authorid INTEGER NOT NULL REFERENCES RegisteredUser(id),
 text VARCHAR(400) NOT NULL,
 date DATE NOT NULL,
 CHECK date > DATE(CAST(year AS VARCHAR) || '-01-01'));


-- Using triggers, enforce that we cannot have a seller/dealer selling
-- an automobile and simultaneously writing a review for the same make,
-- model, and year.

--  first trigger function is to check that the reviewer is not a seller 
--- in Automobile for the same model, make and year of vehicle
CREATE FUNCTION TF_Review_no_selfie() RETURNS TRIGGER AS $$
BEGIN
  -- YOUR IMPLEMENTATION GOES HERE
  IF EXISTS (SELECT *
  FROM Automobile AS Automobile
  WHERE A.make = NEW.make and
  A.model = NEW.model and
  A.year = NEW.year and
  A.sellerid = NEW.authorid
  AND EXISTS (
      SELECT *
      FROM RegisteredUser as R
      WHERE R.id = NEW.authorid
  )) THEN RAISE EXCEPTION '% % % already being sold by %',  NEW.year, NEW.make, NEW.model, NEW.authorid,
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER TG_Review_no_selfie
  BEFORE INSERT OR UPDATE ON Review
  FOR EACH ROW
  EXECUTE PROCEDURE TF_Review_no_selfie();

-- check that the seller is not a reviewer in Review for the same 3 attributes


CREATE FUNCTION TF_Automobile_no_selfie() RETURNS TRIGGER AS $$
BEGIN
  -- YOUR IMPLEMENTATION GOES HERE
  IF EXISTS (SELECT *
  FROM Review AS R
  WHERE R.make = NEW.make and
  R.model = NEW.model and
  R.year = NEW.year and
  R.authorid = NEW.sellerid
  AND EXISTS (
      SELECT *
      FROM RegisteredUser as Reg
      WHERE Reg.id = NEW.sellerid
  )) THEN RAISE EXCEPTION '% % % already being sold by %', NEW.year, NEW.make, NEW.model, NEW.sellerid
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER TG_Automobile_no_selfie
  BEFORE INSERT OR UPDATE ON Automobile
  FOR EACH ROW
  EXECUTE PROCEDURE TF_Automobile_no_selfie();

-- Define a view that lists, for each make-model pair, the
-- avg number of reviews per year, the avg number of automobiles for sale
-- per year, and the average price per sale.

-- CREATE VIEW ModelSummary(make, model,
--                          avg_reviews, avg_forsale, avg_price) AS
-- YOUR IMPLEMENTATION GOES HERE
CREATE VIEW ModelSummary AS
    (SELECT A.make, A.model, A.year
    FROM Automobile AS A
    FULL OUTER JOIN 
    SELECT count(*) as num_reviews
    FROM Review AS R
    WHERE R.make = A.make and
    R.model = A.model and 
    R.year = A.year
    GROUP BY make, model, year
    FULL OUTER JOIN 
    SELECT count(*) as num_forsale
    FROM Automobile as A2
    WHERE A2.make = A.make and
    A2.model = A.model and 
    A2.year = A.year
    GROUP BY make, model, year
    FULL OUTER JOIN 
    SELECT AVG(A3.price) as avg_price
    FROM Automobile as A3
    GROUP BY make, model, year)