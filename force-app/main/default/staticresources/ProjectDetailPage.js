angular.module('cp_app').controller('ProjectDetailCtrl', function($scope,$rootScope) {
    
    debugger;
    $scope.siteURL = siteURL;
    //$rootScope.secondstage = secondstage;
    $rootScope.userHashId;
    $rootScope.userId;
    $rootScope.candidateId;
    $rootScope.siteURL;
    $rootScope.thematicAreaList;
    $scope.tentitiveStartDate;
    $rootScope.contactId;
    $scope.disable = false;
    $rootScope.secondstage;
    $rootScope.proposalStage;
    $scope.thematicAreaToDisplay = [];
    $scope.objKeyword=[];
    $scope.objRtf=[{charCount:0,maxCharLimit:1000,errorStatus:false}];
    $scope.disable = $rootScope.proposalStage;
    if($rootScope.isPrimaryContact=="false"){
        $scope.disable = true;
    }
    //editor.disableReadOnlyMode( 'test' );
    //CKEDITOR.instances['test'].setReadOnly(true);
    $scope.getApplicantDetail = function(){
        ApplicantPortal_Contoller.getApplicantDetails($rootScope.userId, function(result, event){
            if(event.status) {
                debugger;
                if(result != null){
                    var thematicAreaId = []
                    $rootScope.projectId = result.Id;
                    /*  for(var i=0;i<$scope.thematicAreaList.length;i++){
                          thematicAreaId.push($scope.thematicAreaList[i].Id);
                          $scope.thematicAreaToDisplay.push({"Id":$scope.thematicAreaList[i].Id,"Name":$scope.thematicAreaList[i].Name,"checked":false});
                      } */
                     // $scope.tentitiveStartDate = result.Tentative_Start_Date__c;
                     if(result.Tentative_Start_Date__c!=null){
                      $scope.tentitiveStartDate = new Date(result.Tentative_Start_Date__c);
                     }
                     if(result.Summary__c != undefined || result.Summary__c != ""){
                        result.Summary__c = result.Summary__c ? result.Summary__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Summary__c;
                    }
                      $scope.applicantDetails = result;
                        //$scope.applicantDetails.Duration_In_Months_Max_36__c = Math.round($scope.applicantDetails.Duration_In_Months_Max_36__c);
                      if($scope.applicantDetails.Application_Thematic_Area__r != undefined){
                          $scope.thematicAreaToDisplay = [];
                          for(var i=0;i<$scope.applicantDetails.Application_Thematic_Area__r.length;i++){
                                              thematicAreaId.push($scope.applicantDetails.Application_Thematic_Area__r[i].Thematic_Area_Name__c);
      
                            /*  if(thematicAreaId.includes($scope.applicantDetails.Application_Thematic_Area__r[i].Id)){
                                  $scope.thematicAreaToDisplay.push({"Id":$scope.applicantDetails.Application_Thematic_Area__r[i].Id,"Name":$scope.applicantDetails.Application_Thematic_Area__r[i].Thematic_Area_Name__c	,"checked":true});
                              }else{
                                  $scope.thematicAreaToDisplay.push({"Id":$scope.applicantDetails.Application_Thematic_Area__r[i].Id,"Name":$scope.applicantDetails.Application_Thematic_Area__r[i].Thematic_Area_Name__c	,"checked":false});
                              }*/
                          } 
                          for(var i=0;i<$scope.thematicAreaList.length;i++){
                              if(thematicAreaId.includes($scope.thematicAreaList[i].Name)){
                                  $scope.thematicAreaToDisplay.push({"Id":$scope.thematicAreaList[i].Id,"Name":$scope.thematicAreaList[i].Name,"checked":true});
                              }else{
                                  $scope.thematicAreaToDisplay.push({"Id":$scope.thematicAreaList[i].Id,"Name":$scope.thematicAreaList[i].Name	,"checked":false});
                              }
                          }
                      }else{
      
                          for(var i=0;i<$scope.thematicAreaList.length;i++){
                              $scope.thematicAreaToDisplay.push({"Id":$scope.thematicAreaList[i].Id,"Name":$scope.thematicAreaList[i].Name,"checked":false});
      
                          }
                      } 
                }else{
                    for(var i=0;i<$scope.thematicAreaList.length;i++){
                        $scope.thematicAreaToDisplay.push({"Id":$scope.thematicAreaList[i].Id,"Name":$scope.thematicAreaList[i].Name,"checked":false});
                    }
                }
                if($scope.applicantDetails.KeyWords__c!=undefined && $scope.applicantDetails.KeyWords__c!=''){
                    var keyword=$scope.applicantDetails.KeyWords__c.split(';');
                    $scope.objKeyword.splice(0,1);
                    for(var k=0;k<keyword.length;k++){
                      $scope.objKeyword.push({"keyword":keyword[k]});
                    }
                  } 
                  else{
                    $scope.objKeyword.push({"keyword":""});
                  }
                  $scope.$apply();
            }
        },
          {escape: true}
      )
    }
    
    $scope.addKeyword=function(){
        debugger
        if($scope.objKeyword.length<=5){
            $scope.objKeyword.push({keyword:""});
            $scope.$apply();
        }
      }
      $scope.removeKeyword=function(index){
        if($scope.objKeyword.length>1){
        $scope.objKeyword.splice(index, 1);
        }  
      }
      $scope.readCharacter=function(event,index){
        debugger
           try{
           var rtfString=event.toString().replace(/<[^>]*>|\s/g, '').replace(/\s+/g,'').replace(/&ndash;/g,'-').replace(/&euro;/g,'1').replace(/&amp;/g,'1').replace(/&#39;/g,'1').replace(/&quot;/g,'1').replace(/&nbsp;/g,'').replace(/&mdash;/g,'-').replace(/&gt;/g,'>').replace(/&lt;/g,'<').replace(/&bull;/g,'');
            charLength=rtfString.length;
            if(charLength>0){
             $scope.objRtf[index].charCount=charLength;
             if(charLength>$scope.objRtf[index].maxCharLimit){
                  $scope.objRtf[index].errorStatus=true;
             }else
             {
              $scope.objRtf[index].errorStatus=false;
             }
            }
            else{
                  $scope.objRtf[index].charCount=0;
                  $scope.objRtf[index].errorStatus=false;
            }
           }catch(e){}
       }
    $scope.getApplicantDetail();
       
    $scope.restrictDecimalVal = function(myVar){
        // myVar = Math.round($scope.applicantDetails.Duration_In_Months_Max_36__c);
        if(myVar>36){
            return false;
        }
        else
        {
            return true;
        }
    }
    // CKEDITOR.instances["config"].on('keyup', function() {
    //     alert("I ma live!");
    // });
    $scope.rtfMaxLength = function(myVar){
        debugger
        var k = myVar;
        if(myVar>36){
            return false;
        }
        else
        {
            return true;
        }
    }
    $scope.applicantDetails = {};
    $scope.camDetails = {};
    $scope.thematicAreaList = thematicAreaList;
    
    $scope.saveApplication = function(){
        $scope.applicantDetails.Campaign__c = $rootScope.tagCampaignId;
        debugger;

        if($scope.applicantDetails.Acronym__c == undefined || $scope.applicantDetails.Acronym__c == ""){
            swal("info", "Please Enter Project Acronym.","info");
            $("#Acronym").addClass('border-theme');
              return;
        }

        if($scope.applicantDetails.Title_Of__c == undefined || $scope.applicantDetails.Title_Of__c == ""){
            swal("info", "Please Enter Title of Proposal.","info");
            $("#title").addClass('border-theme');
              return;
        }

        if($scope.applicantDetails.Title_In_German__c == undefined || $scope.applicantDetails.Title_In_German__c == ""){
            swal("info", "Please Enter Title des Antrages(In German).","info");
            $("#titleG").addClass('border-theme');
              return;
        }

        if ($scope.applicantDetails.Duration_In_Months_Max_36__c == undefined || $scope.applicantDetails.Duration_In_Months_Max_36__c == ""){
            swal("info", "Please Enter Project Duration.","info");
            $("#txtDuration").addClass('border-theme');
              return;
        }

        if ($scope.applicantDetails.Duration_In_Months_Max_36__c < 24 || $scope.applicantDetails.Duration_In_Months_Max_36__c > 36){
            swal("info", "Duration must be between 24 to 36 months.","info");
            $("#proposedDate").addClass('border-theme');
              return;
        }

        debugger;
        $scope.selectedTheme = [];
        for(var i=0;i<$scope.thematicAreaToDisplay.length;i++){
            if($scope.thematicAreaToDisplay[i].checked){
                $scope.selectedTheme.push($scope.thematicAreaToDisplay[i].Id);
            }
        }
        if($scope.selectedTheme.length<=0){
            swal("info", "Please select at least one project theme.","info");
            return;
        }

        var keyword="";
        for(var i=0;i<$scope.objKeyword.length;i++){
            if($scope.objKeyword[i].keyword!='' && $scope.objKeyword[i].keyword!=undefined){
                if(i==0)
                keyword=$scope.objKeyword[i].keyword;
                else
                keyword=keyword+';'+$scope.objKeyword[i].keyword;
            }
        }
        $scope.applicantDetails.KeyWords__c=keyword;
        delete($scope.applicantDetails.Application_Thematic_Area__r);

        if($scope.applicantDetails.KeyWords__c == undefined || $scope.applicantDetails.KeyWords__c == ""){
            swal("info", "Please Enter Keyword.","info");
            $("#key").addClass('border-theme');
              return;
        }
        
        if($scope.applicantDetails.Summary__c == undefined || $scope.applicantDetails.Summary__c == ""){
            swal("info", "Please Enter Proposal Summary.","info");
              return;
        }
        if($scope.applicantDetails.Summary__c != undefined || $scope.applicantDetails.Summary__c != ""){
            if($scope.objRtf[0].errorStatus){
                swal("info", "Summary max. length limit is 1000 character only.","info");
                return;
            }
    }

                    var year = 0;
                    var month = 0;
                    var day = 0;
                    var today = new Date();
                    var dd = today.getDate();
                    var mm = today.getMonth() + 1; //January is 0!
                    var yyyy = today.getFullYear();

        if(($scope.tentitiveStartDate == undefined || $scope.tentitiveStartDate == '') && $rootScope.secondstage == true){
            swal("info", "Please Enter Tentative Date.","info");
            $("#TSD").addClass('border-theme');
                return;
        }else if(($scope.tentitiveStartDate != undefined || $scope.tentitiveStartDate != "") && $rootScope.secondstage == true){
            year = $scope.tentitiveStartDate.getUTCFullYear();
            month = $scope.tentitiveStartDate.getUTCMonth()+1;
            day = $scope.tentitiveStartDate.getDate();
        }

        if(($scope.tentitiveStartDate != undefined || $scope.tentitiveStartDate != "") && $rootScope.secondstage == true){
            if(($scope.tentitiveStartDate.getDate() < dd && $scope.tentitiveStartDate.getUTCMonth()+1 <= mm && $scope.tentitiveStartDate.getUTCFullYear() <= yyyy) && $rootScope.secondstage == true){
                swal("info", "Tentative Start Date should not be previous date.");
                $("#TSD").addClass('border-theme');
                        return;
            }
        }
        debugger;
    ApplicantPortal_Contoller.insertApplication($scope.applicantDetails,$scope.selectedTheme,day,month,year,$rootScope.contactId,'Two Plus Two', function (result, event){
        debugger;   
        if(event.status && result != null) {
                debugger;
                Swal.fire(
                    'Proposal Detail',
                    'Basic Details have been saved successfully.',
                    'success'
                );
                $scope.redirectPageURL('Consortia');
                $rootScope.projectId = result;
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
    
    
    $scope.thematicArea = function(theme,index){
        debugger;
        if($scope.thematicAreaToDisplay[index].checked){
            $scope.thematicAreaToDisplay[index].checked=false;
        }
        else
        {
            $scope.thematicAreaToDisplay[index].checked=true;
        }
        // if($scope.selectedTheme.includes(theme)){
            
        //     $scope.selectedTheme.splice($scope.selectedTheme.indexOf(theme),1);
        // }else{
        //     $scope.selectedTheme.push(theme);
        // }
    }

    // $scope.unChecked = function () {
    //     debugger;
    //     if ($scope.selectedTheme.length > 1){
    //         if($scope.selectedTheme.Id != undefined){
    //             $scope.deleteThematicArea($scope.selectedTheme.Id);
    //         }
    //         $scope.selectedTheme.splice();
    //     }
    // }

    // $scope.deleteThematicArea = function(){
    //     ApplicantPortal_Contoller.deleteThematicArea($scope.themeId, function (result, event) {
    //         if (event.status) {
    //             debugger;
    //             Swal.fire(
    //                 'Success',
    //                 'UnChecked Succesfully.',
    //                 'success'
    //             );
    //             $scope.$apply();
    //         }
    //     },
    //         {escape: true}
    //         )
    // }

    $scope.getDetails = function(){
        debugger;
        $scope.camDetails = result;
        {escape: false}
    }
    $scope.validateDate=function(){
        var Year;
        var Month;
        var Day;
        debugger
        if($scope.tentitiveStartDate!=undefined && $scope.tentitiveStartDate!=''){
            Year = $scope.tentitiveStartDate.getUTCFullYear();
            Month = $scope.tentitiveStartDate.getUTCMonth();
            Month=Month+1;
            Day = $scope.tentitiveStartDate.getDate();
          }
          var dayDiff = moment().diff(''+Year+'-'+Month+'-'+Day+'', 'days');
          if(dayDiff>0){
            swal('info','Tentative date can not be less than today date. ','info')
            $scope.tentitiveStartDate='';
            $scope.$apply();
          }
    }
    $scope.validateMaxLength=function(val){
        alert(val);
    }
    $(document).ready(function(){
        $("#txtDuration").keypress(function(e){
            debugger
            if(e.charCode>=48 && e.charCode<=57){
                return true;
            }
            else
            {
                return false;
            }
        });       
      });

      $scope.removeClass2=function(controlid){
        $("#"+controlid+"").removeClass('border-theme');
      }

    //   $(document).ready(function() {
    //     if($rootScope.proposalStage != "Draft"){
    //         CKEDITOR.config.readOnly = true;
    //     }
    // });
});