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
        Application_Proposal__c appRec= [SELECT Id,Name,Conga_URL__c FROM Application_Proposal__c WHERE Id = :recordId][0];
        generateCongaTemplate(appRec.Conga_URL__c,appRec.Name);
    }
    
    @AuraEnabled
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
            conLIst.addAll(ap.contacts__r);
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
        system.debug('contactsByPropID.get(appProposalRec.Id)[0]'+contactsByPropID.get(appProposalRec.Id));
        if(appProposalRec.RecordType.Name == 'Industrial Fellowship'){
            tempName = appProposalRec.Name+'_IF_2023_'+contactsByPropID.get(appProposalRec.Id)[0].Firstname +'_'+contactsByPropID.get(appProposalRec.Id)[0].LastName;
            CongaQuery = appProposalRec.IF_conga_Url__c;
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('IF CONGA'+CongaQuery);
        }else if(appProposalRec.RecordType.Name == 'PECFAR'){
            //german and indian logic included
            if(contactsByPropID.get(appProposalRec.Id)[0].Account.BillingCountry == 'India'){
                
                tempName = appProposalRec.Name+'_PECFAR_2023_'+contactsByPropID.get(appProposalRec.Id)[0].Firstname +'_'+contactsByPropID.get(appProposalRec.Id)[1].Firstname;
            }
            
            CongaQuery = appProposalRec.Pecfar_Conga_Url__c;
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('PECFAR CONGA'+CongaQuery);
            
        }else if(appProposalRec.RecordType.Name == 'WISER'){
            tempName = appProposalRec.Name+'_WISER_2023_'+contactsByPropID.get(appProposalRec.Id)[0].Firstname +'_'+contactsByPropID.get(appProposalRec.Id)[0].LastName;
            CongaQuery = appProposalRec.Wiser_Conga_Url__c	;
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('Wiser_Conga_Url__c CONGA'+CongaQuery);
        }else if(appProposalRec.RecordType.Name == 'SING'){
            tempName = appProposalRec.Name+'_SING_2023_'+contactsByPropID.get(appProposalRec.Id)[0].Firstname +'_'+contactsByPropID.get(appProposalRec.Id)[0].LastName;
            system.debug('Attachment Ids Are ' + attIds); 
            CongaQuery = appProposalRec.Sing_Conga_url__c;
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('SING CONGA'+CongaQuery);
        }
        
        system.debug('CongaQuery'+CongaQuery);
        generateCongaTemplate(CongaQuery,tempName);
    }
    
    //This is asynchronous method which will be used to generate template for the proided URL.
    @future (callout=true)
    Public static void generateCongaTemplate(String var,String TemplateName){
        system.debug('var ::'+var);
        String TemplateId = CongaHelperToolLightning.generateReport(var,TemplateName,null,null,null);
        system.debug('TemplateId'+TemplateId);
    }
    
    //This method will be used to generate Template dynamically for Applicatio Portal
    Public Static String getLatestAttachmentId(String proID){
        
        List<Attachment> attList = [Select Id,name from attachment where parentId = :proID order by createdDate DESC];
        for(Attachment atL :attList){
            
        }
        return attList[0].Id;
    }
    ///////////////////////////shiva working on it==================/////////////////////////////////////////////////////////===============================================================
    
    Public static void generateCongaTemplatesForBatch(List<String> recordIdList){
        System.debug('recordIdList'+recordIdList);
        String CongaQuery = '';
        
        String exCategoriesCustomLable  = Label.docCategoriesToBeExcluded;
        map<Id,List<Contact>> contactsByPropID = new map<Id,List<Contact>>();
        List<String> docCategoriesToBeExcluded =  exCategoriesCustomLable.split(',');
        SYSTEM.debug('docCategoriesToBeExcluded---'+docCategoriesToBeExcluded);
        map<Id,List<Attachment>> AttachmentByPropID = new map<Id,List<Attachment>>();
        SYSTEM.debug('AttachmentByPropID---'+AttachmentByPropID);
        
        List<Application_Proposal__c> appProposalRecList = [SELECT Id,Name,Conga_URL__c,Pecfar_Conga_Url__c,IF_conga_Url__c,Wiser_Conga_Url__c,Sing_Conga_url__c,RecordTypeId,RecordType.Name,(Select Id, Firstname , Account.BillingCountry ,Lastname from contacts__r)  FROM Application_Proposal__c WHERE Id IN :recordIdList];
        system.debug('appProposalRecList::'+appProposalRecList.size());
        
        for(Application_Proposal__c ap : appProposalRecList){
            contactsByPropID.put(ap.Id ,ap.contacts__r);
        } 
        
        system.debug('contactsByPropID'+contactsByPropID);
        system.debug('contactsByPropID::'+contactsByPropID.size());
        List<String> UserDocumentIds = new List<String>();
        List<User_Document__c> UserDocList = [Select Id,Name from User_Document__c where Proposal_Id__c = :recordIdList AND Name NOT IN :docCategoriesToBeExcluded];
        
        for(User_Document__c ud : UserDocList){
            UserDocumentIds.add(ud.Id);
        }
        system.debug('UserDocumentIds'+UserDocumentIds);
        String attIds = '';
        List<Attachment> attList = [Select id , name,parentId from Attachment where parentId = :UserDocumentIds order by CreatedDate  Desc Limit 1];
        for(Attachment at : attList){
            IF(AttachmentByPropID.containskey(at.parentId)){
                List<Attachment> tempattLIst = AttachmentByPropID.get(at.parentId);
                tempattLIst.add(at);
                AttachmentByPropID.put(at.parentId ,tempattLIst);
            }else{
                AttachmentByPropID.put(at.parentId ,new List<Attachment>{at});
            }
            SYSTEM.debug('AttachmentByPropID---'+AttachmentByPropID);
            
        } 
        if(attList.size() > 0){
            for(Attachment atid :attList){
                String attid = atid.Id; 
                attIds = attIds + attid  + ',';
            }
            
        }
        
        attIds = attIds.removeEnd(',');
        system.debug('contactsByPropID::'+contactsByPropID);
        List<String> tempListTobePass = new List<String>();
        Map<String,String> mapofTempNameByCongaQuery = new Map<String,string>();
        if(!contactsByPropID.isEmpty()){
            for(Application_Proposal__c ap : appProposalRecList){
                system.debug('ap:::'+ap);
                system.debug('ap.RecordType.Name ::'+ap.RecordType.Name );
                String tempName = '';
                for(Contact con : contactsByPropID.get(ap.Id)){
                    
                    if(ap.RecordType.Name == 'Industrial Fellowship'){
                        tempName = ap.Name+'_IF_2023_'+con.Firstname +'_'+con.LastName;
                        CongaQuery = ap.IF_conga_Url__c;
                        
                        // Shiva's Code for getting Proposal Specific Doc
                        List<Attachment> proposalAtt =  AttachmentByPropID.get(ap.Id);
                        String tempattId = '';
                        for(Attachment atid :attList){
                            tempattId += atid.Id + ',';
                        }
                        tempattId = tempattId.removeEnd(',');
                        
                        
                        CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
                        system.debug('IF CONGA'+CongaQuery);
                        system.debug('tempName-----'+tempName);
                    }else if(ap.RecordType.Name == 'PECFAR'){
                        //german and indian logic included
                        system.debug('con.Account.BillingCountry::'+con.Account.BillingCountry);
                        if(con.Account.BillingCountry == 'India'){
                            
                            tempName = ap.Name+'_PECFAR_2023_'+con.Firstname +'_'+con.Firstname;
                        }
                        
                        CongaQuery = ap.Pecfar_Conga_Url__c;
                        // Shiva's Code for getting Proposal Specific Doc
                        List<Attachment> proposalAtt =  AttachmentByPropID.get(ap.Id);
                        String tempattId = '';
                        for(Attachment atid :attList){
                            tempattId += atid.Id + ',';
                        }
                        tempattId = tempattId.removeEnd(',');
                        
                        CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+tempattId );
                        system.debug('PECFAR CONGA'+CongaQuery);
                        system.debug('tempName-----'+tempName);
                    }else if(ap.RecordType.Name == 'WISER'){
                        tempName = ap.Name+'_WISER_2023_'+con.Firstname +'_'+con.LastName;
                        CongaQuery = ap.Wiser_Conga_Url__c	;
                        // Shiva's Code for getting Proposal Specific Doc
                        List<Attachment> proposalAtt =  AttachmentByPropID.get(ap.Id);
                        String tempattId = '';
                        for(Attachment atid :attList){
                            tempattId += atid.Id + ',';
                        }
                        tempattId = tempattId.removeEnd(',');
                        
                        CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+tempattId );
                    }else if(ap.RecordType.Name == 'SING'){
                        tempName = ap.Name+'_SING_2023_'+con.Firstname +'_'+con.LastName;
                        system.debug('Attachment Ids Are ' + attIds); 
                        CongaQuery = ap.Sing_Conga_url__c;
                        // Shiva's Code for getting Proposal Specific Doc
                        List<Attachment> proposalAtt =  AttachmentByPropID.get(ap.Id);
                        String tempattId = '';
                        for(Attachment atid :attList){
                            tempattId += atid.Id + ',';
                        }
                        tempattId = tempattId.removeEnd(',');
                        
                        CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+tempattId );
                    }
                    system.debug('tempName::'+tempName);
                    system.debug('CongaQuery::'+CongaQuery);
                    if(tempName != null && tempName != ''){
                        mapofTempNameByCongaQuery.put(tempName,CongaQuery);
                    }
                    
                }
                if(tempName != null && tempName != ''){
                    tempListTobePass.add(tempName);
                }
                
            }
        }
        system.debug('CongaQuery::'+CongaQuery);
        if(!tempListTobePass.isEmpty()){
            for(String str : tempListTobePass){
                String TemplateId = CongaHelperToolLightning.generateReport(mapofTempNameByCongaQuery.get(str),str,null,null,null);
            }
        }
        
        
    }
    
}