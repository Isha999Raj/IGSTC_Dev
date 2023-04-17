public class EmailFlowHelper {
    @InvocableMethod(label='Generate Conga Template' description='Get template Id to send an Attachment' category='Application_Proposal__c')
    Public Static Void generateIFTemplateFromProposal(List<Id> recordId){
        String recordIdVar = recordId[0];        
        
        Application_Proposal__c appProposalRec = [SELECT Id,Name,Conga_URL__c,Document_generated__c,Pecfar_Conga_Url__c,IF_conga_Url__c,Wiser_Conga_Url__c,Sing_Conga_url__c,RecordTypeId,RecordType.Name  FROM Application_Proposal__c WHERE Id = :recordIdVar];
        system.debug('recordtypeId'+appProposalRec.RecordTypeId);
        
        if(appProposalRec.RecordType.Name == 'Industrial Fellowship'){
            DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(recordIdVar,'IF Conga Url');
        }else if(appProposalRec.RecordType.Name == 'PECFAR'){
            DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(recordIdVar,'Pecfar Conga Url');
            
        }else if(appProposalRec.RecordType.Name == 'WISER'){
            DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(recordIdVar,'Wiser Conga Url');
        }else if(appProposalRec.RecordType.Name == 'SING'){
            DynamicCongaTempGeneration.GenerateCongaTemplatesUsingCS(recordIdVar,'Sing Conga url');
        }
    }
 
    //@InvocableMethod(label='Generate attachment Id For IF' description='Get attachment template' category='attachment')
    //This method will be used to generate Template dynamically for Applicatio Portal
    Public Static String getLatestAttachmentId(String proID){
        
        List<Attachment> attList = [Select Id,name from attachment where parentId = :proID order by createdDate DESC];
        
        return attList[0].Id;
    }
}