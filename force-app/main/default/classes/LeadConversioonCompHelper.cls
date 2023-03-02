public class LeadConversioonCompHelper {
    
    Public Static Void convertLeadMethod(){
        
        Lead myLead = new Lead(LastName = 'Fry', Company='Fry And Sons');
        insert myLead;
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(myLead.id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
    }
    
}