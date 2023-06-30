public with sharing class UtilityToUploadExcelAndUpdateController {
    public UtilityToUploadExcelAndUpdateController() {

    }

    @AuraEnabled
    Public Static string updateSCStage(List<Application_Proposal__c> myArray){
        try {
            system.debug('myArray ==> '+myArray);
            update myArray;
            return 'SUCCESS'; 
        } catch(Exception e) {
        return  'Error--'+e.getMessage()+'Error In Line='+e.getLineNumber();
        }
        
       
 
    }

    @AuraEnabled(cacheable=true)
    public static List<Application_Proposal__c> getAllProposals(){
        try {
            List<Application_Proposal__c> listOfProposals = [SELECT Id, Name FROM Application_Proposal__c];
            return listOfProposals;
        } catch (Exception e) {
            return null;
        }
    }
}