--Carole,Archfiend Pixie Queen of Fiber Vine
function c160006669.initial_effect(c)
	 c:EnableCounterPermit(0x88)
--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
   
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c160006669.destg)
	e1:SetOperation(c160006669.desop)
	c:RegisterEffect(e1)
  

	 --Evolute
	   local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
 e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,160006669)
	--e1:SetCondition(c160006669.condition)
	e2:SetTarget(c160006669.target)
	e2:SetOperation(c160006669.operation)
	c:RegisterEffect(e2)
   --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x185a))
	e3:SetValue(1)
	c:RegisterEffect(e3)
 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_CHANGE_CODE)
	e5:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e5:SetValue(500314712)
	c:RegisterEffect(e5)
		--special summon
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetCondition(c160006669.spcon)
	e8:SetTarget(c160006669.sptg)
	e8:SetOperation(c160006669.spop)
	e8:SetLabelObject(e2)
	c:RegisterEffect(e8)
	
end
function c160006669.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x185a) or c:IsRace(RACE_PLANT) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160006669.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c160006669.tfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x185a) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c160006669.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c160006669.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end

function c160006669.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c160006669.negop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	if Duel.NegateActivation(ev)~=0 then
	Duel.Destroy(eg,REASON_EFFECT)
	end
end


function c160006669.filter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
		and c:IsType(TYPE_EFFECT)  and not c:IsSetCard(0x185a) and not c:IsType(TYPE_RITUAL)and c:IsDestructable()
end
function c160006669.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c160006669.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack()) end
	local g=Duel.GetMatchingGroup(c160006669.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c160006669.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c160006669.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetAttack())
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
function c160006669.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re~=e:GetLabelObject()
end
function c160006669.spfilter(c,e,tp)
	return c:IsCode(500314712) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c160006669.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c160006669.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c160006669.spop(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c160006669.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c160006669.hhfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x85a) and c:IsType(TYPE_EVOLUTE) and c:IsCanAddCounter(0x88,3)
end
function c160006669.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c160006669.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160006669.hhfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and e:GetHandler():IsDestructable() end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(160006669,1))
	Duel.SelectTarget(tp,c160006669.hhfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	 Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,3,0,0x88)
end

function c160006669.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:AddCounter(0x88,3) then
		end
	end