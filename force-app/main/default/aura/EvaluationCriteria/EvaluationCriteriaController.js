({
	doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getEvaluationRecords");
        action.setParams({
            proposalId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
                var result = response.getReturnValue();
                if(result != null){
                    component.set("v.EvaluationRecordsList",result);
                }
            } 
        });
		$A.enqueueAction(action);
	},
    
    SaveEvaluationRecords : function(component, event, helper) {
        debugger;
        var action = component.get("c.saveEvaluationRecords");
        action.setParams({
            "evaluationRecordList" : component.get("v.EvaluationRecordsList")
        });
        action.setCallback(this,function(response){
            if(response.getState() === 'SUCCESS'){
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
    
    handleyesCheckboxChange : function(component, event, helper) {
        debugger;
        var yesCheck = event.getSource().get("v.value");
        component.set("v.yesCheck", !yesCheck);
	},
    
    showInfo : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'SUCCESS',
            message: 'Eligibility checked successfully !!!!',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    }
    
})