trigger TriggerOnCampaign on Campaign (after insert) {
    if(Trigger.isInsert && Trigger.isAfter){
        TriggerOnCampaignHelper.afterInsert(trigger.newMap);
    }
}