public class BatchToSendSEUCExpense implements Database.Batchable<sObject>, Database.Stateful {
    public BatchToSendSEUCExpense() {}

    public Database.QueryLocator start(Database.BatchableContext bc){
        Date todayDate = system.today();
        string devName = 'WISER';
        return Database.getQueryLocator('SELECT Id, FirstName, LastName, Email, Proposals__r.Tentative_Start_Date__c, Proposals__r.Next_SEUC_Email_Date__c, Proposals__r.RecordType.DeveloperName From Contact where Proposals__r.Next_SEUC_Email_Date__c =: todayDate and Proposals__r.RecordType.DeveloperName =: devName');
    }

    public void execute(Database.BatchableContext bc, List<Contact> contactList){
        system.debug('contactList ------> ' + contactList);

        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        Emailtemplate emailTempRec =  [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Reminder Mail For SE/UC & Expense'];
        if(!contactList.isEmpty()){
            for(Contact conRecord : contactList){
                system.debug('conRecord ---------> ' +conRecord);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { conRecord.Email});//Set To Email Address
                mail.setSubject(emailTempRec.Subject);//Set Subject
                string emailHtmlValue = emailTempRec.HtmlValue;
                if(!string.isBlank(conRecord.FirstName)){
                    emailHtmlValue = emailHtmlValue.replace('{!Contact.FirstName}', conRecord.FirstName);
                }
                if(!string.isBlank(conRecord.Login_Hash_Code__c)){
                    emailHtmlValue = emailHtmlValue.replace('{!Contact.Login_Hash_Code__c}', conRecord.Login_Hash_Code__c);
                }
                
                mail.setHtmlBody(emailHtmlValue);//Set HTML Body
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('The Batch Run Successfully');
    }
}