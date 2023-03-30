public class FetchAttachment {
    @InvocableMethod(label='Generate attachment Id For IF' description='Get attachment template' category='attachment')
    //This method will be used to generate Template dynamically for Applicatio Portal
    Public Static void getLatestAttachmentId(List<String> proIDList){
        system.debug('proIDList ::'+proIDList);
        try{
            String ProId = proIDList[0];
            Contact conRecord = [SELECT Id,Name,Campaign__c FROM Contact WHERE Proposals__c =: ProId];
            String contactEmail = [Select Email From Contact where Proposals__c =: ProId and Is_Primary__c = true].Email; 
            List<String> attachmentsListToBeReturned = new List<String>();
            Emailtemplate emailTempRec = New Emailtemplate();
            List<Attachment> attList = [Select Id,name,Body,ContentType from attachment where parentId = :ProId order by createdDate DESC];
            if(conRecord.Campaign__c == 'if'){
                emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Email to Primary Contact for Proposal Submission IF'];
            }else if(conRecord.Campaign__c == 'pecfar'){
                emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Email to Primary Contact On Proposal Submission v1- PECFAR'];
            }else if(conRecord.Campaign__c == 'wiser'){
                emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Email to Primary Contact for Proposal Submission WISER'];
            }else if(conRecord.Campaign__c == 'sing'){
                emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Email to Primary Contact for proposal Submission - SING'];
            }else if(conRecord.Campaign__c == 'workshop'){
                emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Email to Primary Contact On Proposal Submission - WORKSHOP'];
            }else{
                emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Email to Primary Contact On Proposal Submission - 2+2'];
            }
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType(attList[0].ContentType);
            attach.setFileName(attList[0].Name);
            //attach.setInline(false);
            attach.Body = attList[0].Body;
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //mail.setUseSignature(false);
            mail.setToAddresses(new String[] { contactEmail});//Set To Email Address
            mail.setSubject(emailTempRec.Subject);//Set Subject
            mail.setHtmlBody(emailTempRec.HtmlValue);//Set HTML Body
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });//Set File Attachment
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });//Send Email
            // if(!attList.isEmpty()){
            //     Application_Proposal__c proposalRec = new Application_Proposal__c();
            //     proposalRec.Id = ProId;
            //     proposalRec.Attachment_Id__c = attList[0].Id;
            //     update proposalRec;
            // }
        }catch(Exception e){
            system.debug(e.getMessage()+e.getLineNumber());
        }
        
    }
}