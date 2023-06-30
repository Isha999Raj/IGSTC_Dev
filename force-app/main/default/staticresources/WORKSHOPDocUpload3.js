angular.module('cp_app').controller('WORKSHOPDocUpload3_Ctrl', function($scope,$rootScope) {
    
    $scope.invoice_form=false;
    $scope.invoice_form_disabled=false;
    $scope.monthly_stage=true;
    $scope.monthly_stage_disabled=true;
    $scope.showUndertakingCheck=false;
    $scope.contactCountry="India";
    let baseUrl = window.location.origin;
    $scope.fileURLSCUC=baseUrl;
    $scope.fileURLBrief=baseUrl;
    $scope.fileURLFinal=baseUrl;                    

    $scope.getProjectdetils = function () {
        debugger;
        ApplicantPortal_Contoller.getContactUserDoc($rootScope.contactId, function (result, event) {
            debugger
            console.log('result return onload :: ');
            console.log(result);
            if (event.status) {
                $scope.allDocs = result;
                var uploadCount=0;
                for(var i=0;i<$scope.allDocs.length;i++){
                    if($scope.allDocs[i].userDocument.Name == 'SC / UC Upload'){
                        $scope.Descison=$scope.allDocs[i];
                        if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                            uploadCount=uploadCount+1;
                            // $scope.fileURLSCUC=baseUrl+'/servlet/servlet.FileDownload?file='+$scope.Descison.userDocument.Attachments[0].Id;
                        }
                    }
                    else if($scope.allDocs[i].userDocument.Name == 'WORKSHOP Brief Report'){
                        $scope.brief=$scope.allDocs[i];
                        if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                            uploadCount=uploadCount+1;                        
                        }
                    }
                    else if($scope.allDocs[i].userDocument.Name == 'WORKSHOP Final Report'){
                        $scope.final=$scope.allDocs[i];
                        if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                            uploadCount=uploadCount+1;                        
                        }
                    }
                    if(uploadCount==2)
                            $scope.disableSubmit = false;
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
        ApplicantPortal_Contoller.doCUploadAttachmentSignature22(
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
    $scope.getProjectdetils();
    
})