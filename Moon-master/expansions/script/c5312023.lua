--Necromantian Spell Virus
function c5312023.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,5312023)
    e1:SetCondition(c5312023.condition)
    e1:SetTarget(c5312023.target)
    e1:SetOperation(c5312023.activate)
    c:RegisterEffect(e1)
end
function c5312023.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x226) and c:IsRace(RACE_SPELLCASTER)
end
function c5312023.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c5312023.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c5312023.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,30459350) and Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c5312023.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
    Duel.BreakEffect()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(p,Card.IsType,p,LOCATION_HAND,0,1,1,nil,TYPE_SPELL)
    local tg=g:GetFirst()
    if tg then
        if Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)==0 then
            Duel.ConfirmCards(1-p,tg)
            Duel.ShuffleHand(p)
        end
    else
        local sg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
        Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
    end
end
