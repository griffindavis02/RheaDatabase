
DROP PROCEDURE IF EXISTS MoveVotes;

DELIMITER //
CREATE PROCEDURE MoveVotes(IN pPrecinct VARCHAR(100), IN pTimestamp datetime,
	IN pCoreCandidate VARCHAR(50), IN Number_Of_Moved_Votes INT)
BEGIN
	IF UPPER(pCoreCandidate) != 'TRUMP' AND UPPER(pCoreCandidate) != 'BIDEN' THEN
		SELECT 'Wrong Candidate' AS ' ';
	ELSEIF pTimestamp NOT IN (SELECT DISTINCT Timestamp FROM Penna WHERE precinct = pPrecinct) THEN
		SELECT 'Unknown Timestamp' AS ' ';
	ELSEIF (UPPER(pCoreCandidate) = 'TRUMP')
		AND (Number_Of_Moved_Votes >
        (SELECT Trump FROM Penna WHERE Timestamp = pTimestamp AND precinct = pPrecinct)) THEN
			SELECT 'Not enough votes' AS ' ';
	ELSEIF (UPPER(pCoreCandidate) = 'BIDEN') AND
		(Number_Of_Moved_Votes >
		(SELECT Biden FROM Penna WHERE Timestamp = pTimestamp AND precinct = pPrecinct)) THEN
				SELECT 'Not enough votes' AS ' ';
	ELSE
		SET sql_safe_updates = 0;
		IF UPPER(pCoreCandidate) = 'TRUMP' THEN
			UPDATE Penna
				SET Trump = Trump - Number_Of_Moved_Votes
				WHERE precinct = pPrecinct AND Timestamp >= pTimestamp;
			UPDATE Penna
				SET Biden = Biden + Number_Of_Moved_Votes
				WHERE precinct = pPrecinct AND Timestamp >= pTimestamp;
		ELSE
			UPDATE Penna
				SET Biden = Biden - Number_Of_Moved_Votes
				WHERE precinct = pPrecinct AND Timestamp >= pTimestamp;
			UPDATE Penna
				SET Trump = Trump + Number_Of_Moved_Votes
				WHERE precinct = pPrecinct AND Timestamp  >= pTimestamp;
		END IF;
		SET sql_safe_updates = 1;
	END IF;
END //
DELIMITER ;

CALL MoveVotes('Blacklick Township Voting Precinct', '2020-11-11 00:16:54', 'Trump', 794);

DROP TABLE Penna;
CREATE TABLE Penna AS (SELECT * FROM OldPenna);
