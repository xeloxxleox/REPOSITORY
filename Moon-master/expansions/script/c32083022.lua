--32083022
function c32083022.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c32083022.target)
    e1:SetOperation(c32083022.activate)
    c:RegisterEffect(e1)	
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c32083022.reptg)
	e2:SetValue(c32083022.repval)
	e2:SetOperation(c32083022.repop)
	c:RegisterEffect(e2)
end
function c32083022.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)and c:IsSetCard(0x7D53) and c:IsLevelBelow(4)
end
function c32083022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c32083022.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c32083022.filter,tp,LOCATION_REMOVED,LOCATION_REMOVE,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   local g=Duel.SelectTarget(tp,c32083022.filter,tp,LOCATION_REMOVED,LOCATION_REMOVE,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c32083022.activate(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c32083022.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x7D53) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c32083022.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c32083022.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(32083022,0))
end
function c32083022.repval(e,c)
	return c32083022.repfilter(c,e:GetHandlerPlayer())
end
function c32083022.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end