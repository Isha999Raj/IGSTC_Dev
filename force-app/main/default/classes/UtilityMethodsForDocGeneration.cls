public class UtilityMethodsForDocGeneration {
    
    @AuraEnabled
    public static list<Contact> getRelatedList(Id recordId)
    {
        List<Contact> Conlist = [Select id,name,firstname,lastname,Email,Phone,Fellowship_Duration__c from Contact where Proposals__c=: recordId ];
        return Conlist;
    }

    @AuraEnabled
    public static String getFellowshipType(Id conId){
        try{
            Contact conRec = [SELECT Id,Name,Email,Fellowship_Duration__c,Proposals__c FROM Contact WHERE Id=: conId LIMIT 1];
            system.debug('conRec ::'+conRec);
            if(conRec.Fellowship_Duration__c <61){
                System.debug('pecfarAwardlessthenTwo Called');
                DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(conRec.Proposals__c,'Pecfar Award less then two');
            }else{
                System.debug('pecfarAwardlForTwo Called');
                DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(conRec.Proposals__c,'Pecfar Award two months');
            }
            return 'success';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    
    @AuraEnabled
    Public Static void ifDecisionLetter2(String proID){
        Application_Proposal__c appProposalRecord = [SELECT Id,Name,RecordType.Name From Application_Proposal__c WHERE Id =: proID];
        if(appProposalRecord.RecordType.Name == 'Industrial Fellowship'){
            DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(proID,'IF Decision Letter');
        }else{
            DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(proID,'Pecfar Decision letter'); 
        }
    }
    
    @AuraEnabled
    Public Static void generateTempForAwardDraft(String proID){
        
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        
        if(!conList.isEmpty()){
            for(contact cn : conList){
                if(cn.Industrial_Fellowship_Type__c =='PIEF'){
                    system.debug('Inside PIEF');
                    DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(proID,'IF Award Letter PIEF');
                }else{
                    DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(proID,'IF Award Letter PDIF');
                }
            }
        }
    }
    
    @AuraEnabled
    public static string getAttachmentId(string propId){
        return [SELECT Id, Name FROM Attachment WHERE ParentID =: propId Order by LastModifiedDate desc LIMIT 1].Id;
    }
    
    @AuraEnabled
    public static void sendProposal(string propId, string attId){
        try{
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            List<Contact> contactList = [Select Email,Name,Login_Hash_Code__c,Proposals__c From Contact where Proposals__c =: propId];
            List<Attachment> attList = [Select Id,name,Body,ContentType from attachment where Id = :attId]; 
            List<Application_Proposal__c> appList = New List<Application_Proposal__c>();          
            
            if(!contactList.isEmpty()){
                for(Contact con : contactList){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List <String> emailRecipients = new List <String>{con.Email};
                        mail.setToAddresses(emailRecipients);
                    mail.setSubject('Award Letter');
                    String emailBody = 'Dear ' + con.Name + ',' ;
                    emailBody += ' <br> <br> We are writing this email to notify you that your Award letter has been released. <br> <br>';
                    emailBody += ' <br> Please submit your Undertaking on below link. <br> <br>';
                    emailBody += '<a href="https://indo-germansciencetechnologycentre--dev.sandbox.my.salesforce-sites.com/ApplicantDashboard/ApplicantPortal?id=' + con.Login_Hash_Code__c+ '&campaign=if#/IFDocUploads">' + 'Click here'+ '</a><br><br>' ;
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
                    Application_Proposal__c app = New Application_Proposal__c();
                    app.Id = con.Proposals__c;
                    app.Undertaking_Status__c = 'Sent';
                    appList.add(app);
                }
                if(!emailList.isEmpty()){
                    Messaging.sendEmail(emailList);
                }
                update appList;
            }
            
        }catch(Exception e){
            system.debug(e.getMessage()+e.getLineNumber());
        } 
    }
    
    @AuraEnabled
    public static void sendProposalDecision(string propId, string attId){
        try{
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            List<Contact> contactList = [Select Email,Name,Login_Hash_Code__c,Proposals__c,Campaign__c From Contact where Proposals__c =: propId];
            system.debug('contactList ::'+contactList);
            List<Attachment> attList = [Select Id,name,Body,ContentType from attachment where Id = :attId];
            system.debug('attList ::'+attList); 
            List<Application_Proposal__c> appList = New List<Application_Proposal__c>();          
            
            if(!contactList.isEmpty()){
                for(Contact con : contactList){
                    if(con.Campaign__c == 'if'){
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        List <String> emailRecipients = new List <String>{con.Email};
                            mail.setToAddresses(emailRecipients);
                        mail.setSubject('Decision Letter');
                        String emailBody = 'Dear ' + con.Name + ',' ;
                        emailBody += ' <br> <br> We are writing this email to notify you for your proposal has been approved by our scientific committee and your decision letter has been released. <br> <br>';
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
                        Application_Proposal__c app = New Application_Proposal__c();
                        app.Id = con.Proposals__c;
                        app.Decision_Letter_Sent__c = true;
                        appList.add(app);
                    }else{
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List <String> emailRecipients = new List <String>{con.Email};
                        mail.setToAddresses(emailRecipients);
                    mail.setSubject('Decision Letter');
                    String emailBody = 'Dear ' + con.Name + ',' ;
                    emailBody += ' <br> <br> We are writing this email to notify you for your proposal has been approved by our scientific committee and your decision letter has been released. <br> <br>';
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
                    Application_Proposal__c app = New Application_Proposal__c();
                    app.Id = con.Proposals__c;
                    app.Decision_Letter_Sent__c = true;
                    appList.add(app);
                    }
                }
                if(!emailList.isEmpty()){
                    Messaging.sendEmail(emailList);
                }
                update appList;
            }
            
        }catch(Exception e){
            system.debug(e.getMessage()+e.getLineNumber());
        }
    }
    
    @AuraEnabled
    public static void sendProposal2(string conId, string attId){
        try{
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            List<Contact> contactList = [Select Email,Name,Login_Hash_Code__c,Proposals__c From Contact where Id =: conId LIMIT 1]; 
            List<Attachment> attList = [Select Id,name,Body,ContentType from attachment where Id = :attId]; 
            List<Application_Proposal__c> appList = New List<Application_Proposal__c>();          
            
            if(!contactList.isEmpty()){
                for(Contact con : contactList){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    List <String> emailRecipients = new List <String>{con.Email};
                        mail.setToAddresses(emailRecipients);
                    mail.setSubject('Award Letter');
                    String emailBody = 'Dear ' + con.Name + ',' ;
                    emailBody += ' <br> <br> We are writing this email to notify you that your Award letter has been released. <br> <br>';
                    emailBody += ' <br> Please submit your Undertaking on below link. <br> <br>';
                    emailBody += '<a href="https://indo-germansciencetechnologycentre--dev.sandbox.my.salesforce-sites.com/ApplicantDashboard/ApplicantPortal?id=' + con.Login_Hash_Code__c+ '&campaign=pecfar#/PECFARDocUpload ">' + 'Click here'+ '</a><br><br>' ;
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
                    Application_Proposal__c app = New Application_Proposal__c();
                    app.Id = con.Proposals__c;
                    app.Undertaking_Status__c = 'Sent';
                    appList.add(app);
                }
                if(!emailList.isEmpty()){
                    Messaging.sendEmail(emailList);
                }
                update appList;
            }
            
        }catch(Exception e){
            system.debug(e.getMessage()+e.getLineNumber());
        } 
    }
    @future (callout=true)
    Public static void generateCongaTemplate(String var,String TemplateName){
        system.debug('var ::'+var);
        String TemplateId = CongaHelperToolLightning.generateReport(var,TemplateName,null,null,null);
        system.debug('TemplateId'+TemplateId);
    }
    /********************* END ********************/
    
}