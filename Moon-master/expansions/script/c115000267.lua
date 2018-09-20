--SC2 Unit - Melee - Mothership
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c115000267.initial_effect(c)
	Senya.AddSummonSE(c,aux.Stringid(115000267,0))
	Senya.AddAttackSE(c,aux.Stringid(115000267,1))
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c115000267.tg)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	--cannot be effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c115000267.tg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c115000267.tg(e,c)
	return c:GetCode()~=115000267
end