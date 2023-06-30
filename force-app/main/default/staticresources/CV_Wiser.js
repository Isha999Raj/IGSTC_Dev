angular.module('cp_app').controller('cv_wiser', function($scope,$rootScope) {
    debugger;
    $scope.siteURL = siteURL;
    $scope.contactData = {};
    $scope.objRtf=[{charCount:0,maxCharLimit:0,errorStatus:false}];
    $scope.objRtf.push({charCount:0,maxCharLimit:0,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:0,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:0,errorStatus:false});

    $scope.getCVDetailsForWiserApplicant = function(){
        debugger;
        ApplicantPortal_Contoller.getCVDetailsForWiserApplicant($rootScope.userId, function(result,event){
            debugger;
            if(event.status && result){
                debugger;
                $scope.contactData = result;
                if($scope.contactData.FirstName != undefined || $scope.contactData.FirstName != ""){
                    $scope.contactData.FirstName = $scope.contactData.FirstName ? $scope.contactData.FirstName.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : $scope.contactData.FirstName;
                }
                if($scope.contactData.LastName != undefined || $scope.contactData.LastName != ""){
                    $scope.contactData.LastName = $scope.contactData.LastName ? $scope.contactData.LastName.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : $scope.contactData.LastName;
                }
                if($scope.contactData.Publications_Patents__c != undefined || $scope.contactData.Publications_Patents__c != ""){
                    $scope.contactData.Publications_Patents__c = $scope.contactData.Publications_Patents__c ? $scope.contactData.Publications_Patents__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : $scope.contactData.Publications_Patents__c;
                }
                if($scope.contactData.List_Of_Patents_Filed_Granted__c != undefined || $scope.contactData.List_Of_Patents_Filed_Granted__c != ""){
                    $scope.contactData.List_Of_Patents_Filed_Granted__c = $scope.contactData.List_Of_Patents_Filed_Granted__c ? $scope.contactData.List_Of_Patents_Filed_Granted__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : $scope.contactData.List_Of_Patents_Filed_Granted__c;
                }
                if($scope.contactData.Book_Chapters_Monographs__c != undefined || $scope.contactData.Book_Chapters_Monographs__c != ""){
                    $scope.contactData.Book_Chapters_Monographs__c = $scope.contactData.Book_Chapters_Monographs__c ? $scope.contactData.Book_Chapters_Monographs__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : $scope.contactData.Book_Chapters_Monographs__c;
                }
                if($scope.contactData.Any_Other_Notable_Achievements__c != undefined || $scope.contactData.Any_Other_Notable_Achievements__c != ""){
                    $scope.contactData.Any_Other_Notable_Achievements__c = $scope.contactData.Any_Other_Notable_Achievements__c ? $scope.contactData.Any_Other_Notable_Achievements__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : $scope.contactData.Any_Other_Notable_Achievements__c;
                }
                if($scope.contactData.Education_Details__r == undefined){
                    var rec = {
                        'Institution_Name__c':'',
                        'Contact__c': $scope.contactData.Id
                    };
                    $scope.contactData.Education_Details__r = [];
                        debugger;
                    $scope.contactData.Education_Details__r.push(rec);
                }else{
                    for(var i=0;i<$scope.contactData.Education_Details__r.length;i++){
                        if($scope.contactData.Education_Details__r[i].Degree__c != undefined || $scope.contactData.Education_Details__r[i].Degree__c != ""){
                            $scope.contactData.Education_Details__r[i].Degree__c = $scope.contactData.Education_Details__r[i].Degree__c ? $scope.contactData.Education_Details__r[i].Degree__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : $scope.contactData.Education_Details__r[i].Degree__c;
                        }
                        if($scope.contactData.Education_Details__r[i].Institution_Name__c != undefined || $scope.contactData.Education_Details__r[i].Institution_Name__c != ""){
                            $scope.contactData.Education_Details__r[i].Institution_Name__c = $scope.contactData.Education_Details__r[i].Institution_Name__c ? $scope.contactData.Education_Details__r[i].Institution_Name__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : $scope.contactData.Education_Details__r[i].Institution_Name__c;
                        }
                        if($scope.contactData.Education_Details__r[i].Area_of_specialization__c != undefined || $scope.contactData.Education_Details__r[i].Area_of_specialization__c != ""){
                            $scope.contactData.Education_Details__r[i].Area_of_specialization__c = $scope.contactData.Education_Details__r[i].Area_of_specialization__c ? $scope.contactData.Education_Details__r[i].Area_of_specialization__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : $scope.contactData.Education_Details__r[i].Area_of_specialization__c;
                        }
                    }
                }
                if($scope.contactData.Employment_Details__r == undefined){
                    var emprec = {
                        "Organization_Name__c":"",
                        "Contact__c": $scope.contactData.Id
                    };
                    $scope.contactData.Employment_Details__r = [];
                    debugger;
                    $scope.contactData.Employment_Details__r.push(emprec);
                }else{
                    for(var i=0;i<$scope.contactData.Employment_Details__r.length;i++){
                        if($scope.contactData.Employment_Details__r[i].Organization_Name__c != undefined || $scope.contactData.Employment_Details__r[i].Organization_Name__c != ""){
                            $scope.contactData.Employment_Details__r[i].Organization_Name__c = $scope.contactData.Employment_Details__r[i].Organization_Name__c ? $scope.contactData.Employment_Details__r[i].Organization_Name__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : $scope.contactData.Employment_Details__r[i].Organization_Name__c;
                        }
                        if($scope.contactData.Employment_Details__r[i].Position__c != undefined || $scope.contactData.Employment_Details__r[i].Position__c != ""){
                            $scope.contactData.Employment_Details__r[i].Position__c = $scope.contactData.Employment_Details__r[i].Position__c ? $scope.contactData.Employment_Details__r[i].Position__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : $scope.contactData.Employment_Details__r[i].Position__c;
                        }
                    }
                }
            $scope.$apply();
            }
        })
    }

    $scope.getCVDetailsForWiserApplicant();

    $scope.saveAllDetails = function(){
        debugger;
        if($scope.contactData != undefined){
        if($scope.contactData.Education_Details__r != undefined){
            for(var i=0; i<$scope.contactData.Education_Details__r.length; i++){
                if($scope.contactData.Education_Details__r[i].Institution_Name__c == undefined || $scope.contactData.Education_Details__r[i].Institution_Name__c == ""){
                    swal("Education Details", "Please Enter Institution Name.");
                    $("#institution"+i+"").addClass('border-theme');
                    return; 
                }
                if($scope.contactData.Education_Details__r[i].Area_of_specialization__c == undefined || $scope.contactData.Education_Details__r[i].Area_of_specialization__c == ""){
                    swal("Education Details", "Please Enter Specialization.");
                    $("#specialization"+i+"").addClass('border-theme');
                    return; 
                }
                if($scope.contactData.Education_Details__r[i].Degree__c == undefined || $scope.contactData.Education_Details__r[i].Degree__c == ""){
                    swal("Education Details", "Please Enter Degree.");
                    $("#degree"+i+"").addClass('border-theme');
                    return; 
                }
                if($scope.contactData.Education_Details__r[i].Start_Year__c == undefined || $scope.contactData.Education_Details__r[i].Start_Year__c == ""){
                    swal("Education Details", "Please Enter Start Year.");
                    $("#zipCode1"+i+"").addClass('border-theme');
                    return; 
                }
                if($scope.contactData.Education_Details__r[i].End_Year__c == undefined || $scope.contactData.Education_Details__r[i].End_Year__c == ""){
                    swal("Education Details", "Please Enter End Year.");
                    $("#zipCode2"+i+"").addClass('border-theme');
                    return; 
                }
            }
        }

        if($scope.contactData.Employment_Details__r != undefined){
            for(var j=0; j<$scope.contactData.Employment_Details__r.length; j++){
                if($scope.contactData.Employment_Details__r[j].Organization_Name__c == undefined || $scope.contactData.Employment_Details__r[j].Organization_Name__c == ""){
                    swal("Employment Details", "Please Enter Organization Name.");
                    $("#org"+j+"").addClass('border-theme');
                    return; 
                }

                if($scope.contactData.Employment_Details__r[j].Position__c == undefined || $scope.contactData.Employment_Details__r[j].Position__c == ""){
                    swal("Employment Details", "Please Enter Position.");
                    $("#position"+j+"").addClass('border-theme');
                    return;  
                }

                if($scope.contactData.Employment_Details__r[j].Start_Year__c == undefined || $scope.contactData.Employment_Details__r[j].Start_Year__c == ""){
                    swal("Employment Details", "Please Enter Start Year.");
                    $("#zipCode11"+j+"").addClass('border-theme');
                    return;  
                }

                if($scope.contactData.Employment_Details__r[j].End_Year__c == undefined || $scope.contactData.Employment_Details__r[j].End_Year__c == ""){
                    swal("Employment Details", "Please Enter End Year.");
                    $("#zipCode22"+j+"").addClass('border-theme');
                    return;  
                }
            }

        }

    }

    $scope.educationDetails = [];
    $scope.employmentDetails = [];
    $scope.educationDetails = $scope.contactData.Education_Details__r;
    $scope.employmentDetails = $scope.contactData.Employment_Details__r;

    delete ($scope.contactData['Education_Details__r']);
    delete ($scope.contactData['Employment_Details__r']);
    delete ($scope.contactData['Education_Details__r']);

    for(var i=0;i<$scope.educationDetails.length;i++){
        delete ($scope.educationDetails[i]['$$hashKey']); 
    }
    for(var i=0;i<$scope.employmentDetails.length;i++){
        delete ($scope.employmentDetails[i]['$$hashKey']); 
    }

        ApplicantPortal_Contoller.SaveWorkshopContactDetails2($scope.contactData,$scope.educationDetails,$scope.employmentDetails, function(result,event){
            debugger;
            if(event.status){
                debugger;
                Swal.fire(
                    'Success',
                    'your CV Details has been Saved successfully.',
                    'success'
                );
               $scope.redirectPageURL('AttachmentsInWiser');
               $scope.$apply();
            }
        })
    }

      $scope.addEducationRow=function(){
        debugger;
        $scope.contactData.Education_Details__r.push({
            Institution_Name__c:"",
            Contact__c: $scope.contactData.Id
        });
        $scope.$apply();
        debugger;
    }
    $scope.removeEducationRow=function(index){
        debugger;
        if($scope.contactData.Education_Details__r.length != 1){
            if($scope.contactData.Education_Details__r[index].Id != undefined && $scope.contactData.Education_Details__r[index].Id != ""){
                $scope.deleteEducationRow($scope.contactData.Education_Details__r[index].Id);
            }else{
                $scope.contactData.Education_Details__r.splice(index,1);
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
        $scope.contactData.Employment_Details__r.push({
            Organization_Name__c:"",
            Contact__c: $scope.contactData.Id
        });
        $scope.$apply();
        debugger;
    }
    $scope.removeEmploymentRow=function(index){
        debugger;
        if($scope.contactData.Employment_Details__r.length != 1){
            if($scope.contactData.Employment_Details__r[index].Id != undefined && $scope.contactData.Employment_Details__r[index].Id != ""){
                $scope.deleteEmploymentWorkshop($scope.contactData.Employment_Details__r[index].Id);
            }else{
                $scope.contactData.Employment_Details__r.splice(index,1);
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

    $scope.removeClass=function(controlid,index){
        debugger;
        var controlIdfor=controlid+""+index;
        $("#"+controlIdfor+"").removeClass('border-theme');
      }

    $scope.removeClass2=function(controlid){
        $("#"+controlid+"").removeClass('border-theme');
      }
    $scope.readCharacter=function(event,index){
     debugger
        try{
        var rtfString=event.toString().replace(/<[^>]*>|\s/g, '').replace(/\s+/g,'').replace(/&ndash;/g,'-').replace(/&euro;/g,'1').replace(/&amp;/g,'1').replace(/&#39;/g,'1').replace(/&quot;/g,'1').replace(/&nbsp;/g,'').replace(/&mdash;/g,'-').replace(/&gt;/g,'>').replace(/&lt;/g,'<').replace(/&bull;/g,'');
         charLength=rtfString.length;
         if(charLength>0)
         $scope.objRtf[index].charCount=charLength;
         else
         $scope.objRtf[index].charCount=0;        
        }catch(e){}
    }
    // $scope.readCharacter2=function(event){
    //     debugger
    //        var hh=$scope.contactData.List_Of_Patents_Filed_Granted__c;
    //        try{
    //        var ffh=hh.toString();
    //         var hhg=hh.replace(/<[^>]*>|\s/g, '').length;
    //         hhg=hhg.replace(/\s+/g,'').length;
    //         hhg=hhg.replace(/&nbsp;/g,'').length;
    //         if(hhg>0)
    //         $scope.rtf2=hhg;
    //         else
    //         $scope.rtf2=0;        
    //        }catch(e){}
    //    }
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
});