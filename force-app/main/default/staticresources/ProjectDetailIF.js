angular.module('cp_app').controller('ProjectDetailIF_Ctrl', function($scope,$sce,$rootScope) {
    $scope.objContactList=[];
    $scope.objProposal={};
    $scope.objContacts__r={};
    $scope.objContact1={};
    $scope.objIndFell={};
    $scope.doc={};
    $scope.objRtf=[{charCount:0,maxCharLimit:400,errorStatus:false}];
    $scope.objRtf.push({charCount:0,maxCharLimit:500,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:2000,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:400,errorStatus:false});
    
    $scope.getProjectdetils = function () {
      debugger;
      ApplicantPortal_Contoller.getAllUserDocSignature($rootScope.projectId, function (result, event) {
          debugger
          console.log('result return onload :: ');
          console.log(result);
          if (event.status) {
              $scope.allDocs = result;
              for(var i=0;i<$scope.allDocs.length;i++){
                  if($scope.allDocs[i].userDocument.Name == 'Attach any referred Image'){
                      $scope.doc=$scope.allDocs[i];
                  }
              }
              $scope.$apply();
          }
      }, {
          escape: true
      })
  }
  $scope.getProjectdetils();

  $scope.selectedFile;

  $scope.filePreviewHandler = function(fileContent){
    debugger;
    $scope.selectedFile = fileContent;

    console.log('selectedFile---', $scope.selectedFile);

    $('#file_frame').attr('src', $scope.selectedFile.ContentDistribution.DistributionPublicUrl);

    var myModal = new bootstrap.Modal(document.getElementById('filePreview'))        
    myModal.show('slow') ;
    $scope.$apply();

    //.ContentDistribution.DistributionPublicUrl
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
  // $scope.upsertProposal=function(){
  //   debugger
  //   if($rootScope.projectId==undefined || $rootScope.projectId=='' || $rootScope.projectId==' '){
  //     if(!$rootScope.proposalStage){
  //       $scope.objProposal.Proposal_Stages__c = 'Draft';    
  //   }
  //   else
  //   {
  //       $scope.objProposal.Proposal_Stages__c = 'Submitted';
  //   }
  //   if(!$rootScope.secondstage){
  //       $scope.objProposal.Stage__c = '1st Stage';    
  //   }
  //   else
  //   {
  //       $scope.objProposal.Stage__c = '2nd Stage';
  //   }
  //     IndustrialFellowshipController.upsertProposal($scope.objProposal,$rootScope.contactId, function (result, event) {
  //       $rootScope.projectId=result;
  //       $scope.$apply();
  //     });
  //   }
  // }
  // $scope.upsertProposal();
  $scope.uploadFile = function (type, userDocId, fileId, fileSizeFun) {
    debugger;
    maxFileSize=fileSizeFun;
    $scope.showSpinnereditProf = true;
    var file;

    file = document.getElementById(type).files[0];
    fileName = file.name;
    var typeOfFile = fileName.split(".");
    lengthOfType =  typeOfFile.length;
    if(typeOfFile[lengthOfType-1] == "jpg" || typeOfFile[lengthOfType-1] == "jpeg"){
        
    }else{
      swal('info','Please choose jpg/jpeg file only.','info');
        return;
    }
    console.log(file);
    if (file != undefined) {
        if (file.size <= maxFileSize) {
            
            attachmentName = file.name;
            const myArr = attachmentName.split(".");
            /* if (myArr[1] != "pdf" && type != 'profilePic') {
                alert("Please upload in PDF format only");
                return;
            } */
            var fileReader = new FileReader();
            fileReader.onloadend = function (e) {
                attachment = window.btoa(this.result);  //Base 64 encode the file before sending it
                positionIndex = 0;
                fileSize = attachment.length;
                $scope.showSpinnereditProf = false;
                console.log("Total Attachment Length: " + fileSize);
                doneUploading = false;
                debugger;
                
                if (fileSize < maxStringSize) {
                    $scope.uploadAttachment(type , userDocId, fileId);
                } else {
                  swal("info", "Base 64 Encoded file is too large.  Maximum size is " + maxStringSize + " your file is " + fileSize + ".","info");
                        return;
                    // alert("Base 64 Encoded file is too large.  Maximum size is " + maxStringSize + " your file is " + fileSize + ".");
                }

            }
            fileReader.onerror = function (e) {
              swal("info", "There was an error reading the file.  Please try again.","info");
                      return;
                // alert("There was an error reading the file.  Please try again.");
            }
            fileReader.onabort = function (e) {
              swal("info", "There was an error reading the file.  Please try again.","info");
                      return;
                // alert("There was an error reading the file.  Please try again.");
            }

            fileReader.readAsBinaryString(file);  //Read the body of the file

        } else {
          swal("info", "File must be under 1 Mb in size.  Your file is too large.  Please try again.","info");
          return;
        }
    } else {
      swal("info", "You must choose a file before trying to upload it","info");
        return;
        // alert("You must choose a file before trying to upload it");
        // $scope.showSpinnereditProf = false;
    }
}

$scope.uploadAttachment = function (type, userDocId, fileId) {
    debugger;
    var attachmentBody = "";
    if (fileId == undefined) {
        fileId = " ";
    }
    if (fileSize <= positionIndex + chunkSize) {
        debugger;
        attachmentBody = attachment.substring(positionIndex);
        doneUploading = true;
    } else {
        attachmentBody = attachment.substring(positionIndex, positionIndex + chunkSize);
    }
    console.log("Uploading " + attachmentBody.length + " chars of " + fileSize);
    ApplicantPortal_Contoller.doCUploadAttachmentSignature(
        attachmentBody, attachmentName,fileId, userDocId,
        function (result, event) {
            console.log(result);
            if (event.type === 'exception') {
                console.log("exception");
                console.log(event);
            } else if (event.status) {
                if (doneUploading == true) {
                    swal(
                        'success',
                        'Uploaded Successfully!',
                        'success'
                    )
                    
                    $scope.getProjectdetils();
                    // $scope.disableSubmit = false;
                        
                    }
                    $scope.showUplaodUserDoc = false;
                   // $scope.getCandidateDetails();

                } else {
                    debugger;
                    positionIndex += chunkSize;
                    $scope.uploadAttachment(type,userDocId,result);
                }
        },


        { buffer: true, escape: true, timeout: 120000 }
    );
}
 // $scope.getProjectdetils();
    $scope.getContactDet=function(){
    
    IndustrialFellowshipController.getContactDetailsFellowDet($rootScope.userId, function (result, event) {
            console.log(result);
            console.log(event);
            debugger
            if(result.Proposals__r!=undefined && result.Proposals__r!=''){
                $scope.objProposal=result.Proposals__r;
            }
            $scope.objIndFell=result;
            if(result.Contacts1__r!=undefined && result.Contacts1__r!=''){
                $scope.objContact1=result.Contacts1__r[0];   
            }
            else{
                $scope.objContact1={
                    Host_Details__c:result.Id,
                    MailingStreet:""
                };              
            }
            if(result.Contacts__r!=undefined && result.Contacts__r!=''){
                $scope.objContacts__r=result.Contacts__r[0];                
            }
            else
            {
                $scope.objContacts__r={
                    Mentor_Details__c:result.Id,
                    MailingStreet:""
                };                
            }   
            var mailingAddress=$scope.objContacts__r.MailingStreet;
                if(mailingAddress!=undefined && mailingAddress!=''){
                  var arrMA =mailingAddress.split(';');
                  $scope.MailingLine1=arrMA[0];
                  if(arrMA.length>0){
                    $scope.MailingLine2=arrMA[1];
                  }
                }
                var mailingAddress2=$scope.objContact1.MailingStreet;
                if(mailingAddress2!=undefined && mailingAddress2!=''){
                  var arrMA =mailingAddress2.split(';');
                  $scope.OtherLine1=arrMA[0];
                  if(arrMA.length>0){
                    $scope.OtherLine2=arrMA[1];
                  }
                }
                // if(result.OtherStreet!=undefined && result.OtherStreet!=''){
                //   var arrMA =result.OtherStreet.split(';');
                //   $scope.OtherLine1=arrMA[0];
                //   if(arrMA.length>0){
                //     $scope.OtherLine2=arrMA[1];
                //   }
                // }                     
            $scope.country=$rootScope.country;
            $scope.$apply();
            if(result.Proposals__r.Proposed_area__c != undefined || result.Proposals__r.Proposed_area__c != ""){
              result.Proposals__r.Proposed_area__c = result.Proposals__r.Proposed_area__c ? result.Proposals__r.Proposed_area__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('&gt;','>').replaceAll('&amp;','&') : result.Proposals__r.Proposed_area__c;
            }
            if(result.Proposals__r.Title_Of__c != undefined || result.Proposals__r.Title_Of__c != ""){
              result.Proposals__r.Title_Of__c = result.Proposals__r.Title_Of__c ? result.Proposals__r.Title_Of__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('&gt;','>').replaceAll('&amp;','&') : result.Proposals__r.Title_Of__c;
            }
            if(result.Proposals__r.Research_Approach_Objectives__c != undefined || result.Proposals__r.Research_Approach_Objectives__c != ""){
              result.Proposals__r.Research_Approach_Objectives__c = result.Proposals__r.Research_Approach_Objectives__c ? result.Proposals__r.Research_Approach_Objectives__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('&gt;','>').replaceAll('&amp;','&') : result.Proposals__r.Research_Approach_Objectives__c;
            }
            if(result.Proposals__r.Brief_Statement_of_Purpose__c != undefined || result.Proposals__r.Brief_Statement_of_Purpose__c != ""){
                result.Proposals__r.Brief_Statement_of_Purpose__c = result.Proposals__r.Brief_Statement_of_Purpose__c ? result.Proposals__r.Brief_Statement_of_Purpose__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('&gt;','>').replaceAll('&amp;','&') : result.Proposals__r.Brief_Statement_of_Purpose__c;
              }
              if(result.Proposals__r.Work_plan__c != undefined || result.Proposals__r.Work_plan__c != ""){
                result.Proposals__r.Work_plan__c = result.Proposals__r.Work_plan__c ? result.Proposals__r.Work_plan__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('&gt;','>').replaceAll('&amp;','&') : result.Proposals__r.Work_plan__c;
              }
              if(result.Proposals__r.Expected_Deliverables__c != undefined || result.Proposals__r.Expected_Deliverables__c != ""){
                result.Proposals__r.Expected_Deliverables__c = result.Proposals__r.Expected_Deliverables__c ? result.Proposals__r.Expected_Deliverables__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('&gt;','>').replaceAll('&amp;','&') : result.Proposals__r.Expected_Deliverables__c;
              }

    },{ escape: true });
}
$scope.setAddressSameAs=function(){
    if($scope.objContacts__r.Addess_same_as__c){
      $scope.objContacts__r.OtherStreet=$scope.objContacts__r.MailingStreet;
      $scope.OtherLine22=$scope.MailingLine2;
      $scope.objContacts__r.OtherCity=$scope.objContacts__r.MailingCity;
      $scope.objContacts__r.OtherState=$scope.objContacts__r.MailingState;
      $scope.objContacts__r.OtherCountry=$scope.objContacts__r.MailingCountry;
      $scope.objContacts__r.OtherPostalCode=$scope.objContacts__r.MailingPostalCode;
    }
    else
    {
      $scope.objContacts__r.OtherStreet=null;
      $scope.OtherLine22=null;
      $scope.objContacts__r.OtherCity=null;
      $scope.objContacts__r.OtherState=null;
      $scope.objContacts__r.OtherCountry=null;
      $scope.objContacts__r.OtherPostalCode=null;
    }
  }
  $scope.setAddressSameAsHost=function(){
    if($scope.objContact1.Addess_same_as__c){
      $scope.objContact1.OtherStreet=$scope.objContact1.MailingStreet;
      $scope.OtherLine223=$scope.MailingStreet3;
      $scope.objContact1.OtherCity=$scope.objContact1.MailingCity;
      $scope.objContact1.OtherState=$scope.objContact1.MailingState;
      $scope.objContact1.OtherCountry=$scope.objContact1.MailingCountry;
      $scope.objContact1.OtherPostalCode=$scope.objContact1.MailingPostalCode;
    }
    else
    {
      $scope.objContact1.OtherStreet=null;
      $scope.OtherLine223=null;
      $scope.objContact1.OtherCity=null;
      $scope.objContact1.OtherState=null;
      $scope.objContact1.OtherCountry=null;
      $scope.objContact1.OtherPostalCode=null;
    }
  }
$scope.clickFellowshipDetails=function(){
  debugger

    if($scope.objProposal.Proposed_area__c==undefined || $scope.objProposal.Proposed_area__c==null || $scope.objProposal.Proposed_area__c==''){
        swal('info','Please enter proposed area of work','info'); 
        $("#proposedArea").addClass('border-theme');       
        return;
      }
    if($scope.objProposal.Title_Of__c==undefined || $scope.objProposal.Title_Of__c==null || $scope.objProposal.Title_Of__c==''){
        swal('info','Please enter title of the proposed work','info'); 
        $("#title").addClass('border-theme');       
        return;
      }
      if($scope.objProposal.Duration_In_Months_Max_36__c==undefined || $scope.objProposal.Duration_In_Months_Max_36__c==null || $scope.objProposal.Duration_In_Months_Max_36__c==''){
        swal('info','Please enter duration of the fellowship in months','info');
        $("#duration").addClass('border-theme');        
        return;
      }

      if($scope.objIndFell.Industrial_Fellowship_Type__c == 'PIEF'){
        if($scope.objProposal.Duration_In_Months_Max_36__c < 3){
          swal('info','For PIEF, duration should be minimum 3 months.','info');
          $("#duration").addClass('border-theme');        
          return;
        }
      }

      if($scope.objIndFell.Industrial_Fellowship_Type__c == 'PDIF'){
        if($scope.objProposal.Duration_In_Months_Max_36__c < 6){
          swal('info','For PDIF, duration should be minimum 6 months.','info');
          $("#duration").addClass('border-theme');        
          return;
        }
      }

      if($scope.objProposal.Duration_In_Months_Max_36__c<=0){
        swal('info','Duration of the fellowship can not be zero','info');   
        $("#duration").addClass('border-theme');       
        return;
      }
      if($scope.objProposal.Brief_Statement_of_Purpose__c==undefined || $scope.objProposal.Brief_Statement_of_Purpose__c==null || $scope.objProposal.Brief_Statement_of_Purpose__c==''){
        swal('info','Please enter brief statement of purpose','info'); 
        return;
      }

      if($scope.objProposal.Brief_Statement_of_Purpose__c != undefined || $scope.objProposal.Brief_Statement_of_Purpose__c != ""){
              // var div = document.createElement("div");
              // div.innerHTML = $scope.objProposal.Brief_Statement_of_Purpose__c;
              // let brief = div.innerText.replace(/(\r\n\t|\t|\n|\r)/gm, "");
              // brief = brief.replaceAll(' ','');
            if($scope.objRtf[0].charCount > 400){
              swal('info','Max character limit for Brief Statement of Purpose is 400 only','info');
              return;
            }
    }

      if($scope.objProposal.Research_Approach_Objectives__c==undefined || $scope.objProposal.Research_Approach_Objectives__c==null || $scope.objProposal.Research_Approach_Objectives__c==''){
        swal('info','Please enter objective of the work','info');
        return;
      }

      if($scope.objProposal.Research_Approach_Objectives__c != undefined || $scope.objProposal.Research_Approach_Objectives__c != ""){
              // var div = document.createElement("div");
              // div.innerHTML = $scope.objProposal.Research_Approach_Objectives__c;
              // let research = div.innerText.replace(/(\r\n\t|\t|\n|\r)/gm, "");
              // research = research.replaceAll(' ','');
              if($scope.objRtf[1].charCount > 500){
              swal('info','Max character limit for Objectives of the work is 500 only','info');
              return;
              }
    }

      if($scope.objProposal.Work_plan__c==undefined || $scope.objProposal.Work_plan__c==null || $scope.objProposal.Work_plan__c==''){
        swal('info','Please enter work plan','info'); 
        return;
      }

      if($scope.objProposal.Work_plan__c != undefined || $scope.objProposal.Work_plan__c != ""){
              // var div = document.createElement("div");
              // div.innerHTML = $scope.objProposal.Work_plan__c;
              // let workplan = div.innerText.replace(/(\r\n\t|\t|\n|\r)/gm, "");
              // workplan = workplan.replaceAll(' ','');
              if($scope.objRtf[2].charCount > 2000){
              swal('info','Max character limit for Work plan is 2000 only','info');
              return;
              }
    }

      if($scope.objProposal.Expected_Deliverables__c==undefined || $scope.objProposal.Expected_Deliverables__c==null || $scope.objProposal.Expected_Deliverables__c==''){
        swal('info','Please enter Expected outcomes','info'); 
        return;
      }

      if($scope.objProposal.Expected_Deliverables__c != undefined || $scope.objProposal.Expected_Deliverables__c != ""){
              // var div = document.createElement("div");
              // div.innerHTML = $scope.objProposal.Expected_Deliverables__c;
              // let expected = div.innerText.replace(/(\r\n\t|\t|\n|\r)/gm, "");
              // expected = expected.replaceAll(' ','');
              if($scope.objRtf[3].charCount > 400){
              swal('info','Max character limit for Expected outcomes is 400 only','info');
              return;
              }
    }

    $scope.objContactList.push($scope.objContact1);
    $scope.objContactList.push($scope.objContacts__r);
    delete $scope.objProposal.briefStatement;
    delete $scope.objProposal.research;
    delete $scope.objProposal.workplan;
    delete $scope.objProposal.expected;
    delete $scope.objIndFell.Contacts__r;
    delete $scope.objIndFell.Contacts1__r;
    
    debugger;
    IndustrialFellowshipController.saveFellowshipProposal($rootScope.userId,$scope.objProposal,$scope.objIndFell,$rootScope.accountId,'Industrial Fellowship', function (result, event) {
      debugger;
        if($rootScope.proposalStage){
            $scope.redirectPageURL('AttachmentsIF');
            return; 
        }
            console.log(result);
            console.log(event);
            if (event.status) {
                if(result!=null){
                    $rootScope.projectId=result;
                }
                swal({
                  title: "Project Details",
                  text: 'Your Project details have been saved successfully',
                  icon: "success",
                  button: "ok!",
                }).then((value) => {
                    $scope.redirectPageURL('AchievementsIF');
                    });
              }
              else
              {
                swal({
                  title: "Fellowship Details",
                  text: "Exception!",
                  icon: "error",
                  button: "ok!",
                });
              }

    },{ escape: true });
}
       $scope.restrictDecimalVal = function(myVar){
        debugger;
        myVar = Number(myVar);
        if(myVar>12){
            $scope.objProposal.Duration_In_Months_Max_36__c=12;
        }
        else{
          return true;
        }
    }
    $scope.restrictDecimalVal2 = function(myVar){
      debugger;
      myVar = Number(myVar);
      if(myVar>6){
        $scope.objProposal.Duration_In_Months_Max_36__c=6;
      }
       else{
        return true;
      }
      $scope.$apply();
  }
$scope.redirectPageURL=function(URL){
    var link=document.createElement("a");
    link.id = 'someLink'; //give it an ID!
    link.href='#/'+URL+'';
    link.click();
}
$scope.clickPreviousFellowshipDetails=function(){
    var link=document.createElement("a");
        link.id = 'someLink'; //give it an ID!
        link.href="#/EmploymentDetailsIF";
        link.click();
}
$scope.getContactDet();

$scope.validate=function(){
  debugger;
  if($scope.objIndFell.Industrial_Fellowship_Type__c=="PDIF"){
      if($scope.objProposal.Duration_In_Months_Max_36__c>12){
          $("#spnErrMsg"+index+"").addClass('show');
          $("#txtPer"+index+"").addClass('border-theme');
          $("#spnErrMsg"+index+"").html('maximum 12 is allowed in Duration');
      }
  }
  else if($scope.objIndFell.Industrial_Fellowship_Type__c=="PIEF"){
    if($scope.objProposal.Duration_In_Months_Max_36__c>6){
      $("#spnErrMsg"+index+"").addClass('show');
      $("#txtPer"+index+"").addClass('border-theme');
      $("#spnErrMsg"+index+"").html('maximum 6 is allowed in Duration');
  }
  }
}

$scope.removeClass2=function(controlid){
  $("#"+controlid+"").removeClass('border-theme');
}

});