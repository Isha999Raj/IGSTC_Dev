public class ScheduleBatchProposal implements Schedulable{
    public void execute(SchedulableContext sc) {
        generateTempsForSubmittedProposal b = new generateTempsForSubmittedProposal(); 
        Database.executeBatch(b);
    }
}