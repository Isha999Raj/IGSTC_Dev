public class TestDummy {
    /*public test(){
    }*/

    @RemoteAction
    public static List<Campaign> fetchCampaignsPrograms(){
        List<Campaign> campaignList = [SELECT Id,Name,Description FROM Campaign];
        if(!campaignList.isEmpty()){
            return campaignList; 
        }
        return Null;
    }

    @RemoteAction
    public static List<Campaign> fetchCampaignsPrograms2(){
        List<Campaign> campaignList = [SELECT Id,Name,Description FROM Campaign];
        if(!campaignList.isEmpty()){  
            return campaignList; 
        }
        return Null;
    }

    @RemoteAction
    public static void submitProject(Application_Proposal__c appProposal){
        system.debug('appProposal----'+appProposal);
        insert appProposal;
        system.debug('appProposal.Id---'+appProposal.Id);
    }
}