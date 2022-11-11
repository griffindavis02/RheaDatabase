select Sells.bar

from Sells
inner join Likes on Likes.beer = Sells.beer
inner join Frequents on Frequents.drinker = Likes.drinker
	and Frequents.bar = Sells.bar
    
group by Sells.bar;