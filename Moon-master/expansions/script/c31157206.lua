--Mezka Strike
function c31157206.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c31157206.target)
    e1:SetOperation(c31157206.activate)
    c:RegisterEffect(e1)
    --shuffle
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(31157206,1))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_REMOVE)
    e2:SetCondition(c31157206.tdcon)
    e2:SetTarget(c31157206.tdtg)
    e2:SetOperation(c31157206.tdop)
    c:RegisterEffect(e2)
end
function c31157206.filter(c,e,tp)
    return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(c31157206.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp)
end
function c31157206.spfilter(c,e,tp)
    return c:IsSetCard(0xc70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c31157206.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c31157206.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c31157206.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c31157206.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        local opt=Duel.SelectOption(tp,aux.Stringid(31157206,0),aux.Stringid(31157206,1))
        Duel.SendtoDeck(g,nil,opt,REASON_EFFECT)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c31157206.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,tc,e,tp)
        local sc=sg:GetFirst()
        if sc then
            Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetRange(LOCATION_MZONE)
            e1:SetCountLimit(1)
            e1:SetCode(EVENT_PHASE+PHASE_END)
            e1:SetOperation(c31157206.tdop1)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            sc:RegisterEffect(e1)
            local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e2:SetRange(LOCATION_MZONE)
            e2:SetCode(EFFECT_IMMUNE_EFFECT)
            e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            e2:SetValue(c31157206.efilter)
            sc:RegisterEffect(e2)
        end
    end
end
function c31157206.tdop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
        or Duel.SelectOption(tp,aux.Stringid(31157206,0),aux.Stringid(31157206,1))==0 then
        Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
    else
        Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
    end
end
function c31157206.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c31157206.tdcon(e,tp,eg,ep,ev,re,r,rp)
    if not re then return false end
    local rc=re:GetHandler()
    return e:GetHandler():IsReason(REASON_EFFECT) and rc:IsSetCard(0xc70) and rc:IsType(TYPE_MONSTER)
end
function c31157206.tdfilter(c)
    return c:IsSetCard(0xc70) and c:IsAbleToDeck()
end
function c31157206.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c31157206.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    local g=Duel.GetMatchingGroup(c31157206.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c31157206.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c31157206.tdfilter,tp,LOCATION_GRAVE,0,nil)
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end