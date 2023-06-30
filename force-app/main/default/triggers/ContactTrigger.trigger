trigger ContactTrigger on Contact (before insert,before update) {
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        ContactTriggerHelper.updateHostName(trigger.new);
    }
    
}