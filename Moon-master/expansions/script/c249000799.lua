--Overlay-Evolve Seach Glyph
function c249000799.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c249000799.target)
	e1:SetOperation(c249000799.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c249000799.drcon)
	e2:SetCost(c249000799.drcost)
	e2:SetTarget(c249000799.drtg)
	e2:SetOperation(c249000799.drop)
	c:RegisterEffect(e2)
end
function c249000799.filter(c)
	return c:IsSetCard(0x1D8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c249000799.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000799.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249000222.filter2(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x1D8) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c249000799.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c249000799.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.SelectYesNo(tp,505) then
			local g2=Duel.SelectMatchingCard(tp,c249000799.filter2,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		end
	end
end
function c249000799.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:GetReasonEffect():GetHandler():IsSetCard(0x1D8) and (c:IsType(TYPE_YXZ) or c:IsType(TYPE_SYNCHRO))
end
function c249000799.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c249000799.cfilter,1,nil,tp)
end
function c249000799.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c249000799.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000799.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end