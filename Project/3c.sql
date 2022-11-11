
SELECT
CASE
	WHEN (totalvotes <= next_votes OR next_votes = -1 OR next_precinct = -1 OR precinct != next_precinct) THEN "TRUE"
    ELSE "FALSE"
END Result

FROM (
	SELECT	*,
			LEAD(precinct, 1, -1) OVER (ORDER BY precinct, Timestamp) AS next_precinct,
			LEAD(totalvotes, 1, -1) OVER (ORDER BY precinct, Timestamp) AS next_votes
	FROM Penna
) next_votes_table

ORDER BY precinct, Timestamp