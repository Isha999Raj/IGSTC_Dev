//THIS Conga Class will be used by the aura component:IFDocGenerationCmp;

public class CongaDocGeneration {
    
    Public static list<RecordType> getAlRecodtpe(){
        map<String,String> redtypeidbyname = new map<String,String>();
        system.debug('redtypeidbyname====>'+redtypeidbyname);
        list<RecordType> Recid= new  list<RecordType>();
        Recid =[SELECT Id,Name from RecordType WHERE SobjectType='Application_Proposal__c'];
        for (RecordType rc :Recid){
            redtypeidbyname.put(rc.Id, rc.Name);
        }
        system.debug('Recid=====>'+Recid);
        return Recid;
    }
    
    @AuraEnabled
    Public Static void generateTemplateFromProposal(String recordId){
        System.debug('recordId'+recordId);
        string var = [SELECT Id,Name,Conga_URL__c FROM Application_Proposal__c WHERE Id = :recordId][0].Conga_URL__c;
        system.debug('var----'+var);
        generateCongaTemplate(var);
        
        //return TemplateId;
    }
    
    @AuraEnabled
    Public Static void generateIFTemplateFromProposal(String recordId){
        System.debug('recordId'+recordId);
        String CongaQuery = '';
        String exCategoriesCustomLable  = Label.docCategoriesToBeExcluded;

        List<String> docCategoriesToBeExcluded =  exCategoriesCustomLable.split(',');
        SYSTEM.debug('docCategoriesToBeExcluded---'+docCategoriesToBeExcluded);
        
        
        Application_Proposal__c appProposalRec = [SELECT Id,Name,Conga_URL__c,Pecfar_Conga_Url__c,IF_conga_Url__c,Wiser_Conga_Url__c,Sing_Conga_url__c,RecordTypeId,RecordType.Name  FROM Application_Proposal__c WHERE Id = :recordId];
        system.debug('recordtypeId'+appProposalRec.RecordTypeId);
        
        List<String> UserDocumentIds = new List<String>();
        
        List<User_Document__c> UserDocList = [Select Id,Name from User_Document__c where Proposal_Id__c = :recordId AND Name NOT IN :docCategoriesToBeExcluded];
       
        for(User_Document__c ud : UserDocList){
            UserDocumentIds.add(ud.Id);
        }
        system.debug('UserDocumentIds'+UserDocumentIds);
        
        if(appProposalRec.RecordType.Name == 'Industrial Fellowship'){
            String attIds = '';
            for(Attachment uds : [Select id , name from Attachment where parentId In : UserDocumentIds]){
                attIds = attIds + uds.id  + ',';
            }
            attIds = attIds.removeEnd(',');
            system.debug('Attachment Ids Are ' + attIds); 
            CongaQuery = appProposalRec.IF_conga_Url__c;
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('IF CONGA'+CongaQuery);
        }else if(appProposalRec.RecordType.Name == 'PECFAR'){
            String attIds = '';
            for(Attachment uds : [Select id , name from Attachment where parentId In : UserDocumentIds]){
                attIds = attIds + uds.id  + ',';
            }
            attIds = attIds.removeEnd(',');
            system.debug('Attachment Ids Are ' + attIds); 
            CongaQuery = appProposalRec.Pecfar_Conga_Url__c;
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('PECFAR CONGA'+CongaQuery);
            
        }else if(appProposalRec.RecordType.Name == 'WISER'){
            String attIds = '';
            for(Attachment uds : [Select id , name from Attachment where parentId In : UserDocumentIds]){
                attIds = attIds + uds.id  + ',';
            }
            attIds = attIds.removeEnd(',');
            system.debug('Attachment Ids Are ' + attIds); 
            CongaQuery = appProposalRec.Wiser_Conga_Url__c	;
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('Wiser_Conga_Url__c CONGA'+CongaQuery);
        }else if(appProposalRec.RecordType.Name == 'SING'){
            String attIds = '';
            for(Attachment uds : [Select id , name from Attachment where parentId In : UserDocumentIds]){
                attIds = attIds + uds.id  + ',';
            }
            attIds = attIds.removeEnd(',');
            system.debug('Attachment Ids Are ' + attIds); 
            CongaQuery = appProposalRec.Sing_Conga_url__c;
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('SING CONGA'+CongaQuery);
        }
        
        system.debug('CongaQuery'+CongaQuery);
        generateCongaTemplate(CongaQuery);
    }
    
    //This is asynchronous method which will be used to generate template for the proided URL.
    @future (callout=true)
    Public static void generateCongaTemplate(String var){
        String TemplateId = CongaHelperToolLightning.generateReport(var,null,null,null,null);
        system.debug('TemplateId'+TemplateId);
    }
    
    //This method will be used to generate Template dynamically for Applicatio Portal
    Public Static String getLatestAttachmentId(String proID){
        
        List<Attachment> attList = [Select Id,name from attachment where parentId = :proID order by createdDate DESC];
        
        return attList[0].Id;
    }
    
}