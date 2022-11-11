
DROP procedure IF EXISTS newPenna;

DELIMITER //

CREATE PROCEDURE newPenna ()
BEGIN

	DECLARE prev_total int(11) DEFAULT 0;
    DECLARE prev_Biden int(11) DEFAULT 0;
    DECLARE prev_Trump int(11) DEFAULT 0;
    DECLARE prev_precinct varchar(100) DEFAULT "";
    DECLARE prev_Timestamp datetime DEFAULT '2020-11-04';
	DECLARE cur_total int(11) DEFAULT 0;
    DECLARE cur_Biden int(11) DEFAULT 0;
    DECLARE cur_Trump int(11) DEFAULT 0;
    DECLARE cur_precinct varchar(100) DEFAULT "";
    DECLARE cur_Timestamp datetime DEFAULT '2020-11-04';
    DECLARE SOD int(1) DEFAULT 1;
    DECLARE EOD int(1) DEFAULT 0;

	DECLARE vote_cursor CURSOR FOR
    SELECT totalvotes, Biden, Trump, precinct, Timestamp
    FROM Penna
    ORDER BY precinct, Timestamp;
    
    DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET EOD = 1;
    
    OPEN vote_cursor;
    
    get_cur_votes: LOOP
		IF SOD = 0 THEN
			SET prev_total = cur_total;
            SET prev_Biden = cur_Biden;
            SET prev_Trump = cur_Trump;
            SET prev_precinct = cur_precinct;
            SET prev_Timestamp = cur_Timestamp;
        END IF;
        
		FETCH vote_cursor
		INTO cur_total, cur_Biden, cur_Trump, cur_precinct, cur_Timestamp;
			
		SELECT  cur_precinct AS precinct,
				cur_Timestamp AS Timestamp,
				cur_total - prev_total AS newvotes,
				cur_Biden - prev_Biden AS new_Biden,
				cur_Trump - prev_Trump AS new_Trump
				
		WHERE cur_precinct = prev_precinct;
        
        SET SOD = 0;
        IF EOD = 1 THEN
			LEAVE get_cur_votes;
		END IF;
    END LOOP get_cur_votes;
    
    CLOSE vote_cursor;
    
END //

DELIMITER ;

CALL newPenna();
