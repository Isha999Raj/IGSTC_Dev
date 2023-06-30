({
    doInit: function(component, event, helper) {
        // Retrieve Expense Head records related to the Proposal
        var action = component.get("c.getExpenseHeads");
        action.setParams({
            proposalId: component.get("v.recordId") 
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var expenseHeads = response.getReturnValue();
                component.set("v.expenseHeads", expenseHeads);
            } else {
                // Handle error state
            }
        });
        $A.enqueueAction(action);
    },
    
    saveExpenseDetails : function(component, event, helper) {
        debugger;
        var expenseHeads = component.get("v.expenseHeads");
        for(var i = 0; i < expenseHeads.length; i++){
            if(expenseHeads[i].Year_1_Approved_Amount__c > expenseHeads[i].ELI__c){
                alert("Approved Amount is exceeding!");
                return;
            }
        }
        helper.showSpinner(component);
        var action = component.get("c.saveDetails");
        action.setParams({
            "expenseHeads" : component.get("v.expenseHeads")
        });
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                helper.hideSpinner(component);
                var result = response.getReturnValue();
                if(result != null){
                    let ToastMessage = component.get("c.showInfo");
                    $A.enqueueAction(ToastMessage);
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                    $A.get('e.force:refreshView').fire();
                }
            } 
        });
		$A.enqueueAction(action);
	},
    
    showInfo : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'SUCCESS',
            message: 'Details have been saved successfully..',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    }
})