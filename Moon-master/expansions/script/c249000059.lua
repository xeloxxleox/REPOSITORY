--Change Sentai - Blue
function c249000059.initial_effect(c)
	c:SetUniqueOnField(1,0,249000059)
	--copy effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c249000059.cost)
	e1:SetTarget(c249000059.target)
	e1:SetOperation(c249000059.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c249000059.spcon)
	c:RegisterEffect(e2)
end
function c249000059.costfilter(c)
	return c:IsSetCard(0x155) and c:IsAbleToRemoveAsCost()
end
function c249000059.costfilter2(c)
	return c:IsSetCard(0x155) and not c:IsPublic()
end
function c249000059.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000059.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	or Duel.IsExistingMatchingCard(c249000059.costfilter2,tp,LOCATION_HAND,0,1,e:GetHandler())) end
	local option
	if Duel.IsExistingMatchingCard(c249000059.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000059.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000059.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000059.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000059.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000059.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000059.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c249000059.disfilter(c)
	return c:IsDiscardable() and c:GetAttribute()~=0
end
function c249000059.operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and c:IsFaceup() then
		local sg=Duel.SelectMatchingCard(tp,c249000059.disfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=sg:GetFirst()
		if sg:GetCount()==0 then return end
		if Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)==0 then return end
		local ac=Duel.AnnounceCardFilter(tp,0x8,OPCODE_ISSETCARD,0xA008,OPCODE_ISSETCARD,OPCODE_NOT,OPCODE_AND,tc:GetOriginalAttribute(),OPCODE_ISATTRIBUTE,OPCODE_AND)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		e1:SetCode(EFFECT_ADD_CODE)
		e1:SetValue(ac)
		c:RegisterEffect(e1)
		c:CopyEffect(ac,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	end
end
function c249000059.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x155) and c:GetCode()~=249000059
end
function c249000059.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c249000059.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end