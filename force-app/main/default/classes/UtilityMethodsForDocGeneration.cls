public class UtilityMethodsForDocGeneration {
    
    //This method will be used to generate Template dynamically for Applicatio Portal
    Public Static void generateTempForAppPortal(String proID , String CampaignType ){
        
        Application_Proposal__c propData = [Select id , IF_conga_Url__c , Pecfar_Conga_Url__c ,  Wiser_Conga_Url__c , Conga_URL__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        String TempUrl = '';
        if(CampaignType == 'IF'){
            TempUrl = propData.IF_conga_Url__c;
        }else if(CampaignType == 'PECFAR'){
            TempUrl = propData.Pecfar_Conga_Url__c;
        }else if(CampaignType == 'WISER'){
            TempUrl = propData.Wiser_Conga_Url__c;
        }
        
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
    
    
    //ADDED to call from Flow
    @InvocableMethod(label='Get Template Id' description='Get template Id to send an Attachment' category='Application_Proposal__c')
    Public Static void generateTempForAwardDraftInsideFlow(List<Id> proID){
        
        List<Application_Proposal__c> propData = [Select id , IF_Award_Draft_PEIF__c , IF_Award_Draft__c from Application_Proposal__c where id IN: proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c IN: proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        system.debug('TempUrl---+'+TempUrl);
        
        if(!conList.isEmpty()){
            for(contact cn : conList){
                if(cn.Industrial_Fellowship_Type__c =='PIEF'){
                    system.debug('Inside PIEF');
                    TempUrl = propData[0].IF_Award_Draft_PEIF__c;
                    system.debug('TempUrl---+'+TempUrl);
                }else{
                    TempUrl = propData[0].IF_Award_Draft__c;
                    system.debug('TempUrl---+'+TempUrl);
                }
            }
        }
        string result = generateCongaTemplate(TempUrl);
        system.debug('result -- ' + result);
        propData[0].Attachment_Id__c = result;
        update propData;
    }
    
    
    //This method will be used to generate Template dynamically for Award Draft for IF Campaign
    @AuraEnabled
    Public Static String generateTempForAwardDraft(String proID){
        
        Application_Proposal__c propData = [Select id , IF_Award_Draft_PEIF__c , IF_Award_Draft__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        system.debug('TempUrl---+'+TempUrl);
        
        if(!conList.isEmpty()){
            for(contact cn : conList){
                if(cn.Industrial_Fellowship_Type__c =='PIEF'){
                    system.debug('Inside PIEF');
                    TempUrl = propData.IF_Award_Draft_PEIF__c;
                    system.debug('TempUrl---+'+TempUrl);
                }else{
                    TempUrl = propData.IF_Award_Draft__c;
                    system.debug('TempUrl---+'+TempUrl);
                }
            }
        }
        //CongaDocGeneration.generateCongaTemplate(TempUrl);
        String url = generateCongaTemplate(TempUrl);
        return url;
    }
    
    /********************* Done by Anjali Singh ********************/
    Public static String generateCongaTemplate(String var){
        String TemplateId = CongaHelperToolLightning.generateReport(var,null,null,null,null);
        system.debug('TemplateId'+TemplateId);
        return TemplateId;
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
    
    /********************* END ********************/
    
    
    
    //This method will be used to generate Template dynamically Decisiopn letter IF Campaign
    //@InvocableMethod(label='Decision letter if' description='Send decision letter.' category='Application_Proposal__c')
    Public Static void ifDecisionLetter(String proID){
        Application_Proposal__c propData = [Select id , IF_Decision_letter__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.IF_Decision_letter__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
    
    //This method will be used to generate Template dynamically if MInutes revised letter IF Campaign
    Public Static void ifMinutesRevisedLetter(String proID){
        Application_Proposal__c propData = [Select id , IF_minutes_revised__c from Application_Proposal__c where id = :proID];
        List<Contact> ConlistValue =  [Select id ,  name ,Host_Value_Name__c, Account_Host_Name__c from contact ];
        for(Contact con : ConlistValue){
            system.debug('Account host Name'+con.Account_Host_Name__c);
            if(con.Account_Host_Name__c != null){
                con.Host_Value_Name__c = con.Account_Host_Name__c;
            }
        }
        update ConlistValue;
        
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.IF_minutes_revised__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
    //This method will be used to generate Template dynamically if Tranche` letter IF Campaign
    Public Static void ifTrancheLetter(String proID){
        Application_Proposal__c propData = [Select id , IF_tranche__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.IF_tranche__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
    
    //STARTING METHODS FOR PECFAR DOCS
    
    //This method will be used to generate Template dynamically PECFAR MINUTES MEETING PECFAR Campaign
    Public Static void pecfarMimutesMeeting(String proID){
        Application_Proposal__c propData = [Select id , Pecfar_minutes_of_meetings__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.Pecfar_minutes_of_meetings__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
    
    //This method will be used to generate Template dynamically PECFAR DeCISION PECFAR Campaign
    Public Static void pecfarDecisionLetter(String proID){
        Application_Proposal__c propData = [Select id , Pecfar_Decision_letter__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.Pecfar_Decision_letter__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
    
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
                pecfarAwardlessthenTwo(conRec.Proposals__c);
            }else{
                System.debug('pecfarAwardlForTwo Called');
                pecfarAwardlForTwo(conRec.Proposals__c);
            }
            return 'success';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    //This method will be used to generate Template dynamically PECFAR AWARD LESS THEN TWO PECFAR Campaign
    Public Static void pecfarAwardlessthenTwo(String proID){
        Application_Proposal__c propData = [Select id , Pecfar_Award_less_then_two__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.Pecfar_Award_less_then_two__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
    
    //This method will be used to generate Template dynamically PECFAR AWARD FOR TWO MONTHS PECFAR Campaign
    Public Static void pecfarAwardlForTwo(String proID){
        Application_Proposal__c propData = [Select id , Pecfar_Award_two__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.Pecfar_Award_two__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
    
    // WISER CONGS DOCS METHOD  FOR GENERATION
    
    //This method will be used to generate Template dynamically WISER DRAFT AWARD LETTER  WISER Campaign
    Public Static void WiserDraftLtter(String proID){
        Application_Proposal__c propData = [Select id , Wiser_Draft_Letter__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.Wiser_Draft_Letter__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
    
    //This method will be used to generate Template dynamically WISER MINUTES MEETING  WISER Campaign
    Public Static void WiserMinutesMeeting(String proID){
        Application_Proposal__c propData = [Select id , wiser_minutes_meeting__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.wiser_minutes_meeting__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
    
    //This method will be used to generate Template dynamically WISER CO CHAIR LETTER  WISER Campaign
    Public Static void WiserCoChair(String proID){
        Application_Proposal__c propData = [Select id , Wiser_Co_chair__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.Wiser_Co_chair__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
    
    
    //==============================WORKSHOP==============================================
    
    //This method will be used to generate Template dynamically  Campaign
    Public Static void WorkShopBudgetNote(String proID){
        Application_Proposal__c propData = [Select id , Workshop_Budget_Note__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.Workshop_Budget_Note__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
    
    //This method will be used to generate Template dynamically  Campaign
    Public Static void WorkShopAppCoChair(String proID){
        Application_Proposal__c propData = [Select id , Workshop_app_co_chair__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.Workshop_app_co_chair__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
    
    //This method will be used to generate Template dynamically  Campaign
    Public Static void WorkShopGermanSanction(String proID){
        Application_Proposal__c propData = [Select id , workshop_german_sanction__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.workshop_german_sanction__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }   
    
    //This method will be used to generate Template dynamically  Campaign
    Public Static void WorkShopIndianSanction(String proID){
        Application_Proposal__c propData = [Select id , workshop_indian_sanction__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.workshop_indian_sanction__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    } 
    
    //This method will be used to generate Template dynamically WORKSHOP APPLICATION PORTAL  Campaign
    Public Static void WorkShopApplicationPortal(String proID){
        Application_Proposal__c propData = [Select id , WORKSHOP_APPLICATION_PORTAL__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.WORKSHOP_APPLICATION_PORTAL__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    } 
    
    //=================================================START CONNECT PLUS=========================
    //This method will be used to generate Template dynamically OF CONNECT PLUS SANCTION ORDER  Campaign
    Public Static void ConnectPlusSanctionOrder(String proID){
        Application_Proposal__c propData = [Select id ,Connect_Plus_Sanction_Order__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.Connect_Plus_Sanction_Order__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    } 
    
    // THiS METHOD ID USED TO GENERATE REVIWER PORTAL DOC  
    Public Static void ReviwerPortalDocsGenerate(String proID){
        Application_Proposal__c propData = [Select id ,Reviwer_portal_Conga__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.Reviwer_portal_Conga__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    } 
    
    //=============================================================2+2 CAMPGIAN START FROM HERE==================================
    // THiS METHOD ID USED TO GENERATE   
    Public Static void TwoPlusTwoAwardLetter(String proID){
        Application_Proposal__c propData = [Select id ,Two_plus_two_award_letter__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.Two_plus_two_award_letter__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    } 
    
    // THiS METHOD ID USED TO  
    Public Static void TwoPlusTwoDueDiligence(String proID){
        Expense_Head_Report__c propData = [Select id ,Two_plus_two_draft_due_diligence__c from Expense_Head_Report__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.Two_plus_two_draft_due_diligence__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    } 
    
    // THiS METHOD ID USED TO  
    Public Static void TwoPlusTwoDraftNoteCoChairApproval(String proID){
        Application_Proposal__c propData = [Select id ,TWO_Plus_Two_Draft_note_Co_Chair_Approva__c from Application_Proposal__c where id = :proID];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proID];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.TWO_Plus_Two_Draft_note_Co_Chair_Approva__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }
}