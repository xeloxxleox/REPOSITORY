--Mecha Blade Sky Angel
function c88990009.initial_effect(c)
--xyz summon
    aux.AddXyzProcedure(c,c88990009.mfilter,4,2,c88990009.ovfilter,aux.Stringid(88990009,0),2,c88990009.xyzop)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(88990009,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCountLimit(2,88990009)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c88990009.cost)
    e1:SetTarget(c88990009.target)
    e1:SetOperation(c88990009.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c88990009.atkval)
    c:RegisterEffect(e2)
end
function c88990009.atkval(e,c)
    return c:GetOverlayCount()*100
end
function c88990009.mfilter(c)
    return c:IsSetCard(0xffd)
end
function c88990009.ovfilter(c)
    return c:IsFaceup() and c:IsCode(88990006)
end
function c88990009.xyzop(e,tp,chk,mc)
    if chk==0 then return mc:CheckRemoveOverlayCard(tp,1,REASON_COST) end
    mc:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88990009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88990009.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(800)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c88990009.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
function c88990009.tgfilter(c)
    return c:IsCode(88990006)
end