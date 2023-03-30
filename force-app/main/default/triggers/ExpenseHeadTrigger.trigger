trigger ExpenseHeadTrigger on Expense_Head__c (after insert) {

    if(trigger.isAfter && trigger.isInsert){
        ExpenseSumController.createExpenseheadReport(trigger.new);
    }
}