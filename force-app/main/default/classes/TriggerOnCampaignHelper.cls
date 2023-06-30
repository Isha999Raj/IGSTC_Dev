public class TriggerOnCampaignHelper {
    
    public static void afterInsert(Map<Id,Campaign> campaignMap){
        createFolder(campaignMap.keySet());
    }
    
    @future(callout=true)
    public static void createFolder(Set<Id> campaignList){
        Map<Id,Campaign> campaignMap = new Map<Id,Campaign>([Select Id,Name From Campaign Where Id In : campaignList]);
       
        for(Campaign campRec : campaignMap.values()){
            String response = SharePointHandler.createFolderInsideSite('Campaigns/'+campRec.Name);
            if(response=='Success'){
                createSubFolders(campRec);
            }
        }
    }
    
    public static void createSubFolders(Campaign campaignRec){
        
        String propRecordTypeName= campaignRec.Name;
        if(propRecordTypeName == '2+2 Call'){
            propRecordTypeName = 'Two_Plus_Two';
        }
        
        List<Sharepoint_Master__c>        masterAndChildRecords              = [SELECT Name , (Select Name from SharePoint_Child_Configs__r) FROM Sharepoint_Master__c where Name = :propRecordTypeName and Is_campaign__c = true];
        List<SharePoint_Child_Config__c>  childAndSubChildRecords            = [SELECT Name , (Select Name from SharePoint_Subchild_Configs__r) FROM SharePoint_Child_Config__c where Master_Config_Name__c = :propRecordTypeName and Sharepoint_Master_Configuration__r.Is_campaign__c = true];
        List<SharePoint_Subchild_Configs__c>  SubchildAndInnerChildRecords   = [SELECT Name , (Select Name from SharePoint_innerChild_Configs__r) FROM SharePoint_Subchild_Configs__c where Master_Config_Name__c = :propRecordTypeName AND SharePoint_Child_Config__r.Sharepoint_Master_Configuration__r.Is_campaign__c = true];
        Map<String,List<String>> FoldersBySubFolder = new Map<String,List<String>>();
        Map<String,List<String>> childFoldersBySubFolder = new Map<String,List<String>>();
        
        List<String> folders = new List<String>();
        for(SharePoint_Child_Config__c childFolderRec : childAndSubChildRecords){
            folders.add(childFolderRec.Name);
            List<String> Subfolders = new List<String>();
            for(SharePoint_Subchild_Configs__c relatedRec : childFolderRec.SharePoint_Subchild_Configs__r){
                Subfolders.add(relatedRec.Name);
            }
            FoldersBySubFolder.put(childFolderRec.Name,Subfolders);
        }
        system.debug('FoldersBySubFolder'+FoldersBySubFolder);
        //Preparing the second map of Subfolder and childfodlers
        for(SharePoint_Subchild_Configs__c subChildFolderRec : SubchildAndInnerChildRecords){
            //folders.add(childFolderRec.Name);
            List<String> childFolders = new List<String>();
            for(SharePoint_innerChild_Config__c relatedRec : subChildFolderRec.SharePoint_innerChild_Configs__r){
                childFolders.add(relatedRec.Name);
            }
            childFoldersBySubFolder.put(subChildFolderRec.Name,childFolders);
        }
        system.debug('childFoldersBySubFolder'+childFoldersBySubFolder);
        
        system.debug('childFoldersBySubFolder'+childFoldersBySubFolder);
        for(String folderRec : folders){
            String response = SharePointHandler.createFolderInsideSite('Campaigns'+'/'+campaignRec.Name+'/'+folderRec);
            if(FoldersBySubFolder.get(folderRec)!=null && !FoldersBySubFolder.get(folderRec).isEmpty()){
                for(String subFolder : FoldersBySubFolder.get(folderRec)){
                    SharePointHandler.createFolderInsideSite('Campaigns'+'/'+campaignRec.Name+'/'+folderRec+'/'+subFolder);
                    if(childFoldersBySubFolder.containsKey(subFolder)) {
                        system.debug('Child folders are exisiting'+childFoldersBySubFolder.containsKey(subFolder));
                        for(String StrRec : childFoldersBySubFolder.get(subFolder)){
                            SharePointHandler.createFolderInsideSite('Campaigns'+'/'+campaignRec.Name+'/'+folderRec+'/'+subFolder+'/'+StrRec);
                        }
                    }
                }
            }
        }
    }
}