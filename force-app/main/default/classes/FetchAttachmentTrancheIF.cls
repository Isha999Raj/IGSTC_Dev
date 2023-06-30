public with sharing class FetchAttachmentTrancheIF {
    @InvocableMethod(label='Generate Tranche attachment Id For IF' description='Get TrancheIF template' category='attachment')
    Public Static void getTrancheAttId(List<String> proIDList){
        system.debug('proIDList ::'+proIDList);
        try{
            Date todayDate  = System.today();
            if(!proIDList.isEmpty()){
                String ProId = proIDList[0];
                List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
                List<Contact> conListToUpdateHashCode = New List<Contact>();
                List<Contact> contactList = [Select Email,Name,FirstName,Id,Login_Hash_Code__c From Contact where Proposals__c =: ProId];

                for(Contact con : contactList){
                    con.Login_Hash_Code__c = Utility.generateRandomString();
                    con.Hashcode_Expiration_Date__c = todayDate.addDays(3);
                    conListToUpdateHashCode.add(con);
                }
                if(!conListToUpdateHashCode.isEmpty()){
                    update conListToUpdateHashCode;
                }


                Emailtemplate emailTempRec = New Emailtemplate();
                emailTempRec =  [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Tranche Release Mail - IF'];
                List<Attachment> attList = [Select Id,name,Body,ContentType from attachment where parentId = :ProId order by createdDate DESC limit 1];           
                
                if(!contactList.isEmpty()){
                    for(Contact con : contactList){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List <String> emailRecipients = new List <String>{con.Email};
                        mail.setToAddresses(emailRecipients);
                        string emailHtmlValue = emailTempRec.HtmlValue;
                        if(!string.isBlank(con.FirstName)){
                            emailHtmlValue = emailHtmlValue.replace('{!Contact.FirstName}', con.FirstName);
                        }
                        mail.setHtmlBody(emailHtmlValue);
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
                    EmailMessage emailMessageRecToBeInserted = New EmailMessage();
                    emailMessageRecToBeInserted.MessageDate = System.now();
                    emailMessageRecToBeInserted.Status = '3';
                    emailMessageRecToBeInserted.Subject = emailTempRec.Subject;
                    emailMessageRecToBeInserted.ToAddress = contactList[0].Email;
                    emailMessageRecToBeInserted.Contact__c = contactList[0].Id;
                    system.debug('emailMessageRecToBeInserted ==> '+emailMessageRecToBeInserted);
                    insert emailMessageRecToBeInserted;
                }
            }
        }catch(Exception e){
            system.debug(e.getMessage()+e.getLineNumber());
        }
    }
}