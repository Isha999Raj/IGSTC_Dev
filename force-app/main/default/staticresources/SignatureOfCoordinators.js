angular.module('cp_app').controller('sign_Ctrl', function($scope,$sce,$rootScope) {
    debugger;
    $scope.siteURL = siteURL;
    $rootScope.projectId;
    $scope.decDetails = {};
    $scope.SignDate=new Date($rootScope.signDate);
    $scope.disableUploadButton = true;

    $scope.getProposalConsentCheckbox = function(){
        debugger;
        ApplicantPortal_Contoller.getConsentCheckbox($rootScope.projectId, function(result,event){
            if(event.status){
                debugger;
                $scope.checkbox = result;
                for(var i=0;i<result.Contacts__r.length;i++){
                    if(result.Contacts__r[i].Account.Country_Type__c == "India"){
                        $scope.indianCo = result.Contacts__r[i].Id;
                    }else if(result.Contacts__r[i].Account.Country_Type__c == "Germany"){
                        $scope.germanCo = result.Contacts__r[i].Id;
                    }
                }
                $scope.$apply();
            }
        },
        {escape:true}
        )
    }
    $scope.getProposalConsentCheckbox();

    $scope.getProjectdetils = function () {
        debugger;
        ApplicantPortal_Contoller.getAllUserDoc($rootScope.projectId, function (result, event) {
            debugger
            console.log('result return onload :: ');
            console.log(result);
            if (event.status) {
                $scope.allDocs = result;
                for(var i=0;i<$scope.allDocs.length;i++){
                    if($scope.allDocs[i].userDocument.Name == 'Coordinator 1 Signature'){
                        $scope.doc=$scope.allDocs[i];
                    }
                    if($scope.allDocs[i].userDocument.Name == 'Coordinator 2 Signature'){
                        $scope.doc2=$scope.allDocs[i];
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

    $scope.uploadFile = function (type, userDocId, fileId,maxSize,minFileSize) {
        debugger;
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
    maxFileSize=maxSize;
    if (file != undefined) {
        if (file.size <= maxFileSize) {
            if(file.size<minFileSize){
                swal('info','Your file is too small. Please try again.','info');
                return;
                // alert("Your file is too small. Please try again.");
                // return;
            }
            attachmentName = file.name;
            const myArr = attachmentName.split(".");
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
                    $scope.uploadAttachment(type , userDocId, null);
                } else {
                    swal('info','Base 64 Encoded file is too large.  Maximum size is " + maxStringSize + " your file is " + fileSize + ".','info');
                    return;
                    // alert("Base 64 Encoded file is too large.  Maximum size is " + maxStringSize + " your file is " + fileSize + ".");
                }
    
            }
            fileReader.onerror = function (e) {
                swal('info','There was an error reading the file.  Please try again.','info');
                return;
                // alert("There was an error reading the file.  Please try again.");
            }
            fileReader.onabort = function (e) {
                swal('info','There was an error reading the file.  Please try again.','info');
                return;
                // alert("There was an error reading the file.  Please try again.");
            }
    
            fileReader.readAsBinaryString(file);  //Read the body of the file
    
        } else {
            swal('info','Your file is too large.  Please try again.','info');
            return;
            // alert("Your file is too large.  Please try again.");
            $scope.showSpinnereditProf = false;
        }
    } else {
        swal('info','You must choose a file before trying to upload it','info');
        return;
        // alert("You must choose a file before trying to upload it");
        $scope.showSpinnereditProf = false;
    }
    }
    
        $scope.uploadAttachment = function (type, userDocId, fileId) {
            debugger;
            var attachmentBody = "";
            // if (fileId == undefined) {
            //     fileId = " ";
            // }
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
                            $scope.getProjectdetils();
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

    // $scope.getUserDocs = function () {
    //     debugger;
    //     ApplicantPortal_Contoller.getContactUserDoc($rootScope.contactId, function (result, event) {
    //         if (event.status) {
    //             $scope.proposalDetails = result;
    //             var uploadCount=0;
    //             for(var i=0;i<$scope.proposalDetails.length;i++){
    //                 if($scope.proposalDetails[i].userDocument.Status__c == 'Uploaded'){
    //                     uploadCount=uploadCount+1;
    //                     if(uploadCount==$scope.proposalDetails.length)
    //                         $scope.disableUploadButton = false;
    //                 }
    //             }
    //             $scope.$apply();
    //         }
    //     }, {
    //         escape: true
    //     })
    // }
    // $scope.getUserDocs();

    // $scope.createUserDocument = function(){
    //     debugger;
    //     ApplicantPortal_Contoller.createUserDocument("", $rootScope.contactId, $rootScope.projectId,"", function(result,event){
    //         debugger;
    //         if(event.status && result){
    //             if(result != null){
    //                 $scope.uploadFile('sign',result,'');
    //             }
    //             debugger;
    //             $scope.$apply();
    //         }
    //     },
    //                                               {escape: true}
    //                                              )
    // }

//     var maxStringSize = 6000000;    //Maximum String size is 6,000,000 characters
//     var maxFileSize = 4350000;      //After Base64 Encoding, this is the max file size
//     var chunkSize = 950000;         //Maximum Javascript Remoting message size is 1,000,000 characters
//     var attachment;
//     var attachmentName;
//     var fileSize;
//     var positionIndex;
//     var doneUploading;
//     var appId = "{!$CurrentPage.parameters.id}";
//     var conId = "{!contactId}"
//     //Method to prepare a file to be attached to the Account bound to the page by the standardController
//     $scope.uploadFile = function (type, userDocId, fileId) {
//       debugger;
//       $scope.showSpinnereditProf = true;
//       var file;
//       if (type == 'sign') {
//           file = document.getElementById('sign').files[0];
//           // userDocId = $rootScope.contactId;
//       } else if (type == 'resume') {
//           file = document.getElementById('resumeAttachmentFile').files[0];
//       }
     
//       console.log(file);
//       if (file != undefined) {
//           if (file.size <= maxFileSize) {
              
//               attachmentName = file.name;
//               const myArr = attachmentName.split(".");
//               if (myArr[1] != "pdf" && type != 'profilePic') {
//                   alert("Please upload in PDF format only");
//                   return;
//               }
//               var fileReader = new FileReader();
//               fileReader.onloadend = function (e) {
//                   attachment = window.btoa(this.result);  //Base 64 encode the file before sending it
//                   positionIndex = 0;
//                   fileSize = attachment.length;
//                   $scope.showSpinnereditProf = false;
//                   console.log("Total Attachment Length: " + fileSize);
//                   doneUploading = false;
//                   debugger;
//                   if (fileSize < maxStringSize) {
//                       $scope.uploadAttachment(type , userDocId, fileId);
//                   } else {
//                       alert("Base 64 Encoded file is too large.  Maximum size is " + maxStringSize + " your file is " + fileSize + ".");
//                   }

//               }
//               fileReader.onerror = function (e) {
//                   alert("There was an error reading the file.  Please try again.");
//               }
//               fileReader.onabort = function (e) {
//                   alert("There was an error reading the file.  Please try again.");
//               }

//               fileReader.readAsBinaryString(file);  //Read the body of the file

//           } else {
//               alert("File must be under 4.3 MB in size.  Your file is too large.  Please try again.");
//               $scope.showSpinnereditProf = false;
//           }
//       } else {
//           // alert("You must choose a file before trying to upload it");
//           $scope.showSpinnereditProf = false;
//       }
//   }
//   $scope.uploadAttachment = function (type, userDocId, fileId) {
//       var attachmentBody = "";
//       if (fileId == undefined) {
//           fileId = " ";
//       }
//       if (fileSize <= positionIndex + chunkSize) {
//           debugger;
//           attachmentBody = attachment.substring(positionIndex);
//           doneUploading = true;
//       } else {
//           attachmentBody = attachment.substring(positionIndex, positionIndex + chunkSize);
//       }
//       console.log("Uploading " + attachmentBody.length + " chars of " + fileSize);
//       ApplicantPortal_Contoller.doCUploadAttachment(
//           attachmentBody, attachmentName,fileId, userDocId,
//           function (result, event) {
//               console.log(result);
//               if (event.type === 'exception') {
//                   console.log("exception");
//                   console.log(event);
//               } else if (event.status) {
//                   if (doneUploading == true) {
//                       if (type == 'profilePic') {
//                       }else{
//                           Swal.fire(
//                               '',
//                               'Uploaded Successfully!',
//                               'success'
//                           )
//                           $scope.getUserDocs();
                          
                          
//                       }
//                      // $scope.getCandidateDetails();

//                   } else {
//                       debugger;
//                       positionIndex += chunkSize;
//                       $scope.uploadAttachment(type,userDocId,result);
//                   }
//               } else {
//                   console.log(event.message);
//               }
//           },


//           { buffer: true, escape: true, timeout: 120000 }
//       );
//   }

        $scope.submit = function(){
            debugger;
            delete($scope.checkbox.Contacts__r);

            for(var i=0;i<$scope.allDocs.length;i++){
                if($scope.allDocs[i].userDocument.Name == 'Coordinator 1 Signature'){
                    if($scope.allDocs[i].userDocument.Status__c != 'Uploaded'){
                        swal('info','Please upload Signature.','info');
                        return;
                    }
                }else if($scope.allDocs[i].userDocument.Name == 'Coordinator 2 Signature'){
                    if($scope.allDocs[i].userDocument.Status__c != 'Uploaded'){
                        swal('info','Please upload Signature.','info');
                        return;
                    }
                }
            }
            // if($scope.checkbox.Privacy_Policy_Accepted__c == false){
            //     swal("Required", "Please accept privacy policy.")
            //         return;
            // }
            ApplicantPortal_Contoller.upsertCheckbox($scope.checkbox, function(result,event){
                if(event.status){
                    debugger;
                    Swal.fire(
                        'Success',
                        'Your proposal have been submitted successfully.',
                        'success'
                    );
                    $scope.redirectPageURL('Home');
                    $scope.checkbox = result;
                    $scope.$apply();
                }
            },
           {escape: true}
            )
        }

        $scope.saveAsDraftWorkshop = function(){
            debugger;
            delete($scope.checkbox.Contacts__r);
            ApplicantPortal_Contoller.saveAsDraftWorkshop($scope.checkbox, function(result,event){
                if(event.status){
                    debugger;
                    Swal.fire(
                        'Success',
                        'Your proposal has been saved as Draft.',
                        'success'
                    );
                    // swal("Draft", "Your proposal has been saved as Draft.","");
                    $scope.redirectPageURL('Home');
                    $scope.checkbox = result;
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
    });