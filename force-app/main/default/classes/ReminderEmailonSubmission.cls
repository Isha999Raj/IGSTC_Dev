public with sharing class ReminderEmailonSubmission {
    
    /////////////PECFAR/////////////////////////
    public static void sendReminderEmailPECFAR(){
        List<contact> conList = [SELECT Id,Name,FirstName,LastName,Email FROM Contact where Proposals__r.RecordType.Name = 'PECFAR'];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate empRec = [Select Id,Subject,HtmlValue From EmailTemplate where Name = 'test'];
        Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;

        for(Contact Con : conList){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setOrgWideEmailAddressId(orgWideEmailAddressId);
            email.setToAddresses(new List<String>{Con.Email});
            email.setSubject(empRec.Subject);
            string htmlEmailVal = empRec.HtmlValue;
            if(!string.isBlank(Con.FirstName))
                htmlEmailVal = htmlEmailVal.replace('{!Contact.FirstName}', Con.FirstName);
            if(!string.isBlank(Con.LastName))
                htmlEmailVal = htmlEmailVal.replace('{!Contact.LastName}', Con.LastName);
            
            email.setBccAddresses(new List<String>{'saquib.shaikh@igstc.org'});
            email.setHtmlBody(htmlEmailVal );
            mails.add(email);
            
        }
        Messaging.sendEmail(mails);
     }


     /////////////INDUSTRIAL FELLOWSHIP/////////////////////////
    public static void sendReminderEmailIF(){
        List<contact> conList = [SELECT Id,Name,FirstName,LastName,Email FROM Contact where Proposals__r.RecordType.Name = 'Industrial Fellowship'];
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate empRec = [Select Id,Subject,HtmlValue From EmailTemplate where Name = 'test'];
        Id orgWideEmailAddressId = [SELECT Id FROM OrgWideEmailAddress ].Id;

        for(Contact Con : conList){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setOrgWideEmailAddressId(orgWideEmailAddressId);
            email.setToAddresses(new List<String>{Con.Email});
            email.setSubject(empRec.Subject);
            string htmlEmailVal = empRec.HtmlValue;
            if(!string.isBlank(Con.FirstName))
                htmlEmailVal = htmlEmailVal.replace('{!Contact.FirstName}', Con.FirstName);
            if(!string.isBlank(Con.LastName))
                htmlEmailVal = htmlEmailVal.replace('{!Contact.LastName}', Con.LastName);
            
            email.setBccAddresses(new List<String>{'saquib.shaikh@igstc.org'});
            email.setHtmlBody(htmlEmailVal );
            mails.add(email);
            
        }
        Messaging.sendEmail(mails);
            }
}