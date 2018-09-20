function c90210006.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,90210006)
	e2:SetCondition(c90210006.spcon)
	e2:SetOperation(c90210006.spop)
	c:RegisterEffect(e2)
	--add card to your hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(90210006,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c90210006.target)
	e3:SetOperation(c90210006.activate)
	c:RegisterEffect(e3)
	--special
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Cannot used as Xyz-Material
	local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_SINGLE)
    e13:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    e13:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e13:SetValue(c90210006.synlimit)
    c:RegisterEffect(e13)
end
function c90210006.synlimit(e,c)
    if not c then return false end
    return not c:IsSetCard(0x12D)
end
function c90210006.filtertarget(c)
	return c:IsSetCard(0x12C) and c:IsAbleToHand()
		or c:IsSetCard(0x12D) and c:IsAbleToHand()
		or c:IsSetCard(0x130) and c:IsAbleToHand()
end
function c90210006.filter(c)
	return c:IsSetCard(0x12C) or c:IsSetCard(0x12D) or c:IsSetCard(0x130) and c:IsAbleToDeckAsCost()
end
function c90210006.filtersp(c)
	return c:IsFaceup() and c:IsAttackBelow(2600)
end
function c90210006.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c90210006.filter,tp,LOCATION_HAND,0,1,c)
		and Duel.IsExistingMatchingCard(c90210006.filtersp,tp,0,LOCATION_MZONE,1,nil)
end
function c90210006.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c90210006.filter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
	Duel.ShuffleDeck(tp)
	Duel.BreakEffect()
end
function c90210006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90210006.filtertarget,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c90210006.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c90210006.filtertarget,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end