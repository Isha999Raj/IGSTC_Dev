/**
 * @author [Dinesh B]
 * @email dinesh.b@utilitarianLab.com
 * @create date 2023-02-21 19:06:56
 * @modify date 2023-02-21 19:06:56
 * @desc [description]
 */

public class EvaluationController {
    
    // For Creating Reocords of Evalution 
    public Static void checkEvaluationCriteria(List<Application_Proposal__c> appList){
        List<Evaluation__mdt> Evalutiondata = new List<Evaluation__mdt>();
        Evalutiondata = [SELECT Id,label,Subject__c,Evaluation_Description__c,Progaram_Name__c,Progaram_Name__r.Label FROM Evaluation__mdt];
        List<Evaluation_Step__c> EvaList = new List <Evaluation_Step__c>();
        Set<Id> proposalIdSet = new Set<Id>();
        for(Application_Proposal__c ap : appList){
            proposalIdSet.add(ap.id);
        }
        for(Application_Proposal__c app : [SELECT Id,Name,RecordType.Name FROM Application_Proposal__c WHERe Id IN : proposalIdSet]){
            System.debug('app.RecordType.Name ::'+app.RecordType.Name);
            for(Evaluation__mdt emdt : Evalutiondata){
                if(app.RecordType.Name == 'PECFAR' && emdt.Progaram_Name__r.Label == 'PECFAR'){
                    Evaluation_Step__c eva = new Evaluation_Step__c();
                    eva.Proposals__c = app.id;
                    eva.Subject__c = emdt.Subject__c;
                    eva.Description__c = emdt.Evaluation_Description__c;
                    EvaList.add(eva);
                }
                if(app.RecordType.Name == 'WISER' && emdt.Progaram_Name__r.Label == 'WISER'){
                    Evaluation_Step__c eva = new Evaluation_Step__c();
                    eva.Proposals__c = app.id;
                    eva.Subject__c = emdt.Subject__c;
                    eva.Description__c = emdt.Evaluation_Description__c;
                    EvaList.add(eva);
                }
                if(app.RecordType.Name == 'SING' && emdt.Progaram_Name__r.Label == 'SING'){
                    Evaluation_Step__c eva = new Evaluation_Step__c();
                    eva.Proposals__c = app.id;
                    eva.Subject__c = emdt.Subject__c;
                    eva.Description__c = emdt.Evaluation_Description__c;
                    EvaList.add(eva);
                }
                if(app.RecordType.Name == 'Connect Plus' && emdt.Progaram_Name__r.Label == 'Connect Plus'){
                    Evaluation_Step__c eva = new Evaluation_Step__c();
                    eva.Proposals__c = app.id;
                    eva.Subject__c = emdt.Subject__c;
                    eva.Description__c = emdt.Evaluation_Description__c;
                    EvaList.add(eva);
                }
                if(app.RecordType.Name == 'Industrial Fellowship' && emdt.Progaram_Name__r.Label == 'Industrial Fellowship'){
                    Evaluation_Step__c eva = new Evaluation_Step__c();
                    eva.Proposals__c = app.id;
                    eva.Subject__c = emdt.Subject__c;
                    eva.Description__c = emdt.Evaluation_Description__c;
                    EvaList.add(eva);
                }
                if(app.RecordType.Name == 'Two Plus Two' && emdt.Progaram_Name__r.Label == 'Two Plus Two'){
                    Evaluation_Step__c eva = new Evaluation_Step__c();
                    eva.Proposals__c = app.id;
                    eva.Subject__c = emdt.Subject__c;
                    eva.Description__c = emdt.Evaluation_Description__c;
                    EvaList.add(eva);
                }
                if(app.RecordType.Name == 'Workshop' && emdt.Progaram_Name__r.Label == 'Workshop'){
                    Evaluation_Step__c eva = new Evaluation_Step__c();
                    eva.Proposals__c = app.id;
                    eva.Subject__c = emdt.Subject__c;
                    eva.Description__c = emdt.Evaluation_Description__c;
                    EvaList.add(eva);
                }
            }
        }
        if(!EvaList.isEmpty()){
            insert EvaList;
            System.debug('EvaList Inserted Record Size :: '+EvaList.size());
        }
    }
    
    
    // For Updating the Proposal Record
    public Static void checkEvlautionRecordDetails(String ProposalId, Boolean check){
        Application_Proposal__c prop = [SELECT Id,Name,Evaluation_Criteria__c,RecordType.Name FROM Application_Proposal__c WHERe Id =:ProposalId LIMIT 1];
        if(check == true){
            if(prop.RecordType.Name == 'Industrial Fellowship' || prop.RecordType.Name == 'PECFAR'){
                if(prop.Evaluation_Criteria__c !=null){
                    System.debug('Inside Not null Condition');
                    Decimal CurrentValue = prop.Evaluation_Criteria__c;
                    prop.Evaluation_Criteria__c = CurrentValue + 11.12;
                }else{
                    System.debug('Inside  null Condition');
                    prop.Evaluation_Criteria__c =  11.12;
                }
            }else{
                if(prop.Evaluation_Criteria__c !=null){
                    System.debug('Inside Not null Condition');
                    Decimal CurrentValue = prop.Evaluation_Criteria__c;
                    prop.Evaluation_Criteria__c = CurrentValue + 20;
                }else{
                    System.debug('Inside  null Condition');
                    prop.Evaluation_Criteria__c =  20;
                } 
            }
        }
        update prop;
        System.debug('prop ::'+prop);
    }
    
    // For Checking Criteria True  
    @AuraEnabled
    public Static Evaluation_Step__c updateCriteriaCheck(String recordId){
        Evaluation_Step__c evStep = [SELECT Id,Name,Proposals__c,Status__c,Evaluation_Check__c FROM Evaluation_Step__c WHERE Id =: recordId LIMIT 1];
        if(evStep.Evaluation_Check__c !=true){
            evStep.Evaluation_Check__c = true;
        }
        evStep.Status__c = 'Completed';
        update evStep;
        System.debug('evStep Update Record ::'+evStep);
        return evStep;
    }
}