public class ProposalTriggerHandler {
    static ProposalTriggerHandler proposalInstance;
    
    public static ProposalTriggerHandler getInstance(){
        if(proposalInstance==null)
            proposalInstance = new ProposalTriggerHandler();
        return proposalInstance;    
    }
    
    public void afterInsert(Map<Id,Application_Proposal__c> proposalMap){
        SharePointCallout.createFolder(proposalMap.keySet());
    }
    
    public static void beforeDelete(List<Application_Proposal__c> newPropList){
        system.debug('newPropList'+newPropList);
        for(Application_Proposal__c appProp : newPropList){
            if(appProp.Id == 'a081y000002xuye' || appProp.Id == 'a081y000002xpMl' ||appProp.Id == 'a081y000002xv1N' || appProp.Id == 'a081y000002xmqYAAQ' || appProp.Id == 'a081y000002xnZ7AAI'){
                appProp.addError('These records are being used for testing and cannot be deleted.');
            }
        }
    }
    
    public void createMasterExpenseRecord(List<Application_Proposal__c> proposalList,Map<Id,Application_Proposal__c> oldProposalMap){
        Set<String> proposalIdSet = new Set<String>();
        Map<String,String> mapofAccidByPropId = New Map<String,String>();
        List<Expense_Master__c> emListTobeInsert = New List<Expense_Master__c>();
        for(Application_Proposal__c ap : proposalList){
            if(ap.Stage__c != null && ap.Stage__c != oldProposalMap.get(ap.Id).Stage__c && ap.Stage__c == '2nd Stage'){
                proposalIdSet.add(ap.Id);
            }
        }
        
        if(!proposalIdSet.isEmpty()){
            List<Account> accList = [select id,proposals__c from account where proposals__c in: proposalIdSet];
            for(Account acc : accList){
                mapofAccidByPropId.put(acc.Id,acc.proposals__c);
            }
            for(Account acc : accList){
                Expense_Master__c em = new Expense_Master__c();
                em.Account__c = acc.id;
                em.Proposals__c = mapofAccidByPropId.get(acc.id);
                emListTobeInsert.add(em);
            }
            if(!emListTobeInsert.isEmpty()){
                insert emListTobeInsert;
            }
        }
    }
}