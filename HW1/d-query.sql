select L.drinker as name, D.address, S.beer
from serves S, likes L, drinker D
where S.price > 3.00 and S.beer = L.beer and D.name = L.drinker
order by name desc, beer asc
