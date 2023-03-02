angular.module('cp_app').controller('ProjectHandleGrantPageCtrl', function($scope,$rootScope){
     // $rootScope.projectId;
     // $scope.ExistingGranttList = [];
     // $scope.inputToPass = [];
     // $scope.AccountName;
     // $scope.startDate;
     // $scope.eg = [];
     // $rootScope.userId;

     // debugger;
     // $scope.getExistingGrantDetails = function(){
     //      HostProjectDetailController.getgarntList($rootScope.userId, function(result, event){
     //           debugger;
     //          if(event.status){
     //                if(result.Existing_Grants__r == undefined){
     //                     result.Existing_Grants__r = [{
     //                          "Title__c": "",
     //                          "Funding_Agency__c": "",
     //                          "Budget__c":"",
     //                          "Starting_Date__c":"",
     //                          "Duration__c":"",
     //                          "Account__c": result.Id
     //                      }];
                         
     //           }

     //                if(result.Existing_Grants__r != undefined){
     //                     for (let j = 0; j < result.Existing_Grants__r.length; j++) {
     //                          if(result.Existing_Grants__r[j].Starting_Date__c != undefined && result.Existing_Grants__r[j].Starting_Date__c != ""){
     //                               result.Existing_Grants__r[j].Starting_Date__c = new Date(result.Existing_Grants__r[j].Starting_Date__c);
     //                            }
     //                     }
     //                }

     //           $scope.inputToPass.push(result);
                  
     //          }
     //          $scope.$apply();
     //      },
     //      {escape: true}
     //      )
     // }
     // $scope.getExistingGrantDetails();

     // $scope.addRowsWorkPackage = function () {
     //      debugger;

     //                $scope.inputToPass[0].Existing_Grants__r.push({

     //                     "Title__c": "",
     //                     "Funding_Agency__c": "",
     //                     "Budget__c":"",
     //                     "Starting_Date__c":"",
     //                     "Duration__c":"",
     //                     "Account__c": $scope.inputToPass[0].Id
     //                 });
              
     //      }
        
      
      

     //  // Delete

     //  $scope.removeRow = function (index) {
     //      debugger;
     //      if ($scope.inputToPass[0].Existing_Grants__r[index].length == 1) {
     //          return;
     //      }
     //      if($scope.inputToPass[0].Existing_Grants__r[index].Id == undefined){
     //           $scope.inputToPass[0].Existing_Grants__r.splice(index, 1);
     //          return;
     //      }
     //      HostProjectDetailController.deleteExistGrant($scope.inputToPass[0].Existing_Grants__r[index].Id, function (result, event) {
     //         //  alert("Method Called")
     //          if (event.status && result !=null) {
     //             // swal("Success", "Record Deleted Successfully");
     //              $scope.inputToPass[0].Existing_Grants__r.splice(index, 1);
     //              console.log("$scope.ExistingGranttList ::"+$scope.inputToPass)
     //          }
     //          $scope.$apply();
     //      });
     //  }

     //   // Delete


     //   $scope.previousPage = function(){
     //      debugger;
     //      $scope.redirectPageURL('TwoReferenceWiser');
     //      // window.location.replace(window.location.origin+'/ApplicantDashboard/ApplicantPortal?id='+$rootScope.userId+'#/TwoReferenceWiser');
     //   }

     //  $scope.saveParticipants = function(index){
     //      debugger;

     //           var startDay =0;
     //           var startMonth =0;
     //           var startYear =0;
     //           var today = new Date();
     //           var dd = today.getDate();
     //           var mm = today.getUTCMonth() + 1; //January is 0!
     //           var yyyy = today.getUTCFullYear();
     //           $scope.accountList = [];
     //           $scope.hostFromAccount = [];
             
     //           for(var i=0;i<$scope.inputToPass.length;i++){
     //                $scope.accountList.push($scope.inputToPass[i]);
     //                for(let j=0;j<$scope.accountList[i].Existing_Grants__r.length;j++){
     //                     $scope.hostFromAccount.push($scope.accountList[i].Existing_Grants__r[j]);
     //                }
     //           }

     //           for(var i=0;i<$scope.hostFromAccount.length;i++){
     //                if($scope.hostFromAccount[i].Title__c == undefined || $scope.hostFromAccount[i].Title__c == ""){
     //                     swal("info", "Please enter title.","info");
     //                     // $("#title").addClass('border-theme');
     //                     $("#title"+i+"").addClass('border-theme');
     //                     return;
     //                }
     //                if($scope.hostFromAccount[i].Funding_Agency__c == undefined || $scope.hostFromAccount[i].Funding_Agency__c == ""){
     //                     swal("info", "Please enter funding agency.","info");
     //                     // $("#funding").addClass('border-theme');
     //                     $("#funding"+i+"").addClass('border-theme');
     //                     return;
     //                }
     //                if($scope.hostFromAccount[i].Budget__c == undefined || $scope.hostFromAccount[i].Budget__c == ""){
     //                     swal("info", "Please enter budget.","info");
     //                     // $("#budget").addClass('border-theme');
     //                     $("#budget"+i+"").addClass('border-theme');
     //                     return;
     //                }
     //                if($scope.hostFromAccount[i].Starting_Date__c == undefined || $scope.hostFromAccount[i].Starting_Date__c == ""){
     //                     swal("info", "Please enter starting date.","info");
     //                     // $("#startDate").addClass('border-theme');
     //                     $("#startDate"+i+"").addClass('border-theme');
     //                     return;
     //                }
     //                if($scope.hostFromAccount[i].Starting_Date__c > today){
     //                     swal("info", "Starting date should not be future date.","info");
     //                     // $("#startDate").addClass('border-theme');
     //                     $("#startDate"+i+"").addClass('border-theme');
     //                     return; 
     //                }
     //                if($scope.hostFromAccount[i].Duration__c == undefined || $scope.hostFromAccount[i].Duration__c == ""){
     //                     swal("info", "Please enter duration.","info");
     //                     // $("#duration").addClass('border-theme');
     //                     $("#duration"+i+"").addClass('border-theme');
     //                     return;
     //                }
     //           }


     //      for(var i=0; i<$scope.hostFromAccount.length;i++){
     //           delete($scope.hostFromAccount[i]['$$hashKey']);
     //           var EGRecord = {"startDay":0,"startMonth":0,"startYear":0,"accId":$scope.hostFromAccount[i].Account__c,
     //           EGList:{
     //            Id:$scope.hostFromAccount[i].Id,"Title__c":$scope.hostFromAccount[i].Title__c,"Funding_Agency__c":$scope.hostFromAccount[i].Funding_Agency__c,
     //            "Budget__c":$scope.hostFromAccount[i].Budget__c,"Duration__c":$scope.hostFromAccount[i].Duration__c,Account__c:$scope.hostFromAccount[i].Account__c
     //           }};
              
     //           if($scope.hostFromAccount[i].Starting_Date__c != undefined && $scope.hostFromAccount[i].Starting_Date__c != ''){
     //                console.log("Date::"+ $scope.hostFromAccount[i].Starting_Date__c.getUTCFullYear());
     //                EGRecord.startYear = $scope.hostFromAccount[i].Starting_Date__c.getUTCFullYear();
     //                EGRecord.startMonth = $scope.hostFromAccount[i].Starting_Date__c.getUTCMonth()+1;
     //                EGRecord.startDay = $scope.hostFromAccount[i].Starting_Date__c.getDate();
     //           }
     //           $scope.eg.push(EGRecord);
     //      }
     //      HostProjectDetailController.insertExistingGrantsListApex($scope.eg, function(result,event){
     //           if(event.status && result !=null){
     //                console.log("Result ::"+result);
                   
                   
     //                swal({
     //                     title: "Success",
     //                     text:  'Your Existing Grant has been saved successfully.',
     //                     icon: "success",
     //                   button: "ok!",
     //              });
     //              $scope.redirectPageURL('CV_Wiser');
                  
     //      // window.location.replace('https://dev-igstc.cs114.force.com/ApplicantDashboard/ApplicantPortal?id='+$rootScope.userId+'#/AttachmentsInWiser');
     //           }else{
     //                swal({
     //                     title: "Error",
     //                     text: "Exception!",
     //                     icon: "error",
     //                     button: "ok!",
     //                   });
     //           }
     //      })
     //  }

     //  $scope.redirectPageURL = function(pageName){
     //      debugger;
     //      var link=document.createElement("a");
     //      link.id = 'someLink'; //give it an ID!
     //      link.href="#/"+pageName;
     //      link.click();
     //  }

     //  $scope.removeClass=function(controlid,index){

     //      var controlIdfor=controlid+""+index;

     //      $("#"+controlIdfor+"").removeClass('border-theme');

     //    }

     debugger;
    $scope.siteURL = siteURL;
    $scope.applicantDetails = [];
    $scope.input=[];
    $scope.disableGrants = [];
    var statusLoginHas=0;

    $scope.getApplicantDetails = function(){
     HostProjectDetailController.getApplicantDetailsForGrantWISER($rootScope.contactId, function (result, event){
            if(event.status) {
                debugger;
                $scope.applicantDetails = result;
                $scope.grants = [];
                for(var i=0;i<$scope.applicantDetails.length;i++){
                    statusLoginHas=0;
                    if ($scope.applicantDetails[i].Contacts != undefined){
                        for(j = 0; j < $scope.applicantDetails[i].Contacts.length; j++){
                            if ($scope.applicantDetails[i].Contacts[j].Login_Hash_Code__c == $rootScope.userId){
                                $scope.input.push($scope.applicantDetails[i]);
                                statusLoginHas=1;
                            }
                        }
                    }
                    if(statusLoginHas==0){
                        $scope.disableGrants.push($scope.applicantDetails[i]);
                    }
                }
                for(var i=0;i<$scope.input.length;i++){
                    if($scope.input[i].Existing_Grants__r != undefined){
                        for(var j=0;j<$scope.input[i].Existing_Grants__r.length;j++){
                            if($scope.input[i].Existing_Grants__r[j].Starting_Date__c != undefined){
                                $scope.input[i].Existing_Grants__r[j].Starting_Date__c   = new Date($scope.input[i].Existing_Grants__r[j].Starting_Date__c);
                            }
                        }
                            
                    }else if($scope.input[i].Existing_Grants__r == undefined){
                        var rec = {
                            'Account__r.Name':$scope.input[i].Name,
                            'Title__c': '',
                            'Funding_Agency__c': '',
                            'Duration__c': '',
                            'Budget__c': '',
                            'Starting_Date__c': '',
                            'Account__c': $scope.input[i].Id,
                            'Application__c': $scope.input[i].Proposals__c
                        };
                        $scope.input[i].Existing_Grants__r = [];
                        debugger;
                        $scope.input[i].Existing_Grants__r.push(rec);
                    }
                }
                for(var i=0;i<$scope.disableGrants.length;i++){
                    if($scope.disableGrants[i].Existing_Grants__r != undefined){
                      for(var j=0;j<$scope.disableGrants[i].Existing_Grants__r.length;j++){
                        if($scope.disableGrants[i].Existing_Grants__r[j].Starting_Date__c != undefined){
                            var date = new Date($scope.disableGrants[i].Existing_Grants__r[j].Starting_Date__c);
                            var year = date.getUTCFullYear();
                            var month = date.getMonth()+1;
                            var day = date.getDate();
                            $scope.disableGrants[i].Existing_Grants__r[j].Starting_Date__c   = year.toString()+'-'+month.toString()+'-'+day.toString();
                    }
                }
            }
        }
                    
                    var existingGrant = [{"title":"","fundingagency":"","Account":"","AccountName":"","duration":"","budget":"","id":"","startingyear":0,"startingmonth":0,"startingday":0,"Application":""}];
                    $scope.grants.push(existingGrant);
                $scope.$apply();
            }
        },
        {escape: true}
        )
    }

    $scope.getApplicantDetails();

    $scope.submitExistingGrants = function(){
        debugger;
        for(var i=0;i<$scope.input.length;i++){
            for(var j=0;j<$scope.input[i].Existing_Grants__r.length;j++){
                if($scope.input[i].Existing_Grants__r[j].Funding_Agency__c == undefined || $scope.input[i].Existing_Grants__r[j].Funding_Agency__c == ""){
                    swal("Existing Grants", "Please Enter Funding Agency.");
                    return;
                }
                if($scope.input[i].Existing_Grants__r[j].Budget__c == undefined || $scope.input[i].Existing_Grants__r[j].Budget__c == ""){
                    swal("Existing Grants", "Please Enter Budget.");
                    return;
                }
                if($scope.input[i].Existing_Grants__r[j].Starting_Date__c == undefined || $scope.input[i].Existing_Grants__r[j].Starting_Date__c == ""){
                    swal("Existing Grants", "Please Enter Starting Date.");
                    return;
                }
                if($scope.input[i].Existing_Grants__r[j].Duration__c == undefined || $scope.input[i].Existing_Grants__r[j].Duration__c == ""){
                    swal("Existing Grants", "Please Enter Duration(Number in months).");
                    return;
                }
            }
        }
        $scope.grantList = [];
        for(let i=0; i<$scope.grants.length; i++){
            delete ($scope.grants[i]['Name']);
            delete ($scope.grants[i]['$$hashKey']);
          
            for(let j=0; j<$scope.input[i].Existing_Grants__r.length; j++){
                if($scope.input[i].Existing_Grants__r[j].Budget__c == undefined || $scope.input[i].Existing_Grants__r[j].Budget__c == ""){
                    $scope.input[i].Existing_Grants__r[j].Budget__c = 0;
                    // Number('$scope.applicantDetails[i].Existing_Grants__r[j].Budget__c');
                }
                if($scope.input[i].Existing_Grants__r[j].Duration__c == undefined || $scope.input[i].Existing_Grants__r[j].Duration__c == ""){
                    $scope.input[i].Existing_Grants__r[j].Duration__c = 0;
                    // Number('$scope.applicantDetails[i].Existing_Grants__r[j].Duration__c'); 
                }
                var grantApplication = {"title":"","fundingagency":"","Account":$scope.input[i].Id,"AccountName":$scope.input[i].Name,"duration":"","budget":"","id":"","startingyear":0,"startingmonth":0,"startingday":0,"Application":""};
                    grantApplication.Account = $scope.input[i].Id;
                    grantApplication.Application = $scope.input[i].Proposals__c;
                    grantApplication.AccountName = $scope.input[i].Name;
                    grantApplication.id = $scope.input[i].Existing_Grants__r[j].Id;
                    grantApplication.title = $scope.input[i].Existing_Grants__r[j].Title__c;
                    grantApplication.fundingagency = $scope.input[i].Existing_Grants__r[j].Funding_Agency__c;
                    grantApplication.duration = $scope.input[i].Existing_Grants__r[j].Duration__c;
                    grantApplication.budget = $scope.input[i].Existing_Grants__r[j].Budget__c;
                    $scope.grantList.push(grantApplication);
    
                if($scope.input[i].Existing_Grants__r[j].Starting_Date__c != undefined && $scope.input[i].Existing_Grants__r[j].Starting_Date__c != ""){
                    grantApplication.startingyear = $scope.input[i].Existing_Grants__r[j].Starting_Date__c.getUTCFullYear();
                    grantApplication.startingmonth = $scope.input[i].Existing_Grants__r[j].Starting_Date__c.getUTCMonth()+1;
                    grantApplication.startingday = $scope.input[i].Existing_Grants__r[j].Starting_Date__c.getDate();
                }else{
                    delete ($scope.input[i].Existing_Grants__r[j].Starting_Date__c);     
                }
    
                delete ($scope.input[i].Existing_Grants__r[j].Starting_Date__c);
            }
        }
        HostProjectDetailController.insertExistingGrantsWISER($scope.grantList, function(result, event){
          if(event.status && result !=null){
                              console.log("Result ::"+result);
                             
                             
                              swal({
                                   title: "Success",
                                   text:  'Your Existing Grant has been saved successfully.',
                                   icon: "success",
                                 button: "ok!",
                            });
                            $scope.redirectPageURL('CV_Wiser');
                            
                    // window.location.replace('https://dev-igstc.cs114.force.com/ApplicantDashboard/ApplicantPortal?id='+$rootScope.userId+'#/AttachmentsInWiser');
                         }else{
                              swal({
                                   title: "Error",
                                   text: "Exception!",
                                   icon: "error",
                                   button: "ok!",
                                 });
                         }
                    })
                }
    
    $scope.addRow = function (index) {
        debugger;
        var rec = {
            'Account__r.Name':$scope.input[index].Name,
            'Title__c': '',
            'Funding_Agency__c': '',
            'Duration__c': '',
            'Budget__c': '',
            'Starting_Date__c': '',
            'Account__c': $scope.input[index].Id,
            'Application__c': $scope.input[index].Proposals__c
        };
        $scope.input[index].Existing_Grants__r.push(rec);
    }

    $scope.deleteRow = function (param1,param2) {
        debugger;
        if ($scope.input[param1].Existing_Grants__r.length > 1){
            if($scope.input[param1].Id != undefined){
                $scope.deleteGrants($scope.input[param1].Existing_Grants__r[param2].Id);
            }
            $scope.input[param1].Existing_Grants__r.splice(param2, 1);
        }
    }

    $scope.deleteGrants = function(grantstId){
        ApplicantPortal_Contoller.deleteGrants(grantstId, function (result, event) {
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

    $scope.redirectPageURL = function(pageName){
        debugger;
        var link=document.createElement("a");
        link.id = 'someLink'; //give it an ID!
        link.href="#/"+pageName;
        link.click();
    }

    $scope.previousPage = function(){
          debugger;
          $scope.redirectPageURL('TwoReferenceWiser');
          // window.location.replace(window.location.origin+'/ApplicantDashboard/ApplicantPortal?id='+$rootScope.userId+'#/TwoReferenceWiser');
       }

});