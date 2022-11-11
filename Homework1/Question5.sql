select Sells.bar

from Sells
inner join Likes on Sells.beer = Likes.beer

where Likes.drinker = "Mike"

group by Sells.bar;