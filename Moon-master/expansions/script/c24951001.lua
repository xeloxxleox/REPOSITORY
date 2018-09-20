-- Magenic Vessel of Din-La
function c24951001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24951001,0))
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,24951001)
	e2:SetCondition(c24951001.proxcon)
	e2:SetCost(c24951001.proxcost)
	e2:SetOperation(c24951001.proxop)
	c:RegisterEffect(e2)
end
function c24951001.proxcon(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:GetHandler():IsType(TYPE_SPELL) and te:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsPlayerCanDraw(tp,1)then 
			return true
		end
	end
end
function c24951001.proxfilter(c)
	return c:IsDiscardable() and c:IsSetCard(0x5F453A) and c:CheckActivateEffect(false,true,false)~=nil and c:IsType(TYPE_QUICKPLAY)
end
function c24951001.proxcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24951001.proxfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),tp) end
	Duel.Draw(tp,1,REASON_EFFECT)
	local g=Duel.SelectMatchingCard(tp,c24951001.proxfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler(),tp)
	local te=g:GetFirst():CheckActivateEffect(false,true,true)
	c24951001[Duel.GetCurrentChain()]=te
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c24951001.proxop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local te=c24951001[Duel.GetCurrentChain()]
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c24951001.etarget)
	e3:SetValue(c24951001.efilter)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c24951001.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=c24951001[Duel.GetCurrentChain()]
	if chkc then
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,true)
	end
	if chk==0 then return true end
	if not te then return end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c24951001.etarget(e,c)
	return c:IsType(TYPE_TOKEN)
end
function c24951001.efilter(e,re,te)
	return re:IsActiveType(TYPE_SPELL) and e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end