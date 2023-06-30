public with sharing class NorthernArcGetLead {
    public String candidateId {get;set;}

    public NorthernArcGetLead() {
        candidateId = Apexpages.currentPage().getParameters().get('id'); 
    }

    @RemoteAction
    public static Lead getLeads(String leadId){
        try{
            Lead leadRecord = [SELECT Id,Name From Lead WHERE Id =: leadId];
            return leadRecord;
        }catch(Exception e){
            return null;
        }
    }
}