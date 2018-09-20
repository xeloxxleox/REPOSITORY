--created & coded by Lyris
--「S・VINE」シーカー
function c240100183.initial_effect(c)
	local ss=Effect.CreateEffect(c)
	ss:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	ss:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	ss:SetCode(EVENT_REMOVE)
	ss:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	ss:SetCondition(c240100183.con1)
	ss:SetTarget(c240100183.target1)
	ss:SetOperation(c240100183.op1)
	c:RegisterEffect(ss)
	local sl=ss:Clone()
	sl:SetCategory(CATEGORY_SPECIAL_SUMMON)
	sl:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	sl:SetCountLimit(1,240100183)
	sl:SetCondition(c240100183.con2)
	sl:SetTarget(c240100183.target2)
	sl:SetOperation(c240100183.op2)
	c:RegisterEffect(sl)
end
function c240100183.filter(c,e,tp)
	return c:IsSetCard(0x285b) and c:GetCode()~=240100183 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c240100183.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=1
	if c:IsPreviousLocation(LOCATION_HAND) then ct=2 end
	e:SetLabel(ct)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_DECK+LOCATION_HAND)
end
function c240100183.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c240100183.filter(chkc,e,tp) end
	if chk==0 then return true end
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,c240100183.filter,tp,LOCATION_REMOVED,0,ct,ct,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),nil,nil)
end
function c240100183.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoGrave(c,REASON_EFFECT+REASON_RETURN)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<2 or not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)		local tc=g:GetFirst()
		local ct=0
		while tc do
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_RACE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(RACE_FAIRY)
				tc:RegisterEffect(e1)
				ct=ct+1
			end
			tc=g:GetNext()
		end
		if ct>0 then Duel.SpecialSummonComplete() end
	end
end
function c240100183.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_GRAVE) and c:IsFaceup()
end
function c240100183.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c240100183.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
