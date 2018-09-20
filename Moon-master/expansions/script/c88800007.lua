--Delivery
local card = c88800007
local id=88800007
function card.initial_effect(c)
    --Without Tribute
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(card.ntcon)
    c:RegisterEffect(e1)
    --Quick Summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_HAND)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
    e2:SetCondition(card.sumcon)
    e2:SetCost(card.sumcost)
    e2:SetTarget(card.sumtg)
    e2:SetOperation(card.sumop)
    c:RegisterEffect(e2)
    --Destroy S/T
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,id)
    e3:SetCondition(card.cond)
    e3:SetTarget(card.target)
    e3:SetOperation(card.operation)
    c:RegisterEffect(e3)
end
    
    --no tribute
function card.nonfilter(c)
    return c:IsFacedown() or not c:IsRace(RACE_DRAGON)
end
function card.ntcon(e,c,minc)
    if c==nil then return true end
    local tp=c:GetControler()
    return minc==0 and c:GetLevel()>4
        and not Duel.IsExistingMatchingCard(card.nonfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

-- Summon
function card.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function card.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(card.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil)
        and c:GetFlagEffect(id)==0 end
    local g=Duel.SelectMatchingCard(tp,card.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
    Duel.Release(g,POS_FACEUP,REASON_COST)
    c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function card.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsSummonable(true,nil) or c:IsMSetable(true,nil) end
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function card.sumop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local pos=0
    if c:IsSummonable(true,nil) then pos=pos+POS_FACEUP_ATTACK end
    if c:IsMSetable(true,nil) then pos=pos+POS_FACEDOWN_DEFENSE end
    if pos==0 then return end
    if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
        Duel.Summon(tp,c,true,nil)
    else
        Duel.MSet(tp,c,true,nil)
    end
end

function card.cond(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(card.checkfilter,1,nil)
end
function card.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(card.dfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function card.operation(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,card.dfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

--filters
function card.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function card.tfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xfb0)
end
function card.dfilter(c)
    return c:IsSetCard(0xfb0) and not c:IsCode(id) and c:IsAbleToHand()
end
function card.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DRAGON) and not c:IsCode(id) and c:IsReleasable()
end
function card.checkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xfb0)
end