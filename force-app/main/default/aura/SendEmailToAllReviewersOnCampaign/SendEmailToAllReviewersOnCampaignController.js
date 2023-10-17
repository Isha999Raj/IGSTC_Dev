({
    doInit : function(component, event, helper) {
        var action = component.get("c.runBatchClass");
        action.setParams({
            campId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var toastEvent = $A.get("e.force:showToast");
            if(response.getState()==='SUCCESS'){
                toastEvent.setParams({
                    title : 'Success',
                    message: 'Email has been sent to assigned reviewers...',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
            }
            else {
                // var errors= response.getError();
                toastEvent.setParams({
                    title : 'Sent Error',
                    message: 'We cant send this Email to the Reviewer.',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'sticky'
                });
            }
            // setTimeout(()=>{  
            //     var stdModal = document.getElementsByClassName("uiModal forceModal");    
            //     stdModal.forEach(function(a, b) {
            //     $A.util.addClass(a, "slds-hide");
            //     });        
            // },10);
            toastEvent.fire();
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        });
        $A.enqueueAction(action);
    },

    handleCancel: function(component, event, helper) {
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})