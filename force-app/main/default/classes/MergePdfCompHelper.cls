public with sharing class MergePdfCompHelper {
    @AuraEnabled(cacheable=true)
    public static String getRecordsId(String accId) {
        List<Id> lsOfCont = new List<Id>();
        List<ContentDocumentLink> lsOfCDL = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId=:accId];
        String idString='';
        for(integer i=0;i<lsOfCDL.size();i++){
            if(i == lsOfCDL.size()-1){
                idString+= lsOfCDL[i].ContentDocumentId;
            }else{
                idString+= lsOfCDL[i].ContentDocumentId + ',';
            }
            
        }
        System.debug('IDs are '+idString);
        return idString;
    }
    @AuraEnabled
    public static List<String> getData(String accountId){
        System.debug('ID is '+accountId);
        Map<String,String> mapOfData = new Map<String,String>();
        List<ContentDocumentLink> lsOfCDL = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId=:accountId];
        List<Id> tempsId =new List<Id>();
        for(ContentDocumentLink tempLoop:lsOfCDL){
            tempsId.add(tempLoop.ContentDocumentId);
        }
        List<ContentVersion> lsOfCV = [SELECT Id,VersionData,FileExtension FROM ContentVersion WHERE ContentDocumentId=:tempsId];
        List<String> lsOfFiles = new  List<String>();
        for(ContentVersion tempLoopCv :lsOfCV){
            if(tempLoopCv.VersionData.size() > 150000){
                system.debug('Something is tooo big man..'+tempLoopCv.VersionData.size());
                for(integer i = 0 ; i < tempLoopCv.VersionData.size() / 150000 ; i++){
                    Blob csvFileBody =tempLoopCv.VersionData;
                    String csvAsString= EncodingUtil.base64Encode(tempLoopCv.VersionData);
                    system.debug(csvAsString.length());
                    //List<String> csvFileLines= csvAsString.split(',');
                    //system.debug(csvFileLines);
                }
            }else{
                lsOfFiles.add(EncodingUtil.base64Encode(tempLoopCv.VersionData)); 
                system.debug(EncodingUtil.base64Encode(tempLoopCv.VersionData).length());
            }
            System.debug('File Extension is  '+tempLoopCv.FileExtension);
            if((''+tempLoopCv.FileExtension).toLowerCase() == 'pdf'){
                system.debug('tempLoopCv.VersionData'+tempLoopCv.VersionData);
                mapOfData.put(''+tempLoopCv.Id+','+'PDF',EncodingUtil.base64Encode(tempLoopCv.VersionData));    
            }else{
                mapOfData.put(''+tempLoopCv.Id+','+'PDF',EncodingUtil.base64Encode(tempLoopCv.VersionData));
            }
            
        }
        return lsOfFiles; 
    }
}