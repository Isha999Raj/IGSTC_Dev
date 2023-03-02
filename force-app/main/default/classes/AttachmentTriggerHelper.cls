public class AttachmentTriggerHelper {
    
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
}