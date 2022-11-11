select Frequents.drinker

from Frequents
inner join (
	select Frequents.bar
	from Frequents

	group by Frequents.bar
	order by count(Frequents.drinker) desc
	limit 1
) most_popular_bar on most_popular_bar.bar = Frequents.bar

group by Frequents.drinker;