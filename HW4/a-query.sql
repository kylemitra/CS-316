select distinct D.name
from drinker D
where D.name not in
(select distinct F2.drinker
from frequents F2
where not exists (
select *
from Serves S, Likes L
where F2.bar = S.bar and
F2.drinker = L.drinker and
S.beer = L.beer))