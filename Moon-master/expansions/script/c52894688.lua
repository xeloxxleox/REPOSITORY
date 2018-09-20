--Sinister Oni Mask Ritual
--Scripted by Kedy
--Concept by XStutzX
--Edited 16.9.18 v1.1
local function ID()
    local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
    str=string.sub(str,1,string.len(str)-4)
    local cod=_G[str]
    local id=tonumber(string.sub(str,2))
    return id,cod
end

local id,cod=ID()
function cod.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(cod.target)
	e1:SetOperation(cod.activate)
	c:RegisterEffect(e1)
	--Fusion Sub
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(cod.salcon)
	e2:SetTarget(cod.saltg)
	e2:SetOperation(cod.salop)
	c:RegisterEffect(e2)
end

--Send to Grave
function cod.filter(c,e,tp)
	local mt=_G["c"..c:GetCode()]
	if not mt[c] then return end
	local fe=mt[c]
	return c:IsSetCard(0xf05a) and c:IsType(TYPE_MONSTER) and cod.matfilter(e,fe,tp)
end
function cod.matfilter(e,fe,tp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_MONSTER)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	local res=fe:GetTarget()(e,tp,nil,0,0,0,0,0,0)
	e1:Reset()
	return res
end
function cod.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cod.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cod.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local mt=_G["c"..g:GetFirst():GetCode()]
	local fe=mt[g:GetFirst()]
	Duel.SendtoGrave(g,REASON_EFFECT)
	e:SetCategory(fe:GetCategory())
	e:SetProperty(fe:GetProperty())
	local tg=fe:GetTarget()
	if tg then tg(e,tp,nil,0,0,0,0,0,1) end
	fe:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(fe)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cod.activate(e,tp,eg,ep,ev,re,r,rp)
	local fe=e:GetLabelObject()
	if not fe then return end
	e:SetLabelObject(fe:GetLabelObject())
	local op=fe:GetOperation()
	if op then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_MONSTER)
		e1:SetReset(RESET_CHAIN)
		e:GetHandler():RegisterEffect(e1)
		op(e,tp,eg,ep,ev,re,r,rp) 
	end
end

--Fusion Sub
function cod.salcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0xf05b) 
end
function cod.sfilter(c,eg)
	local res=false
	if #eg==1 and c:GetReasonCard()==eg:GetFirst() then
		res=true
	else
		for tc in aux.Next(eg) do
			if c:GetReasonCard()==tc then
				res=true
			end
		end
	end
	return res and c:IsReason(REASON_FUSION) and c:IsAbleToHand() and not c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function cod.saltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cod.sfilter,tp,LOCATION_GRAVE,0,1,nil,eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectTarget(tp,cod.sfilter,tp,LOCATION_GRAVE,0,1,1,nil,eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,tp,LOCATION_GRAVE)
end
function cod.salop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end