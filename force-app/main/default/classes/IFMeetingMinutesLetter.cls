public with sharing class IFMeetingMinutesLetter {

    @InvocableMethod(label='IF Minutes Letter' description='Send MinutesIF letter.' category='Application_Proposal__c')
    Public Static void ifMinutesRevisedLetter(List<String> proID){
        String proposalId = proID[0];
        system.debug('proposalId ---->'+proposalId);
        DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(proposalId,'IF minutes revised');
    }
}