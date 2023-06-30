public class AttandanceReportEmailAndTaskBatch implements Database.Batchable<sObject>, Database.Stateful {

    public Database.QueryLocator start(Database.BatchableContext bc){
        Date todayDate = system.today();
        string devName = 'Industrial_Fellowships';
        return Database.getQueryLocator('SELECT Id, Start_Date__c,End_Date__c,Tranche_Date_before_7_days__c,Status__c,Proposals__r.RecordType.DeveloperName,Proposals__c From Disbursement_Schedule__c where Tranche_Date_before_7_days__c =: todayDate and Proposals__r.RecordType.DeveloperName =: devName');
    }

    public void execute(Database.BatchableContext bc, List<Disbursement_Schedule__c> disbursementList){
        system.debug('disbursementList ------> ' + disbursementList);
        set<Id> proposalIds = New set<Id>();
        for(Disbursement_Schedule__c disbursementRecord : disbursementList){
            system.debug('disbursementRecord -------> '+disbursementRecord);
            if(disbursementRecord.Proposals__c != null){
                proposalIds.add(disbursementRecord.Proposals__c);
            }
        }
        system.debug('proposalIds ------>'+proposalIds);
        List<Contact> contactList = [SELECT Id,Name,FirstName,Email,Password__c,Login_Hash_Code__c,Proposals__c,Proposals__r.Title_Of__c From Contact WHERE Email != null AND Proposals__c IN : proposalIds];
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        Emailtemplate emailTempRec =  [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Reminder Mail For Documents - IF'];
        if(!contactList.isEmpty()){
            for(Contact conRecord : contactList){

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
                if(!string.isBlank(conRecord.Id)){
                    emailHtmlValue = emailHtmlValue.replace('{!Contact.Id}', conRecord.Id);
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