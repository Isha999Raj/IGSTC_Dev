
angular.module('cp_app').controller('singHost_ctrl', function($scope,$rootScope, fileReader){
     $scope.objContact = {};
     $rootScope.projectId;
    debugger;

    $scope.checkEmail = function(email,contId){
      debugger;
      $scope.emailCheck = false;
      if(contId == undefined){
        contId = "";
      }
      ApplicantPortal_Contoller.checkEmail(email,contId,function(result,event){
        debugger;
        if(event.status){
          debugger;
          if(result.length > 0){
            $scope.emailCheck = true;
          }else{
            $scope.emailCheck = false;
          }
          $scope.$apply();
        }
      })

    }

     $scope.getHostSing = function(){
        debugger;
        ApplicantPortal_Contoller.getHostSing($rootScope.projectId,function(result,event){
            debugger;
            if(event.status && result){
                $scope.hostDetails = result;
                $scope.contactDetails = result.Contacts[0];
            }else{
                $scope.hostDetails = {"Name":"","Email__c":""};
                $scope.contactDetails = {"LastName":"","Email":""};
            }
            $scope.$apply();
        })
     }
     $scope.getHostSing();

     $scope.saveHostDetails = function(){
        debugger;

        if($scope.hostDetails.Name == undefined || $scope.hostDetails.Name == ""){
            swal("info", "Please enter Host Organization Name.","info");
            $("#name").addClass('border-theme');
            return;
          }

          if($scope.hostDetails.Email__c == undefined || $scope.hostDetails.Email__c == ""){
            swal("info", "Please enter Host Email.","info");
            $("#email").addClass('border-theme');
            return;
          }else{
            if($scope.valid($scope.hostDetails.Email__c)){
              swal(
                  'info',
                  'Check Host Registered Email.',
                  'info'
              );
              $("#email").addClass('border-theme');
              return;
          }
          }
          if($scope.hostDetails.Phone == undefined || $scope.hostDetails.Phone == ""){
            swal("info", "Please enter Host Mobile no.","info");
            $("#mobile").addClass('border-theme');
            return;
          }
        //   if($scope.hostDetails.BillingStreet == undefined || $scope.hostDetails.BillingStreet == ""){
        //     swal("info", "Please Enter First Name.","info");
        //     $("#txtFirstName").addClass('border-theme');
        //     return;
        //   }
        //   if($scope.hostDetails.BillingCity == undefined || $scope.hostDetails.BillingCity == ""){
        //     swal("info", "Please Enter First Name.","info");
        //     $("#txtFirstName").addClass('border-theme');
        //     return;
        //   }
          if($scope.hostDetails.BillingCountry == undefined || $scope.hostDetails.BillingCountry == ""){
            swal("info", "Please enter Host Country.","info");
            $("#country").addClass('border-theme');
            return;
          }
          if($scope.hostDetails.BillingState == undefined || $scope.hostDetails.BillingState == ""){
            swal("info", "Please enter Host State.","info");
            $("#state").addClass('border-theme');
            return;
          }
          if($scope.hostDetails.BillingPostalCode == undefined || $scope.hostDetails.BillingPostalCode == ""){
            swal("info", "Please enter Host Pin Code.","info");
            $("#pin").addClass('border-theme');
            return;
          }

          //COORDINATOR

          if($scope.contactDetails.FirstName == undefined || $scope.contactDetails.FirstName == ""){
            swal("info", "Please enter Host collaborator First Name.","info");
            $("#fname").addClass('border-theme');
            return;
          }
          if($scope.contactDetails.LastName == undefined || $scope.contactDetails.LastName == ""){
            swal("info", "Please enter Host collaborator Last Name.","info");
            $("#lname").addClass('border-theme');
            return;
          }
          if($scope.contactDetails.Nationality__c == undefined || $scope.contactDetails.Nationality__c == ""){
            swal("info", "Please enter Host collaborator Nationality.","info");
            $("#selectNatinality").addClass('border-theme');
            return;
          }
          if($scope.contactDetails.Email == undefined || $scope.contactDetails.Email == ""){
            swal("info", "Please enter Host collaborator Email.","info");
            $("#email2").addClass('border-theme');
            return;
          }else{
            if($scope.valid($scope.contactDetails.Email)){
              swal(
                  'info',
                  'Check Your Registered Email.',
                  'info'
              );
              $("#email2").addClass('border-theme');
              return;
          }
          }
          if($scope.contactDetails.MobilePhone == undefined || $scope.contactDetails.MobilePhone == ""){
            swal("info", "Please enter Host collaborator Mobile no.","info");
            $("#mobile2").addClass('border-theme');
            return;
          }
          if($scope.contactDetails.Designation__c == undefined || $scope.contactDetails.Designation__c == ""){
            swal("info", "Please enter Host collaborator Designation.","info");
            $("#designation").addClass('border-theme');
            return;
          }
          if($scope.contactDetails.Department == undefined || $scope.contactDetails.Department == ""){
            swal("info", "Please enter Host collaborator Department.","info");
            $("#dept").addClass('border-theme');
            return;
          }
          if($scope.contactDetails.MailingCountry == undefined || $scope.contactDetails.MailingCountry == ""){
            swal("info", "Please enter Host collaborator Country.","info");
            $("#country2").addClass('border-theme');
            return;
          }
          if($scope.contactDetails.MailingState == undefined || $scope.contactDetails.MailingState == ""){
            swal("info", "Please enter Host collaborator State.","info");
            $("#state2").addClass('border-theme');
            return;
          }
          if($scope.contactDetails.MailingPostalCode == undefined || $scope.contactDetails.MailingPostalCode == ""){
            swal("info", "Please enter Host collaborator Pin Code.","info");
            $("#pin2").addClass('border-theme');
            return;
          }

          if($scope.emailCheck == true){
            swal('info','Collaborator Email already exists.','info');
            $("#email2").addClass('border-theme');
                return;
        }

        delete($scope.hostDetails['Contacts']);
        console.log($scope.hostDetails);
        debugger;
        ApplicantPortal_Contoller.saveHostDetails($scope.hostDetails,$scope.contactDetails,$rootScope.projectId,function(result,event){
            debugger;
            if(event.status){
                swal({
                    title: "SUCCESS",
                    text: 'Host details have been saved successfully.',
                    icon: "success",
                    button: "ok!",
               })  
               $scope.redirectPageURL('ProjectDetailsSing');  
            }else{
                swal({
                     title: "ERROR",
                     text: "Exception !",
                     icon: "error",
                     button: "ok!",
                });
           }
           $scope.$apply();
        })
     }
    
          $scope.redirectPageURL = function(pageName){
            debugger;
            var link=document.createElement("a");
            link.id = 'someLink'; //give it an ID!
            link.href="#/"+pageName;
            link.click();
        }

        $scope.valid = function(value){
            if(value!=undefined){
                 var x=value;
                 var atpos = x.indexOf("@");
                 var dotpos = x.lastIndexOf(".");
                if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length) {
                    
                    return true;
                }
                return false;
             }
         }

         $scope.checkEmail = function(email,contId){
            debugger;
            $scope.emailCheck = false;
            if(contId == undefined){
              contId = "";
            }
            ApplicantPortal_Contoller.checkEmail(email,contId,function(result,event){
              debugger;
              if(event.status){
                debugger;
                if(result.length > 0){
                  $scope.emailCheck = true;
                }else{
                  $scope.emailCheck = false;
                }
                $scope.$apply();
              }
            })
      
          }
    
          $scope.removeClass=function(controlid){
            $("#"+controlid+"").removeClass('border-theme');
          } 
});

