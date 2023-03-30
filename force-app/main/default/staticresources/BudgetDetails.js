angular.module('cp_app').controller('budget_ctrl', function($scope, $rootScope){
    console.log('Intiated::');
    $scope.siteURL = siteURL;
    $rootScope.projectId;
    $scope.expenseDetails = false;
    $scope.accList = [];
    $scope.expenseList = [];
    $scope.accId = '';

    $scope.getContact = function(){
        debugger;
        ApplicantPortal_Contoller.getConSing($rootScope.userId,function(result,event){
            debugger;
            if(event.status && result){
                $scope.conRecord = result;
            }
            $scope.$apply();
            $scope.getExpenseRecords();
        })
    }
    $scope.getContact();


    $scope.getExpenseRecords = function(){
        debugger;
        IndustrialFellowshipController.getExpenseRecords($rootScope.projectId, function(result,event){
            console.log("declred expense list");
            console.log(result);
            debugger;
            if(event.status){
               if(result.length >0){
                   for(var i=0;i<result.length;i++){
                       if(result[i].Expense_Line_Items__r == undefined){
                           result[i].Expense_Line_Items__r  = [];
                           if($scope.conRecord.MailingCountry == "India"){
                            result[i].Expense_Line_Items__r.push( {"Expense_Head__c":result[i].Id,'Description__c': '',"Currency_Type__c":'INR'});
                           }else{
                            result[i].Expense_Line_Items__r.push( {"Expense_Head__c":result[i].Id,'Description__c': '',"Currency_Type__c":'EURO'});
                           }
                       }else{
                           result[i].Expense_Line_Items__r = result[i].Expense_Line_Items__r;
                       }
                      }
                   $scope.expenseList = result;
               }else{
               }
               $scope.$apply();   
            }
        },
        {escape: true}
        )
    } 
    
   

    $scope.addRow = function (param1) {
        debugger;
        $scope.expenseList[param1].Expense_Line_Items__r.push({
           'Description__c': '',
           "Expense_Head__c":$scope.expenseList[param1].Id
       });
        $scope.$apply();
        
    }

    $scope.deleteRow = function (param1, param2) {
        debugger;
        if ($scope.expenseList[param1].Expense_Line_Items__r.length > 1){
            $scope.expenseList[param1].Expense_Line_Items__r.splice(param2, 1);
        }
    }

$scope.saveExpenceLineitems = function(){
   $scope.expLineItem = [];
   debugger;

   for(var i=0;i< $scope.expenseList.length;i++){
       for (let j = 0; j < $scope.expenseList[i].Expense_Line_Items__r.length; j++) {
           delete($scope.expenseList[i].Expense_Line_Items__r[j]['$$hashKey']);
           $scope.expLineItem.push( $scope.expenseList[i].Expense_Line_Items__r[j]);
       }
   }

   if($scope.conRecord.MailingCountry == "India"){
    if($scope.year1 > 900000){
        swal("info", "Total Grants asked by IGSTC should not be more than 900000.","info");
        return;
    }
   }else{
        if($scope.year1Germany > 10000){
            swal("info", "Total Grants asked by IGSTC should not be more than 10000 €.","info");
            return;
        }
   }

   IndustrialFellowshipController.saveExpenceLineItem($scope.expLineItem,function(result,event){
       if(event.status && result != null){
               console.log(result);                    
           swal({
                title: "SUCCESS",
                text: 'Budget details have been saved successfully.',
                icon: "success",
                button: "ok!",
           })  
           $scope.redirectPageURL('AttachmentsSing');                  
         
      } else{
           swal({
                title: "ERROR",
                text: "Exception !",
                icon: "error",
                button: "ok!",
           });
      }
       
   })
}
    $scope.redirectPageURL = function(pageName){
        debugger;
        var link=document.createElement("a");
        link.id = 'someLink'; //give it an ID!
        link.href="#/"+pageName;
        link.click();
    }

    $scope.calculateOtherField=function(){
        debugger;
        $scope.year1 = 0;
        $scope.year1Germany = 0;
        for(var i=0;i<$scope.expenseList.length;i++){
            if($scope.conRecord.MailingCountry == "India"){
                if($scope.expenseList[i].Expense_Line_Items__r != undefined){
                    for(var j=0;j<$scope.expenseList[i].Expense_Line_Items__r.length;j++){
                        if($scope.expenseList[i].Expense_Line_Items__r[j].Year1_Expense__c != undefined){
                            $scope.year1 = $scope.year1+Number($scope.expenseList[i].Expense_Line_Items__r[j].Year1_Expense__c);
                        }
        
                    }
                }
            }else{
                if($scope.expenseList[i].Expense_Line_Items__r != undefined){
                    for(var j=0;j<$scope.expenseList[i].Expense_Line_Items__r.length;j++){
                        if($scope.expenseList[i].Expense_Line_Items__r[j].Year1_Expense__c != undefined){
                            $scope.year1Germany = $scope.year1Germany+Number($scope.expenseList[i].Expense_Line_Items__r[j].Year1_Expense__c);
                        }
        
                    }
                } 
            }
        }
        $scope.$apply();
    }
})