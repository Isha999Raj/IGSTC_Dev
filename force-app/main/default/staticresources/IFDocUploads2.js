angular.module('cp_app').controller('IFDocUploads2_Ctrl', function($scope,$rootScope) {
    $scope.objContact={};
    $scope.Traveller={};
    $scope.Visa={};
    $scope.AttendanceReport={};
    $scope.SEUCUpload={};
    $scope.Reimb={};
    $scope.CloserReport={};
    $scope.objProposal={};
    $scope.decision_letter=false;
    $scope.decision_letter_disabled=false;
    $scope.visa_stage=false;
    $scope.visa_stage_disabled=false;
    $scope.undertaking_stage=false;
    $scope.undertaking_stage_disabled=false;
    $scope.monthly_stage=false;
    $scope.monthly_stage_disabled=true;
    $scope.getOnLoad=function(){
        IndustrialFellowshipController.getDocUploadDet($rootScope.userHashId, function (result, event) {
            console.log(result);
            console.log(event);    
            debugger  
            $scope.objContact=result;
            $scope.objProposal=result.Proposals__r;
                  $scope.$apply();                  
                // if($scope.objProposal.Undertaking_Status__c!=undefined){
                //     if($scope.objProposal.Undertaking_Status__c=="Sent")
                //         $scope.undertaking_stage=false;
                //     else if($scope.objProposal.Undertaking_Status__c=="Approved"){
                //         $scope.undertaking_stage=true;
                //         $scope.undertaking_stage_disabled=true;
                //         $scope.monthly_stage=true;
                //         $scope.monthly_stage_disabled=false;
                //     }   
                //     else
                //     {
                //         $scope.undertaking_stage=true;
                //         $scope.undertaking_stage_disabled=true;
                //     }                 
                //   }else{
                //     $scope.undertaking_stage=true;
                //   }
        });   
    }
    $scope.getProjectdetils = function () {
        debugger;
        ApplicantPortal_Contoller.getAllUserDoc($rootScope.projectId, function (result, event) {
            debugger
            console.log('result return onload :: ');
            console.log(result);
            if (event.status) {
                $scope.allDocs = result;
                var uploadCount=0;
                for(var i=0;i<$scope.allDocs.length;i++){
                    if($scope.allDocs[i].userDocument.Name == 'Closure Report'){
                        $scope.CloserReport=$scope.allDocs[i];
                    }
                    else if($scope.allDocs[i].userDocument.Name == 'Re-Imbersement Document'){
                        $scope.Reimb=$scope.allDocs[i];
                    }
                }
                $scope.$apply();
            }
        }, {
            escape: true
        })
    }
    $scope.uploadFile = function (type, userDocId, fileId,createTask,taskSubject) {
        $scope.showSpinnereditProf = true;
        var file;
    
            file = document.getElementById(type).files[0];
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
                        $scope.uploadAttachment(type , userDocId, fileId,createTask,taskSubject);
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
                $scope.showSpinnereditProf = false;
            }
        } else {
            alert("You must choose a file before trying to upload it");
            $scope.showSpinnereditProf = false;
        }
    }
    
    $scope.uploadAttachment = function (type, userDocId, fileId,createTask,taskSubject) {
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
        ApplicantPortal_Contoller.doCUploadAttachmentA(
            attachmentBody, attachmentName,fileId, userDocId,$rootScope.projectId,createTask,taskSubject, 
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
                        //$scope.updateProposal(type);
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
    $scope.updateProposal=function(type){
        if(type == 'Traveller Form'){
            $scope.objProposal.Travel_Form_Status__c="Submitted";
        }
        else if(type == 'Visa Documents'){
            $scope.objProposal.Visa_Stages__c="Submitted";
        }
        else if(type == 'Undertaking'){
            $scope.objProposal.Undertaking_Status__c="Submitted";
        }
        else if(type == 'Attendance Report'){
            return
        }
        else if(type == 'SC / UC Upload'){
            return
        }else{
            return;
        }
        IndustrialFellowshipController.updateIFDocStatus($scope.objProposal, function (result, event) {
            console.log('update proposal status');
            console.log(result);
            console.log(event);
        }); 
    }
    $scope.getProjectdetils();
    $scope.getOnLoad();
});