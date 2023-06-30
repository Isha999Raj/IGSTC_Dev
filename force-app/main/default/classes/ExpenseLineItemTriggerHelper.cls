// THIS CLASS HAS BEEN CREATED BY SHIVA 
// THIS CLASS FOR SUM ALL LINE ITEM  VALUE ON ITS HEAD 
// THIS IS ONLU FOR SING
//  DATE 2023-05-03 YY-MM-DD

public class ExpenseLineItemTriggerHelper {

    Public static void updateTotalValueOnItsHead(List<Expense_Line_Item__c> newELIList){
        system.debug('newELIList::'+newELIList);
        list<string> expenseHeadIDList =new list<string>();
        for(Expense_Line_Item__c ELI:newELIList){
            IF(ELI.Expense_Head__c !=NULL){
                expenseHeadIDList.add(ELI.Expense_Head__c);
            }
        }
        
        Map<Id, Decimal> lineItemvalueIWthHeadID = new Map<Id, Decimal>();
        map<id,Expense_Head__c> expenHeadByID = new  map<id,Expense_Head__c>([select id,ELI__c,Proposals__c,Proposals__r.recordtype.name,(select id,Expense_Head__c,Year1_Expense__c from Expense_Line_Items__r) from Expense_Head__c where id In: expenseHeadIDList AND Proposals__r.recordtype.name='SING']);
        for(Expense_Head__c exh : expenHeadByID.values()){
            Decimal totalofLineItem = 0;
           // Decimal totalPercentage = 0;
            list<Expense_Line_Item__c> linitemList=exh.Expense_Line_Items__r;
            for( Expense_Line_Item__c litm : linitemList){
                if(litm.Year1_Expense__c != null){
                    totalofLineItem +=litm.Year1_Expense__c;
                }
                
            }
            
            lineItemvalueIWthHeadID.put(exh.id,totalofLineItem);
        }
        
         List<Expense_Head__c> headTobeUpdated = new List<Expense_Head__c>();
        
        for (Id headID : lineItemvalueIWthHeadID.keySet()) {
            Expense_Head__c EXPH = new Expense_Head__c(Id=headID, ELI__c=lineItemvalueIWthHeadID.get(headID));
            headTobeUpdated.add(EXPH);
        }
        if(!headTobeUpdated.isEmpty()){
             update headTobeUpdated;
        }
       
    }
}