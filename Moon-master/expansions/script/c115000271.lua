--SC2 Custom - Random Wolf
function c115000271.initial_effect(c)
	--random special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c115000271.condition)
	e3:SetCost(c115000271.cost)
	e3:SetTarget(c115000271.target)
	e3:SetOperation(c115000271.operation)
	c:RegisterEffect(e3)
end
function c115000271.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and (c:IsSetCard(0x11AB) or c:IsSetCard(0x21AB))
end
function c115000271.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c115000271.filter2,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
	return ct > 4
end
function c115000271.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) and e:GetHandler():GetAttackAnnouncedCount()==0 end
	Duel.PayLPCost(tp,800)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
function c115000271.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c115000271.filter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c115000271.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	local g=Duel.GetMatchingGroup(c115000271.filter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e)
	local sg=g:RandomSelect(1-tp,2)
	if sg then
		local sc=sg:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
			e1:SetReset(RESET_CHAIN)
			sc:RegisterEffect(e1)
			Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
			sc=sg:GetNext()
		end
	end
end