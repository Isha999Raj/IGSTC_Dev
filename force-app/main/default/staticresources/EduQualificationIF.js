angular.module('cp_app').controller('EduQualificationIF_Ctrl', function($scope,$rootScope) {
    $scope.objContact={};
    $scope.objEduDetails={};
    $scope.objMasterThesis={};
    $scope.objPhDThesis={};
    // $scope.degree = degree;
    $scope.eduList=[];    
    $rootScope.percentCGPA;
    debugger
    $scope.thesispick=$rootScope.natureOfThesisWork;
    $scope.phdpick=$rootScope.natureOfPhDWork;
    $scope.getEduQualification=function(){
        IndustrialFellowshipController.getEduQualification($rootScope.userId, function (result, event) {
            debugger
            console.log(result);
            console.log(event);
            $scope.objEduDetails=result;
            var educationRecCount=0;
            var thesisRecCount=0;
            var phdRecCount=0;
            for(var i=0; i<result.length;i++){
                if(result[i].RecordType.Name=="Education"){
                    educationRecCount=educationRecCount+1;
                    // result[i].End_Year__c=parseInt(result[i].End_Year__c);
                    $scope.eduList.push(result[i]);
                }
                if(result[i].RecordType.Name=="Thesis"){
                    if(result[i].Thesis_Type__c=="Master Thesis"){
                        thesisRecCount=1;
                        $scope.objMasterThesis=result[i];
                        // delete($scope.objEduDetails[i]);
                        // $scope.objEduDetails.splice(i,1);
                        if($scope.objMasterThesis.Start_Date__c!=undefined && $scope.objMasterThesis.Start_Date__c!=''){
                            $scope.StartDate=new Date($scope.objMasterThesis.Start_Date__c);
                        }
                        if($scope.objMasterThesis.End_Date__c!=undefined && $scope.objMasterThesis.End_Date__c!=''){
                            $scope.EndDate=new Date($scope.objMasterThesis.End_Date__c);
                        }
                    }
                    else if(result[i].Thesis_Type__c=="PhD Thesis"){
                        phdRecCount=1;
                        $scope.objPhDThesis=result[i];
                        // delete($scope.objEduDetails[i]);
                        // $scope.objEduDetails.splice(i,1);
                        if($scope.objPhDThesis.Start_Date__c!=undefined && $scope.objPhDThesis.Start_Date__c!=''){
                            $scope.masterStartDate=new Date($scope.objPhDThesis.Start_Date__c);
                        }
                        if($scope.objPhDThesis.End_Date__c!=undefined && $scope.objPhDThesis.End_Date__c!=''){
                            $scope.masterEndDate=new Date($scope.objPhDThesis.End_Date__c);
                        }
                    }
                }
            }
            if(educationRecCount<=0){
                $scope.eduList.push({
                    "Institution_Name__c": "",
                    "Contact__c": $rootScope.contactId,
                    "RecordType": {
                        "Name": "Education",
                    }
                });
            }
            if(thesisRecCount<=0){
                $scope.objMasterThesis={
                    "Contact__c": $rootScope.contactId,
                    Thesis_Type__c:"Master Thesis",
                    "RecordType": {
                        "Name": "Thesis",
                    }
                };
            }
            if(phdRecCount<=0){
                $scope.objPhDThesis={
                    "Contact__c": $rootScope.contactId,
                    Thesis_Type__c:"PhD Thesis",
                    "RecordType": {
                        "Name": "Thesis",
                    }
                };
            }
            $scope.$apply();
        });
    }
    $scope.addEduRow=function(){
        $scope.eduList.push({
            "Institution_Name__c": "",
            "Contact__c": $rootScope.contactId,
            "RecordType": {
                "Name": "Education",
            }
        });
    }
    $scope.removeRow=function(index,itemId){
        debugger
        if($scope.eduList.length==1){
            return;
        }
        if(itemId==undefined){
            $scope.eduList.splice(index,1);
            $scope.$apply();
        }else{
            IndustrialFellowshipController.deleteEducationLineItem(itemId, function (result, event) {
                if (event.status) {
                    swal('success','Education record has been deleted successfully','success');
                    $scope.eduList.splice(index,1);
                    $scope.$apply();
                }else
                {
                    console.log(event);
                    swal('error','Exception occured!','error');
                }
            });   
        }
    }
    $scope.redirectPageURL=function(URL){
        var link=document.createElement("a");
        link.id = 'someLink'; //give it an ID!
        link.href='#/'+URL+'';
        link.click();
      }
    $scope.saveEduDetailIF=function(){
        debugger;
            for(var i=0;i<$scope.eduList.length;i++){
                if($scope.eduList[i].Degree__c == undefined || $scope.eduList[i].Degree__c == ""){
                    swal('info','Please Enter Education Degree','info');
                    $("#degree"+i+"").addClass('border-theme');
                    return;
                }  
                if($scope.eduList[i].End_Year__c == undefined || $scope.eduList[i].End_Year__c == ""){
                    swal('info','Please Enter Year of Completion','info');
                    $("#endYear"+i+"").addClass('border-theme');
                    return;
                }
                if($scope.eduList[i].Institution_Name__c == undefined || $scope.eduList[i].Institution_Name__c == ""){
                    swal('info','Please Enter Institution Name','info');
                    $("#instName"+i+"").addClass('border-theme');
                    return;
                }
                if($scope.eduList[i].Percentage_cgpa__c == undefined || $scope.eduList[i].Percentage_cgpa__c == ""){
                    swal('info','Please choose either CGPA/Percentage','info');
                    $("#cgpa"+i+"").addClass('border-theme');
                    return; 
                }
                if($scope.eduList[i].Percentage_cgpa__c == "Percentage"){
                    if($scope.eduList[i].Percentage__c==undefined||$scope.eduList[i].Percentage__c==""){
                        swal('info','Please enter Percentage.','info');
                        $("#txtPer"+i+"").addClass('border-theme');
                        return; 
                    }
    
                    if($scope.eduList[i].Percentage__c==00){
                        swal('info','Please enter Percentage more than 0.','info');
                        $("#txtPer"+i+"").addClass('border-theme');
                        return;  
                    }

                }
                if($scope.eduList[i].Percentage_cgpa__c == "CGPA"){
                    if($scope.eduList[i].CGPA__c==undefined||$scope.eduList[i].CGPA__c==""){
                        swal('info','Please enter CGPA.','info');
                        $("#txtPer"+i+"").addClass('border-theme');
                        return; 
                    }
    
                    if($scope.eduList[i].CGPA__c==00 || $scope.eduList[i].CGPA__c == 0){
                        swal('info','Please enter CGPA more than 0.','info');
                        $("#txtPer"+i+"").addClass('border-theme');
                        return;  
                    }

                }
                // if($scope.eduList[i].Percentage__c==undefined||$scope.eduList[i].CGPA__c==""){
                //     swal('info','Please enter Percentage / CGPA','info');
                //     $("#txtPer"+i+"").addClass('border-theme');
                //     return;
                // }
                if($scope.eduList[i].Area_of_specialization__c==undefined||$scope.eduList[i].Area_of_specialization__c==""){
                    swal('info','Please enter Area of specialization','info');
                    $("#txtSpecialization"+i+"").addClass('border-theme');
                    return;
                }
        }
        
        $scope.objSendData=[];
        $scope.objSendData.push($scope.objMasterThesis);
        $scope.objSendData.push($scope.objPhDThesis);
        
        for(var i=0;i<$scope.eduList.length;i++){
            if($scope.eduList[i].End_Year__c != null){
                $scope.eduList[i].End_Year__c=$scope.eduList[i].End_Year__c.toString();
            }
            $scope.objSendData.push($scope.eduList[i]);
        }
        for (let i = 0; i < $scope.objSendData.length; i++) {
            delete($scope.objSendData[i]['$$hashKey']);
            delete($scope.objSendData[i]['Name']);
            delete($scope.objSendData[i]['RecordTypeId']);
            delete $scope.objSendData[i].RecordType;
        }
       
        debugger
        $scope.dateList=[];
        var years=0;
        var month=0;
        var day=0;
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1;
        var yyyy = today.getFullYear();
        var mjStartDate = null;
        var mjEndDate = null;
        if($scope.masterStartDate!=undefined && $scope.masterStartDate!=''){
        years = $scope.masterStartDate.getUTCFullYear();
        month = $scope.masterStartDate.getUTCMonth()+1;
        day = $scope.masterStartDate.getDate();
        mjStartDate = moment([years, month, day]);
        $scope.dateList.push({GroupName:'phd',fromTo:'start',year:years,month:month,day:day});
      }
    
        
      
      years=0;
      month=0;
      day=0;
    if($scope.masterEndDate!=undefined && $scope.masterEndDate!=''){
      years = $scope.masterEndDate.getUTCFullYear();
      month = $scope.masterEndDate.getUTCMonth()+1;
      day = $scope.masterEndDate.getDate();
      mjEndDate = moment([years, month, day]);
      $scope.dateList.push({GroupName:'phd',fromTo:'end',year:years,month:month,day:day});
    }
    years=0;
      month=0;
      day=0;
      if($scope.StartDate!=undefined && $scope.StartDate!=''){
        years = $scope.StartDate.getUTCFullYear();
        month = $scope.StartDate.getUTCMonth()+1;
        day = $scope.StartDate.getDate();
        $scope.dateList.push({GroupName:'mt',fromTo:'start',year:years,month:month,day:day});
      } 
      years=0;
      month=0;
      day=0;
      if($scope.EndDate!=undefined && $scope.EndDate!=''){
        years = $scope.EndDate.getUTCFullYear();
        month = $scope.EndDate.getUTCMonth()+1;
        day = $scope.EndDate.getDate();
        $scope.dateList.push({GroupName:'mt',fromTo:'end',year:years,month:month,day:day});
      } 
    if($scope.StartDate != undefined && $scope.StartDate != ""){
        if($scope.StartDate > today){
        // if($scope.StartDate.getDate() > dd && $scope.StartDate.getUTCMonth()+1 >= mm && $scope.StartDate.getUTCFullYear() >= yyyy){
            swal('info','Master  Thesis Start Date should not be future date.','info');    
            $("#masterSD").addClass('border-theme');
                    return;
        }
        // }
    }

    // if($scope.EndDate != undefined && $scope.EndDate != ""){
    //     if($scope.EndDate.getDate() > today){
    //         swal("info", "Master Thesis End Date should not be future date.","info");
    //         $("#masterED").addClass('border-theme');
    //                 return;
    //     }
    // }

    if(($scope.StartDate != undefined && $scope.StartDate != "") && ($scope.EndDate != undefined && $scope.EndDate != "")){
        if($scope.StartDate > $scope.EndDate){
            swal("info", "Master Thesis start date should not be previous to Master Thesis end date.","info");
            $("#masterED").addClass('border-theme');
            $("#masterSD").addClass('border-theme');
                    return;
        }
    }
    
    if(($scope.StartDate != undefined && $scope.StartDate != "") && ($scope.EndDate != undefined && $scope.EndDate != "")){
        if($scope.StartDate == $scope.EndDate){
            swal("info", "Master Thesis start date should not be same date to Master Thesis end date.","info");
            $("#masterED").addClass('border-theme');
            $("#masterSD").addClass('border-theme');
                    return;
        }
    }
    
    if($scope.masterStartDate != undefined && $scope.masterStartDate != ""){
        if($scope.masterStartDate > today){
            swal("info", "PHD Thesis Start Date should not be future date.","info");
            $("#phdSD").addClass('border-theme');
                    return;
        }
    }
    
    // if($scope.masterEndDate != undefined && $scope.masterEndDate != ""){
    //     if($scope.masterEndDate > today){
    //         swal("info", "PHD Thesis End Date should not be future date.","info");
    //         $("#phdED").addClass('border-theme');
    //                 return;
    //     }
    // }

    if(($scope.masterStartDate != undefined && $scope.masterStartDate != "") && ($scope.masterEndDate != undefined && $scope.masterEndDate != "")){
        if($scope.masterStartDate > $scope.masterEndDate){
            swal("info", "PHD Thesis start date should not be previous to PHD Thesis end date.","info");
            $("#phdSD").addClass('border-theme');
            $("#phdED").addClass('border-theme');
                    return;
        }
    }

    if(($scope.masterStartDate != undefined && $scope.masterStartDate != "") && ($scope.masterEndDate != undefined && $scope.masterEndDate != "")){
        if($scope.masterStartDate == $scope.masterEndDate){
            swal("info", "PHD Thesis start date should not be same date to PHD Thesis end date.","info");
            $("#phdSD").addClass('border-theme');
            $("#phdED").addClass('border-theme');
                    return;
        }
    }

    for (let i = 0; i < $scope.objSendData.length; i++) {
        delete($scope.objSendData[i]['$$hashKey']);
        delete($scope.objSendData[i]['Name']);
        delete($scope.objSendData[i]['RecordTypeId']);
        delete $scope.objSendData[i].RecordType;
    }
    
    //$scope.dateList.push({GroupName:'mt',fromTo:'end',year:years,month:month,day:day});
    debugger;
        IndustrialFellowshipController.saveEduDetailIF($rootScope.userId,$scope.objSendData,$scope.dateList, function (result, event) {
            debugger
            console.log(result);
            console.log(event);
            if (event.status) {
                swal({
                  title: "Education Qualification",
                  text: result,
                  icon: "success",
                  button: "ok!",
                }).then((value) => {
                    $scope.redirectPageURL('EmploymentDetailsIF');
                    });
              }
              else
              {
                swal({
                  title: "Education Qualification",
                  text: "Exception!",
                  icon: "error",
                  button: "ok!",
                });
              }
        })
    }
    $scope.myFilter=function(item){
        if(item.RecordType.Name!="Thesis"){
            return true;
        }
        else
        {
            return false;
        }
    }
    $scope.clickPreviousEduQualification=function(){
        var link=document.createElement("a");
        link.id = 'someLink'; //give it an ID!
        link.href="#/Parent_Organization";
        link.click();
    }
    $scope.getEduQualification();

    var inputQuantity = [];
    $(function() { 
        debugger;    
      $("#zipCode").on("keyup", function (e) {
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
    $scope.restrictDecimalVal = function(myVar){
        debugger;
        if(myVar.length>4){
            return false;
        }
        else
        {
            return true;
        }
    }
    $scope.validatePercentage=function(index,event){
        debugger;

        if($scope.eduList[index].Percentage_cgpa__c=="Percentage"){
            stringP = $scope.eduList[index].Percentage__c.toString()
            var splitPercent = stringP.split(".");
            if(splitPercent.length > 2){
                $scope.eduList[index].Percentage__c = Number(splitPercent[0]+"."+splitPercent[1]);
                swal("info", "Enter valid value for percentage.","info");
                return;
            }
        }
        
        if($scope.eduList[index].Percentage_cgpa__c!=undefined){
            if($scope.eduList[index].Percentage_cgpa__c=="CGPA"){
                if($scope.eduList[index].Percentage__c>10){
                    $scope.eduList[index].Percentage__c=10;
                }
            }
            else{
                if((event.keyCode>=48 && event.keyCode<=57) || event.keyCode==48 || event.keyCode==8 || event.keyCode==190){
                if($scope.eduList[index].Percentage__c>100){
                    $scope.eduList[index].Percentage__c='100';
                }
            }else{
                $scope.eduList[index].Percentage__c='0';
            }
            }
        }else{
        if($scope.eduList[index].Percentage__c>100){
            $scope.eduList[index].Percentage__c='100';
        }
    }
    };
    $scope.validatePerCGPA=function(index){
        debugger
        if($scope.eduList[index].Percentage_cgpa__c=="CGPA"){
            delete $scope.eduList[index].Percentage__c;
            delete $scope.eduList[index].CGPA__c;
            // if($scope.eduList[index].Percentage__c>10){
            //     $("#spnErrMsg"+index+"").addClass('show');
            //     $("#txtPer"+index+"").addClass('border-theme');
            //     $("#spnErrMsg"+index+"").html('maximum 10 is allowed in CGPA');
            // }
        }
        else{
            $scope.eduList[index].Percentage__c=0;
            delete $scope.eduList[index].Percentage__c;
            delete $scope.eduList[index].CGPA__c;
            $scope.removeClasses(index);
        }
    }
    $scope.removeClasses=function(index){
        debugger
        $("#spnErrMsg"+index+"").removeClass('show');
        $("#spnErrMsg"+index+"").addClass('hide');
        $("#txtPer"+index+"").removeClass('border-theme');
    }

    $scope.removeClass=function(controlid,index){
        var controlIdfor=controlid+""+index;
        $("#"+controlIdfor+"").removeClass('border-theme');
      }

      $scope.removeClass2=function(controlid){
        $("#"+controlid+"").removeClass('border-theme');
      }
});