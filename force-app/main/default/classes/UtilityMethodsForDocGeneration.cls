public class UtilityMethodsForDocGeneration {
    
    @AuraEnabled
    public static list<Contact> getRelatedList(Id recordId)
    {
        List<Contact> Conlist = [Select id,name,firstname,lastname,Email,Phone,Fellowship_Duration__c from Contact where Proposals__c=: recordId ];
        return Conlist;
    }

    @AuraEnabled
    public static String getFellowshipType(String proID){
        try{
            System.debug('pecfarAwardlessthenTwo Called');
            DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(proID,'Pecfar Award less then two');
            
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
    Public Static string generateAwardLetterOfSing(String proID){ 
        try{
            list<contact> conList  =[select id,name from contact WHERE Proposals__c =:proID];
            Application_Proposal__c proposalRecord = [SELECT Id, RecordType.Name, Country_of_Venue__c FROM Application_Proposal__c Where Id =: proID];
            system.debug('conList----'+conList);

            if(!conList.isEmpty()){
                if(proposalRecord.RecordType.Name == 'SING'){
                    DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(proID,'Sing Award Letter'); 
                }else if(proposalRecord.RecordType.Name == 'Workshop'){
                    if(proposalRecord.Country_of_Venue__c == 'India'){
                        DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(proID,'workshop indian sanction');
                    }else{
                        DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(proID,'workshop german sanction');
                    }
                }
            } 
            return 'Success';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @AuraEnabled
    Public Static void generateWiserAwardLetter(String proID){
        
        list<contact> conList  =[select id,name from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        
        if(!conList.isEmpty()){
            DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(proID,'Wiser Draft Letter');
        }
    }
    
    @AuraEnabled
    public static string getAttachmentId(string propId){
        return [SELECT Id, Name FROM Attachment WHERE ParentID =: propId Order by LastModifiedDate desc LIMIT 1].Id;
    }
    
    @AuraEnabled
    public static string sendProposal(string propId, string attId){
        try{
            Date todayDate  = System.today();
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            List<Contact> conListToUpdateHashCode = New List<Contact>();
            List<Contact> conList = [Select Email,FirstName,Name,Login_Hash_Code__c,Industrial_Fellowship_Type__c,Proposals__c,Proposals__r.Title_Of__c,AccountName__c,Proposals__r.Duration_In_Months_Max_36__c,Proposals__r.Visa_Stages__c,Proposals__r.Tentative_Start_Date__c From Contact where Proposals__c =: propId];
            
            for(Contact con : conList){
                con.Login_Hash_Code__c = Utility.generateRandomString();
                con.Hashcode_Expiration_Date__c = todayDate.addDays(3);
                conListToUpdateHashCode.add(con); 
            }
            if(!conListToUpdateHashCode.isEmpty()){
                update conListToUpdateHashCode;
            }
            
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
                        EmailMessage emailMessageRecToBeInserted = New EmailMessage();
                        emailMessageRecToBeInserted.MessageDate = System.now();
                        emailMessageRecToBeInserted.Status = '3';
                        emailMessageRecToBeInserted.Subject = emailTempRec.Subject;
                        emailMessageRecToBeInserted.ToAddress = con.Email;
                        emailMessageRecToBeInserted.Contact__c = con.Id;
                        system.debug('emailMessageRecToBeInserted ==> '+emailMessageRecToBeInserted);
                        insert emailMessageRecToBeInserted;
                        if(conList[0].Proposals__r.Visa_Stages__c == 'Approved'){
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            Application_Proposal__c app = New Application_Proposal__c();
                            app.Id = conList[0].Proposals__c;
                            app.Undertaking_Status__c = 'Sent';
                            appList.add(app);
                            update appList;
                        }
                        

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
                        EmailMessage emailMessageRecToBeInserted = New EmailMessage();
                        emailMessageRecToBeInserted.MessageDate = System.now();
                        emailMessageRecToBeInserted.Status = '3';
                        emailMessageRecToBeInserted.Subject = emailTempRecPIEF.Subject;
                        emailMessageRecToBeInserted.ToAddress = con.Email;
                        emailMessageRecToBeInserted.Contact__c = con.Id;
                        system.debug('emailMessageRecToBeInserted ==> '+emailMessageRecToBeInserted);
                        insert emailMessageRecToBeInserted;
                        if(conList[0].Proposals__r.Visa_Stages__c == 'Approved'){
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            Application_Proposal__c app = New Application_Proposal__c();
                            app.Id = conList[0].Proposals__c;
                            app.Undertaking_Status__c = 'Sent';
                            appList.add(app);
                            update appList;
                        }
                    }
                    
                }
            }
            return conList[0].Proposals__r.Visa_Stages__c;
            
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
            // system.debug(e.getMessage()+e.getLineNumber());
        } 
    }
    
    @AuraEnabled
    public static string sendProposalDecision(string propId, string attId){
        try{
            Date todayDate  = System.today();
                string returnValue;
                List<Application_Proposal__c> appList = New List<Application_Proposal__c>();
                List<Contact> conListToUpdateHashcode = New List<Contact>();
                List<Contact> conList = [SELECT Id,Name,FirstName,LastName,Campaign__c,ApplicationId__c,Proposals__r.Tentative_Start_Date__c,Proposals__r.Duration_In_Months_Max_36__c,Proposals__r.Travel_Form_Status__c,Proposals__r.RecordType.DeveloperName,Proposals__r.Invitation_Letter_Form_Status__c,Login_Hash_Code__c FROM Contact WHERE Proposals__c =: propId];
                
                /*Updating Hashcode */
                for(Contact conRec : conList){
                    conRec.Login_Hash_Code__c = Utility.generateRandomString();
                    conRec.Hashcode_Expiration_Date__c = todayDate.addDays(3);
                    conListToUpdateHashcode.add(conRec);
                }
                if(!conListToUpdateHashcode.isEmpty()){
                    update conListToUpdateHashcode;
                }


                String contactEmail = [Select Email From Contact where Proposals__c =: propId and Is_Primary__c = true].Email; 
                List<String> attachmentsListToBeReturned = new List<String>();
                List<EmailMessage> listOfEmailMesToInsert = New List<EmailMessage>();  
                Emailtemplate emailTempRec = New Emailtemplate();
                List<Attachment> attList = [Select Id,name,Body,ContentType from attachment where parentId = :propId order by createdDate DESC];
                system.debug('attList --> '+attList[0].Id);
                if(conList[0].Proposals__r.RecordType.DeveloperName == 'Industrial_Fellowships'){
                    emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Decision Letter - IF'];
                }else if(conList[0].Proposals__r.RecordType.DeveloperName == 'PECFAR'){
                    emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Decision Mail - PECFAR'];
                }

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
                if(!string.isBlank(conList[0].Id)){
                    emailHtmlValue = emailHtmlValue.replace('{!Contact.Id}', conList[0].Id);
                }
                mail.setHtmlBody(emailHtmlValue);//Set HTML Body
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });//Set File Attachment
                if(conList[0].Proposals__r.Travel_Form_Status__c == 'Approved' && conList[0].Proposals__r.RecordType.DeveloperName == 'Industrial_Fellowships'){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    EmailMessage emailMessageRecToBeInserted = New EmailMessage();
                    emailMessageRecToBeInserted.MessageDate = System.now();
                    emailMessageRecToBeInserted.Status = '3';
                    emailMessageRecToBeInserted.Subject = emailTempRec.Subject;
                    emailMessageRecToBeInserted.ToAddress = contactEmail;
                    emailMessageRecToBeInserted.Contact__c = conList[0].Id;
                    system.debug('emailMessageRecToBeInserted ==> '+emailMessageRecToBeInserted);
                    insert emailMessageRecToBeInserted;
                    Application_Proposal__c app = New Application_Proposal__c();
                    app.Id = conList[0].Proposals__c;
                    app.Decision_Letter_Sent__c = true;
                    //app.Travel_Form_Status__c = 'Sent';
                    app.Visa_Stages__c = 'Sent';
                    app.Proposal_Stages__c = 'Under Visa Process';
                    appList.add(app);
                    update appList;
                    returnValue = conList[0].Proposals__r.Travel_Form_Status__c;
                }else if(conList[0].Proposals__r.RecordType.DeveloperName == 'PECFAR'){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    EmailMessage emailMessageRecToBeInserted = New EmailMessage();
                    emailMessageRecToBeInserted.MessageDate = System.now();
                    emailMessageRecToBeInserted.Status = '3';
                    emailMessageRecToBeInserted.Subject = emailTempRec.Subject;
                    emailMessageRecToBeInserted.ToAddress = contactEmail;
                    emailMessageRecToBeInserted.Contact__c = conList[0].Id;
                    system.debug('emailMessageRecToBeInserted ==> '+emailMessageRecToBeInserted);
                    insert emailMessageRecToBeInserted;
                    Application_Proposal__c app = New Application_Proposal__c();
                    app.Id = conList[0].Proposals__c;
                    app.Decision_Letter_Sent__c = true;
                    app.Proposal_Stages__c = 'Under Award';
                    appList.add(app);
                    if(!appList.isEmpty()){
                        update appList;
                    }
                    returnValue = conList[0].Proposals__r.Invitation_Letter_Form_Status__c;
                }
                 return returnValue;   
                
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
            //system.debug(e.getMessage()+e.getLineNumber());
        }
    }
    
    @AuraEnabled
    public static void sendProposal2(string propId, string attId){
        try{
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            List<Contact> contactList = [Select Email,Name,Login_Hash_Code__c,Proposals__c From Contact where Proposals__c =: propId]; 
            List<Attachment> attList = [Select Id,name,Body,ContentType from attachment where Id = :attId]; 
            List<Application_Proposal__c> appList = New List<Application_Proposal__c>();  
            List<EmailMessage> listOfEmailMesToInsert = New List<EmailMessage>();        
            
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

                    EmailMessage emailMessageRecToBeInserted = New EmailMessage();
                    emailMessageRecToBeInserted.MessageDate = System.now();
                    emailMessageRecToBeInserted.Status = '3';
                    emailMessageRecToBeInserted.Subject = 'Award Letter';
                    emailMessageRecToBeInserted.ToAddress = con.Email;
                    emailMessageRecToBeInserted.Contact__c = con.Id;
                    system.debug('emailMessageRecToBeInserted ==> '+emailMessageRecToBeInserted);
                    listOfEmailMesToInsert.add(emailMessageRecToBeInserted);
                }
                if(!emailList.isEmpty()){
                    Messaging.sendEmail(emailList);
                }
                if(!listOfEmailMesToInsert.isEmpty()){
                    insert listOfEmailMesToInsert;
                }
                Application_Proposal__c app = New Application_Proposal__c();
                app.Id = contactList[0].Proposals__c;
                app.Undertaking_Status__c = 'Sent';
                appList.add(app);
                system.debug('appList ----> '+appList);
                update appList;
            }
            
        }catch(Exception e){
            system.debug(e.getMessage()+e.getLineNumber());
        } 
    }

    @AuraEnabled
    public static void sendProposalAwardWiser(string propId, string attId){
        try{

                List<Application_Proposal__c> appList = New List<Application_Proposal__c>();
                List<Contact> conList = [SELECT Id,Name,FirstName,LastName,Campaign__c,ApplicationId__c,Proposals__r.Tentative_Start_Date__c,Proposals__r.Duration_In_Months_Max_36__c,Login_Hash_Code__c FROM Contact WHERE Proposals__c =: propId];
                String contactEmail = [Select Email From Contact where Proposals__c =: propId and Is_Primary__c = true].Email; 
                List<String> attachmentsListToBeReturned = new List<String>();
                Emailtemplate emailTempRec = New Emailtemplate();
                List<Attachment> attList = [Select Id,name,Body,ContentType from attachment where parentId = :propId order by createdDate DESC];
                // emailTempRec = [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Decision Mail - IF'];

                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                attach.setContentType(attList[0].ContentType);
                attach.setFileName(attList[0].Name);
                attach.Body = attList[0].Body;
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { contactEmail});//Set To Email Address
                mail.setSubject('Award Letter');
                String emailBody = 'Dear ' + conList[0].Name + ',' ;
                emailBody += ' <br> <br> We are writing this email to notify you that your Award letter has been released. <br> <br>';
                emailBody += ' <br> Please submit your Undertaking on below link. <br> <br>';
                emailBody += '<a href="https://indo-germansciencetechnologycentre--dev.sandbox.my.salesforce-sites.com/ApplicantDashboard/ApplicantPortal?id=' + conList[0].Login_Hash_Code__c+ '&campaign=wiser#/WISERDocUpload ">' + 'Click here'+ '</a><br><br>' ;
                emailBody += '<br><br> Thanks & Regards, <br> Amit Salvi, <br> Project Co-ordinator <br> IGSTC';
                mail.setHtmlBody(emailBody);
                // string emailHtmlValue = emailTempRec.HtmlValue;
                // if(!string.isBlank(conList[0].FirstName)){
                //     emailHtmlValue = emailHtmlValue.replace('{!Contact.FirstName}', conList[0].FirstName);
                // }
                // if(conList[0].Proposals__r.Tentative_Start_Date__c != null){
                //     emailHtmlValue = emailHtmlValue.replace('{!Application_Proposal__c.Tentative_Start_Date__c}', string.valueOf(conList[0].Proposals__r.Tentative_Start_Date__c));
                // }
                // if(conList[0].Proposals__r.Duration_In_Months_Max_36__c != null){
                //     emailHtmlValue = emailHtmlValue.replace('{!Application_Proposal__c.Duration_In_Months_Max_36__c}', string.valueOf(conList[0].Proposals__r.Duration_In_Months_Max_36__c));
                // }
                // if(!string.isBlank(conList[0].Login_Hash_Code__c)){
                //     emailHtmlValue = emailHtmlValue.replace('{!Contact.Login_Hash_Code__c}', conList[0].Login_Hash_Code__c);
                // }
                // mail.setHtmlBody(emailHtmlValue);//Set HTML Body
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });//Set File Attachment
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                Application_Proposal__c app = New Application_Proposal__c();
                app.Id = conList[0].Proposals__c;
                app.Undertaking_Status__c = 'Sent';
                app.Endorsement_Letter_Status__c = 'Sent';
                appList.add(app);

                update appList;
            
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



    @AuraEnabled
    public static string SendAwardLetterSing(string propId, string attId){
        try{
            Application_Proposal__c applicationProposalRecord = [SELECT Id, RecordType.Name From Application_Proposal__c WHERE Id =: propId];
            List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            List<Contact> conList = [Select Email,FirstName,Name,Login_Hash_Code__c,Is_Primary__c,Proposals__c,Proposals__r.Title_Of__c,AccountName__c,Proposals__r.Duration_In_Months_Max_36__c,Proposals__r.Tentative_Start_Date__c From Contact where Proposals__c =: propId AND Is_Primary__c = true];
            List<Attachment> attList = [Select Id,name,Body,ContentType from attachment where Id = :attId]; 
            List<Application_Proposal__c> appList = New List<Application_Proposal__c>();
            List<EmailMessage> listOfEmailMesToInsert = New List<EmailMessage>();
            Emailtemplate emailTempRec =  [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Award Letter - SING'];
            Emailtemplate emailTempRecWorkshop =  [Select Id,HtmlValue,Subject from EmailTemplate where Name ='Award Letter - WORKSHOP'];
            
            if(applicationProposalRecord.RecordType.Name == 'SING'){
                if(!conList.isEmpty()){
                    for(Contact con : conList){
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
                            mail.setHtmlBody(emailHtmlValue);//Set HTML Body
                            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });//Set File Attachment
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                            EmailMessage emailMessageRecToBeInserted = New EmailMessage();
                            emailMessageRecToBeInserted.MessageDate = System.now();
                            emailMessageRecToBeInserted.Status = '3';
                            emailMessageRecToBeInserted.Subject = emailTempRec.Subject;
                            emailMessageRecToBeInserted.ToAddress = con.Email;
                            emailMessageRecToBeInserted.Contact__c = con.Id;
                            system.debug('emailMessageRecToBeInserted ==> '+emailMessageRecToBeInserted);
                            listOfEmailMesToInsert.add(emailMessageRecToBeInserted);
                                Application_Proposal__c app = New Application_Proposal__c();
                                app.Id = conList[0].Proposals__c;
                                app.Undertaking_Status__c = 'Sent';
                                appList.add(app);
                                update appList;
                        }
                        if(!listOfEmailMesToInsert.isEmpty()){
                            insert listOfEmailMesToInsert;
                        }
                }
            }else if(applicationProposalRecord.RecordType.Name == 'Workshop'){
                if(!conList.isEmpty()){
                    for(Contact con : conList){
                        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
                        attach.setContentType(attList[0].ContentType);
                        attach.setFileName(attList[0].Name);
                        attach.Body = attList[0].Body;
                        
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setToAddresses(new String[] { con.Email});//Set To Email Address
                        mail.setSubject(emailTempRecWorkshop.Subject);//Set Subject
                        string emailHtmlValue = emailTempRecWorkshop.HtmlValue;
                        if(!string.isBlank(conList[0].FirstName)){
                            emailHtmlValue = emailHtmlValue.replace('{!Contact.FirstName}', conList[0].FirstName);
                        }
                        if(!string.isBlank(conList[0].Login_Hash_Code__c)){
                            emailHtmlValue = emailHtmlValue.replace('{!Contact.Login_Hash_Code__c}', conList[0].Login_Hash_Code__c);
                        }
                        if(!string.isBlank(conList[0].Proposals__r.Title_Of__c)){
                            emailHtmlValue = emailHtmlValue.replace('{!Application_Proposal__c.Title_Of__c}', conList[0].Proposals__r.Title_Of__c);
                        }
                        mail.setHtmlBody(emailHtmlValue);//Set HTML Body
                        mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });//Set File Attachment
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

                        EmailMessage emailMessageRecToBeInserted = New EmailMessage();
                        emailMessageRecToBeInserted.MessageDate = System.now();
                        emailMessageRecToBeInserted.Status = '3';
                        emailMessageRecToBeInserted.Subject = emailTempRecWorkshop.Subject;
                        emailMessageRecToBeInserted.ToAddress = con.Email;
                        emailMessageRecToBeInserted.Contact__c = con.Id;
                        system.debug('emailMessageRecToBeInserted ==> '+emailMessageRecToBeInserted);
                        listOfEmailMesToInsert.add(emailMessageRecToBeInserted);

                            Application_Proposal__c app = New Application_Proposal__c();
                            app.Id = conList[0].Proposals__c;
                            app.Proposal_Stages__c = 'Under Grant';
                            appList.add(app);
                            update appList;
                    }
                    if(!listOfEmailMesToInsert.isEmpty()){
                        insert listOfEmailMesToInsert;
                    }
                } 
            }
            
            return 'SUCCESS';
            
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
            // system.debug(e.getMessage()+e.getLineNumber());
        } 
    }
    /********************* END ********************/
    
}