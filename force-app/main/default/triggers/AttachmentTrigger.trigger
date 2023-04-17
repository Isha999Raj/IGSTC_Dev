trigger AttachmentTrigger on Attachment (before insert) {
    
    if(Trigger.isbefore && Trigger.IsInsert){
        //AttachmentTriggerHelper.DeletePreviousAttach(Trigger.New);
    }
    
}