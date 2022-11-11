select Bars.city as Town

from Bars

inner join Frequents on Bars.name = Frequents.bar

group by Town
order by COUNT(Bars.city) DESC
limit 1;
