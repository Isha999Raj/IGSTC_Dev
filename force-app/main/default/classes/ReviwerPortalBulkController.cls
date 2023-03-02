public class ReviwerPortalBulkController {
    
    
 @AuraEnabled(cacheable=true)
    public static List<Campaign> getCampaign(){
        try{
            List<Campaign> CampaignList = [SELECT Id, Name FROM Campaign];
            return CampaignList;       
        }catch(Exception e){
            return null;
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Application_Proposal__c> catchName(String campaignName){
        try{
            system.debug('ampaign Name:'+campaignName);
            List<Application_Proposal__c> app = [SELECT Id,Title_Of__c, Name FROM Application_Proposal__c WHERE Campaign__c =:campaignName AND Proposal_Stages__c=: 'Submitted' AND RecordType.DeveloperName != null];
            return app;
        }catch(Exception e){
            return null;
        }
        
    }
    
    
    @AuraEnabled(cacheable=true)
    public static finalWrapper getProposalAndReviewer(string campaignNName){
        List<Reviewer__c> reviewerList = [select Id ,Name From Reviewer__c WHERE Campaign__c=: campaignNName];
        Set<Id> allReviewer = new Set<Id>(); 
        for(Reviewer__c IndiRev: reviewerList){
            allReviewer.add( IndiRev.Id);
        }
        List<Application_Proposal__c> applicationList = [select Id,Name,(Select id,Name,Proposals__c,isSelected__c,Reviewer__c from Reviewer_Mapping__r) From Application_Proposal__c WHERE Campaign__c=: campaignNName];
        List<reviewerWrapper> reviewerWrapperList = new List<reviewerWrapper>(); 
        for(Application_Proposal__c app :applicationList){
            List<Reviewer_Mapping__c> reviewerMappingListToBeInserted = new List<Reviewer_Mapping__c>();
            if(app.Reviewer_Mapping__r.size()==0){
                for(Reviewer__c Individualreviewer : reviewerList){
                    Reviewer_Mapping__c reviewerMapRecord = new Reviewer_Mapping__c();
                
                    reviewerMapRecord.Proposals__c =app.Id;
                    reviewerMapRecord.Reviewer__c = Individualreviewer.Id;
                    reviewerMapRecord.isSelected__c = false;   
                    reviewerMappingListToBeInserted.add(reviewerMapRecord);
                }
                
            }else{
               // Handle Stored Data
                for(Reviewer_Mapping__c RmRec : app.Reviewer_Mapping__r) {
                    // Also Find Out - Who Are pending Reviewers
                    allReviewer.remove(RmRec.Reviewer__c);
                    
                    reviewerMappingListToBeInserted.add(RmRec);
                }
                // Handle Dummy data
                for(Id leftOutreviewerId : allReviewer){
                    Reviewer_Mapping__c reviewerMapRecord = new Reviewer_Mapping__c();
                
                    reviewerMapRecord.Proposals__c =app.Id;
                    reviewerMapRecord.Reviewer__c = leftOutreviewerId;
                    reviewerMapRecord.isSelected__c = false;   
                    reviewerMappingListToBeInserted.add(reviewerMapRecord);
                }
                // 
            }
           	reviewerWrapper wrapInstance = new reviewerWrapper(app,reviewerMappingListToBeInserted);
            reviewerWrapperList.add(wrapInstance);
        }
        finalWrapper finalWrapInstance = new finalWrapper();
        finalWrapInstance.allAppWithRM = reviewerWrapperList;
        finalWrapInstance.allReviewer = reviewerList;
        System.debug('instannce'+finalWrapInstance );
        return finalWrapInstance;
    }

    public class finalWrapper{
        public List<reviewerWrapper> allAppWithRM;
        public List<Reviewer__c> allReviewer;
    }
    public class reviewerWrapper{
        public Application_Proposal__c application;
        public List<Reviewer_Mapping__c> reviewerList;
        public reviewerWrapper(Application_Proposal__c application,List<Reviewer_Mapping__c> reviewerList){
            this.application = application;
            this.reviewerList = reviewerList;
        }
        
    }
    
    @AuraEnabled
    public static String getReviewerAction(List<Reviewer_Mapping__c> listOfSelectedReviewerMappings){
        try{
            system.debug('listOfSelectedReviewerMappings --->'+listOfSelectedReviewerMappings);
           
            if(listOfSelectedReviewerMappings.isEmpty()){
                return 'Error';
            }else{
                upsert listOfSelectedReviewerMappings;
                return 'success 123';    
            } 
        }catch(Exception e){
            return e.getMessage();
        }      
        
    }
}