select main_likes.drinker

from Likes main_likes

where main_likes.beer in (
	select sub_likes.beer
    from Likes sub_likes
    where sub_likes.drinker = "Mike"
)
and main_likes.drinker != "Mike"

group by main_likes.drinker
	having COUNT(main_likes.drinker) > 1;