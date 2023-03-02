angular.module('cp_app').controller('projectCtrl', function($scope,$rootScope) {
    debugger
    $scope.config = {}; 
    $scope.config.toolbarGroups = [
    { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
    { name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
    { name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
    { name: 'forms', groups: [ 'forms' ] },
    { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
    { name: 'links', groups: [ 'links' ] },
    { name: 'insert', groups: [ 'insert' ] },
    { name: 'styles', groups: [ 'styles' ] },
    { name: 'colors', groups: [ 'colors' ] },
    { name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
    { name: 'tools', groups: [ 'tools' ] },
    { name: 'others', groups: [ 'others' ] },
    { name: 'about', groups: [ 'about' ] }
];
$scope.config.removeButtons = 'BGColor,Anchor,Subscript,Superscript,Paste,Copy,Cut,Undo,Redo';
    debugger;
    $scope.siteURL = siteURL;  
    $scope.proposalDetails = {};
    $scope.disable = false;
    $rootScope.secondstage;
    $scope.objRtf=[{charCount:0,maxCharLimit:0,errorStatus:false}];
    $scope.objRtf.push({charCount:0,maxCharLimit:0,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:0,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:0,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:0,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:0,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:0,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:0,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:0,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:0,errorStatus:false});

    $scope.getProjectdetils = function(){
        debugger;
        ApplicantPortal_Contoller.getProjectdetils($rootScope.userId, function(result,event){
            debugger;
            if(event.status && result){
                debugger;
                if(result.Research_Approach_Objectives__c != undefined || result.Research_Approach_Objectives__c != ""){
                    result.Research_Approach_Objectives__c = result.Research_Approach_Objectives__c ? result.Research_Approach_Objectives__c.replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Research_Approach_Objectives__c;
                }
                if(result.Current_State_Of_The_Art__c != undefined || result.Current_State_Of_The_Art__c != ""){
                    result.Current_State_Of_The_Art__c = result.Current_State_Of_The_Art__c ? result.Current_State_Of_The_Art__c.replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Current_State_Of_The_Art__c;
                }
                if(result.Project_Description__c != undefined || result.Project_Description__c != ""){
                    result.Project_Description__c = result.Project_Description__c ? result.Project_Description__c.replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Project_Description__c;
                }
                if(result.Expected_Deliverables__c != undefined || result.Expected_Deliverables__c != ""){
                    result.Expected_Deliverables__c = result.Expected_Deliverables__c ? result.Expected_Deliverables__c.replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Expected_Deliverables__c;
                }
                if(result.Reasons_For_And_Benefits_Of_Cooperation__c != undefined || result.Reasons_For_And_Benefits_Of_Cooperation__c != ""){
                    result.Reasons_For_And_Benefits_Of_Cooperation__c = result.Reasons_For_And_Benefits_Of_Cooperation__c ? result.Reasons_For_And_Benefits_Of_Cooperation__c.replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Reasons_For_And_Benefits_Of_Cooperation__c;
                }
                if(result.Equipment__c != undefined || result.Equipment__c != ""){
                    result.Equipment__c = result.Equipment__c ? result.Equipment__c.replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Equipment__c;
                }
                if(result.Criteria_For_Abandoning_The_Project__c != undefined || result.Criteria_For_Abandoning_The_Project__c != ""){
                    result.Criteria_For_Abandoning_The_Project__c = result.Criteria_For_Abandoning_The_Project__c ? result.Criteria_For_Abandoning_The_Project__c.replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Criteria_For_Abandoning_The_Project__c;
                }
                if(result.Innovative_Aspects__c != undefined || result.Innovative_Aspects__c != ""){
                    result.Innovative_Aspects__c = result.Innovative_Aspects__c ? result.Innovative_Aspects__c.replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Innovative_Aspects__c;
                }
                if(result.Research_Scholars__c != undefined || result.Research_Scholars__c != ""){
                    result.Research_Scholars__c = result.Research_Scholars__c ? result.Research_Scholars__c.replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Research_Scholars__c;
                }
                if(result.Necessity_Of_Funding__c != undefined || result.Necessity_Of_Funding__c != ""){
                    result.Necessity_Of_Funding__c = result.Necessity_Of_Funding__c ? result.Necessity_Of_Funding__c.replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Necessity_Of_Funding__c;
                }
                $scope.proposalDetails = result;
                $scope.$apply();
            }
        },
                                                  {escape: true}
                                                 )
    }
    $scope.getProjectdetils();

    $scope.readCharacter=function(event,index){
        debugger
           try{
           var rtfString=event.toString().replace(/<[^>]*>|\s/g, '').replace(/\s+/g,'').replace(/&ndash;/g,'-').replace(/&euro;/g,'1').replace(/&amp;/g,'1').replace(/&#39;/g,'1').replace(/&quot;/g,'1').replace(/&nbsp;/g,'').replace(/&mdash;/g,'-').replace(/&gt;/g,'>').replace(/&lt;/g,'<').replace(/&bull;/g,'');
            charLength=rtfString.length;
            if(charLength>0){
             $scope.objRtf[index].charCount=charLength;
            }
            else{
                  $scope.objRtf[index].charCount=0;
            }
           }catch(e){}
       }

    $scope.saveDetails = function(){
        debugger;

        if($scope.proposalDetails.Research_Approach_Objectives__c == undefined || $scope.proposalDetails.Research_Approach_Objectives__c == ""){
            Swal.fire(
                '',
              'Please fill main objectives of the research proposal.',
              'error'
              );
              return;
        }
        if($scope.proposalDetails.Current_State_Of_The_Art__c == undefined || $scope.proposalDetails.Current_State_Of_The_Art__c == ""){
            Swal.fire(
                '',
              'Please fill current state of the art.',
              'error'
              );
              return;
        }
        if($scope.proposalDetails.Project_Description__c == undefined || $scope.proposalDetails.Project_Description__c == ""){
            Swal.fire(
                '',
              'Please fill Project description of proposal.',
              'error'
              );
              return;
        }
        if($scope.proposalDetails.Expected_Deliverables__c == undefined || $scope.proposalDetails.Expected_Deliverables__c == ""){
            Swal.fire(
                '',
              'Please fill Expected Deliverables.',
              'error'
              );
              return;
        }
        if($scope.proposalDetails.Reasons_For_And_Benefits_Of_Cooperation__c == undefined || $scope.proposalDetails.Reasons_For_And_Benefits_Of_Cooperation__c == ""){
            Swal.fire(
                '',
              'Please fill Reasons for and benefits of cooperation including previous collaboration with the partner country.',
              'error'
              );
              return;
        }
        if($scope.proposalDetails.Equipment__c == undefined || $scope.proposalDetails.Equipment__c == ""){
            Swal.fire(
                '',
              'Please fill Proposal Equipment.',
              'error'
              );
              return;
        }

        if(($scope.proposalDetails.Criteria_For_Abandoning_The_Project__c == undefined || $scope.proposalDetails.Criteria_For_Abandoning_The_Project__c == "") && $rootScope.secondstage == true)
                    {
                        Swal.fire(
                          '',
                        'Please fill citeria for abandoning the project.',
                        'error'
                        );
                            return;
                    }

        if(($scope.proposalDetails.Necessity_Of_Funding__c == undefined || $scope.proposalDetails.Necessity_Of_Funding__c == "") && $rootScope.secondstage == true)
        {
            Swal.fire(
                '',
            'Tell us your necessity of funding..',
            'error'
            );
                return;
        }
        ApplicantPortal_Contoller.insertProjectDetails($scope.proposalDetails, function(result,event){
            if(event.status){
                debugger;
                Swal.fire(
                    'Success',
                    'Your Proposal Detail has been saved successfully.',
                    'success'
                );
                $scope.redirectPageURL('WorkPackages');
                $scope.proposalDetails = result;
                $scope.$apply();
            }
        },
       {escape: true}
        )
    }
    
    $scope.uploadFile = function (proposalId, fileId) {
        debugger;
        $scope.showSpinner = true;
        var file = document.getElementById('attachmentFiles').files[0];
        /* if (type == 'profilePic') {
                    file = document.getElementById('profilePic').files[0];
                } else if (type == 'resume') {
                    file = document.getElementById('resumeAttachmentFile').files[0];
                }
                else { */
                    //file = ;
                    //}
                    
                    console.log(file);
                    if (file != undefined) {
                        if (file.size <= maxFileSize) {
                            
                            attachmentName = file.name;
                            const myArr = attachmentName.split(".");
                            if (myArr[1] != "pdf") {
                                alert("Please upload in PDF format only");
                                return;
                            }
                            var fileReader = new FileReader();
                            fileReader.onloadend = function (e) {
                                attachment = window.btoa(this.result);  //Base 64 encode the file before sending it
                                positionIndex = 0;
                                fileSize = attachment.length;
                                $scope.showSpinner = false;
                                console.log("Total Attachment Length: " + fileSize);
                                doneUploading = false;
                                if (fileSize < maxStringSize) {
                                    $scope.uploadAttachment(proposalId, fileId); //Attachment, proposalId, 
                                } else {
                                    alert("Base 64 Encoded file is too large.  Maximum size is " + maxStringSize + " your file is " + fileSize + ".");
                                }
                                
                            }
                            fileReader.onerror = function (e) {
                                alert("There was an error reading the file.  Please try again.");
                            }
                            fileReader.onabort = function (e) {
                                alert("There was an error reading the file.  Please try again.");
                            }
                            
                            fileReader.readAsBinaryString(file);  //Read the body of the file
                            
                        } else {
                            alert("File must be under 4.3 MB in size.  Your file is too large.  Please try again.");
                            $scope.showSpinner = false;
                        }
                    } else {
                        alert("You must choose a file before trying to upload it");
                        $scope.showSpinner = false;
                    }
                }
                
                $scope.uploadAttachment = function (proposalId, fileId) { //fileId = conVer id , proposalId = userDocumentId;
                    var attachmentBody = "";
                    if (fileId == undefined) {
                        fileId = "";
                    }
                    if (fileSize <= positionIndex + chunkSize) {
                        attachmentBody = attachment.substring(positionIndex);
                        doneUploading = true;
                    } else {
                        attachmentBody = attachment.substring(positionIndex, positionIndex + chunkSize);
                    }
                    console.log("Uploading " + attachmentBody.length + " chars of " + fileSize);
                    
                    //console.log("Type----",type);
                    console.log("attachmentBody----", attachmentBody);
                    console.log("attachmentName----", attachmentName);
                    console.log("candidateId----", candidateId);
                    console.log("proposalId----", proposalId);
                    console.log("fileId----", fileId);
                    
                    
                    ApplicantPortal_Contoller.doCUploadAttachment(attachmentBody, attachmentName, fileId, proposalId,
                                                                 function (cvId, event) {
                                                                     console.log(cvId);
                                                                     if(cvId === 'ERROR') {
                                                                         alert('Something went wrong, please contact support@ondonte.com');
                                                                         return;
                                                                     }
                                                                     if (event.type === 'exception') {
                                                                         console.log("exception");
                                                                         console.log(event);
                                                                     } else if (event.status) {
                                                                         if (doneUploading == true) {
                                                                             // debugger;
                                                                             if ($scope.isExpirable) {
                                                                                 $scope.updateDocExpiryDate();
                                                                             }
                                                                             Swal.fire(
                                                                                 '',
                                                                                 'Uploaded Successfully!',
                                                                                 'success'
                                                                             )
                                                                             $("#fileUploadModel").modal('hide');
                                                                             $("#resumeUploadModel").modal('hide');
                                                                             $scope.showUplaodUserDoc = false;
                                                                             debugger;
                                                                             CandidateDashboard_Controller.updateUserDoc(proposalId, fileId, function(result, evnet) {
                                                                                 if(result === "success") {
                                                                                     $scope.getContactUserDoc();
                                                                                 }else {
                                                                                     alert('Something went wrong, please contact support@ondonte.com');
                                                                                 }
                                                                                 
                                                                             });
                                                                             // $scope.getCandidateDetails();
                                                                         } else {
                                                                             debugger;
                                                                             positionIndex += chunkSize;
                                                                             $scope.uploadAttachment(proposalId, cvId);
                                                                         }
                                                                     } else {
                                                                         console.log(event.message);
                                                                     }
                                                                 },
                                                                 
                                                                 
                                                                 { buffer: true, escape: true, timeout: 120000 }
                                                                );
                }   
                
                $scope.uploadFileToUserDoc = function () {
                    debugger;
                    $scope.selecteduDoc;
                    if ($scope.fileId != undefined) {
                        $scope.uploadFile($scope.proposalDetails.Id, $scope.fileId);
                    } else {
                        $scope.uploadFile($scope.proposalDetails.Id, "");                    
                    } 
                }
                
                $scope.redirectPageURL = function(pageName){
                    debugger;
                    var link=document.createElement("a");
                    link.id = 'someLink'; //give it an ID!
                    link.href="#/"+pageName;
                    link.click();
                }
                
            });