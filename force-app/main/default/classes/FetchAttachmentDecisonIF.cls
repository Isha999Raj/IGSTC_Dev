public with sharing class FetchAttachmentDecisonIF {
    
    @InvocableMethod(label='Generate Decision attachment Id For IF' description='Get DecisionIF template' category='attachment')
    //This method will be used to generate Template dynamically for Applicatio Portal
    Public Static void getDecisionAttId(List<String> proIDList){
        system.debug('proIDList ::'+proIDList);
        try{
            if(!proIDList.isEmpty()){
                String ProId = proIDList[0];
                Contact conRecord = [SELECT Id,Name,FirstName,LastName,Campaign__c,ApplicationId__c FROM Contact WHERE Proposals__c =: ProId];
                String contactEmail = [Select Email From Contact where Proposals__c =: ProId and Is_Primary__c = true].Email; 
                List<String> attachmentsListToBeReturned = new List<String>();
                Emailtemplate emailTempRec = New Emailtemplate();
                List<Attachment> attList = [Select Id,name,Body,ContentType from attachment where parentId = :ProId order by createdDate DESC];
                emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Decision Mail - IF'];

                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setContentType(attList[0].ContentType);
                attach.setFileName(attList[0].Name);
                attach.Body = attList[0].Body;
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { contactEmail});//Set To Email Address
                mail.setSubject(emailTempRec.Subject);//Set Subject
                string emailHtmlValue = emailTempRec.HtmlValue;
                if(!string.isBlank(conRecord.Name)){
                    emailHtmlValue = emailHtmlValue.replace('{!Contact.Name}', conRecord.Name);
                }
                if(!string.isBlank(conRecord.ApplicationId__c)){
                    emailHtmlValue = emailHtmlValue.replace('{!Contact.ApplicationId__c}', conRecord.ApplicationId__c);
                }
                mail.setHtmlBody(emailHtmlValue);//Set HTML Body
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });//Set File Attachment
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });//Send Email

                // if(!contactList.isEmpty()){
                //     for(Contact con : contactList){
                //         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //         List <String> emailRecipients = new List <String>{con.Email};
                //             mail.setToAddresses(emailRecipients);
                //         mail.setSubject('Decision Letter');
                //         String emailBody = 'Dear ' + con.Name + ',' ;
                //         emailBody += ' <br> <br> We are writing this email to notify you for your proposal has been approved by our scientific committee . <br> <br>';
                //         emailBody += ' <br> Please find below attached file is decision letter. <br> <br>';
                //         emailBody += '<br><br> Thanks & Regards, <br> Amit Salvi, <br> Project Co-ordinator <br> IGSTC';
                //         mail.setHtmlBody(emailBody);//Set HTML Body
                //         Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                //         if(!attList.isEMpty()){
                //             attach.setContentType(attList[0].ContentType);
                //             attach.setFileName(attList[0].Name);
                //             attach.Body = attList[0].Body;
                //             mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
                //         }
                //         emailList.add(mail);
                //     }
                //     if(!emailList.isEmpty()){
                //         Messaging.sendEmail(emailList);
                //     }
                // }
            }
        }catch(Exception e){
            system.debug(e.getMessage()+e.getLineNumber());
        }
    }
}