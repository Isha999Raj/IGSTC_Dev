trigger TriggerOnEvalutionStep on Evaluation_Step__c (after update) {

    if(trigger.isAfter && trigger.isUpdate){
       // List<Application_Proposal__c> proposalList = new List<Application_Proposal__c>();
       // Set<Id> proposalIdSet = new Set<Id>();
        for(Evaluation_Step__c step : trigger.new){
           // proposalIdSet.add(step.Proposals__c);
           system.debug('step.Evaluation_Check__c :::'+step.Evaluation_Check__c);
           EvaluationController.checkEvlautionRecordDetails(step.Proposals__c, step.Evaluation_Check__c );
        }
       // proposalList = [SELECT Id,Name FROM Application_Proposal__c WHERE Id IN:proposalIdSet ];
        
    }
}