select F1.drinker, AVG(F1.times_a_week) as avg_time
from frequents F1
where (F1.bar, F1.drinker)
in (
select F2.bar, F2.drinker
from frequents F2, serves S, likes L
where F2.drinker = L.drinker and
L.beer = S.beer and
F2.bar = S.bar
group by F2.bar, F2.drinker
having count(*) >= 2)
group by drinker