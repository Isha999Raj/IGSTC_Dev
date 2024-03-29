public with sharing class IFReleaseTrancheLetter {
    
    @InvocableMethod(label='IF Tranche Release' description='Send Tranche letter.' category='Application_Proposal__c')
    Public Static void ifTrancheLetter(List<String> proID){
        String proposalId = proID[0];
        Application_Proposal__c propData = [Select id , IF_tranche__c from Application_Proposal__c where id = :proposalId];
        system.debug('propData--'+propData);
        list<contact> conList  =[select id,name,Industrial_Fellowship_Type__c from contact WHERE Proposals__c =:proposalId];
        system.debug('conList----'+conList);
        GenerateCongaTemplatesUsingCS(proposalId,'IF Tranche Letter');
    }

    Public Static void GenerateCongaTemplatesUsingCS(String recordID, String TempName){
        TemplateURLByName__c TempInfoRec=[select id,name,Object_Name__c,Formula_Field_Name__c from TemplateURLByName__c where Name =:TempName];
        String query='';
        String CongaQuery = '';
        String objectList = TempInfoRec.Object_Name__c;
        String fieldName =TempInfoRec.Formula_Field_Name__c+', Id,Name,RecordTypeId,RecordType.Name,(Select Id, Firstname , Account.BillingCountry ,Lastname from contacts__r)';
        String condition='id=:recordID';
        query = 'SELECT '+ fieldName +' FROM ' + objectList + ' WHERE ' + condition;
        // query = 'SELECT '+ fieldName +' FROM ' + objectList;
        System.debug('query is '+ query );
        List<Application_Proposal__c> queryData = Database.query(query);
        system.debug('queryData--'+queryData);
        
        //-------------------------------------------------------------------------
        Application_Proposal__c propRec = new Application_Proposal__c();
        propRec = queryData[0];
        map<Id,List<Contact>> contactsByPropID = new map<Id,List<Contact>>();
        List<Contact> conLIst = new List<Contact>();
        conLIst.addAll(propRec.contacts__r);
        contactsByPropID.put(propRec.Id ,conLIst);
        //-------------------------------------------------------------------------- 
        
        String exCategoriesCustomLable  = Label.docCategoriesToBeExcluded;
        // String tempName = '';
        List<String> docCategoriesToBeExcluded =  exCategoriesCustomLable.split(',');
        SYSTEM.debug('docCategoriesToBeExcluded---'+docCategoriesToBeExcluded);
        system.debug('contactsByPropID'+contactsByPropID);
        
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
        system.debug('contactsByPropID.get(propRec.Id)[0]'+contactsByPropID.get(propRec.Id));
        if(propRec.RecordType.Name == 'Industrial Fellowship'){
            tempName = propRec.Name+'_IF_2023_'+contactsByPropID.get(propRec.Id)[0].Firstname +'_'+contactsByPropID.get(propRec.Id)[0].LastName;
            CongaQuery = propRec.IF_tranche__c;
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('IF CONGA'+CongaQuery);
        }else if(propRec.RecordType.Name == 'PECFAR'){
            //german and indian logic included
            if(contactsByPropID.get(propRec.Id)[0].Account.BillingCountry == 'India'){
                system.debug('propRec------'+contactsByPropID.get(propRec.Id)[0].Account.BillingCountry);
                
                tempName = propRec.Name+'_PECFAR_2023_'+contactsByPropID.get(propRec.Id)[0].Firstname +'_'+contactsByPropID.get(propRec.Id)[1].Firstname;
            }
            else{
                 tempName = propRec.Name+'_PECFAR_2023_'+contactsByPropID.get(propRec.Id)[1].Firstname +'_'+contactsByPropID.get(propRec.Id)[0].Firstname;
            }
            
            CongaQuery = (String)propRec.get(TempInfoRec.Formula_Field_Name__c);
            system.debug('');
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('PECFAR CONGA'+CongaQuery);
            
        }else if(propRec.RecordType.Name == 'WISER'){
            tempName = propRec.Name+'_WISER_2023_'+contactsByPropID.get(propRec.Id)[0].Firstname +'_'+contactsByPropID.get(propRec.Id)[0].LastName;
            CongaQuery = (String)propRec.get(TempInfoRec.Formula_Field_Name__c);
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('Wiser_Conga_Url__c CONGA'+CongaQuery);
        }else if(propRec.RecordType.Name == 'SING'){
            tempName = propRec.Name+'_SING_2023_'+contactsByPropID.get(propRec.Id)[0].Firstname +'_'+contactsByPropID.get(propRec.Id)[0].LastName;
            system.debug('Attachment Ids Are ' + attIds); 
            CongaQuery = (String)propRec.get(TempInfoRec.Formula_Field_Name__c);
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('SING CONGA'+CongaQuery);
        }else{
            tempName = propRec.Name+contactsByPropID.get(propRec.Id)[0].Firstname +'_'+contactsByPropID.get(propRec.Id)[0].LastName;
            system.debug('Attachment Ids Are ' + attIds); 
            CongaQuery = (String)propRec.get(TempInfoRec.Formula_Field_Name__c);
            CongaQuery = CongaQuery.replace('AttachmentId=00P1y000003a34i','AttachmentId='+attIds );
            system.debug('SING CONGA'+CongaQuery);
        }
        system.debug('tempName-----'+tempName);
        generateCongaTemplate(CongaQuery,tempName); 	
    }

    @future (callout=true)
    Public static void generateCongaTemplate(String var,String TemplateName){
        system.debug('var ::'+var);
        String TemplateId = CongaHelperToolLightning.generateReport(var,TemplateName,null,null,null);
        system.debug('TemplateId'+TemplateId);
    }
}