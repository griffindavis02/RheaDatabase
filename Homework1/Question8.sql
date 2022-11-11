select Likes.drinker

from Likes
inner join Sells on Sells.beer = Likes.beer

where Sells.bar = "Caravan"

group by Likes.drinker;