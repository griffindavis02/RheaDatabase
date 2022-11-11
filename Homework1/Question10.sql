select Frequents.bar

from Frequents

where Frequents.drinker = "Mike"
or Frequents.drinker = "Steve"

group by Frequents.bar;