select F1.bar, F1.drinker
from frequents F1
where F1.times_a_week = 
(
select max(F2.times_a_week)
from frequents F2
where F2.bar = F1.bar)
group by bar, drinker