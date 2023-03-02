angular.module('cp_app').controller('financialdetails_ctrl', function($scope, $rootScope){
   
    $scope.siteURL = siteURL;
    $rootScope.projectId;
    $scope.expenseHeadList = [];
    $scope.listOfItems = [];

    $scope.getExpenseDetails = function(){
        debugger;
        ApplicantPortal_Contoller.getExpenseDetailsOfAccount($rootScope.userId, function(result,event){
            debugger;
            console.log("onload data");
            console.log(result);
            if(event.status && result!=null){
                debugger;
                $scope.expenseHeadList = result;

                    for(var i=0;i<$scope.expenseHeadList.length;i++){
                        
                      for(var j=0;j<$scope.expenseHeadList[i].exHeadWrapper.length;j++){
                        if($scope.expenseHeadList[i].exHeadWrapper[j].expenseLineItemList.length <= 0){
                            debugger;
                            $scope.expenseHeadList[i].exHeadWrapper[j].expenseLineItemList.push({"Multiplier__c":"","Expense_Head__c":$scope.expenseHeadList[i].exHeadWrapper[j].expenseHead.Id,"Total_Expense__c":""});
                        }
                      }  
                    }
                    debugger;
                    $scope.$apply();
            }
        },
        {escape:true}
        ) 
    }
    $scope.getExpenseDetails();

    $scope.redirectPageURL = function(pageName){
        debugger;
        var link=document.createElement("a");
        link.Id = 'someLink';
        link.href="#/"+pageName;
        link.click();
    }

    $scope.submitDetails = function(){
       debugger;

       for(let i=0; i<$scope.expenseHeadList.length; i++){
            delete ($scope.expenseHeadList[i]['Name']);
            delete ($scope.expenseHeadList[i]['$$hashKey']);
            for(var j=0;j<$scope.expenseHeadList[i].exHeadWrapper.length;j++){
                delete ($scope.expenseHeadList[i].exHeadWrapper[j]['$$hashKey']);
                delete ($scope.expenseHeadList[i].exHeadWrapper[j].expenseHead.Expense_Line_Items__r);
                for(var k=0;k<$scope.expenseHeadList[i].exHeadWrapper[j].expenseLineItemList.length;k++){
                    delete ($scope.expenseHeadList[i].exHeadWrapper[j].expenseLineItemList[k]['$$hashKey']);
                    $scope.listOfItems.push($scope.expenseHeadList[i].exHeadWrapper[j].expenseLineItemList[k]);
                }
            }
       }

         debugger;
         ApplicantPortal_Contoller.saveExpenseDetails($scope.listOfItems,function(result,event){
            debugger;
            if(event.status && result!=null){
                Swal.fire(
                    'Success',
                    'Financial detail has been saved successfully.',
                    'success'
                );
                $scope.redirectPageURL('Curriculum_vitae');
                $scope.$apply();
            }
         },
         {escape:true}
         )
    }

    $scope.addLineItems = function(param1,param2){
        debugger;
        if($scope.expenseHeadList[param1].exHeadWrapper[param2]){
            $scope.expenseHeadList[param1].exHeadWrapper[param2].expenseLineItemList.push({"Multiplier__c":"","Expense_Head__c":$scope.expenseHeadList[param1].exHeadWrapper[param2].expenseHead.Id});
        }else{
            $scope.expenseHeadList[param1].exHeadWrapper[param2].expenseLineItemList = [{"Multiplier__c":"","Expense_Head__c":$scope.expenseHeadList[param1].exHeadWrapper[param2].expenseHead.Id}];
        }
        $scope.$apply();
    }

    $scope.deleteLineItems = function (param1,param2,param3) {
        debugger;
        if ($scope.expenseHeadList[param1].exHeadWrapper[param2].expenseLineItemList.length > 1){
            if($scope.expenseHeadList[param1].exHeadWrapper[param2].expenseLineItemList[param3].Id != undefined){
                $scope.deleteExpenseLineItems($scope.expenseHeadList[param1].exHeadWrapper[param2].expenseLineItemList[param3].Id);
            }
            $scope.expenseHeadList[param1].exHeadWrapper[param2].expenseLineItemList.splice(param3, 1);
        }
    }


    $scope.deleteExpenseLineItems = function(lineItemId){
        ApplicantPortal_Contoller.deleteExpenseLineItems(lineItemId, function (result, event) {
            if (event.status) {
                debugger;
                Swal.fire(
                    'Success',
                    'Deleted Succesfully.',
                    'success'
                );
                $scope.$apply();
            }
        },
            {escape: true}
            )
    }
});