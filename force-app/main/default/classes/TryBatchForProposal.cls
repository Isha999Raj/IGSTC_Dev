public class TryBatchForProposal implements Database.Batchable <Sobject>{
    public Database.QueryLocator Start(Database.BatchableContext bc){
        String query = 'SELECT Id,Name,Proposal_Stages__c FROM Application_Proposal__c WHERE Proposal_Stages__c = \'Submitted\' ';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Application_Proposal__c> proposalList){
        System.debug('Hello');
        for(Application_Proposal__c proposal : proposalList) {        
            try {
                System.debug(proposal);
                
              CongaDocGeneration.generateIFTemplateFromProposal(proposal.Id);    
            } catch(Exception e) {
                System.debug(e);
            }
        }
    }
    
    public void finish(Database.BatchableContext bc) {
        // execute any post-processing operations like sending email
        
        
    }
}