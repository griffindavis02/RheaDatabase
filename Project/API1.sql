
DROP procedure IF EXISTS API1;

DELIMITER //

CREATE PROCEDURE API1 (IN C varchar(5), IN T datetime, IN P varchar(50))
BEGIN

	IF UPPER(C) != "BIDEN" AND UPPER(C) != "TRUMP" THEN
		SELECT 'Wrong Candidate' AS ' ';
	ELSEIF T < '2020-11-03 19:39:48' THEN
		SELECT 'Timestamp too early' AS ' ';
	ELSEIF ISNULL((SELECT precinct from Penna WHERE precinct = P LIMIT 1)) THEN
		SELECT 'Precinct does not exist' AS ' ';
	ELSE
		SELECT CASE
			WHEN UPPER(C) = "TRUMP" THEN Trump
			WHEN UPPER(C) = "BIDEN" THEN Biden
		END result

		FROM Penna

		WHERE precinct = P 
		AND Timestamp = (
			SELECT Timestamp
			FROM Penna
			WHERE Timestamp < T
			ORDER BY Timestamp DESC
			LIMIT 1
		);
	END IF;
    
END //

DELIMITER ;

CALL API1('Trump', '2020-11-04 03:58:36', 'Adams Township No. 1 Voting Precinct');
