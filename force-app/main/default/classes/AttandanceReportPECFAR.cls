public class AttandanceReportPECFAR implements Database.Batchable<sObject>, Database.Stateful {

    public Database.QueryLocator start(Database.BatchableContext bc){
        Date todayDate = system.today();
        string devName = 'pecfar';
        return Database.getQueryLocator('SELECT Id, Start_Date__c,End_Date__c,Status__c,Contact__r.Campaign__c,Proposals__c From Disbursement_Schedule__c where Start_Date__c =: todayDate and Contact__r.Campaign__c =: devName');
    }

    public void execute(Database.BatchableContext bc, List<Disbursement_Schedule__c> disbursementList){
        system.debug('disbursementList ------> ' + disbursementList);
        set<Id> conId = New set<Id>();
        for(Disbursement_Schedule__c disbursementRecord : disbursementList){
            system.debug('disbursementRecord -------> '+disbursementRecord);
            if(disbursementRecord.Contact__c != null){
                conId.add(disbursementRecord.Contact__c);
            }
        }
        system.debug('conId ------>'+conId);
        List<Contact> contactList = [SELECT Id,Name,Email,Password__c,Login_Hash_Code__c,Proposals__c,Proposals__r.Title_Of__c From Contact WHERE Email != null AND Id IN : conId];
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        if(!contactList.isEmpty()){
            for(Contact conRecord : contactList){
                Messaging.SingleEmailMessage contactEmail = new Messaging.SingleEmailMessage();
                List <String> emailRecipients = new List <String>{conRecord.Email};
                    
                contactEmail.setToAddresses(emailRecipients);
                contactEmail.setSubject('Attendance Report');
                contactEmail.setReplyTo(emailRecipients[0]);
                
                String emailBody = 'Dear ' + conRecord.Name + ',' ;
                emailBody += ' <br> <br> We are writing this email to notify you for your attendance report for proposal title as' + conRecord.Proposals__r.Title_Of__c + '". <br> <br>';
                emailBody += ' It has been already 1 month and we have not recieved your attendance report on above mentioned proposal.  <br> Kindly Submit your attendance report on the below link. <br> <br>';
                emailBody += '<a href="https://indo-germansciencetechnologycentre--dev.sandbox.my.salesforce-sites.com/ApplicantDashboard/ApplicantPortal?id=' + conRecord.Login_Hash_Code__c+ '&campaign=if#/PECFARDocUpload">' + 'Click here'+ '</a><br><br>' ;
                emailBody += '<br><br> Thanks & Regards, <br> Amit Salvi, <br> Project Co-ordinator <br> IGSTC';
                contactEmail.setHtmlBody(emailBody);
                emailsList.add(contactEmail);
            }
        }
        if(!emailsList.isEmpty()) {
            Messaging.sendEmail(emailsList);
        }
    }
    
    public void finish(Database.BatchableContext bc){
        System.debug('The Batch Run Successfully');
    }

}