select precinct

from Penna

where date(Timestamp) = '2020-11-05'

group by	precinct,
			totalvotes
order by	totalvotes asc
limit 10