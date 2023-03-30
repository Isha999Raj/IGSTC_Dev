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
    
    public void createDisbursmentFRecord(Map<Id, Application_Proposal__c> newProposalMap,Map<Id,Application_Proposal__c> oldProposalMap){
        Set<id> proposalId = New Set<Id>();
        List<Disbursement_Schedule__c> disbursementList = New List<Disbursement_Schedule__c>();
        
        for(Application_Proposal__c proposalRec : newProposalMap.values()){
            system.debug('proposalRec--->'+proposalRec.RecordType_Name__c);
            system.debug('proposalRec.Proposal_Stages__c ::'+proposalRec.Proposal_Stages__c);
            system.debug('RecordType ::'+proposalRec.RecordType_Name__c);
            if(proposalRec.Proposal_Stages__c != null && proposalRec.Proposal_Stages__c != oldProposalMap.get(proposalRec.Id).Proposal_Stages__c && proposalRec.Proposal_Stages__c == 'Under Decision'){
                if(proposalRec.RecordType_Name__c == 'Industrial Fellowship'){
                    proposalId.add(proposalRec.Id);
                }
            }
        }
        system.debug('proposalId ::'+proposalId);
        List<Contact> contactList = [SELECT Id,Name,Proposals__c,Industrial_Fellowship_Type__c,Proposals__r.Tentative_End_Date__c,Proposals__r.Tentative_Start_Date__c,Proposals__r.RecordType_Name__c FROM Contact WHERE Proposals__c In : proposalId Limit 1];
        system.debug('contactList ::'+contactList);
        if(!contactList.isEMpty()){
            Long Difference = contactList[0].Proposals__r.Tentative_Start_Date__c.monthsBetween(contactList[0].Proposals__r.Tentative_End_Date__c);
            system.debug('Difference ::'+Difference);
            if(contactList[0].Industrial_Fellowship_Type__c == 'PDIF' && contactList[0].Proposals__r.RecordType_Name__c == 'Industrial Fellowship'){
                List<Grant_Portal_Docs__c> getCurrencyForPDIF = [Select Id,Name,Amount__c,Campaign__c,Campaign_Type__c From Grant_Portal_Docs__c WHERE Campaign__c = 'IF' AND Campaign_Type__c = 'PDIF'];
                for(Integer i=0;i<Difference;i++){
                    Disbursement_Schedule__c disbursementRecord = New Disbursement_Schedule__c();
                    disbursementRecord.Proposals__c = contactList[0].Proposals__c;
                    disbursementRecord.Tranche__c = string.valueOf( i + 1 );
                    disbursementRecord.Start_Date__c = contactList[0].Proposals__r.Tentative_Start_Date__c.addMonths(i);
                    disbursementRecord.End_Date__c = contactList[0].Proposals__r.Tentative_Start_Date__c.addMonths(i + 1);
                    if(disbursementRecord.Start_Date__c.day() < 15 && i == 0){
                      disbursementRecord.Amount__c = getCurrencyForPDIF[0].Amount__c * 2;  
                    }else{
                      disbursementRecord.Amount__c = getCurrencyForPDIF[0].Amount__c;  
                    }
                    disbursementRecord.Release_Grant_Amount__c = disbursementRecord.Amount__c;
                    disbursementList.add(disbursementRecord);
                }
            } else{
                List<Grant_Portal_Docs__c> getCurrencyForPIEF = [Select Id,Name,Amount__c,Campaign__c,Campaign_Type__c From Grant_Portal_Docs__c WHERE Campaign__c = 'IF' AND Campaign_Type__c = 'PIEF'];
                for(Integer i=0;i<Difference;i++){
                    Disbursement_Schedule__c disbursementRecord = New Disbursement_Schedule__c();
                    disbursementRecord.Proposals__c = contactList[0].Proposals__c;
                    disbursementRecord.Tranche__c = string.valueOf( i + 1 );
                    disbursementRecord.Start_Date__c = contactList[0].Proposals__r.Tentative_Start_Date__c.addMonths(i);
                    disbursementRecord.End_Date__c = contactList[0].Proposals__r.Tentative_Start_Date__c.addMonths(i + 1);
                    disbursementRecord.Amount__c = getCurrencyForPIEF[0].Amount__c;
                    disbursementRecord.Release_Grant_Amount__c = disbursementRecord.Amount__c;
                    disbursementList.add(disbursementRecord);
                }
            }
            
            if(!disbursementList.isEmpty()){
                    insert disbursementList;
                }
        }
        
    }
}