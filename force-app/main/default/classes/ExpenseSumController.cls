/**
* @author [Dinesh B]
* @email dinesh.b@utilitarianLab.com
* @create date 2023-03-23 19:19:09
* @modify date 2023-03-23 19:19:09
* @desc [description]
*/


public class ExpenseSumController {
    
    public Static void updateExpenseSum(List<Expense_Line_Item__c> expLineItemList){
        
        Set<Id> ExpHeadIdSet = new Set<id>();
        expLineItemList = [SELECT Id,Name,Expense_Head__c FROM Expense_Line_Item__c];
        for(Expense_Line_Item__c exp : expLineItemList){
            ExpHeadIdSet.add(exp.Expense_Head__c);
        }
        Decimal FirstYearSum = 0;
        List<Expense_Line_Item__c> ListExpLineItemWithExpHead = [SELECT Id,Name,Expense_Head__c FROM Expense_Line_Item__c WHERE Expense_Head__c IN:ExpHeadIdSet];
        for(Expense_Line_Item__c exp : ListExpLineItemWithExpHead){
            if(exp.Expense_Head__r.Year_Detail__c == '1'){
                FirstYearSum = FirstYearSum + exp.Year1_Expense__c;
            }
        }
        System.debug('Total ');
        List<Expense_Head__c> ExpHeadList = [SELECT Id,Name,ELI__c FROM Expense_Head__c WHERE ID IN:ExpHeadIdSet];
        for(Expense_Head__c exp : ExpHeadList){
            for(Expense_Line_Item__c expItem : ListExpLineItemWithExpHead){
                if(expItem.Expense_Head__c == exp.Id){
                    exp.ELI__c = FirstYearSum;
                }
            }
        }
        Update ExpHeadList;
    }
    
    Public Static void createExpenseheadReport(List<Expense_Head__c> expList){
        try{
            if(expList.size() > 0){
                Set<Id> ExpId = new Set<Id>();
                List<Expense_Head_Report__c> expheadReportList = new List<Expense_Head_Report__c>();  
                for(Expense_Head__c exp : expList){
                    System.debug('Yearly_Expense__c ID  ==> '+exp.Yearly_Expense__c);
                    ExpId.add(exp.Yearly_Expense__c);
                }
                
                Yearly_Expense__c YearExp = [SELECT Id,Name,Expense_Master__c,Expense_Master__r.Proposals__c FROM Yearly_Expense__c WHERE Id IN:ExpId LIMIT 1];
                System.debug('Proposal Id ==> '+YearExp.Expense_Master__r.Proposals__c);
                for(Expense_Head__c exp : expList){
                    
                    if(exp.Year_Detail__c == '1'){
                        Expense_Head_Report__c ExHeReport = new Expense_Head_Report__c();
                        ExHeReport.Expense_Head_Name__c = exp.Name;
                        ExHeReport.Year_1_ELI__c = exp.ELI__c;
                        ExHeReport.Account__c = exp.Account_Id__c;
                        ExHeReport.Proposal__c = YearExp.Expense_Master__r.Proposals__c;
                        expheadReportList.add(ExHeReport);
                    }
                    else if(exp.Year_Detail__c == '2'){
                        Expense_Head_Report__c ExHeReport = new Expense_Head_Report__c();
                        ExHeReport.Expense_Head_Name__c = exp.Name;
                        ExHeReport.Year_2_ELI__c = exp.ELI__c;
                        ExHeReport.Account__c = exp.Account_Id__c;
                        ExHeReport.Proposal__c = YearExp.Expense_Master__r.Proposals__c;
                        expheadReportList.add(ExHeReport);
                    }
                    else if(exp.Year_Detail__c == '3'){
                        Expense_Head_Report__c ExHeReport = new Expense_Head_Report__c();
                        ExHeReport.Expense_Head_Name__c = exp.Name;
                        ExHeReport.Year_3_ELI__c = exp.ELI__c;
                        ExHeReport.Account__c = exp.Account_Id__c;
                        ExHeReport.Proposal__c = YearExp.Expense_Master__r.Proposals__c;
                        expheadReportList.add(ExHeReport);
                    }
                }
                if(expheadReportList.size() > 0){
                    insert expheadReportList;
                    System.debug('expheadReportList ID ===> '+expheadReportList[0].Id);
                }
            }
        }catch(Exception e){
            System.debug('Error Message ==> '+e.getMessage() + ' && Error Line  ==> '+e.getLineNumber());
        }
        
    }
}