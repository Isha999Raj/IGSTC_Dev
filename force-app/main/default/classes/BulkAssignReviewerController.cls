global class BulkAssignReviewerController {
    
    
    @RemoteAction
    global static List<Campaign> getCampaign(){
        try{
            List<Campaign> CampaignList = [SELECT Id, Name FROM Campaign];
            return CampaignList;       
        }catch(Exception e){
            return null;
        }
    }
    
    
    @RemoteAction
    global static List<Application_Proposal__c> catchName(String campaignName){
        try{
            system.debug('ampaign Name:'+campaignName);
            List<Application_Proposal__c> app = [SELECT Id,Title_Of__c, Name FROM Application_Proposal__c WHERE Campaign__c =:campaignName AND Proposal_Stages__c=: 'Submitted' AND RecordType.DeveloperName != null];
            return app;
        }catch(Exception e){
            return null;
        }
        
    }
    
    
    @RemoteAction
    global static finalWrapper getProposalAndReviewer(string campaignNName){
        system.debug('campaignNName ==> '+campaignNName);
        List<Reviewer__c> reviewerList = [select Id ,Name From Reviewer__c];
        Set<Id> allReviewer = new Set<Id>(); 
        for(Reviewer__c IndiRev: reviewerList){
            allReviewer.add( IndiRev.Id);
        }
        system.debug('allReviewer ==> '+allReviewer);
        // List<Application_Proposal__c> applicationList = [select Id,Name,Title_Of__c,(select name from contacts__r),(Select id,Name,Proposals__c,isSelected__c,Reviewer__c from Reviewer_Mapping__r) From Application_Proposal__c WHERE Campaign__c=: campaignNName and Proposal_Stages__c in('Under Eligibility Check','Under Review')];
        List<Application_Proposal__c> applicationList = [select Id,Name,Title_Of__c,(select name from contacts__r),(Select id,Name,Proposals__c,isSelected__c,Reviewer__c from Reviewer_Mapping__r) From Application_Proposal__c WHERE Campaign__c=: campaignNName and Proposal_Stages__c IN ('Under Eligibility Check','Under Review')];
        system.debug('applicationList ==> '+applicationList);
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
        return finalWrapInstance;
    }
    @RemoteAction
    global static List<Reviewer__c> getCampaignReviewerData(){
        try{
            List<Reviewer__c> listReviewer=[select id,name,Birthdate__c,Email__c,Skills__c,campaign__r.name from Reviewer__c];

            return listReviewer;
        }catch(Exception e){
            system.debug('Error Message::=>'+e.getMessage());
            system.debug('Error Line No.::=>'+e.getLineNumber());
            return null;
        }
    }
    global class finalWrapper{
        public List<reviewerWrapper> allAppWithRM;
        public List<Reviewer__c> allReviewer;
    }
    global class reviewerWrapper{
        public Application_Proposal__c application;
        public List<Reviewer_Mapping__c> reviewerList;
        public reviewerWrapper(Application_Proposal__c application,List<Reviewer_Mapping__c> reviewerList){
            this.application = application;
            this.reviewerList = reviewerList;
        }
        
    }
    
    @RemoteAction
    global static String getReviewerAction(List<Reviewer_Mapping__c> listOfSelectedReviewerMappings,List<Reviewer_Mapping__c> RemoveReviewerMappings){
        try{
            system.debug('listOfSelectedReviewerMappings --->'+listOfSelectedReviewerMappings);
           
            if(!listOfSelectedReviewerMappings.isEmpty()){
                upsert listOfSelectedReviewerMappings;
            }
            if(!RemoveReviewerMappings.isEmpty()){
                delete RemoveReviewerMappings;
            } 
            return 'success';
        }catch(Exception e){
            return e.getMessage();
        }      
        
    }
}