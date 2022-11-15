
DROP TRIGGER IF EXISTS deleted_tuples;
CREATE TABLE IF NOT EXISTS Deleted_Tuples AS (SELECT * FROM Penna LIMIT 0);
DROP TRIGGER IF EXISTS inserted_tuples;
CREATE TABLE IF NOT EXISTS Inserted_Tuples AS (SELECT * FROM Penna LIMIT 0);
DROP TRIGGER IF EXISTS updated_tuples;
CREATE TABLE IF NOT EXISTS Updated_Tuples AS (SELECT * FROM Penna LIMIT 0);
SET sql_safe_updates = 0;

DELIMITER //
CREATE TRIGGER deleted_tuples BEFORE DELETE ON Penna FOR EACH ROW
BEGIN
    
    INSERT INTO Deleted_Tuples (ID, Timestamp, state, locality, precinct, geo, totalvotes, Biden, Trump, filestamp)
    VALUES (OLD.ID, OLD.Timestamp, OLD.state, OLD.locality, OLD.precinct, OLD.geo, OLD.totalvotes, OLD.Biden, OLD.Trump, OLD.filestamp);
    
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER inserted_tuples BEFORE INSERT ON Penna FOR EACH ROW
BEGIN
    
    INSERT INTO Inserted_Tuples (ID, Timestamp, state, locality, precinct, geo, totalvotes, Biden, Trump, filestamp)
    VALUES (NEW.ID, NEW.Timestamp, NEW.state, NEW.locality, NEW.precinct, NEW.geo, NEW.totalvotes, NEW.Biden, NEW.Trump, NEW.filestamp);
    
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER updated_tuples BEFORE UPDATE ON Penna FOR EACH ROW
BEGIN
    
    INSERT INTO Updated_Tuples (ID, Timestamp, state, locality, precinct, geo, totalvotes, Biden, Trump, filestamp)
    VALUES (OLD.ID, OLD.Timestamp, OLD.state, OLD.locality, OLD.precinct, OLD.geo, OLD.totalvotes, OLD.Biden, OLD.Trump, OLD.filestamp);
    
END //
DELIMITER ;

-- DELETE EXAMPLES
SELECT * FROM Deleted_Tuples;

DELETE FROM Penna
WHERE precinct = 'Adams Township - Dunlo Voting Precinct'
AND Timestamp = '2020-11-04 03:58:36';

SELECT * FROM Deleted_Tuples;

DELETE FROM Penna
WHERE precinct = 'Cambria Township - Colver Voting Precinct';

SELECT * FROM Deleted_Tuples;

-- INSERT EXAMPLES
SELECT * FROM Inserted_Tuples;

INSERT INTO Penna(ID, Timestamp, state, locality, precinct, geo, totalvotes, Biden, Trump, filestamp)
    VALUES(143, '2020-11-11 23:34:26', 'PA', 'Centre', 'FERGUSON NORTH 1', '42027-FERGUSON TWP NORTH 1', 1390, 1, 0, 'NOVEMBER_11_2020_233426.json');

SELECT * FROM Inserted_Tuples;

INSERT INTO Penna(ID, Timestamp, state, locality, precinct, geo, totalvotes, Biden, Trump, filestamp)
    VALUES(143, '2020-11-11 23:34:26', 'PA', 'Centre', 'FERGUSON NORTH 2', '42027-FERGUSON TWP NORTH 2', 940, 3, 1, 'NOVEMBER_11_2020_233426.json');

SELECT * FROM Inserted_Tuples;

-- UPDATE EXAMPLES
SELECT * FROM Updated_Tuples;

UPDATE Penna SET Timestamp = '2020-11-11 23:34:26'
WHERE ID = 14 AND Timestamp = '2020-11-11 21:50:46';

SELECT * FROM Updated_Tuples;

UPDATE Penna SET Timestamp = '2020-11-11 23:34:26'
WHERE ID = 15 AND Timestamp = '2020-11-11 21:50:46';

SELECT * FROM Updated_Tuples;

-- RESET SAFE UPDATES AND TABLES

SET sql_safe_updates = 1;

DROP TABLE Deleted_Tuples;
DROP TABLE Inserted_Tuples;
DROP TABLE Updated_Tuples;
DROP TABLE Penna;
CREATE TABLE Penna AS (SELECT * FROM OldPenna);