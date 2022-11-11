
DROP procedure IF EXISTS API4;

DELIMITER //

CREATE PROCEDURE API4 (IN pPrecinct varchar(50))
BEGIN

	SELECT
    CASE
		WHEN Trump > Biden THEN "Trump"
        ELSE "Biden"
	END winner,
    CASE
		WHEN Trump > Biden THEN CONCAT(Trump/totalvotes, '%')
        ELSE CONCAT(Biden/totalvotes, '%')
	END percentage_votes
    
    FROM Penna
    
    WHERE Timestamp = '2020-11-11 21:50:46'
    AND precinct = pPrecinct;
    
END //

DELIMITER ;

CALL API4('345 LONDON GROVE S');