--Medivatale Griffin
function c160008783.initial_effect(c)
 aux.AddOrigEvoluteType(c)
  aux.AddEvoluteProc(c,nil,7,c160008783.filter1,c160008783.filter2)
	c:EnableReviveLimit() 
end
function c160008783.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) 
end
function c160008783.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY) 
end
