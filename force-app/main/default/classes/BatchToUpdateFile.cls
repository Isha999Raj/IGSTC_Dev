public class BatchToUpdateFile implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator([Select Id from Lead]);//[Select ContentDocumentId, LinkedEntityID From ContentDocumentLink where LinkedEntityID != null]);
    }
    
    public void execute(Database.BatchableContext BC, List<ContentDocumentLink> scope){
        for (ContentDocumentLink doc_link : scope){
            ContentVersion cv = [select ContentDocumentId,FileType  , VersionData from ContentVersion where ContentDocumentId =:doc_link.ContentDocumentId];
            ContentDocument cd = [select id, title from ContentDocument where id =:cv.ContentDocumentId];
            Attachment attc = new Attachment();
            attc.Body = (cv.VersionData); //needed for the base64 body of the file
            attc.ParentId = 'a081y000002xrjh'; //needed to attach the Attachment record back to the Account
            attc.Name = cd.Title + 'a081y000002xrjh'; //needed to give the Attachment record the original File name plus Account ID
            attc.ContentType = cv.FileType;
            insert attc;
            delete doc_link;
            
            
        }
    }
    
    public void finish(Database.BatchableContext BC){
    }
}