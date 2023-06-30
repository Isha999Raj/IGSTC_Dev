trigger AttachmentTrigger on Attachment (before insert,after insert,after update,before update) {
    
    if(Trigger.isafter && Trigger.IsInsert){
        system.debug('Attachment Trigger is running..!!');
        //This method will be used to push the docs to sharepoint that are uploaded to contact 
        AttachmentTriggerHelper.pushAttachmentsToSPFromContact(Trigger.New);
        AttachmentTriggerHelper.updateAttachmentName(Trigger.New);
    }
    
    
}