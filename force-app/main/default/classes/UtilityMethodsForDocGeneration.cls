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
        return generateCongaTemplate(TempUrl);
    }
    
    /********************* Done by Anjali Singh ********************/
    Public static String generateCongaTemplate(String var){
        String TemplateId = CongaHelperToolLightning.generateReport(var,null,null,null,null);
        system.debug('TemplateId'+TemplateId);
        return TemplateId;
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
    
}