public with sharing class PECFARDecisionLetter {

    @InvocableMethod(label='Pecfar Decision Letter' description='Send Decision letter.' category='Application_Proposal__c')
    Public Static void pecfarDecisionLetter(List<String> proID){
        String proposalId = proID[0];
        Application_Proposal__c propData = [Select id , Pecfar_Decision_letter__c from Application_Proposal__c where id = :proposalId];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proposalId];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.Pecfar_Decision_letter__c;
        system.debug('TempUrl---+'+TempUrl);
        CongaDocGeneration.generateCongaTemplate(TempUrl);
    }

    @future (callout=true)
    Public static void generateCongaTemplate(String var){
        String TemplateId = CongaHelperToolLightning.generateReport(var,null,null,null,null);
        system.debug('TemplateId'+TemplateId);
    }
}