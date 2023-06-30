public class BatchToSendVisaReminderIF implements Database.Batchable<sObject>, Database.Stateful {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        Date todayDate = system.today();
        string devName = 'Industrial_Fellowships';
        return Database.getQueryLocator('SELECT Id, Name,Next_Visa_Date__c,Visa_Stages__c,(SELECT Id,Name,Email,Password__c,Proposals__c,Proposals__r.Title_Of__c From Contacts__r) From Application_Proposal__c where Next_Visa_Date__c =: todayDate and Visa_Stages__c != \'Submitted\' and RecordType.DeveloperName =: devName');
    }

    public void execute(Database.BatchableContext bc, List<Application_Proposal__c> projectList){
        system.debug('projectList:: ' + projectList);
        Date todayDate = system.today();
        List<Contact> conListToUpdate = New List<Contact>();
        List<Application_Proposal__c> proposalListToUpdate = New List<Application_Proposal__c>();
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        
        for(Application_Proposal__c project : projectList){
                for(Contact conRec : project.Contacts__r){
                    Contact contactRecord = New Contact();
                    contactRecord.Id = conRec.Id;
                    contactRecord.Login_Hash_Code__c = Utility.generateRandomString();
                    conListToUpdate.add(contactRecord);
                    Messaging.SingleEmailMessage contactEmail = new Messaging.SingleEmailMessage();
                    List <String> emailRecipients = new List <String>{conRec.Email};
                    
                    contactEmail.setToAddresses(emailRecipients);
                    contactEmail.setSubject('Visa Document');
                    contactEmail.setReplyTo(emailRecipients[0]);

                    String emailBody = 'Dear ' + conRec.Name + ',' ;
                    emailBody += '<br> We are writing this email to notify you for your visa is not submitted yet. <br> <br>';
                    emailBody += ' It has been already 15 days and we have not recieved your visa.  <br> Kindly Submit your visa on the below link. <br> <br>';
                    emailBody += '<a href="https://indo-germansciencetechnologycentre--dev.sandbox.my.salesforce-sites.com/ApplicantDashboard/ApplicantPortal?id=' + conRec.Login_Hash_Code__c+ '&campaign=if#/IFDocUploads ">' + 'Click here'+ '</a><br><br>' ;
                    emailBody += '<br><br> Thanks & Regards, <br> Amit Salvi, <br> Project Co-ordinator <br> IGSTC';
                    contactEmail.setHtmlBody(emailBody);
                    emailsList.add(contactEmail);
                    }
                    Application_Proposal__c appProposal = New Application_Proposal__c();
                    appProposal.Id = project.Id;
                    appProposal.Next_Visa_Date__c = appProposal.Next_Visa_Date__c.addDays(15);
                    proposalListToUpdate.add(appProposal);
        }
        update proposalListToUpdate;
        update conListToUpdate;
        if(!emailsList.isEmpty()) {
            Messaging.sendEmail(emailsList);
        }
    }

    public void finish(Database.BatchableContext bc){
        System.debug('The Batch Run Successfully');
    }
}