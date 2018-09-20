--Number c8888001200: Alpha Galaxy-Eyes Exodiac Godly Dragon
function c88880012.initial_effect(c)
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x889),6,4)
    c:EnableReviveLimit()
    --(1) spsummon limit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c88880012.splimit)
    c:RegisterEffect(e1)
    --(2) battle or Target effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetCondition(c88880012.tgcon)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e2)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    c:RegisterEffect(e4)
    --(3) Negate Attack once
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(88880012,0))
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_ATTACK_ANNOUNCE)
    e5:SetTarget(c88880012.atktg)
    e5:SetCost(c88880012.atkcost)
    e5:SetOperation(c88880012.atkop)
    c:RegisterEffect(e5)
end
--(1) spsummon limit
function c88880012.splimit(e,se,sp,st)
    return se:GetHandler():IsSetCard(0x95)
end
--(2) Target Effect
function c88880012.tgcon(e)
    return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
--(3) negate attack
function c88880012.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c88880012.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88880012.spfilter(c,e,tp)
    return c:IsSetCard(0x107b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88880012.atkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateAttack()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c88880012.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
        local g=Duel.SelectMatchingCard(tp,c88880012.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
