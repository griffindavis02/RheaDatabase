
DROP procedure IF EXISTS API2;

DELIMITER //

CREATE PROCEDURE API2 (IN pDate datetime)
BEGIN

	IF pDate < '2020-11-03' THEN
		SELECT 'Timestamp too early' AS ' ';
	ELSEIF pDate > '2020-11-11' THEN
		SELECT 'Timestamp too late' AS ' ';
	ELSE
	SELECT
		CASE
			WHEN SUM(Trump) > SUM(Biden) THEN "Trump"
			WHEN SUM(Trump) < SUM(Biden) THEN "Biden"
			ELSE "Tie"
		END candidate,
		CASE
			WHEN pDate < '2020-11-03' THEN "Timestamp too early"
			WHEN pDate > '2020-11-11' THEN "Timestamp too late"
			WHEN SUM(Trump) > SUM(Biden) THEN SUM(Trump)
			WHEN SUM(Trump) < SUM(Biden) THEN SUM(Biden)
			ELSE "Tie"
		END votes
		
		FROM Penna
		
		WHERE Timestamp = (
			SELECT Timestamp
			FROM Penna
			WHERE Timestamp < pDate+1
			ORDER BY Timestamp DESC
			LIMIT 1
		);
	END IF;
    
END //

DELIMITER ;

CALL API2('2020-11-06');