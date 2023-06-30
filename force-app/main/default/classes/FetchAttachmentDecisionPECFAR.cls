public with sharing class FetchAttachmentDecisionPECFAR {
    @InvocableMethod(label='Generate Decision attachment Id For PECFAR' description='Get DecisionPECFAR template' category='attachment')
    //This method will be used to generate Template dynamically for Applicatio Portal
    Public Static void getDecisionAttIdPECFAR(List<String> proIDList){
        system.debug('proIDList ::'+proIDList);
        try{
            if(!proIDList.isEmpty()){
                String ProId = proIDList[0];
                List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
                List<Contact> contactList = [Select Email,Name From Contact where Proposals__c =: ProId]; 
                List<Attachment> attList = [Select Id,name,Body,ContentType from attachment where parentId = :ProId order by createdDate DESC limit 1];           
                
                if(!contactList.isEmpty()){
                    for(Contact con : contactList){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List <String> emailRecipients = new List <String>{con.Email};
                            mail.setToAddresses(emailRecipients);
                        mail.setSubject('Decision Letter');
                        String emailBody = 'Dear ' + con.Name + ',' ;
                        emailBody += ' <br> <br> We are writing this email to notify you for your proposal has been approved by our scientific committee . <br> <br>';
                        emailBody += ' <br> Please find below attached file is decision letter. <br> <br>';
                        emailBody += '<br><br> Thanks & Regards, <br> Amit Salvi, <br> Project Co-ordinator <br> IGSTC';
                        mail.setHtmlBody(emailBody);//Set HTML Body
                        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                        if(!attList.isEMpty()){
                            attach.setContentType(attList[0].ContentType);
                            attach.setFileName(attList[0].Name);
                            attach.Body = attList[0].Body;
                            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
                        }
                        emailList.add(mail);
                    }
                    if(!emailList.isEmpty()){
                        Messaging.sendEmail(emailList);
                    }
                }
            }
        }catch(Exception e){
            system.debug(e.getMessage()+e.getLineNumber());
        }
    }
}