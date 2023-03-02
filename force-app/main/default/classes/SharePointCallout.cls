public with sharing class SharePointCallout {
    @future(callout=true)
    public static void createFolder(Set<Id> proposalList){
        Map<Id,Application_Proposal__c> pMap = new Map<Id,Application_Proposal__c>([Select Id,Name,RecordType.DeveloperName,(Select Id,Name From Proposal_Documents__r) From Application_Proposal__c Where Id In : proposalList]);


        for(Application_Proposal__c pro : pMap.values()){
            String response = SharePointHandler.createFolderInsideSite('Proposals/'+pro.Name);
            if(response=='Success'){
                createSubFolders(pro);
                /*for(Proposal_Document__c pd: pro.Proposal_Documents__r){
                    SharePointHandler.createFolderInsideSite('Proposals/'+pro.Name+'/'+pd.Name);
                }*/
            }
        }
    }



    public static void createSubFolders(Application_Proposal__c pro){
        Map<String, Proposal_SharePoint_Config__mdt> mcs = Proposal_SharePoint_Config__mdt.getAll();

        Proposal_SharePoint_Config__mdt ifMdt = mcs.get(pro.RecordType.DeveloperName);
        String folder = ifMdt.Folders__c;
        List<String> folders = folder.split(';');


        for(String f : folders){
            String mainFolder;
            List<String> subFoldersList;
            if(f.Contains('=>')){
                mainFolder = f.split('=>')[0];
                String subFolders = f.split('=>')[1];
                subFoldersList = subFolders.split(',');
                System.debug('SubFolders-----'+subFoldersList);
            }else{
                mainFolder = f;
            }

            String response = SharePointHandler.createFolderInsideSite('Proposals/'+pro.Name+'/'+mainFolder);
            if(subFoldersList!=null && !subFoldersList.isEmpty()){
                for(String subFolder : subFoldersList){
                    SharePointHandler.createFolderInsideSite('Proposals/'+pro.Name+'/'+mainFolder+'/'+subFolder);
                }
            }
        }

    }
    
      public static void createCustomFolder(String recordId, Integer fNumbers,List<String> expensesList, List<String> recDocs){
        Application_Proposal__c pro = [Select Id,Name From Application_Proposal__c Where Id=:recordId];
        for(Integer i = 1; i<=fNumbers; i++){
            String fName = i+'';
            
            if(i==1){
                fName += ' st';
            }else if(i==2){
                fName += ' nd';
            }else if(i==3){
                fName += ' rd';
            }else if(i==4 || i== 5 || i==6 || i==7 || i==8 || i==9){
                fName += ' th';
            }
            
            fName += ' '+expensesList[i-1];
            cFolder('Proposals/'+pro.Name+'/'+fName);
        }
          
          for(String fName : recDocs){
           	   cFolder('Proposals/'+pro.Name+'/'+fName);
          }
    }
    
    @future(callout=true)
    public static void cFolder(String folderName){
        SharePointHandler.createFolderInsideSite(folderName);
    }
}