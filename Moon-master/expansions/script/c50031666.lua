
function c50031666.initial_effect(c)
aux.EnablePendulumAttribute(c)
	 aux.AddOrigEvoluteType(c)
	aux.AddEvoluteProc(c,nil,4,c50031666.filter1,c50031666.filter2)
c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50031666,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c50031666.atkcon)
	e1:SetCost(c50031666.atkcost)
	e1:SetOperation(c50031666.atkop)
	c:RegisterEffect(e1)
 
		--active limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c50031666.actcon)
	e3:SetOperation(c50031666.actop)
	c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_PZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCountLimit(1)
	e4:SetCondition(c50031666.condition)
--  e3:SetCost(c50031666.cost)
	e4:SetTarget(c50031666.tg)
	e4:SetOperation(c50031666.op)
	c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(50031666,0))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c50031666.sgcon)
	e5:SetTarget(c50031666.sgtg)
	e5:SetOperation(c50031666.sgop)
	c:RegisterEffect(e5)
		--actlimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	e6:SetValue(c50031666.aclimit2)
	e6:SetCondition(c50031666.actcon2)
	c:RegisterEffect(e6)
end
c50031666.pendulum_level=8
function c50031666.checku(sg,ec,tp)
return sg:IsExists(Card.IsType,1,nil,TYPE_NORMAL)
end
function c50031666.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c50031666.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY)
end
--function c50031666.spcon(e,c)
	--if c==nil then return true end
--  local tp=c:GetControler()
--  local g1=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,160007854)
--  if g1:GetCount()>0 then
--  local g2=Duel.IsCanRemoveCounter(c:GetControler(),1,1,0x1075,4,REASON_COST)
	--  return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and g2
--  end
--  return false
--end
--function c50031666.spop(e,tp,eg,ep,ev,re,r,rp,c)
--  local g1=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_MZONE,0,1,1,nil,160007854)
--  local g2=Duel.RemoveCounter(tp,1,1,0x1075,4,REASON_RULE)
--  Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO)
--end
function c50031666.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c50031666.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c50031666.actcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	return ac and ac:IsControler(tp) and ac:IsType(TYPE_NORMAL)
end
function c50031666.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c50031666.actlimit)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
end

function c50031666.actlimit(e,re,tp)
	return  not re:GetHandler():IsImmuneToEffect(e)
end
function c50031666.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c50031666.nmfilter(c)
	return  c:IsType(TYPE_NORMAL) and c:IsFaceup()
end
function c50031666.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE)  end
	if chk==0 then return Duel.IsExistingTarget(c50031666.nmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c50031666.nmfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c50031666.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		e1:SetValue(3000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e3:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	end
end
function c50031666.sgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+388
end

function c50031666.filter(c,p)
	return (c:GetLevel() >= 5 or c:GetRank() >= 5) and c:IsType(TYPE_EFFECT) and c:IsAbleToGrave()
end
function c50031666.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c50031666.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c50031666.sgfilter(c,p)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(p)
end
function c50031666.sgop(e,tp,eg,ep,ev,re,r,rp)

local g=Duel.GetMatchingGroup(c50031666.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local ct=Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.SendtoGrave(g,REASON_EFFECT)
	local lp=Duel.GetLP(tp)
	if ct>0 then
		Duel.SetLP(tp,lp-ct*500)
	end
end
function c50031666.aclimit2(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c50031666.actcon2(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

function c50031666.costfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_NORMAL) and (c:IsType(TYPE_PENDULUM) and c:IsFaceup())
end
function c50031666.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,2,REASON_COST) and Duel.IsExistingMatchingCard(c50031666.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c50031666.costfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RemoveCounter(tp,0x88,2,REASON_COST)
		c:RegisterFlagEffect(50031666,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end

function c50031666.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c50031666.atkfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL  and c:IsType(TYPE_EFFECT)
end
function c50031666.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c50031666.atkfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local atk=0
		local tc=g:GetFirst()
		while tc do
			atk=atk+tc:GetAttack()/2
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
