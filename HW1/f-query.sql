select distinct L1.drinker, D.address
from likes L1, likes L2, drinker D
where L1.drinker = L2.drinker and L1.beer != L2.beer and L1.drinker = D.name
