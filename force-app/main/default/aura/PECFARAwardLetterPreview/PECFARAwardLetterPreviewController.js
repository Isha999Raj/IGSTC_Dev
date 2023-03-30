({
	doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getRelatedList");
        action.setParams({
            "recordId" : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.contactList', result);  
                
            }
        });
        $A.enqueueAction(action);
    },
    checkboxSelect : function(component, event, helper) {
        debugger;
           var selectedaccId= document.querySelector('input[name="options"]:checked').id;
           component.set("v.currentContactId",selectedaccId);
    },
    handleClick : function(component, event, helper) {
        debugger;
        let callMethod = component.get("c.getFellow");
        $A.enqueueAction(callMethod);
        //alert("PDF")
    },
    getFellow : function(component, event, helper) {
        debugger;
        var action= component.get("c.getFellowshipType");
        action.setParams({
            "conId" : component.get("v.currentContactId")
        });
        action.setCallback(this, function(response){
            if(response.getState() === "SUCCESS"){
                var result = response.getReturnValue();
                component.set('v.previewClicked', true);  
                
            }
            else{
                alert(JSON.stringify(response.getError()));
            }
        });
        window.setTimeout( 
            $A.getCallback(function(){ 
                component.set("v.showSpinner", false); 
                helper.helperMethod(component, event);
            }), 15000 
        );
        $A.enqueueAction(action);
    },
    
    handleSend: function(component, event, helper) {
        debugger;
        var action = component.get("c.sendProposal2");
        action.setParams({
            conId : component.get("v.currentContactId")
        });
        
        action.setCallback(this,function(e){
            var toastEvent = $A.get("e.force:showToast");
            if(e.getState()==='SUCCESS'){
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Award letter Sent Successfully',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
            }
            else if(e.getState() ==='ERROR') {
                var errors= response.getError();
                toastEvent.setParams({
                    title : 'Sent Error',
                    message: errors[0].message,
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'sticky'
                });
            }
            toastEvent.fire();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        });
        $A.enqueueAction(action);  
    },
    
    handleCancel: function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
})