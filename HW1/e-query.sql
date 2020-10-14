select distinct F.drinker
from serves S1, serves S2, frequents F
where S1.beer = S2.beer and S1.price > S2.price and S1.bar = F.bar
