public with sharing class PECFARMeetingMinutesLetter {
    
    @InvocableMethod(label='PECFAR Minutes Letter' description='Send MinutesPECFAR letter.' category='Application_Proposal__c')
    Public Static void pecfarMinutesRevisedLetter(List<String> proID){
        String proposalId = proID[0];
        system.debug('proposalId ---->'+proposalId);
        DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(proposalId,'Pecfar minutes of meetings');
    }

}