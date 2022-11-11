select Frequents.bar

from Frequents

inner join Bars on Bars.name = Frequents.bar
inner join (
	select Bars.city as Town
	from Bars
	inner join Frequents on Bars.name = Frequents.bar
	group by Town
	order by COUNT(Bars.city) DESC
	limit 1
) as most_drinkers

where Bars.city = most_drinkers.Town
group by Frequents.bar;