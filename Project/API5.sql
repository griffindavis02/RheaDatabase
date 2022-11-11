
DROP procedure IF EXISTS API5;

DELIMITER //

CREATE PROCEDURE API5 (IN pPrecinctPattern varchar(50))
BEGIN

	SELECT
    CASE
		WHEN Trump > Biden THEN "Trump"
        ELSE "Biden"
	END winner,
    CASE
		WHEN Trump > Biden THEN Trump
        ELSE Biden
	END votes
    
    FROM Penna
    
    WHERE Timestamp = '2020-11-11 21:50:46'
    AND LOCATE(pPrecinctPattern, precinct) != 0;
    
END //

DELIMITER ;

CALL API5('LONDON');