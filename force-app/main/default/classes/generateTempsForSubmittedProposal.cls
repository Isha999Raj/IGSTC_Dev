public class generateTempsForSubmittedProposal implements Database.Batchable <Sobject>,Database.AllowsCallouts{
    public Database.QueryLocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id,Name,Proposal_Stages__c FROM Application_Proposal__c WHERE Proposal_Stages__c = \'Submitted\' ';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Application_Proposal__c> proposalList){
        System.debug('Hello');
        for(Application_Proposal__c proposal : proposalList) {        
            try {
                CongaDocGeneration.generateCongaTemplatesForBatch(proposal.Id);    
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        
    }
}