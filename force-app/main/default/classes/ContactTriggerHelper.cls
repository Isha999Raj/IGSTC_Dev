public class ContactTriggerHelper {

    public static void updateHostName(List<Contact> newContacList){
        for(Contact con : newContacList){
            system.debug('Account host Name'+con.Account_Host_Name__c);
            if(con.Account_Host_Name__c != null){
                con.Host_Value_Name__c = con.Account_Host_Name__c;
            }
        }
    }
}