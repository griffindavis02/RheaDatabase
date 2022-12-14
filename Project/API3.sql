
DROP procedure IF EXISTS API3;

DELIMITER //

CREATE PROCEDURE API3 (IN pCandidate varchar(5))
BEGIN

	IF UPPER(pCandidate) != "TRUMP" AND UPPER(pCandidate) != "BIDEN" THEN
		SELECT "Wrong Candidate" AS " ";
	ELSE
		SELECT precinct
		
		FROM Penna
		
		WHERE Timestamp = '2020-11-11 21:50:46'
		AND (
			(UPPER(pCandidate) = "TRUMP" AND Trump > Biden)
			OR (UPPER(pCandidate) = "BIDEN" AND Biden > Trump)
		)
		
		GROUP BY precinct
		ORDER BY totalvotes DESC
		
		LIMIT 10;
	END IF;
    
END //

DELIMITER ;

CALL API3('Trump');