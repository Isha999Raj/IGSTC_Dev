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
            List<Contact> conList = [Select Email,FirstName,Name,Login_Hash_Code__c,Industrial_Fellowship_Type__c,Proposals__c,Proposals__r.Title_Of__c,AccountName__c,Proposals__r.Duration_In_Months_Max_36__c,Proposals__r.Tentative_Start_Date__c From Contact where Proposals__c =: propId];
            List<Attachment> attList = [Select Id,name,Body,ContentType from attachment where Id = :attId]; 
            List<Application_Proposal__c> appList = New List<Application_Proposal__c>(); 
            Emailtemplate emailTempRec =  [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Award Letter For PDIF - IF'];
            Emailtemplate emailTempRecPIEF =  [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Award Letter For PIEF - IF'];       
            
            if(!conList.isEmpty()){
                for(Contact con : conList){
                    if(con.Industrial_Fellowship_Type__c == 'PDIF'){
                        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                        attach.setContentType(attList[0].ContentType);
                        attach.setFileName(attList[0].Name);
                        attach.Body = attList[0].Body;
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(new String[] { con.Email});//Set To Email Address
                        mail.setSubject(emailTempRec.Subject);//Set Subject
                        string emailHtmlValue = emailTempRec.HtmlValue;
                        if(!string.isBlank(conList[0].FirstName)){
                            emailHtmlValue = emailHtmlValue.replace('{!Contact.FirstName}', conList[0].FirstName);
                        }
                        if(!string.isBlank(conList[0].Login_Hash_Code__c)){
                            emailHtmlValue = emailHtmlValue.replace('{!Contact.Login_Hash_Code__c}', conList[0].Login_Hash_Code__c);
                        }
                        if(!string.isBlank(conList[0].Proposals__r.Title_Of__c)){
                            emailHtmlValue = emailHtmlValue.replace('{!Application_Proposal__c.Title_Of__c}', conList[0].Proposals__r.Title_Of__c);
                        }
                        if(!string.isBlank(conList[0].AccountName__c)){
                            emailHtmlValue = emailHtmlValue.replace('{!Contact.AccountName__c}', conList[0].AccountName__c);
                        }
                        if(conList[0].Proposals__r.Duration_In_Months_Max_36__c != null){
                            emailHtmlValue = emailHtmlValue.replace('{!Application_Proposal__c.Duration_In_Months_Max_36__c}', string.valueOf(conList[0].Proposals__r.Duration_In_Months_Max_36__c));
                        }
                        if(conList[0].Proposals__r.Tentative_Start_Date__c != null){
                            emailHtmlValue = emailHtmlValue.replace('{!Application_Proposal__c.Tentative_Start_Date__c}', string.valueOf(conList[0].Proposals__r.Tentative_Start_Date__c));
                        }
                        mail.setHtmlBody(emailHtmlValue);//Set HTML Body
                        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });//Set File Attachment
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                        // Application_Proposal__c app = New Application_Proposal__c();
                        // app.Id = conList[0].Proposals__c;
                        // app.Undertaking_Status__c = 'Sent';
                        // appList.add(app);
                        // update appList;
                        // Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        // List <String> emailRecipients = new List <String>{con.Email};
                        // mail.setToAddresses(emailRecipients);
                        // mail.setSubject('Award Letter');
                        // String emailBody = 'Dear ' + con.Name + ',' ;
                        // emailBody += ' <br> <br> We are writing this email to notify you that your Award letter has been released. <br> <br>';
                        // emailBody += ' <br> Please submit your Undertaking on below link. <br> <br>';
                        // emailBody += '<a href="https://indo-germansciencetechnologycentre--dev.sandbox.my.salesforce-sites.com/ApplicantDashboard/ApplicantPortal?id=' + con.Login_Hash_Code__c+ '&campaign=if#/IFDocUploads">' + 'Click here'+ '</a><br><br>' ;
                        // emailBody += '<br><br> Thanks & Regards, <br> Amit Salvi, <br> Project Co-ordinator <br> IGSTC';
                        // mail.setHtmlBody(emailBody);//Set HTML Body
                        // Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                        // if(!attList.isEMpty()){
                        //     attach.setContentType(attList[0].ContentType);
                        //     attach.setFileName(attList[0].Name);
                        //     attach.Body = attList[0].Body;
                        //     mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
                        // }
                        // emailList.add(mail);
                        // Application_Proposal__c app = New Application_Proposal__c();
                        // app.Id = con.Proposals__c;
                        // app.Undertaking_Status__c = 'Sent';
                        // appList.add(app);
                    }else{
                        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                        attach.setContentType(attList[0].ContentType);
                        attach.setFileName(attList[0].Name);
                        attach.Body = attList[0].Body;
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(new String[] { con.Email});//Set To Email Address
                        mail.setSubject(emailTempRecPIEF.Subject);//Set Subject
                        string emailHtmlValue = emailTempRecPIEF.HtmlValue;

                        if(!string.isBlank(conList[0].FirstName)){
                            emailHtmlValue = emailHtmlValue.replace('{!Contact.FirstName}', conList[0].FirstName);
                        }
                        if(!string.isBlank(conList[0].Login_Hash_Code__c)){
                            emailHtmlValue = emailHtmlValue.replace('{!Contact.Login_Hash_Code__c}', conList[0].Login_Hash_Code__c);
                        }
                        if(!string.isBlank(conList[0].Proposals__r.Title_Of__c)){
                            emailHtmlValue = emailHtmlValue.replace('{!Application_Proposal__c.Title_Of__c}', conList[0].Proposals__r.Title_Of__c);
                        }
                        if(!string.isBlank(conList[0].AccountName__c)){
                            emailHtmlValue = emailHtmlValue.replace('{!Contact.AccountName__c}', conList[0].AccountName__c);
                        }
                        if(conList[0].Proposals__r.Duration_In_Months_Max_36__c != null){
                            emailHtmlValue = emailHtmlValue.replace('{!Application_Proposal__c.Duration_In_Months_Max_36__c}', string.valueOf(conList[0].Proposals__r.Duration_In_Months_Max_36__c));
                        }
                        if(conList[0].Proposals__r.Tentative_Start_Date__c != null){
                            emailHtmlValue = emailHtmlValue.replace('{!Application_Proposal__c.Tentative_Start_Date__c}', string.valueOf(conList[0].Proposals__r.Tentative_Start_Date__c));
                        }
                        mail.setHtmlBody(emailHtmlValue);//Set HTML Body
                        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });//Set File Attachment
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                        // Application_Proposal__c app = New Application_Proposal__c();
                        // app.Id = conList[0].Proposals__c;
                        // app.Undertaking_Status__c = 'Sent';
                        // appList.add(app);
                        // update appList;
                    }
                    
                }
                // if(!emailList.isEmpty()){
                //     Messaging.sendEmail(emailList);
                // }
            }
            
        }catch(Exception e){
            system.debug(e.getMessage()+e.getLineNumber());
        } 
    }
    
    @AuraEnabled
    public static void sendProposalDecision(string propId, string attId){
        try{

                List<Application_Proposal__c> appList = New List<Application_Proposal__c>();
                List<Contact> conList = [SELECT Id,Name,FirstName,LastName,Campaign__c,ApplicationId__c,Proposals__r.Tentative_Start_Date__c,Proposals__r.Duration_In_Months_Max_36__c,Login_Hash_Code__c FROM Contact WHERE Proposals__c =: propId];
                String contactEmail = [Select Email From Contact where Proposals__c =: propId and Is_Primary__c = true].Email; 
                List<String> attachmentsListToBeReturned = new List<String>();
                Emailtemplate emailTempRec = New Emailtemplate();
                List<Attachment> attList = [Select Id,name,Body,ContentType from attachment where parentId = :propId order by createdDate DESC];
                emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Decision Mail - IF'];

                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setContentType(attList[0].ContentType);
                attach.setFileName(attList[0].Name);
                attach.Body = attList[0].Body;
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { contactEmail});//Set To Email Address
                mail.setSubject(emailTempRec.Subject);//Set Subject
                string emailHtmlValue = emailTempRec.HtmlValue;
                if(!string.isBlank(conList[0].FirstName)){
                    emailHtmlValue = emailHtmlValue.replace('{!Contact.FirstName}', conList[0].FirstName);
                }
                if(conList[0].Proposals__r.Tentative_Start_Date__c != null){
                    emailHtmlValue = emailHtmlValue.replace('{!Application_Proposal__c.Tentative_Start_Date__c}', string.valueOf(conList[0].Proposals__r.Tentative_Start_Date__c));
                }
                if(conList[0].Proposals__r.Duration_In_Months_Max_36__c != null){
                    emailHtmlValue = emailHtmlValue.replace('{!Application_Proposal__c.Duration_In_Months_Max_36__c}', string.valueOf(conList[0].Proposals__r.Duration_In_Months_Max_36__c));
                }
                if(!string.isBlank(conList[0].Login_Hash_Code__c)){
                    emailHtmlValue = emailHtmlValue.replace('{!Contact.Login_Hash_Code__c}', conList[0].Login_Hash_Code__c);
                }
                mail.setHtmlBody(emailHtmlValue);//Set HTML Body
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });//Set File Attachment
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                Application_Proposal__c app = New Application_Proposal__c();
                app.Id = conList[0].Proposals__c;
                app.Decision_Letter_Sent__c = true;
                app.Travel_Form_Status__c = 'Sent';
                appList.add(app);

                update appList;
            
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