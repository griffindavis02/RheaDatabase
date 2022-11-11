select Likes.drinker

from Likes

group by Likes.drinker
order by count(Likes.drinker) desc
limit 1
