select distinct F.drinker 
from frequents F, serves S 
where F.bar = S.bar AND S.beer = 'Amstel'
