public with sharing class IFReleaseTrancheLetter {
    
    @InvocableMethod(label='IF Tranche Release' description='Send Tranche letter.' category='Application_Proposal__c')
    Public Static void ifTrancheLetter(List<String> proID){
        String proposalId = proID[0];
        Application_Proposal__c propData = [Select id , IF_tranche__c from Application_Proposal__c where id = :proposalId];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proposalId];
        system.debug('conList----'+conList);
        String TempUrl = '';
        TempUrl = propData.IF_tranche__c;
        system.debug('TempUrl---+'+TempUrl);
        generateCongaTemplate(TempUrl);
    }

    @future (callout=true)
    Public static void generateCongaTemplate(String var){
        String TemplateId = CongaHelperToolLightning.generateReport(var,null,null,null,null);
        system.debug('TemplateId'+TemplateId);
    }
}