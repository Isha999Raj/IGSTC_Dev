angular.module('cp_app').controller('CV_Ctrl', function($scope,$rootScope) {
    debugger;
    $scope.siteURL = siteURL;
    $scope.AccountContactData=[];
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
                debugger;
                $scope.$apply();
            }
        }
        )  
    }
    $scope.getDependentPicklistValues();

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

    $scope.backComp=function(GrandIndex,index){
        debugger
        $("#educationDet"+GrandIndex+""+index+"").hide();
        $("#contactBasicDet"+GrandIndex+""+index+"").show();
    }

    $scope.updateContactDet=function(parentIndex,index){
        for(var i=0;i<$scope.AccountContactData[parentIndex].Lcon.length;i++){
            $('#contactBasicDet'+parentIndex+''+i+'').hide('slow');
            $('#educationDet'+parentIndex+''+i+'').hide('slow');
            $('#employementEx'+parentIndex+''+i+'').hide('slow');
            $('#publication'+parentIndex+''+i+'').hide('slow');
        }
        $("#contactBasicDet"+parentIndex+""+index+"").toggle('slow');       
    }

    $scope.addEducationRow=function(){
        debugger;
        $scope.allDetailList.Education_Details__r.push({
            Institution_Name__c:"",
            Contact__c: $scope.allDetailList.Id
        });
        $scope.$apply();
        debugger;
    }
    $scope.removeEducationRow=function(index){
        debugger;
        if($scope.allDetailList.Education_Details__r.length != 1){
            if($scope.allDetailList.Education_Details__r[index].Id != undefined && $scope.allDetailList.Education_Details__r[index].Id != ""){
                $scope.deleteEducationRow($scope.allDetailList.Education_Details__r[index].Id);
            }else{
                $scope.allDetailList.Education_Details__r.splice(index,1);
        }
    }
}

$scope.deleteEducationRow = function(eduId){
    ApplicantPortal_Contoller.deleteEducationWorkshop(eduId, function (result, event) {
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

    $scope.addEmploymentRow=function(index){
        debugger;
        $scope.allDetailList.Employment_Details__r.push({
            Organization_Name__c:"",
            Contact__c: $scope.allDetailList.Id
        });
        $scope.$apply();
        debugger;
    }
    $scope.removeEmploymentRow=function(index){
        debugger;
        if($scope.allDetailList.Employment_Details__r.length != 1){
            if($scope.allDetailList.Employment_Details__r[index].Id != undefined && $scope.allDetailList.Employment_Details__r[index].Id != ""){
                $scope.deleteEmploymentWorkshop($scope.allDetailList.Employment_Details__r[index].Id);
            }else{
                $scope.allDetailList.Employment_Details__r.splice(index,1);
        }
    }
 }

 $scope.deleteEmploymentWorkshop = function(empId){
    ApplicantPortal_Contoller.deleteEmploymentWorkshop(empId, function (result, event) {
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
        link.Id = 'someLink'; //give it an ID!
        link.href="#/"+pageName;
        link.click();
    }

    var inputQuantity = [];
    $(function() {     
      $(".zipcode-number").on("keyup", function (e) {
        var $field = $(this),
            val=this.value,
            $thisIndex=parseInt($field.data("idx"),10); 
        if (this.validity && this.validity.badInput || isNaN(val) || $field.is(":invalid") ) {
            this.value = inputQuantity[$thisIndex];
            return;
        } 
        if (val.length > Number($field.attr("maxlength"))) {
          val=val.slice(0, 5);
          $field.val(val);
        }
        inputQuantity[$thisIndex]=val;
      });      
    });

   

    $scope.onCountryChange = function(){
        debugger;
        
                if($scope.allDetailList.MailingCountry == 'India'){
                    $scope.allDetailList.stateList = $scope.indianStates;
                }else if($scope.allDetailList.MailingCountry == 'Germany'){
                    $scope.allDetailList.stateList = $scope.germanStates;
                }
                $scope.$apply();
    }

/*/////////////////////////////////// After UI Code ///////////////////////////////////////////*/

    $scope.allDetailList = [];
    $scope.gerCoordDetails = function(){
        debugger;
        ApplicantPortal_Contoller.getCoodinatorDetList($rootScope.userId, function(result,event){
            debugger;
            if(event.status && result != null){
                debugger;
                $scope.allDetailList = result;
                if($scope.allDetailList.Publications_Patents__c != undefined || $scope.allDetailList.Publications_Patents__c != ""){
                    $scope.allDetailList.Publications_Patents__c = $scope.allDetailList.Publications_Patents__c ? $scope.allDetailList.Publications_Patents__c.replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : $scope.allDetailList.Publications_Patents__c;
                }
                if($scope.allDetailList.Education_Details__r == undefined){
                    var rec = {
                        'Institution_Name__c':'',
                        'Contact__c': $scope.allDetailList.Id
                    };
                    $scope.allDetailList.Education_Details__r = [];
                        debugger;
                    $scope.allDetailList.Education_Details__r.push(rec);
                }
                if($scope.allDetailList.Employment_Details__r == undefined){
                    var emprec = {
                        "Organization_Name__c":"",
                        "Contact__c": $scope.allDetailList.Id
                    };
                    $scope.allDetailList.Employment_Details__r = [];
                    debugger;
                    $scope.allDetailList.Employment_Details__r.push(emprec);
                }
                if($scope.allDetailList.MailingCountry == 'India'){
                        $scope.allDetailList.stateList = $scope.indianStates;
                    }else if($scope.allDetailList.MailingCountry == 'Germany'){
                        $scope.allDetailList.stateList = $scope.germanStates; 
                    }
                $scope.$apply();
            }
        })
    }
    $scope.gerCoordDetails();

    $scope.saveAllDetails = function(){
        debugger;
        if($scope.allDetailList != undefined){
        if($scope.allDetailList.FirstName == undefined || $scope.allDetailList.FirstName == ""){
            swal("Contact Details", "Please Enter Your First Name.");
            $("#FName").addClass('border-theme');
                return;
        }
        if($scope.allDetailList.LastName == undefined || $scope.allDetailList.LastName == ""){
            swal("Contact Details", "Please Enter Your Last Name.");
            $("#LName").addClass('border-theme');
                return;
        }
        if($scope.allDetailList.Email == undefined || $scope.allDetailList.Email == ""){
            swal("Contact Details", "Please Enter Your Email.");
            $("#txtEmail1").addClass('border-theme');
                return;
        }
        if($scope.allDetailList.Actual_Position__c == undefined || $scope.allDetailList.Actual_Position__c == ""){
            swal("Contact Details", "Please Enter Your Actual Position.");
            $("#position").addClass('border-theme');
                return;
        }
        if($scope.allDetailList.MailingCountry == undefined || $scope.allDetailList.MailingCountry == ""){
            swal("Contact Details", "Please Enter Country.");
            $("#country").addClass('border-theme');
                return;
        }
        if($scope.allDetailList.MailingState == undefined || $scope.allDetailList.MailingState == ""){
            swal("Contact Details", "Please Enter State.");
            $("#state").addClass('border-theme');
                return;
        }
        if($scope.allDetailList.MailingPostalCode == undefined || $scope.allDetailList.MailingPostalCode == ""){
            swal("Contact Details", "Please Enter Post Code.");
            $("#postCode").addClass('border-theme');
                return;
        }
        if($scope.emailCheck == true){
            swal('info','Email already exists.','info');
            $("#txtEmail1").addClass('border-theme');
                return;
          }

        if($scope.allDetailList.Education_Details__r != undefined){
            for(var i=0; i<$scope.allDetailList.Education_Details__r.length; i++){
                if($scope.allDetailList.Education_Details__r[i].Degree__c == undefined || $scope.allDetailList.Education_Details__r[i].Degree__c == ""){
                    swal('info','Please Enter Education Degree','info');
                    $("#degree"+i+"").addClass('border-theme');
                    return;
                }  
                if($scope.allDetailList.Education_Details__r[i].End_Year__c == undefined || $scope.allDetailList.Education_Details__r[i].End_Year__c == ""){
                    swal('info','Please Enter Year of Completion','info');
                    $("#endYear"+i+"").addClass('border-theme');
                    return;
                }
                if($scope.allDetailList.Education_Details__r[i].Institution_Name__c == undefined || $scope.allDetailList.Education_Details__r[i].Institution_Name__c == ""){
                    swal('info','Please Enter Institution Name','info');
                    $("#instName"+i+"").addClass('border-theme');
                    return;
                }
                if($scope.allDetailList.Education_Details__r[i].Percentage_cgpa__c == undefined || $scope.allDetailList.Education_Details__r[i].Percentage_cgpa__c == ""){
                    swal('info','Please choose either CGPA/Percentage','info');
                    $("#cgpa"+i+"").addClass('border-theme');
                    return; 
                }
                if($scope.allDetailList.Education_Details__r[i].Percentage_cgpa__c == "Percentage"){
                    if($scope.allDetailList.Education_Details__r[i].Percentage__c==undefined||$scope.allDetailList.Education_Details__r[i].Percentage__c==""){
                        swal('info','Please enter Percentage.','info');
                        $("#txtPer"+i+"").addClass('border-theme');
                        return; 
                    }
    
                    if($scope.allDetailList.Education_Details__r[i].Percentage__c==00){
                        swal('info','Please enter Percentage more than 0.','info');
                        $("#txtPer"+i+"").addClass('border-theme');
                        return;  
                    }

                }
                if($scope.allDetailList.Education_Details__r[i].Percentage_cgpa__c == "CGPA"){
                    if($scope.allDetailList.Education_Details__r[i].CGPA__c==undefined||$scope.allDetailList.Education_Details__r[i].CGPA__c==""){
                        swal('info','Please enter CGPA.','info');
                        $("#txtPer"+i+"").addClass('border-theme');
                        return; 
                    }
    
                    if($scope.allDetailList.Education_Details__r[i].CGPA__c==00 || $scope.allDetailList.Education_Details__r[i].CGPA__c == 0){
                        swal('info','Please enter CGPA more than 0.','info');
                        $("#txtPer"+i+"").addClass('border-theme');
                        return;  
                    }

                }
                if($scope.allDetailList.Education_Details__r[i].Area_of_specialization__c==undefined||$scope.allDetailList.Education_Details__r[i].Area_of_specialization__c==""){
                    swal('info','Please enter Area of specialization','info');
                    $("#txtSpecialization"+i+"").addClass('border-theme');
                    return;
                }
            }
        }

        if($scope.allDetailList.Employment_Details__r != undefined){
            for(var j=0; j<$scope.allDetailList.Employment_Details__r.length; j++){
                if($scope.allDetailList.Employment_Details__r[j].Organization_Name__c == undefined || $scope.allDetailList.Employment_Details__r[j].Organization_Name__c == ""){
                    swal("Employment Details", "Please Enter Organization Name.");
                    $("#org"+j+"").addClass('border-theme');
                    return; 
                }

                if($scope.allDetailList.Employment_Details__r[j].Position__c == undefined || $scope.allDetailList.Employment_Details__r[j].Position__c == ""){
                    swal("Employment Details", "Please Enter Position.");
                    $("#pos"+j+"").addClass('border-theme');
                    return;  
                }

                if($scope.allDetailList.Employment_Details__r[j].Start_Year__c == undefined || $scope.allDetailList.Employment_Details__r[j].Start_Year__c == ""){
                    swal("Employment Details", "Please Enter Start Year.");
                    $("#sYear"+j+"").addClass('border-theme');
                    return;  
                }

                if($scope.allDetailList.Employment_Details__r[j].End_Year__c == undefined || $scope.allDetailList.Employment_Details__r[j].End_Year__c == ""){
                    swal("Employment Details", "Please Enter End Year.");
                    $("#endyear"+j+"").addClass('border-theme');
                    return;  
                }
            }

        }

    }

    $scope.educationDetails = [];
    $scope.employmentDetails = [];
    $scope.educationDetails = $scope.allDetailList.Education_Details__r;
    $scope.employmentDetails = $scope.allDetailList.Employment_Details__r;

    $scope.allDetailList['State__c'] = $scope.allDetailList['MailingState'];
    delete ($scope.allDetailList['Education_Details__r']);
    delete ($scope.allDetailList['Employment_Details__r']);
    delete ($scope.allDetailList['Education_Details__r']);
    delete ($scope.allDetailList['stateList']);

    for(var i=0;i<$scope.educationDetails.length;i++){
        delete ($scope.educationDetails[i]['$$hashKey']); 
    }
    for(var i=0;i<$scope.employmentDetails.length;i++){
        delete ($scope.employmentDetails[i]['$$hashKey']); 
    }

        ApplicantPortal_Contoller.SaveWorkshopContactDetails($scope.allDetailList,$scope.educationDetails,$scope.employmentDetails, function(result,event){
            debugger;
            if(event.status){
                debugger;
                Swal.fire(
                    'Success',
                    'your Contact Details has been Saved successfully.',
                    'success'
                );
               $scope.redirectPageURL('SignatureOfCoordinators');
               $scope.$apply();
            }
        })
    }

    $scope.validatePercentage=function(index,event){
        debugger;

        if($scope.allDetailList.Education_Details__r[index].Percentage_cgpa__c=="Percentage"){
            stringP = $scope.allDetailList.Education_Details__r[index].Percentage__c.toString()
            var splitPercent = stringP.split(".");
            if(splitPercent.length > 2){
                $scope.allDetailList.Education_Details__r[index].Percentage__c = Number(splitPercent[0]+"."+splitPercent[1]);
                swal("info", "Enter valid value for percentage.","info");
                return;
            }
        }
        
        if($scope.allDetailList.Education_Details__r[index].Percentage_cgpa__c!=undefined){
            if($scope.allDetailList.Education_Details__r[index].Percentage_cgpa__c=="CGPA"){
                if($scope.allDetailList.Education_Details__r[index].Percentage__c>10){
                    $scope.allDetailList.Education_Details__r[index].Percentage__c=10;
                }
            }
            else{
                if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode==48 || event.keyCode==8 || event.keyCode==190){
                if($scope.allDetailList.Education_Details__r[index].Percentage__c>100){
                    $scope.allDetailList.Education_Details__r[index].Percentage__c='100';
                }
            }else{
                $scope.allDetailList.Education_Details__r[index].Percentage__c=0;
            }
            }
        }else{
        if($scope.allDetailList.Education_Details__r[index].Percentage__c>100){
            $scope.allDetailList.Education_Details__r[index].Percentage__c=100;
        }
    }

    }

    $scope.removeClass=function(controlid,index){
        debugger;
        var controlIdfor=controlid+""+index;
        $("#"+controlIdfor+"").removeClass('border-theme');
      }

    $scope.removeClass2=function(controlid){
        $("#"+controlid+"").removeClass('border-theme');
      }
});