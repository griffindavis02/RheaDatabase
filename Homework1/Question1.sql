select 	Drinkers.name
        
from Drinkers
inner join Likes on Drinkers.name = Likes.drinker

where Drinkers.phone like "917%"
and Likes.beer like "Bud%";
