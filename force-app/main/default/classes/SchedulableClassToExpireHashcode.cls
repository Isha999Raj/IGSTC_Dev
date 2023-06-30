public class SchedulableClassToExpireHashcode implements Schedulable {
    public SchedulableClassToExpireHashcode() {

    }

    public void execute(SchedulableContext context) {
        // Get today's date
        Date today = Date.today();
        
        // Query contacts with HashCodeExpirationDate equal to today
        List<Contact> contactList = [SELECT Id, Hashcode_Expiration_Date__c, Login_Hash_Code__c FROM Contact WHERE Hashcode_Expiration_Date__c = :today];
        List<Contact> ContactListToUpdate = New List<Contact>();
        
        for (Contact con : contactList) {
            con.Login_Hash_Code__c = '';
            ContactListToUpdate.add(con);
        }
        if(!ContactListToUpdate.isEmpty()){
            update ContactListToUpdate;
        }
    }
}