public class ExpenseMasterTriggerHandler {
	
    public static void createYearlyExpense(List<Expense_Master__c> emList){
        List<Yearly_Expense__c> yearlyExpenseListTobeInsert = New List<Yearly_Expense__c>();
        for(Expense_Master__c em : emList){
            for(integer i=1;i<4;i++){
                Yearly_Expense__c ye = new Yearly_Expense__c();
                ye.Expense_Master__c = em.Id;
                ye.Year__c = String.valueOf(i);
                yearlyExpenseListTobeInsert.add(ye);
            }
        }
        if(!yearlyExpenseListTobeInsert.isEmpty()){
            insert yearlyExpenseListTobeInsert;
        }
    }
}