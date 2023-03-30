public class EmailFlowHelper {
    @InvocableMethod(label='Generate Conga Template' description='Get template Id to send an Attachment' category='Application_Proposal__c')
    Public Static Void generateIFTemplateFromProposal(List<Id> recordId){
        String recordIdVar = recordId[0];
        System.debug('recordId'+recordId);
        String CongaQuery = '';
        String exCategoriesCustomLable  = Label.docCategoriesToBeExcluded;
        
        List<String> docCategoriesToBeExcluded =  exCategoriesCustomLable.split(',');
        SYSTEM.debug('docCategoriesToBeExcluded---'+docCategoriesToBeExcluded);
        
        
        Application_Proposal__c appProposalRec = [SELECT Id,Name,Conga_URL__c,Document_generated__c,Pecfar_Conga_Url__c,IF_conga_Url__c,Wiser_Conga_Url__c,Sing_Conga_url__c,RecordTypeId,RecordType.Name  FROM Application_Proposal__c WHERE Id = :recordIdVar];
        system.debug('recordtypeId'+appProposalRec.RecordTypeId);
        
        List<String> UserDocumentIds = new List<String>();
        
        List<User_Document__c> UserDocList = [Select Id,Name from User_Document__c where Proposal_Id__c = :recordIdVar AND Name NOT IN :docCategoriesToBeExcluded];
        
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
        generateCongaTemplate(CongaQuery,recordIdVar);
        //return 'Success';
    }
    
    //This is asynchronous method which will be used to generate template for the proided URL.
    @future (callout=true)
    Public static void generateCongaTemplate(String var,string recordIdVar){
        String TemplateId = CongaHelperToolLightning.generateReport(var,null,null,null,null);
        
        Application_Proposal__c appProposalRec = [SELECT Id,Name,Conga_URL__c,Document_generated__c,Pecfar_Conga_Url__c,IF_conga_Url__c,Wiser_Conga_Url__c,Sing_Conga_url__c,RecordTypeId,RecordType.Name  FROM Application_Proposal__c WHERE Id = :recordIdVar];
        appProposalRec.Document_generated__c=true;
        update appProposalRec;
        
        system.debug('TemplateId'+TemplateId);
    }
    //@InvocableMethod(label='Generate attachment Id For IF' description='Get attachment template' category='attachment')
    //This method will be used to generate Template dynamically for Applicatio Portal
    Public Static String getLatestAttachmentId(String proID){
        
        List<Attachment> attList = [Select Id,name from attachment where parentId = :proID order by createdDate DESC];
        
        return attList[0].Id;
    }
}