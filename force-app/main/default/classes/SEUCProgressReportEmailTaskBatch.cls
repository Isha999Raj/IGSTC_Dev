public class SEUCProgressReportEmailTaskBatch implements Database.Batchable<sObject>, Database.Stateful {

    public Database.QueryLocator start(Database.BatchableContext bc){
        Date todayDate = system.today();
        string devName = 'Industrial_Fellowships';
        return Database.getQueryLocator('SELECT Id, Name,Progress_Report_Date__c,Tentative_End_Date__c,RecordType.DeveloperName From Application_Proposal__c where Progress_Report_Date__c =: todayDate and Tentative_End_Date__c >=: todayDate and RecordType.DeveloperName =: devName');
    }
    
    public void execute(Database.BatchableContext bc, List<Application_Proposal__c> projectList){

        system.debug('projectList:: ' + projectList);
        set<Id> proposalIsSet = New set<Id>();

        for(Application_Proposal__c appProp : projectList){
            proposalIsSet.add(appProp.Id);
        }

        Emailtemplate emailTempRec =  [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Progress Report Reminder Mail - IF'];
        List<Contact> contactList = [SELECT Id,FirstName,Name,Email,Password__c,Proposals__c,Proposals__r.Title_Of__c,Proposals__r.Progress_Report_Date__c,Login_Hash_Code__c,Hashcode_Expiration_Date__c From Contact WHERE Proposals__c IN :proposalIsSet];
        system.debug('contactList ==> '+contactList);
        List<Contact> contListToUpdateHashCode = New List<Contact>();
        Date todayDate = system.today();
        List<Task> taskListToInsert = new List<Task>();
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();

        if(!contactList.isEmpty()){
            for(Contact con : contactList){
                con.Login_Hash_Code__c = Utility.generateRandomString();
                con.Hashcode_Expiration_Date__c = todayDate.addDays(3); 
                contListToUpdateHashCode.add(con);
            }
            update contListToUpdateHashCode;
        }

        if(!contactList.isEmpty()){
            system.debug('contactList2 ==> '+contactList);
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
            system.debug('contactList[0].Proposals__c ==> '+contactList[0].Proposals__c);
            Application_Proposal__c proposalToUpdate = New Application_Proposal__c();
            proposalToUpdate.Id = contactList[0].Proposals__c;
            proposalToUpdate.Progress_Report_Date__c = contactList[0].Proposals__r.Progress_Report_Date__c.addMonths(3);
            update proposalToUpdate;
        }
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('The Batch Run Successfully');
    }

}