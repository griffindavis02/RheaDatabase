select Drinkers.name

from Drinkers
inner join Likes on Drinkers.name = Likes.drinker

where Drinkers.name != "Mike"
and Likes.beer in (
	select Likes.beer
    from Likes
    where Likes.drinker = "Mike"
)

group by Drinkers.name;