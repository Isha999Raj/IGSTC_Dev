@isTest
public class CongaDocGenerationTest {
    @isTest
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
    
    @isTest
     Public Static void generateTemplateFromProposal(){
        Application_Proposal__c appRec= [SELECT Id,Name,Conga_URL__c FROM Application_Proposal__c];
         
        generateCongaTemplate(appRec.Conga_URL__c,appRec.Name);
    }
    
        Public Static void generateIFTemplateFromProposal(String recordId){
        System.debug('recordId'+recordId);
        String CongaQuery = '';
        String exCategoriesCustomLable  = Label.docCategoriesToBeExcluded;
        String tempName = '';
        List<String> docCategoriesToBeExcluded =  exCategoriesCustomLable.split(',');
        SYSTEM.debug('docCategoriesToBeExcluded---'+docCategoriesToBeExcluded);
        map<Id,List<Contact>> contactsByPropID = new map<Id,List<Contact>>();
        
        List<Application_Proposal__c> appProposalRecList = [SELECT Id,Name,Conga_URL__c,Pecfar_Conga_Url__c,IF_conga_Url__c,Wiser_Conga_Url__c,Sing_Conga_url__c,RecordTypeId,RecordType.Name,(Select Id, Firstname , Account.BillingCountry ,Lastname from contacts__r)  FROM Application_Proposal__c WHERE Id = :recordId];
        Application_Proposal__c appProposalRec = appProposalRecList[0];
        
        
        for(Application_Proposal__c ap : appProposalRecList){
            List<Contact> conLIst = new List<Contact>();
            conLIst.addAll(conLIst);
            contactsByPropID.put(ap.Id ,conLIst);
        }
        system.debug('contactsByPropID'+contactsByPropID);
        
        system.debug('recordtypeId'+appProposalRec.RecordTypeId);
        
        List<String> UserDocumentIds = new List<String>();
        
        List<User_Document__c> UserDocList = [Select Id,Name from User_Document__c where Proposal_Id__c = :recordId AND Name NOT IN :docCategoriesToBeExcluded];
       
        for(User_Document__c ud : UserDocList){
            UserDocumentIds.add(ud.Id);
        }
        system.debug('UserDocumentIds'+UserDocumentIds);
        String attIds = '';
        for(String usd : UserDocumentIds){
            List<Attachment> attList = [Select id , name from Attachment where parentId = :usd order by CreatedDate  Desc Limit 1];
            if(attList.size() > 0){
                String attid = attList[0].Id; 
                attIds = attIds + attid  + ',';
            }
             
        }
        attIds = attIds.removeEnd(',');
        system.debug('Attachment Ids Are ' + attIds); 
         
        if(appProposalRec.RecordType.Name == 'Industrial Fellowship'){
            tempName = appProposalRec.Id+'_IF_2023_'+contactsByPropID.get(appProposalRec.Id)[0].Firstname +'_'+contactsByPropID.get(appProposalRec.Id)[0].LastName;
            CongaQuery = appProposalRec.IF_conga_Url__c;
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('IF CONGA'+CongaQuery);
        }else if(appProposalRec.RecordType.Name == 'PECFAR'){
            //german and indian logic included
            if(contactsByPropID.get(appProposalRec.Id)[0].Account.BillingCountry == 'India'){
                tempName = appProposalRec.Id+'_PECFAR_2023_'+contactsByPropID.get(appProposalRec.Id)[0].Firstname +'_'+contactsByPropID.get(appProposalRec.Id)[1].Firstname;
            }
            
            CongaQuery = appProposalRec.Pecfar_Conga_Url__c;
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('PECFAR CONGA'+CongaQuery);
            
        }else if(appProposalRec.RecordType.Name == 'WISER'){
            tempName = appProposalRec.Id+'_WISER_2023_'+contactsByPropID.get(appProposalRec.Id)[0].Firstname +'_'+contactsByPropID.get(appProposalRec.Id)[0].LastName;
            CongaQuery = appProposalRec.Wiser_Conga_Url__c	;
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('Wiser_Conga_Url__c CONGA'+CongaQuery);
        }else if(appProposalRec.RecordType.Name == 'SING'){
            tempName = appProposalRec.Id+'_SING_2023_'+contactsByPropID.get(appProposalRec.Id)[0].Firstname +'_'+contactsByPropID.get(appProposalRec.Id)[0].LastName;
            system.debug('Attachment Ids Are ' + attIds); 
            CongaQuery = appProposalRec.Sing_Conga_url__c;
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('SING CONGA'+CongaQuery);
        }
        
        system.debug('CongaQuery'+CongaQuery);
        generateCongaTemplate(CongaQuery,tempName);
    }
    
        Public static void generateCongaTemplate(String var,String TemplateName){
        system.debug('var ::'+var);
        String TemplateId = CongaHelperToolLightning.generateReport(var,TemplateName,null,null,null);
        system.debug('TemplateId'+TemplateId);
    }
    
    //This method will be used to generate Template dynamically for Applicatio Portal
    Public Static String getLatestAttachmentId(String proID){
        
        List<Attachment> attList = [Select Id,name from attachment where parentId = :proID order by createdDate DESC];
        
        return attList[0].Id;
    }
}