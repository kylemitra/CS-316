select F1.drinker as drinker1, F2.drinker as drinker2, F1.bar
from frequents F1, frequents F2
where F1.bar = F2.bar AND F1.drinker < F2.drinker
