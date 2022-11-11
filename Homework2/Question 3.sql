select Frequents.drinker

from Frequents
inner join Likes
	on Likes.drinker = Frequents.drinker
left join Sells
	on Sells.beer = Likes.beer
    and Frequents.bar = Sells.bar

group by Frequents.drinker
	having count(Likes.beer) = count(Sells.beer)