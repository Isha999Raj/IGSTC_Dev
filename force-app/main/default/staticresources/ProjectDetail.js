angular.module('cp_app').controller('projectCtrl', function($scope,$sce,$rootScope) {
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
    console.log('second stage=>'+$rootScope.secondstage);
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
                    result.Research_Approach_Objectives__c = result.Research_Approach_Objectives__c ? result.Research_Approach_Objectives__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Research_Approach_Objectives__c;
                }
                if(result.Current_State_Of_The_Art__c != undefined || result.Current_State_Of_The_Art__c != ""){
                    result.Current_State_Of_The_Art__c = result.Current_State_Of_The_Art__c ? result.Current_State_Of_The_Art__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Current_State_Of_The_Art__c;
                }
                if(result.Project_Description__c != undefined || result.Project_Description__c != ""){
                    result.Project_Description__c = result.Project_Description__c ? result.Project_Description__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Project_Description__c;
                }
                if(result.Expected_Deliverables__c != undefined || result.Expected_Deliverables__c != ""){
                    result.Expected_Deliverables__c = result.Expected_Deliverables__c ? result.Expected_Deliverables__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Expected_Deliverables__c;
                }
                if(result.Reasons_For_And_Benefits_Of_Cooperation__c != undefined || result.Reasons_For_And_Benefits_Of_Cooperation__c != ""){
                    result.Reasons_For_And_Benefits_Of_Cooperation__c = result.Reasons_For_And_Benefits_Of_Cooperation__c ? result.Reasons_For_And_Benefits_Of_Cooperation__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Reasons_For_And_Benefits_Of_Cooperation__c;
                }
                if(result.Equipment__c != undefined || result.Equipment__c != ""){
                    result.Equipment__c = result.Equipment__c ? result.Equipment__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Equipment__c;
                }
                if(result.Criteria_For_Abandoning_The_Project__c != undefined || result.Criteria_For_Abandoning_The_Project__c != ""){
                    result.Criteria_For_Abandoning_The_Project__c = result.Criteria_For_Abandoning_The_Project__c ? result.Criteria_For_Abandoning_The_Project__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Criteria_For_Abandoning_The_Project__c;
                }
                if(result.Innovative_Aspects__c != undefined || result.Innovative_Aspects__c != ""){
                    result.Innovative_Aspects__c = result.Innovative_Aspects__c ? result.Innovative_Aspects__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Innovative_Aspects__c;
                }
                if(result.Research_Scholars__c != undefined || result.Research_Scholars__c != ""){
                    result.Research_Scholars__c = result.Research_Scholars__c ? result.Research_Scholars__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Research_Scholars__c;
                }
                if(result.Necessity_Of_Funding__c != undefined || result.Necessity_Of_Funding__c != ""){
                    result.Necessity_Of_Funding__c = result.Necessity_Of_Funding__c ? result.Necessity_Of_Funding__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Necessity_Of_Funding__c;
                }
                $scope.proposalDetails = result;
                $scope.$apply();
            }
        },
                                                  {escape: true}
                                                 )
    }
    $scope.getProjectdetils();
    $scope.getDocsDet = function () {
        debugger;
        $scope.selectedFile = '';
        $('#file_frame').attr('src', '');
        ApplicantPortal_Contoller.getAllProposalDoc($rootScope.projectId, function (result, event) {
            debugger
            console.log('onload doc:: ');
            console.log(result);
            if (event.status) {
                $scope.allDocs = result;
                var uploadCount=0;
                for(var i=0;i<$scope.allDocs.length;i++){
                    debugger;
                    if($scope.allDocs[i].userDocument.Name == 'Project Details'){
                        $scope.doc=$scope.allDocs[i];
                    }
                }
                $scope.$apply();
            }
        }, {
            escape: true
        })
    }
    $scope.getDocsDet();
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
    $scope.uploadFile = function (type, userDocId, fileId) {
        debugger;
        $scope.showSpinnereditProf = true;
        var file;
        maxFileSize=5191680;
    file = document.getElementById('fileSignature').files[0];
    fileName = file.name;
    var typeOfFile = fileName.split(".");
    lengthOfType =  typeOfFile.length;
    if(typeOfFile[lengthOfType-1] == "pdf" || typeOfFile[lengthOfType-1] == "PDF"){
        
    }else{
      swal('info','Please choose pdf only.','info');
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
            ApplicantPortal_Contoller.doCUploadAttachmentProjectDet(
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
                            
                            //$scope.getProjectdetils();
                            $scope.getDocsDet();
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
    // $scope.uploadFile = function (type, userDocId, fileId,maxSize,minFileSize) {
    //     debugger;
    //     $scope.showSpinnereditProf = true;
    //     var file;
    
    //         file = document.getElementById('attachmentFiles').files[0];
    //         fileName = file.name;
    //         var typeOfFile = fileName.split(".");
    //         lengthOfType =  typeOfFile.length;
    //         if(typeOfFile[lengthOfType-1] != "pdf"){
    //             swal('info','Please choose pdf file only.','info');
    //             return;
    //         }
    //     console.log(file);
    //     maxFileSize=maxSize;
    //     if (file != undefined) {
    //         if (file.size <= maxFileSize) {
                
    //             attachmentName = file.name;
    //             const myArr = attachmentName.split(".");
    //             var fileReader = new FileReader();
    //             fileReader.onloadend = function (e) {
    //                 attachment = window.btoa(this.result);  //Base 64 encode the file before sending it
    //                 positionIndex = 0;
    //                 fileSize = attachment.length;
    //                 $scope.showSpinnereditProf = false;
    //                 console.log("Total Attachment Length: " + fileSize);
    //                 doneUploading = false;
    //                 debugger;
    //                 if (fileSize < maxStringSize) {
    //                     $scope.uploadAttachment(type , userDocId, null);
    //                 } else {
    //                     swal('info','Base 64 Encoded file is too large.  Maximum size is " + maxStringSize + " your file is " + fileSize + ".','info');
    //                     return;
    //                 }
    
    //             }
    //             fileReader.onerror = function (e) {
    //                 swal('info','There was an error reading the file.  Please try again.','info');
    //                 return;
    //             }
    //             fileReader.onabort = function (e) {
    //                 swal('info','There was an error reading the file.  Please try again.','info');
    //                 return;
    //             }
    
    //             fileReader.readAsBinaryString(file);  //Read the body of the file
    
    //         } else {
    //             swal('info','Your file is too large.  Please try again.','info');
    //             return;
    //             $scope.showSpinnereditProf = false;
    //         }
    //     } else {
    //         swal('info','You must choose a file before trying to upload it','info');
    //         return;
    //         $scope.showSpinnereditProf = false;
    //     }
    // }
    
    // $scope.uploadAttachment = function (type, userDocId, fileId) {
    //     debugger;
    //     var attachmentBody = "";
    //     // if (fileId == undefined) {
    //     //     fileId = " ";
    //     // }
    //     if (fileSize <= positionIndex + chunkSize) {
    //         debugger;
    //         attachmentBody = attachment.substring(positionIndex);
    //         doneUploading = true;
    //     } else {
    //         attachmentBody = attachment.substring(positionIndex, positionIndex + chunkSize);
    //     }
    //     console.log("Uploading " + attachmentBody.length + " chars of " + fileSize);
    //     ApplicantPortal_Contoller.doCUploadAttachmentAa(
    //         attachmentBody, attachmentName,fileId, userDocId, 
    //         function (result, event) {
    //             console.log(result);
    //             if (event.type === 'exception') {
    //                 console.log("exception");
    //                 console.log(event);
    //             } else if (event.status) {
    //                 if (doneUploading == true) {
    //                     $scope.getProjectdetils();
                        
    //                     swal(
    //                         'success',
    //                         'Uploaded Successfully!',
    //                         'success'
    //                     )
    //                     $scope.getProjectdetils();
    //                     // $scope.disableSubmit = false;
                            
    //                     }
    //                    // $scope.getCandidateDetails();\
    //                    else {
    //                     debugger;
    //                     positionIndex += chunkSize;
    //                     $scope.uploadAttachment(type,userDocId,result);
    //                 }
    //                 $scope.showUplaodUserDoc = false;
    //                 } 
    //         },
    
    
    //         { buffer: true, escape: true, timeout: 120000 }
    //     );
    // }
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

        // if($scope.proposalDetails.Research_Approach_Objectives__c == undefined || $scope.proposalDetails.Research_Approach_Objectives__c == ""){
        //     Swal.fire(
        //         '',
        //       'Please fill main objectives of the research proposal.',
        //       'error'
        //       );
        //       return;
        // }
        // if($scope.proposalDetails.Current_State_Of_The_Art__c == undefined || $scope.proposalDetails.Current_State_Of_The_Art__c == ""){
        //     Swal.fire(
        //         '',
        //       'Please fill current state of the art.',
        //       'error'
        //       );
        //       return;
        // }
        // if($scope.proposalDetails.Project_Description__c == undefined || $scope.proposalDetails.Project_Description__c == ""){
        //     Swal.fire(
        //         '',
        //       'Please fill Project description of proposal.',
        //       'error'
        //       );
        //       return;
        // }
        // if($scope.proposalDetails.Expected_Deliverables__c == undefined || $scope.proposalDetails.Expected_Deliverables__c == ""){
        //     Swal.fire(
        //         '',
        //       'Please fill Expected Deliverables.',
        //       'error'
        //       );
        //       return;
        // }
        // if($scope.proposalDetails.Reasons_For_And_Benefits_Of_Cooperation__c == undefined || $scope.proposalDetails.Reasons_For_And_Benefits_Of_Cooperation__c == ""){
        //     Swal.fire(
        //         '',
        //       'Please fill Reasons for and benefits of cooperation including previous collaboration with the partner country.',
        //       'error'
        //       );
        //       return;
        // }
        // if($scope.proposalDetails.Equipment__c == undefined || $scope.proposalDetails.Equipment__c == ""){
        //     Swal.fire(
        //         '',
        //       'Please fill Proposal Equipment.',
        //       'error'
        //       );
        //       return;
        // }

        // if(($scope.proposalDetails.Criteria_For_Abandoning_The_Project__c == undefined || $scope.proposalDetails.Criteria_For_Abandoning_The_Project__c == "") && $rootScope.secondstage == true)
        //             {
        //                 Swal.fire(
        //                   '',
        //                 'Please fill citeria for abandoning the project.',
        //                 'error'
        //                 );
        //                     return;
        //             }

        // if(($scope.proposalDetails.Necessity_Of_Funding__c == undefined || $scope.proposalDetails.Necessity_Of_Funding__c == "") && $rootScope.secondstage == true)
        // {
        //     Swal.fire(
        //         '',
        //     'Tell us your necessity of funding..',
        //     'error'
        //     );
        //         return;
        // }
        $("#btnSubmit").html('<i class="fa-solid fa-spinner fa-spin-pulse me-3"></i>Please wait...');
        ApplicantPortal_Contoller.insertProjectDetails($scope.proposalDetails, function(result,event){
            $("#btnSubmit").html('<i class="fa-solid fa-check me-2"></i>Save and Next');
            if(event.status){
                debugger;
                swal({
                    title: "Success",
                    text: "Project Details have been saved successfully.",
                    icon: "success",
                    buttons: true,
                    dangerMode: false,
                }).then((willDelete) => {
                    if (willDelete) {       
                        if($rootScope.secondstage){             
                            $scope.redirectPageURL('ExpenseDeclaration');
                        }else{
                            $scope.redirectPageURL('Declartion_2plus2');
                        }
                    } else {
                     return;
                    }
                  });
    
                // Swal.fire(
                //     'Success',
                //     'Project Details have been saved successfully.',
                //     'success'
                // );
                // $scope.redirectPageURL('WorkPackages');
                // $scope.proposalDetails = result;
                // $scope.$apply();
            }
        },
       {escape: true}
        )
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