select	Sells.bar

from Sells
inner join Frequents on Frequents.bar = Sells.bar

where Sells.beer = "Budweiser"
	and Frequents.drinker != "Gunjan"

group by	Sells.bar,
			Sells.price
order by Sells.price desc
limit 1;