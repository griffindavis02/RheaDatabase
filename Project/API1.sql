-- precinct check won't work due to asynchronous call. when implementing in API, could check there

DROP procedure IF EXISTS `API1`;

DELIMITER //

CREATE PROCEDURE `API1` (IN C varchar(5), IN T datetime, IN P varchar(50))
BEGIN
	SELECT CASE
		WHEN UPPER(C) != "BIDEN" AND UPPER(C) != "TRUMP" THEN "Wrong Candidate"
		WHEN T < '2020-11-03 19:39:48' THEN "Timestamp too early"
		WHEN ISNULL((SELECT precinct from Penna WHERE precinct = P LIMIT 1)) THEN "Precinct does not exist"
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
END //

DELIMITER ;

CALL API1('Trump', '2020-11-04 03:58:36', 'Adams Township No. 1 Voting Precinct');

-- SELECT ISNULL((SELECT precinct from Penna WHERE precinct = 'Adams Township No. 1 Voting Precinct' LIMIT 1))