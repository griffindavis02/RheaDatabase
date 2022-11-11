select table1.bar

from (
	select Sells.bar,
		row_number() over (
			partition by Sells.bar
        ) row_num

	from Sells
	inner join Likes on Likes.beer = Sells.beer
		and Likes.drinker = "Mike"
) table1
    
where table1.row_num > 2

group by table1.bar