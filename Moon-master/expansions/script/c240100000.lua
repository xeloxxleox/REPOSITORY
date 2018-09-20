--created & coded by Lyris, art from Cardfight!! Vanguard's Soul Charge
--ソウル・チャージ
function c240100000.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	c:SetUniqueOnField(1,0,240100000)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetLabel(0)
	e2:SetCondition(c240100000.checkop)
	e2:SetTarget(c240100000.attg)
	e2:SetOperation(c240100000.atop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c240100000.sdcon)
	c:RegisterEffect(e4)
	if not c240100000.global_check then
		c240100000.global_check=true
		c240100000[0]=aux.Stringid(122518919,0)
		c240100000[1]=aux.Stringid(122518919,1)
	end
end
function c240100000.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	return re:IsActiveType(TYPE_XYZ) and tc:IsLocation(LOCATION_ONFIELD) and tc:IsControler(e:GetLabel())
end
function c240100000.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.Hint(HINT_OPSELECTED,0,c240100000[rp])
	local tc=Group.FromCards(re:GetHandler())
	Duel.HintSelection(tc)
	Duel.SetTargetCard(tc)
end
function c240100000.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local p=e:GetLabel()
	local g=Duel.GetDecktopGroup(p,1)
	if g:GetCount()==0 then return end
	Duel.DisableShuffleCheck()
	Duel.Overlay(tc,g)
	local ap=0x0+p+0x1
	local ct=c:GetFlagEffectLabel(240100000)
	if not ct then
		c:RegisterFlagEffect(240100000,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,ap)
	else
		c:SetFlagEffectLabel(240100000,bit.bor(ap,ct))
	end
end
function c240100000.sdcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(240100000)>0 and bit.band(c:GetFlagEffectLabel(240100000),0x3)==0x3
end
