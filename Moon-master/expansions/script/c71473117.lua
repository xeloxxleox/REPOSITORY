--Fantasia Knight - Recruit
function c71473117.initial_effect(c)
    --Pendulum Set
    aux.EnablePendulumAttribute(c)
    --SPLimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(1,0)
    e1:SetCondition(c71473117.splimcon)
    e1:SetTarget(c71473117.splimit)
    c:RegisterEffect(e1)
    --Excavate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(71473117,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_PREDRAW)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCondition(c71473117.thcon)
    e2:SetTarget(c71473117.thtg)
    e2:SetOperation(c71473117.thop)
    c:RegisterEffect(e2)
    --Special Summon (Normal)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(71473117,1))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetTarget(c71473117.sptg)
    e3:SetOperation(c71473117.spop)
    c:RegisterEffect(e3)
    --To Hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(71473117,2))
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetCondition(c71473117.thcon2)
    e4:SetTarget(c71473117.thtg2)
    e4:SetOperation(c71473117.thop2)
    c:RegisterEffect(e4)
    --Destroy
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(71473117,3))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetCondition(c71473117.descon)
    e5:SetTarget(c71473117.destg)
    e5:SetOperation(c71473117.desop)
    c:RegisterEffect(e5)
    --Synchro Material Custom
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_TUNER_MATERIAL_LIMIT)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e6:SetTarget(c71473117.synlimit)
    c:RegisterEffect(e6)
end
function c71473117.splimcon(e)
    return not e:GetHandler():IsForbidden()
end
function c71473117.synlimit(e,c)
    return c:IsSetCard(0x1C1D)
end
function c71473117.splimit(e,c,sump,sumtype,sumpos,targetp)
    if c:IsSetCard(0x1C1D) then return false end
    return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c71473117.thcon(e,tp,eg,ep,ev,re,r,rp)
    return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
end
function c71473117.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_DRAW_COUNT)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_DRAW)
    e1:SetValue(0)
    Duel.RegisterEffect(e1,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1,0,0)
end
function c71473117.filter(c)
    return c:IsSetCard(0x1C1D) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c71473117.thop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
    Duel.ConfirmDecktop(tp,3)
    local g=Duel.GetDecktopGroup(tp,3)
    if g:GetCount()>0 then
        Duel.DisableShuffleCheck()
        if g:IsExists(c71473117.filter,1,nil)  then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=g:FilterSelect(tp,c71473117.filter,1,1,nil)
            Duel.SendtoHand(sg,tp,REASON_EFFECT+REASON_REVEAL)
            Duel.ConfirmCards(1-tp,sg)
            Duel.ShuffleHand(tp)
            g:Sub(sg)
        end
        Duel.Destroy(g,REASON_EFFECT+REASON_REVEAL)
    end
end
function c71473117.filter1(c,e,tp)
    return c:IsSetCard(0x1C1D) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71473117.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c71473117.filter1(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c71473117.filter1,tp,LOCATION_PZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c71473117.filter1,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c71473117.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c71473117.thcon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetPreviousLocation()==LOCATION_SZONE
end
function c71473117.thfilter(c)
    return c:IsSetCard(0x1C1D) and c:IsAbleToHand()
end
function c71473117.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c71473117.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71473117.thop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c71473117.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c71473117.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetPreviousLocation()==LOCATION_EXTRA
end
function c71473117.cfilter(c)
    return c:IsDestructable()
end
function c71473117.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp)
        and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
        and Duel.IsExistingMatchingCard(c71473117.cfilter,tp,LOCATION_PZONE,0,1,nil) end
    local g=Duel.GetMatchingGroup(c71473117.cfilter,tp,LOCATION_PZONE,0,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c71473117.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c71473117.cfilter,tp,LOCATION_PZONE,0,nil)
    local sg=g:Select(tp,1,2,nil)
    local ct=Duel.Destroy(sg,REASON_EFFECT)
    if ct>0 then
        Duel.BreakEffect()
        Duel.Draw(tp,ct,REASON_EFFECT)
    end
end