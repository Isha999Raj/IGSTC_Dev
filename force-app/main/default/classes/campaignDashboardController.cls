public with sharing class campaignDashboardController {
    public campaignDashboardController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Campaign> getAllCampaignsDetails(){
        try {
            List<Campaign> listofCampaigns = [SELECT Id,Name,StartDate,EndDate,(SELECT Id,Name,RecordType.Name,Proposal_Stages__c,Submitted__c,
            SC_Review_Stages__c,Review_Completed__c,Eligibility_Checked__c,Eligibility_Status__c,Evaluation_Criteria__c,Travel_Form_Status__c,
            Visa_Stages__c,Undertaking_Status__c FROM Proposals__r) FROM Campaign];
            return listofCampaigns;
        } catch(Exception e) {
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Campaign getselectedCampDetails(string campName){
        try{
            Campaign campRecord = [SELECT Id,Name,StartDate,EndDate,(SELECT Id,Name,RecordType.Name,Proposal_Stages__c,Submitted__c,
            SC_Review_Stages__c,Review_Completed__c,Eligibility_Checked__c,Eligibility_Status__c,Evaluation_Criteria__c,Travel_Form_Status__c,
            Visa_Stages__c,Undertaking_Status__c,Decision_Letter_Sent__c,Bank_Status__c,Invitation_Letter_Form_Status__c,Indian_Invoice_Status__c,
            German_Invoice_Status__c FROM Proposals__r) FROM Campaign WHERE Name =: campName];
            return campRecord;
        }catch (Exception e){
            return null;
        }
    }
}