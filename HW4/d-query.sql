select name
from drinker
where not exists (
select S.bar
from serves S, frequents F
where F.bar=S.bar and
name = F.drinker and
S.beer not in (
select L.beer
from likes L
where name = L.drinker
))