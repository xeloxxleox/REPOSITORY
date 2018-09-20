--Chroma-Distortion Revival Angel
function c249000498.initial_effect(c)
	--revive
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c249000498.cost)
	e1:SetTarget(c249000498.target)
	e1:SetOperation(c249000498.operation)
	c:RegisterEffect(e1)
end
function c249000498.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c249000498.filter(c,e,tp)
	return (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000498.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c249000498.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c249000498.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c249000498.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c249000498.overlayfilter(c)
	return (not c:IsHasEffect(EFFECT_NECRO_VALLEY)) and (not c:IsType(TYPE_MONSTER))
end
function c249000498.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if tc:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c249000498.overlayfilter,tp,LOCATION_GRAVE,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,c249000498.overlayfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.Overlay(tc,g)
			end
		end
	end
end
