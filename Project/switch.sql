
DROP procedure IF EXISTS Switch;
SET GLOBAL connect_timeout=28800;
SET GLOBAL interactive_timeout=28800;
SET GLOBAL wait_timeout=28800;
SET GLOBAL mysqlx_connect_timeout=28800;
SET GLOBAL mysqlx_read_timeout=28800;


DELIMITER //

CREATE PROCEDURE Switch ()
BEGIN

    DECLARE mPrecinct varchar(100) DEFAULT '';
    DECLARE mTimestamp datetime DEFAULT NULL;
    DECLARE mCurrentWinner varchar(5) DEFAULT '';
    DECLARE mCurrentLoser varchar(5) DEFAULT '';
    DECLARE mPrecinctWinner varchar(5) DEFAULT '';
    DECLARE mPrevPrecinct varchar(100) DEFAULT '';
    DECLARE EOD int(1) DEFAULT 0;

	DECLARE win_cursor CURSOR FOR
    SELECT precinct, Timestamp,
        CASE
            WHEN Trump > Biden THEN "Trump"
            WHEN Biden > Trump THEN "Biden"
            ELSE "Tie"
        END winner
    FROM Penna
    ORDER BY precinct, Timestamp;
    
    DECLARE CONTINUE HANDLER
    FOR NOT FOUND SET EOD = 1;

    CREATE TEMPORARY TABLE IF NOT EXISTS switchPenna (
        precinct varchar(100) DEFAULT NULL,
        Timestamp datetime DEFAULT NULL,
        fromCandidate varchar(5) DEFAULT NULL,
        toCandidate varchar(5) DEFAULT NULL
    );
    
    OPEN win_cursor;
    
    get_new_winner: LOOP
        
		FETCH win_cursor
        INTO mPrecinct, mTimestamp, mCurrentWinner;

        IF mCurrentWinner = "Trump" THEN
            SET mCurrentLoser = "Biden";
        ELSE
            SET mCurrentLoser = "Trump";
        END IF;

		IF mPrecinct != mPrevPrecinct THEN
			SET mPrecinctWinner = (
				SELECT
					CASE
						WHEN Trump > Biden THEN "Trump"
						WHEN Biden > Trump THEN "Biden"
						ELSE "Tie"
					END winner
				FROM Penna
				WHERE precinct = mPrecinct
				ORDER BY Timestamp DESC
				LIMIT 1
			);
		END IF;

        IF (mCurrentWinner NOT IN (
            SELECT
                CASE
                    WHEN Trump > Biden THEN "Trump"
                    WHEN Biden > Trump THEN "Biden"
                    ELSE "Tie"
                END winner
            FROM Penna
            WHERE precinct = mPrecinct
            AND Timestamp >= mTimestamp-1
            AND Timestamp < mTimestamp
        )
        AND mCurrentWinner = mPrecinctWinner)
        THEN
            INSERT INTO switchPenna (precinct, Timestamp, fromCandidate, toCandidate)
                VALUES (mPrecinct, mTimestamp, mCurrentLoser, mCurrentWinner);
        END IF;
        
        IF EOD = 1 THEN
			LEAVE get_new_winner;
		END IF;
        
        SET mPrevPrecinct = mPrecinct;
    END LOOP get_new_winner;
    
    CLOSE win_cursor;

    SELECT * FROM switchPenna;
    
END //

DELIMITER ;

CALL Switch();
