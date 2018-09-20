--Paintress Rahpaelina
function c101010389.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c)
			aux.EnableDualAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
   
		--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c101010389.pencost)
	e3:SetTarget(c101010389.pentg)
	e3:SetOperation(c101010389.penop)
	c:RegisterEffect(e3)
		--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_SZONE,0)
e4:SetCondition(c101010389.discon)
	e4:SetTarget(c101010389.tgtg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
		--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(aux.IsDualState)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
	--SpecialSummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(101010389,0))
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCountLimit(1)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(aux.IsDualState)
	--e7:SetCost(c101010389.cost)
	e7:SetTarget(c101010389.target)
	e7:SetOperation(c101010389.operation)
	c:RegisterEffect(e7)
end
function c101010389.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c101010389.splimcon(e)
	return not e:GetHandler():IsForbidden()
end

function c101010389.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50)  and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c101010389.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010389.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101010389.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
Duel.Release(g,REASON_COST)
end
function c101010389.penfilter(c)
	return c:IsSetCard(0xc50) and c:IsType(TYPE_PENDULUM)   and  c:IsFaceup() and not c:IsForbidden()
end
function c101010389.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c101010389.penfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c101010389.penop(e,tp,eg,ep,ev,re,r,rp)
	  if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0  then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c101010389.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
function c101010389.tgtg(e,c)
	return c:IsSetCard(0xc50)
end

function c101010389.pilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc50)
end
function c101010389.discon(e,tp,eg,ep,ev,re,r,rp)
	return  aux.IsDualState(e) and  Duel.IsExistingMatchingCard(c101010389.pfilter,tp,LOCATION_SZONE,0,1,nil)
end


function c101010389.extrasfilter(c,e,tp)
	return c:IsSetCard(0xc50) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() 
end

function c101010389.penfilterxx(c)
	return c:IsSetCard(0xc50) and c:IsType(TYPE_PENDULUM)  and  c:IsDestructable()
end
function c101010389.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101010389.penfilterxx,tp,LOCATION_PZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101010389.extrasfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c101010389.penfilterxx,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c101010389.extrasfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function c101010389.operation(e,tp,eg,ep,ev,re,r,rp)
	  local ex,g1=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	if g1:GetFirst():IsRelateToEffect(e) and Duel.Destroy(g1,REASON_EFFECT)~=0 then
		local hg=g2:Filter(c101010389.extrasfilter,nil,e)
	Duel.SpecialSummon(hg,0,tp,tp,false,false,POS_FACEUP)
	end
end
