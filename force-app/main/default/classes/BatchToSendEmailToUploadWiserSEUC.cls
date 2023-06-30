public class BatchToSendEmailToUploadWiserSEUC implements Database.Batchable<sObject>, Database.Stateful {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        Date todayDate = system.today();
        string devName = 'WISER';
        return Database.getQueryLocator('SELECT Id,Name,FirstName,LastName,Email,Login_Hash_Code__c,Proposals__c,Proposals__r.Next_SEUC_Email_Date__c From Contact where Proposals__r.RecordType.DeveloperName =: devName AND Proposals__r.Next_SEUC_Email_Date__c =: todayDate AND Is_Primary__c = true');
    }

    public void execute(Database.BatchableContext bc, List<Contact> contactList){
        system.debug('contactList -------> '+contactList);
        List<Application_Proposal__c> proposalListToUpdate = New List<Application_Proposal__c>();
        List<Messaging.SingleEmailMessage> emailsList = new List<Messaging.SingleEmailMessage>();
        Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;
        if(!contactList.isEmpty()){
            for(Contact conRecord : contactList){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
                mail.setToAddresses(new String[] { conRecord.Email});
                mail.setSubject('Upload SE/UC & Expense Details');

                String emailBody = 'Dear ' + conRecord.Name + ',' ;
                emailBody += '<br> We are writing this email to notify you for SE/UC is not submitted yet. <br> <br>';
                emailBody += ' It has been already been 1 year and we have not recieved your SE/UC and Expense details.  <br> Kindly Submit your visa on the below link. <br> <br>';
                emailBody += '<a href="https://indo-germansciencetechnologycentre--dev.sandbox.my.salesforce-sites.com/ApplicantDashboard/ApplicantPortal?id=' + conRecord.Login_Hash_Code__c+ '&campaign=if#/WiserSEUCorExpenseUpload ">' + 'Click here'+ '</a><br><br>' ;
                emailBody += '<br><br> Thanks & Regards, <br> Amit Salvi, <br> Project Co-ordinator <br> IGSTC';
                mail.setHtmlBody(emailBody);
                emailsList.add(mail);

                Application_Proposal__c appProposal = New Application_Proposal__c();
                appProposal.Id = conRecord.Proposals__c;
                if(appProposal.Next_SEUC_Email_Date__c != null){
                    appProposal.Next_SEUC_Email_Date__c = appProposal.Next_SEUC_Email_Date__c.addMonths(12);
                }
                proposalListToUpdate.add(appProposal);
            }
            if(!proposalListToUpdate.isEmpty())
                update proposalListToUpdate;
            if(!emailsList.isEmpty()) {
                Messaging.sendEmail(emailsList);
            }
        }
    }

    public void finish(Database.BatchableContext bc){
        System.debug('The Batch Run Successfully');
    }
}