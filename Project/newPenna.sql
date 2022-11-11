
DROP TABLE newPenna;
DROP procedure IF EXISTS newPenna;

DELIMITER //

CREATE PROCEDURE newPenna (
	IN pPrecinct varchar(50),
    IN pTimestamp datetime,
    IN pNewVotes int(11),
    IN pBidenVotes int(11),
    IN pTrumpVotes int(11)
)
BEGIN

	IF NOT EXISTS (
		SELECT TABLE_NAME
		FROM information_schema.TABLES 
        WHERE TABLE_NAME = 'newPenna'
    ) THEN
		CREATE TABLE `newPenna` (
			precinct varchar(100) DEFAULT NULL,
            Timestamp datetime DEFAULT NULL,
            newvotes int(11) DEFAULT NULL,
            new_Biden int(11) DEFAULT NULL,
            new_Trump int(11) DEFAULT NULL
        );
        INSERT INTO newPenna (precinct, Timestamp, newvotes, new_Biden, new_Trump)
			SELECT precinct, Timestamp, totalvotes, Biden, Trump FROM Penna;
		-- ALTER TABLE newPenna RENAME COLUMN totalvotes TO newvotes;
		-- ALTER TABLE newPenna RENAME COLUMN Biden TO new_Biden;
		-- ALTER TABLE newPenna RENAME COLUMN Trump TO new_Trump;
	END IF;
    
    SET SQL_SAFE_UPDATES = 0;
    
    UPDATE newPenna
    
    SET	newvotes = newvotes + pNewVotes,
		new_Biden = new_Biden + pBidenVotes,
        new_Trump = new_Trump + pTrumpVotes
	
    WHERE precinct = pPrecinct
    AND Timestamp >= pTimestamp;
    
    SET SQL_SAFE_UPDATES = 1;
    
    SELECT *
    FROM newPenna
    WHERE precinct = pPrecinct
    AND Timestamp >= pTimestamp
    ORDER BY Timestamp;
    
END //

DELIMITER ;

CALL newPenna('Hanover', '2020-11-06 19:10:53', 36, 27, 9);
