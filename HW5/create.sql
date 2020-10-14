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

CREATE TABLE Automobile
(vin CHAR(17) NOT NULL PRIMARY KEY,
 make VARCHAR(32) NOT NULL,
 CHECK (make in ('Honda', 'Bugatti', 'Rolls-Royce', 'Toyota', 'Ford', 'Jeep', 'other')),
 model VARCHAR(32) NOT NULL,
 year INTEGER NOT NULL,
 color VARCHAR(32) NOT NULL,
 mileage INTEGER NOT NULL,
 body_style VARCHAR(16) NOT NULL,
 sellerid INTEGER NOT NULL REFERENCES Seller(id),
 price DECIMAL(10, 2) NOT NULL);

CREATE TABLE Review
(reviewid INTEGER NOT NULL PRIMARY KEY,
 make VARCHAR(32) NOT NULL,
 CHECK (make in ('Honda', 'Bugatti', 'Rolls-Royce', 'Toyota', 'Ford', 'Jeep', 'other')),
 model VARCHAR(32) NOT NULL,
 year INTEGER NOT NULL,
 authorid INTEGER NOT NULL REFERENCES RegisteredUser(id),
 text VARCHAR(400) NOT NULL,
 date DATE NOT NULL,
 CHECK (date > DATE(CAST(year AS VARCHAR) || '-01-01')));

-- Using triggers, enforce that we cannot have a seller/dealer selling
-- an automobile and simultaneously writing a review for the same make,
-- model, and year.

CREATE FUNCTION TF_Review_no_selfie() RETURNS TRIGGER AS $$
BEGIN
  -- YOUR IMPLEMENTATION GOES HERE
  IF EXISTS (SELECT *
  FROM Automobile AS A
  WHERE A.make = NEW.make and
  A.model = NEW.model and
  A.year = NEW.year and
  A.sellerid = NEW.authorid
  AND EXISTS (
      SELECT *
      FROM RegisteredUser as R
      WHERE R.id = NEW.authorid
  )) THEN RAISE EXCEPTION '% % % already being sold by %',  NEW.year, NEW.make, NEW.model, NEW.authorid;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TG_Review_no_selfie
  BEFORE INSERT OR UPDATE ON Review
  FOR EACH ROW
  EXECUTE PROCEDURE TF_Review_no_selfie();

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
  )) THEN RAISE EXCEPTION '% % % already being sold by %', NEW.year, NEW.make, NEW.model, NEW.sellerid;
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

-- CREATE VIEW ModelSummary(make, model, year,
--                          num_reviews, num_forsale, avg_price) AS
CREATE VIEW ModelSummary AS
  SELECT R.make, R.model, R.year, count(R.*) as num_reviews, 
  count(A.*) as num_forsale, AVG(A.price) as avg_price
  FROM Automobile A
  FULL OUTER JOIN Review R
  ON A.make = R.make
  GROUP BY R.make, R.model, R.year
