public class AttachmentTriggerHelper {
    
    public static void updateAttachmentName(List<Attachment> NewAttList){
        system.debug('NewAttList'+NewAttList);
        List<String> parentIdList = new List<String>();
        
        for(Attachment at : NewAttList) {
            String sObjName = (at.ParentId).getSObjectType().getDescribe().getName();
            system.debug('sObjName'+sObjName);
            if( sObjName == 'User_Document__c'){
                parentIdList.add(at.ParentId);     
            }
        }
        
        List<User_Document__c> userDocumentList = [Select id , name , Proposal_Id__c , Propsal_Name__c , Contact__c ,(Select Id,Name from Attachments Order by createdDate Desc LIMIT 1 ) from User_Document__c where  ID IN :parentIdList ];
        
        for(User_Document__c ud : userDocumentList){
            ud.Attachment_Name__c = ud.Attachments[0].Name;
        }
        update userDocumentList;
        
    }
    
    public static void DeletePreviousAttach(List<Attachment> NewAttList){
        system.debug('NewAttList'+NewAttList);
        List<String> parentIdList = new List<String>();
        
        for(Attachment at : NewAttList) {
            String sObjName = (at.ParentId).getSObjectType().getDescribe().getName();
            system.debug('sObjName'+sObjName);
            if( sObjName == 'User_Document__c'){
                parentIdList.add(at.ParentId);     
            }
        }
        
        list<Attachment> attachList = [select id,name from Attachment where ParentId IN: parentIdList];
        system.debug('attachList'+attachList);
        if(attachList.size() > 0){
            delete attachList;    
        }
        
    }
    
    //This method is being used to push the uploaded attachments to the sharepoint to specific folders from user documents of contact..
    public static void pushAttachmentsToSPFromContact(List<Attachment> NewAttList){
        Map<String,List<String>> userDocsByFolder = new map<String,List<String>>();
        Map<String,User_Document__c> userDocById = new map<String,User_Document__c>();
        Map<String,String> userDocIdByProposalName = new map<String,String>();
        Map<Id,String> attachmentRecByPath = new Map<Id,String>();
        Map<String,List<String>> FoldersBySubFolder = new Map<String,List<String>>();
        List<User_Document__c> userDocumentList = new  List<User_Document__c>();
        List<String> userDocumentIds = new List<String>();
        List<String> appProposalIds = new List<String>();
        List<String> attachmentIdList = new List<String>();
        String proposalName = ''; 
        String path = '';
        String folderName = '';
        String parentFolderName = '';
        
        //Mapping the Folders to the Main Folders using Master_Sharepoint_records.
        
        List<Sharepoint_Master__c>        masterAndChildRecords              = [SELECT Name , (Select Name from SharePoint_Child_Configs__r) FROM Sharepoint_Master__c where Name = 'PECFAR' and Is_campaign__c = false];
        List<SharePoint_Child_Config__c>  childAndSubChildRecords            = [SELECT Name , (Select Name from SharePoint_Subchild_Configs__r) FROM SharePoint_Child_Config__c where Master_Config_Name__c = 'PECFAR' and Sharepoint_Master_Configuration__r.Is_campaign__c = false];
        
        for(SharePoint_Child_Config__c childFolderRec : childAndSubChildRecords){
            List<String> Subfolders = new List<String>();
            for(SharePoint_Subchild_Configs__c relatedRec : childFolderRec.SharePoint_Subchild_Configs__r){
                Subfolders.add(relatedRec.Name);
            }
            FoldersBySubFolder.put(childFolderRec.Name,Subfolders);
        }
        system.debug('FoldersBySubFolder'+FoldersBySubFolder);
        //Mapping the Folders to the User Documents folders on sharePoint. 
        List<Folders_Mapping_For_Sharepoint__c> folderMappingData = [SELECT Name,Sub_Folders__c FROM Folders_Mapping_For_Sharepoint__c];
        
        for(Folders_Mapping_For_Sharepoint__c mappingRec : folderMappingData){
            if(mappingRec.Name == 'Release Notes as per Disbursement'){
                userDocsByFolder.put('Release Notes as per Disbursement Schedule',mappingRec.Sub_Folders__c.split(','));    
            }else{
                userDocsByFolder.put(mappingRec.Name,mappingRec.Sub_Folders__c.split(','));
            }
        }
        system.debug('userDocsByFolder'+userDocsByFolder);
        for(Attachment at : NewAttList) {
            String sObjName = (at.ParentId).getSObjectType().getDescribe().getName();
            system.debug('sObjName'+sObjName);
            if( sObjName == 'User_Document__c'){
                userDocumentIds.add(at.ParentId);     
            }
            if(sObjName == 'Application_Proposal__c'){
                appProposalIds.add(at.ParentId);
            }
        }
        
        if(userDocumentIds.size() > 0){
            for(User_Document__c ud : [Select Id , name , Proposal_Id__c , Propsal_Name__c from User_Document__c where id IN : userDocumentIds]){
                userDocById.put(ud.Id , ud);
            }    
            userDocumentList = [Select id , name , Proposal_Id__c , Propsal_Name__c , Proposals__r.Name, Contact__c ,(Select Id,Name from Attachments Order by createdDate Desc LIMIT 1 ) from User_Document__c where  ID IN :userDocumentIds ];
            system.debug('userDocById'+userDocById);
            
            
            for(String folder : userDocsByFolder.keyset()){
                system.debug('Main Folder'+folder);
                for(String userDoc : userDocsByFolder.get(folder)){
                    system.debug('Second Folder '+userDoc);
                    for(User_Document__c udRec: userDocumentList){
                        system.debug('third Folder '+udRec.Name);
                        if(udRec.Name == userDoc){
                            //attachmentIdList.add(udRec.Attachments[0].Id);
                            if(udRec.Propsal_Name__c != null){
                                proposalName = udRec.Propsal_Name__c;    
                            }else{
                                proposalName = udRec.Proposals__r.Name;    
                            }
                            system.debug('proposalName====>'+proposalName);
                            for(String mainFolder : FoldersBySubFolder.keySet()){
                                for(String folderValue : FoldersBySubFolder.get(mainFolder)){
                                    if(folder.equals(folderValue)){
                                        system.debug('Got it 🧑‍💻');
                                        parentFolderName = mainFolder;
                                    }else{
                                        parentFolderName = 'Application Document';
                                    }
                                    
                                }
                            }
                            parentFolderName = parentFolderName.replaceAll(' ','%20');
                            folderName = folder.replaceAll(' ','%20');
                            system.debug('parentFolderName=====>'+parentFolderName);
                            system.debug('folderName=====>'+folderName);
                            system.debug('proposalName===>'+proposalName);
                            path = '/sites/IGSTC/Shared%20Documents/Proposals/PECFAR/'+proposalName+'/'+parentFolderName+'/'+folderName;
                            attachmentRecByPath.put(udRec.Attachments[0].Id,path);
                        }
                    }
                    
                    
                }
            }
            system.debug('attachmentRecByPath'+attachmentRecByPath);
            list<Attachment> attachList = [select id,name,Body from Attachment where ID IN: attachmentRecByPath.keySet()];
            system.debug('attachList size'+attachList.size());
            for(Attachment att : attachList){
                system.debug('The path is ====>'+attachmentRecByPath.get(att.Id));
                createFileUsingBlobFromAttachments(att.Body,att.Name,attachmentRecByPath.get(att.Id));
            }
        }
        
        system.debug('appProposalIds'+appProposalIds);
        if(appProposalIds.size() > 0){
            
            List<Application_Proposal__c> appProposalList = [Select id , name ,(Select Id,Name from Attachments Order by createdDate Desc LIMIT 1 ) from Application_Proposal__c where  ID IN :appProposalIds];
            proposalName = appProposalList[0].Name;
            for(Application_Proposal__c uds : appProposalList){
                attachmentIdList.add(uds.Attachments[0].Id);
            }
            system.debug('Running for the proposals..../');
            system.debug('proposalName'+proposalName);
            path = '/sites/IGSTC/Shared%20Documents/Proposals/PECFAR/'+proposalName+'/Application%20Document/Attachments';
            list<Attachment> attachList = [select id,name,Body from Attachment where ID IN: attachmentIdList];
            for(Attachment att : attachList){
                system.debug('The path is ====>'+attachmentRecByPath.get(att.Id));
                createFileUsingBlobFromAttachments(att.Body,att.Name,path);
            }
            
        }
        
        
    }
    
    //This method is being used to push the uploaded attachments to the sharepoint to specific folders from user documents of Proposal..
    public static void pushAttachmentsToSPFromProposal(List<Attachment> NewAttList){
        Map<String,List<String>> userDocsByFolder = new map<String,List<String>>();
        Map<String,User_Document__c> userDocById = new map<String,User_Document__c>();
        Map<String,String> userDocIdByProposalName = new map<String,String>();
        Map<Id,String> attachmentRecByPath = new Map<Id,String>();
        Map<String,List<String>> FoldersBySubFolder = new Map<String,List<String>>();
        List<User_Document__c> userDocumentList = new  List<User_Document__c>();
        List<String> userDocumentIds = new List<String>();
        List<String> appProposalIds = new List<String>();
        List<String> attachmentIdList = new List<String>();
        String proposalName = ''; 
        String path = '';
        String folderName = '';
        String parentFolderName = '';
        
        //Mapping the Folders to the Main Folders using Master_Sharepoint_records.
        
        List<Sharepoint_Master__c>        masterAndChildRecords              = [SELECT Name , (Select Name from SharePoint_Child_Configs__r) FROM Sharepoint_Master__c where Name = 'PECFAR' and Is_campaign__c = false];
        List<SharePoint_Child_Config__c>  childAndSubChildRecords            = [SELECT Name , (Select Name from SharePoint_Subchild_Configs__r) FROM SharePoint_Child_Config__c where Master_Config_Name__c = 'PECFAR' and Sharepoint_Master_Configuration__r.Is_campaign__c = false];
        
        /*for(SharePoint_Child_Config__c childFolderRec : childAndSubChildRecords){
            List<String> Subfolders = new List<String>();
            for(SharePoint_Subchild_Configs__c relatedRec : childFolderRec.SharePoint_Subchild_Configs__r){
                Subfolders.add(relatedRec.Name);
            }
            FoldersBySubFolder.put(childFolderRec.Name,Subfolders);
        }*/
        for(Sharepoint_Master__c childFolderRec : masterAndChildRecords){
            List<String> Subfolders = new List<String>();
            for(SharePoint_Child_Config__c relatedRec : childFolderRec.SharePoint_Child_Configs__r){
                Subfolders.add(relatedRec.Name);
            }
            FoldersBySubFolder.put(childFolderRec.Name,Subfolders);
        }
        system.debug('FoldersBySubFolder'+FoldersBySubFolder);
        
        //Mapping the Folders to the User Documents folders on sharePoint. 
        
        List<Folders_Mapping_For_Sharepoint__c> folderMappingData = [SELECT Name,Sub_Folders__c FROM Folders_Mapping_For_Sharepoint__c];
        
        for(Folders_Mapping_For_Sharepoint__c mappingRec : folderMappingData){
            if(mappingRec.Name == 'Release Notes as per Disbursement'){
                userDocsByFolder.put('Release Notes as per Disbursement Schedule',mappingRec.Sub_Folders__c.split(','));    
            }else{
                userDocsByFolder.put(mappingRec.Name,mappingRec.Sub_Folders__c.split(','));
            }
        }
        system.debug('userDocsByFolder'+userDocsByFolder);
        for(Attachment at : NewAttList) {
            String sObjName = (at.ParentId).getSObjectType().getDescribe().getName();
            system.debug('sObjName'+sObjName);
           
            if(sObjName == 'Application_Proposal__c'){
                appProposalIds.add(at.ParentId);
            }
        }
        
        if(appProposalIds.size() > 0){
            
            List<Application_Proposal__c> appProposalList = [Select id , name ,(Select Id,Name from Attachments Order by createdDate Desc LIMIT 1 ) from Application_Proposal__c where  ID IN :appProposalIds];
            proposalName = appProposalList[0].Name;
            for(Application_Proposal__c uds : appProposalList){
                attachmentIdList.add(uds.Attachments[0].Id);
            }
            system.debug('proposalName'+proposalName);
            path = '/sites/IGSTC/Shared%20Documents/Proposals/PECFAR/'+proposalName+'/Application%20Document/Attachments';
            list<Attachment> attachList = [select id,name,Body from Attachment where ID IN: attachmentIdList];
            for(Attachment att : attachList){
                system.debug('The path is ====>'+attachmentRecByPath.get(att.Id));
                createFileUsingBlobFromAttachments(att.Body,att.Name,path);
            }
            
        }
    }
    
    @future(callout=true)
    public static void createFileUsingBlobFromAttachments(Blob content,String fileName,String folderName){
        fileName = fileName.replaceAll(' ','%20');
        String url = 'sites/IGSTC/_api/web/GetFolderByServerRelativeUrl('+'\''+folderName+'\')/Files/add(url=\''+fileName+'\',overwrite=true)';
        //String url = 'sites/'+siteName+'/_api/web/GetFolderByServerRelativeUrl('+'\'/sites/'+siteName+'/'+folderName+'\')/Files/add(url=\''+fileName+'\',overwrite=true)';
        
        HTTP http = new HTTP();
        HttpRequest req = new HttpRequest();
        
        String body = 'Ly8gUmVxdWVzdCBCb2R5LS0tLQ0KDQp7DQogICJjdXN0b21lcl9ncm91cGluZyI6ICJaMDAxIiwNCiAgInBhcnRuZXJfcm9sZSI6ICJTWTAwMDFYIiwNCiAgImN1c3RvbWVyX25hbWUiOiAiQWtoaWwgSyBHIiwNCiAgInN0cmVldF8yIjogIk5POjgwLEJPTU1BU0FORFJBIElORFVTVFJJQUwgQVJFQSIsDQogICJzdHJlZXRfMyI6ICJBTkVLQUwgVEFMVUssIEhPU1VSIFJPQUQsIiwNCiAgInN0cmVldCI6ICJJTkRVU1RSSUFMIEFSRUEsIENIRU1CQU5PT1IiLA0KICAicG9zdGFsX0NvZGUiOiAiNjgzNTcyIiwNCiAgImNpdHkiOiAiQU5HQU1BTFkiLA0KICAiY291bnRyeSI6ICJJTiIsDQogICJyZWdpb24iOiAzMiwNCiAgImxhbmd1YWdlIjogIkVOIiwNCiAgInRlbGVwaG9uZV9udW1iZXIiOiAiOTI0OTUwMDAwMiIsDQogICJtb2JpbGVfbnVtYmVyIjogIjkyNDk1MDAwMDIiLA0KICAiZW1haWwiOiAibW9vbGFuc2dyb3VwQGdtYWlsLmNvbSIsDQogICJ0YXhfdHlwZSI6ICIwOSIsDQogICJnc3Rpbl9udW1iZXIiOiAiMzJBQUNDTTMyNTlOMVpCIiwNCiAgInBhbl9udW1iZXIiOiAiQUFDQ00zMjU5TiINCn0NCg0KDQovLyBSZXNwb25zZSAtIFN1Y2Nlc3MNCg0Kew0KICAgICJzdGF0dXMiOnRydWUsDQogICAgImN1c3RvbWVyX2lkIjoiV0VXRVBXSUUzMjMyMzIzMiIsDQp9DQoNCi8vIFJlc3BvbnNlIC0gRXJyb3INCg0Kew0KICAgICJzdGF0dXMiOnRydWUsDQogICAgIm1lc3NhZ2UiOiJFcnJvciBtZXNzYWdlIGhlcmUiLA0KfQ0KDQo=';
        
        req.setHeader('Accept', 'application/json;odata=verbose');
        req.setHeader('Content-Type','application/json;odata=verbose');
        req.setHeader('Content-Length', '0');
        req.setHeader('X-RequestDigest','{form_digest_value}');
        req.setTimeout(120000);
        //req.setBody(EncodingUtil.base64Decode(body).toString());
        req.setBodyAsBlob(content);
        
        req.setMethod('POST');
        req.setEndpoint('callout:SPSF/'+url);
        
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
    }
}