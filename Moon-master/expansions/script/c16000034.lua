--ESPergear Knight : Lancie
function c16000034.initial_effect(c)
	   aux.AddOrigEvoluteType(c)
  aux.AddEvoluteProc(c,nil,7,c16000034.matfilter,c16000034.filter2)
	c:EnableReviveLimit() 
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16000034,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c16000034.eqcon)
	e1:SetCost(c16000034.eqcost)
	e1:SetTarget(c16000034.eqtg)
	e1:SetOperation(c16000034.eqop)
	c:RegisterEffect(e1)
		--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16000034,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c16000034.dgct)
	e3:SetTarget(c16000034.dgtg)
	e3:SetOperation(c16000034.dgop)
	c:RegisterEffect(e3)
			   --Special SUmmon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16000034,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c16000034.spcon)
	e4:SetTarget(c16000034.sumtg)
	e4:SetOperation(c16000034.spop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
end
function c16000034.matfilter(c,ec,tp)
   return c:IsAttribute(ATTRIBUTE_LIGHT) 
end

function c16000034.filter2(c,ec,tp)
	return   (c:IsType(TYPE_UNION) and c:IsRace(RACE_MACHINE)) or c:IsRace(RACE_PSYCHO)
end
function c16000034.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetLabelObject()
	return ec==nil or ec:GetFlagEffect(16000034)==0
end
function c16000034.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,3,REASON_COST)
end
function c16000034.xfilter(c)
	return  c:IsAbleToChangeControler() and c:IsFaceup()
end
function c16000034.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp)  end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c16000034.xfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c16000034.xfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c16000034.eqlimit(e,c)
	return e:GetOwner()==c
end
function c16000034.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsFaceup() then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local atk=tc:GetTextAttack()/2
			local def=tc:GetTextDefense()/2
			if tc:IsFacedown() or atk<0 then atk=0 end
			if tc:IsFacedown() or def<0 then def=0 end
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			tc:RegisterFlagEffect(16000034,RESET_EVENT+0x1fe0000,0,0)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c16000034.eqlimit)
			tc:RegisterEffect(e1)
			if atk>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(atk)
				tc:RegisterEffect(e2)
			end
			--if def>0 then
				--local e3=Effect.CreateEffect(c)
				--e3:SetType(EFFECT_TYPE_EQUIP)
				--e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				--e3:SetCode(EFFECT_UPDATE_DEFENSE)
				--e3:SetReset(RESET_EVENT+0x1fe0000)
				--e3:SetValue(def)
				--tc:RegisterEffect(e3)
			--end
	end
end
end
function c16000034.cfilter(c)
	return c:IsAbleToGrave() and c:GetAttack()>0 
end
function c16000034.dgct(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetEquipGroup():FilterCount(c16000034.cfilter,nil)>0
		and c:GetAttackAnnouncedCount()==0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16000034,0))
	local g=c:GetEquipGroup():FilterSelect(tp,c16000034.cfilter,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	e:SetLabel(g:GetFirst():GetBaseAttack())
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end

function c16000034.dgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,e:GetLabel())
end
function c16000034.dgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c16000034.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c16000034.mgfilter(c,e,tp,sync)
return not c:IsControler(tp) or not c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
		or  not  r==REASON_MATERIAL+0x10000000
		or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c16000034.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if chk==0 then return mg:GetCount()>0 and ft>=mg:GetCount() 
		and not mg:IsExists(c16000034.mgfilter,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg,mg:GetCount(),tp,0)
end
function c16000034.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetHandler():GetMaterial()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if mg:GetCount()>ft 
		or mg:IsExists(c16000034.mgfilter,1,nil,e,tp,e:GetHandler()) then return end
	Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
