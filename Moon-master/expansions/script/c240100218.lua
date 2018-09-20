--created & coded by Lyris
--S・VINEの零天使ラグナクライッシャ(アナザー宙)
function c240100218.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c)
	aux.AddSpatialProc(c,c240100218.mcheck,4,300,nil,c240100218.mfilter,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	local ae3=Effect.CreateEffect(c)
	ae3:SetCategory(CATEGORY_REMOVE)
	ae3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ae3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	ae3:SetCode(EVENT_TO_GRAVE)
	ae3:SetRange(LOCATION_MZONE)
	ae3:SetCondition(c240100218.condition)
	ae3:SetTarget(c240100218.target)
	ae3:SetOperation(c240100218.operation)
	c:RegisterEffect(ae3)
end
function c240100218.mfilter(c)
	return (c:IsSetCard(0x85a) or c:IsSetCard(0x85b)) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c240100218.mcheck(sg)
	local sg=sg:Clone()
	local vg=sg:Filter(function(c) return c:IsSetCard(0x85a) or c:IsSetCard(0x85b) end,nil)
	if vg:GetCount()==sg:GetCount() then return true end
	sg:Sub(vg)
	return vg:GetFirst():GetAttack()>sg:GetFirst():GetAttack()
end
function c240100218.cfilter(c)
	return c:IsLevelAbove(1) and c:IsSetCard(0x285b)
end
function c240100218.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
	if g:GetCount()==0 then return false end
	local tc=g:GetFirst()
	e:SetLabel(tc:GetLevel())
	return g:GetCount()==1 and c240100218.cfilter(tc)
end
function c240100218.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x285b)
end
function c240100218.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100218.filter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function c240100218.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c240100218.filter2,tp,LOCATION_REMOVED,0,1,e:GetLabel(),nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
end
