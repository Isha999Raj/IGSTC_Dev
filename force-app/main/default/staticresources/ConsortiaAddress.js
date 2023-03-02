angular.module('cp_app').controller('address_ctrl', function($scope,$rootScope) {

    $scope.siteURL = siteURL;

    $scope.getDependentPicklistValues = function(){
        debugger;
        $scope.indianStates = [];
        $scope.germanStates = [];
        ApplicantPortal_Contoller.getFieldDependencies('Contact','Country__c','States__c', function(result,event){
            debugger;
            if(event.status && result != null){
                debugger;
                $scope.indianStates = result.India;
                $scope.germanStates = result.Germany;
                $scope.allStates = result.India.concat(result.Germany);
                $scope.$apply();
            }
        }
        )  
    }
    $scope.getDependentPicklistValues();

    $scope.getAddressDetails = function(){
        debugger;
        ApplicantPortal_Contoller.getAddressDetails($rootScope.userId, function(result, event){
            if(event.status) {
                debugger;
                $scope.addressDetails = result;
                    if($scope.addressDetails.BillingCountry == 'India'){
                        $scope.addressDetails.stateList = $scope.indianStates;
                    }else if($scope.addressDetails.BillingCountry == 'Germany'){
                        $scope.addressDetails.stateList = $scope.germanStates; 
                    }
                //$scope.addressDetails.ShippingCountry = $scope.addressDetails.BillingCountry; 
                $scope.$apply();
            }
        },
            {escape: true}
        )
    }
    $scope.getAddressDetails();

    $scope.redirectPageURL = function (pageName){
        var link = document.createElement("a");
        link.id = 'someLink'; //give it an ID!
        link.href = "#/" + pageName;
        link.click();
    }

    $scope.saveAddressDetails = function(){
        debugger;

        if($scope.addressDetails.Name == undefined || $scope.addressDetails.Name == ""){
            swal("Address Details", "Please Enter Institution/Industry Name.");
            $("#inst").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.Contacts[0].Name == undefined || $scope.addressDetails.Contacts[0].Name == ""){
            swal("Address Details", "Please Enter Head of Project.");
            $("#head").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.Contacts[0].Phone == undefined || $scope.addressDetails.Contacts[0].Phone == ""){
            swal("Address Details", "Please Enter Phone.");
            $("#phone").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.Contacts[0].Department == undefined || $scope.addressDetails.Contacts[0].Department == ""){
            swal("Address Details", "Please Enter Department.");
            $("#dept").addClass('border-theme');
                return;
        }

        if($scope.addressDetails.BillingStreet == undefined || $scope.addressDetails.BillingStreet == ""){
            swal("Address Details", "Please Enter Street.");
            $("#IStreet").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.BillingCity == undefined || $scope.addressDetails.BillingCity == ""){
            swal("Address Details", "Please Enter City.");
            $("#ICity").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.BillingCountry == undefined || $scope.addressDetails.BillingCountry== ""){
            swal("Address Details", "Please Enter Country.");
            $("#ICountry").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.BillingState == undefined || $scope.addressDetails.BillingState == ""){
            swal("Address Details", "Please Enter State.");
            $("#IState").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.BillingPostalCode == undefined || $scope.addressDetails.BillingPostalCode == ""){
            swal("Address Details", "Please Enter Post Code.");
            $("#IPcode").addClass('border-theme');
                return;
        }

        if($scope.addressDetails.Industry__c == true){
            if($scope.addressDetails.Year_Of_Establishment__c == undefined || $scope.addressDetails.Year_Of_Establishment__c == ""){
                swal("Address Details", "Please Enter Year Of Establishment.");
                $("#establish").addClass('border-theme');
                return;
            }
            if($scope.addressDetails.Main_Business_Area__c == undefined || $scope.addressDetails.Main_Business_Area__c == ""){
                swal("Address Details", "Please Enter Main Business Area.");
                $("#business").addClass('border-theme');
                return;
            }
            if($scope.addressDetails.NumberOfEmployees == undefined || $scope.addressDetails.NumberOfEmployees == ""){
                swal("Address Details", "Please Enter Number Of Permanent Employees.");
                $("#employees").addClass('border-theme');
                return;
            }
            if($scope.addressDetails.Infrastructural_Facilities__c == undefined || $scope.addressDetails.Infrastructural_Facilities__c == ""){
                swal("Address Details", "Please Enter Infrastructural Facilities.");
                $("#facility").addClass('border-theme');
                return;
            }
            if($scope.addressDetails.Domain_Expertise_Available__c == undefined || $scope.addressDetails.Domain_Expertise_Available__c == ""){
                swal("Address Details", "Please Enter Domain Expertise Available/Existing.");
                $("#domain").addClass('border-theme');
                return;
            }
            if($scope.addressDetails.Ownership_Profile__c == undefined || $scope.addressDetails.Ownership_Profile__c == ""){
                swal("Address Details", "Please Enter Ownership profile.");
                $("#ownership").addClass('border-theme');
                return;
            }
            if($scope.addressDetails.Last_Year_s_Balance__c == undefined || $scope.addressDetails.Last_Year_s_Balance__c == ""){
                swal("Address Details", "Please Enter Last year's balance.");
                $("#balance").addClass('border-theme');
                return;
            }
        }

        $scope.contactList = [];  
        if($scope.addressDetails.Contacts != undefined){
            $scope.contactList.push($scope.addressDetails.Contacts[0]);
        }
        $scope.addressDetails['Shipping_State__c'] = $scope.addressDetails['BillingState'];
        // $scope.addressDetails.NumberOfEmployees = Number($scope.addressDetails.NumberOfEmployees);

        delete ($scope.addressDetails['Contacts']);
        delete ($scope.addressDetails['$$hashKey']);
        delete ($scope.addressDetails['stateList']);
         debugger;
        ApplicantPortal_Contoller.saveAddressDetails($scope.addressDetails,$scope.contactList, function(result,event){
            debugger;
            if(event.status){
                debugger;
                Swal.fire(
                    'Success',
                    'Consortia Details has been saved successfully.',
                    'success'
                );
                $scope.disableSubmit = true; 
                $scope.redirectPageURL('ConsortiaContacts');
            }
        },
        {escape:true}
        )
    }

    $scope.removeClass2=function(controlid){
        $("#"+controlid+"").removeClass('border-theme');
      }
});