({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.generateTempForAwardDraft");
        action.setParams({
            proID : component.get("v.recordId")
        });
        action.setCallback(this,function(e){
            if(e.getState()=='SUCCESS'){
                var result=e.getReturnValue();
                component.set("v.fileId", result);
                component.set("v.showSpinner", false);
            }
            else{
                alert(JSON.stringify(e.getError()));
            }
        });
        $A.enqueueAction(action);  
    }
})