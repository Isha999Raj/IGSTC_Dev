trigger TriggerOnProposal on Application_Proposal__c (after insert,after update, before update,before delete) {
    ProposalTriggerHandler proposalInstance = ProposalTriggerHandler.getInstance();
    
    if(Trigger.isInsert && Trigger.isAfter){
        proposalInstance.afterInsert(Trigger.newMap);
        EvaluationController.checkEvaluationCriteria(trigger.new);
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        proposalInstance.createMasterExpenseRecord(Trigger.new,Trigger.oldMap);
        proposalInstance.createDisbursmentFRecord(Trigger.newMap,Trigger.oldMap);
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        //   EvaluationController.checkEvlautionRecordDetails(trigger.new);
    }
    
    if(trigger.isBefore && trigger.isDelete){
        ProposalTriggerHandler.beforeDelete(trigger.old);
    }
}