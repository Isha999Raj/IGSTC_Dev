public with sharing class IFDecisionLetter {
    public IFDecisionLetter() {

    }

    @InvocableMethod(label='Decision letter if' description='Send decision letter.' category='Application_Proposal__c')
    Public Static void ifDecisionLetter(List<String> proID){
        String proposalId = proID[0];
        Application_Proposal__c propData = [Select id , IF_Decision_letter__c from Application_Proposal__c where id = :proposalId];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proposalId];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.IF_Decision_letter__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }

    @future (callout=true)
    Public static void generateCongaTemplate(String var,string recordIdVar){
        String TemplateId = CongaHelperToolLightning.generateReport(var,null,null,null,null);
        
        Application_Proposal__c appProposalRec = [SELECT Id,Name,Conga_URL__c,Document_generated__c,Pecfar_Conga_Url__c,IF_conga_Url__c,Wiser_Conga_Url__c,Sing_Conga_url__c,RecordTypeId,RecordType.Name  FROM Application_Proposal__c WHERE Id = :recordIdVar];
        appProposalRec.Document_generated__c=true;
        update appProposalRec;
        
        system.debug('TemplateId'+TemplateId);
    }
}