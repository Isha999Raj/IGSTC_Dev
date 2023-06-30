trigger TriggerOnEvalutionStep on Evaluation_Step__c (after update) {
    
    if(trigger.isAfter && trigger.isUpdate){
        EvaluationController.UpdatEvelutionCriteriaBasedOnEvalutionSteps(trigger.newMap, trigger.oldMap);
    }
}