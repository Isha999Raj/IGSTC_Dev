angular.module('cp_app').controller('singdoc_ctrl', function ($scope,$sce,$rootScope) {

    $scope.objContact={};
    $scope.disableSubmit = true;
    $scope.allDocs={};
    $scope.doc={};
    $scope.allSixDoc={};
debugger;
$scope.redirectPageURL=function(URL){
    var link=document.createElement("a");
    link.id = 'someLink'; //give it an ID!
    link.href='#/'+URL+'';
    link.click();
}

$scope.selectedFile;

$scope.filePreviewHandler = function(fileContent){
    debugger;
    $scope.selectedFile = fileContent;

    console.log('selectedFile---', $scope.selectedFile);

    $('#file_frame').attr('src', $scope.selectedFile.ContentDistribution.DistributionPublicUrl);

    var myModal = new bootstrap.Modal(document.getElementById('filePreview'))        
    myModal.show('slow') ;
    $scope.$apply();

}

$scope.getProjectdetils = function () {
    debugger;
    $scope.selectedFile = '';
    $('#file_frame').attr('src', '');
    ApplicantPortal_Contoller.getAllUserDocSignature($rootScope.projectId, function (result, event) {
        debugger
        console.log('result return onload :: ');
        console.log(result);
        if (event.status) {
            $scope.allDocs = result;
            var uploadCount=0;
            for(var i=0;i<$scope.allDocs.length;i++){
                debugger;
                if($scope.allDocs[i].userDocument.Name == 'Bank Account Details'){
                    $scope.bank=$scope.allDocs[i];
                    if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                        uploadCount=uploadCount+1;
                    }
                }else if($scope.allDocs[i].userDocument.Name == 'Sensitivity/Security Clearance'){
                    $scope.sensitivity=$scope.allDocs[i];
                    if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                        uploadCount=uploadCount+1;
                    }
                }else if($scope.allDocs[i].userDocument.Name == 'Note for Sensitivity/ Security Clearance'){
                    $scope.noteForSensitivity=$scope.allDocs[i];
                    if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                        uploadCount=uploadCount+1;
                    }
                }else if($scope.allDocs[i].userDocument.Name == 'Note for Due Diligence'){
                    $scope.dueDiligence=$scope.allDocs[i];
                    if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                        uploadCount=uploadCount+1;
                    }
                }else if($scope.allDocs[i].userDocument.Name == 'Note for Approval to release Award Letter'){
                    $scope.awardNote=$scope.allDocs[i];
                    if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                        uploadCount=uploadCount+1;
                    }
                }else if($scope.allDocs[i].userDocument.Name == 'Undertaking'){
                    $scope.undertaking=$scope.allDocs[i];
                    if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                        uploadCount=uploadCount+1;
                    }
                }else if($scope.allDocs[i].userDocument.Name == 'Euro Remittance Invoice (German applicant only)'){
                    $scope.euroRemittance=$scope.allDocs[i];
                    if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                        uploadCount=uploadCount+1;
                    }
                }
            }
            $scope.$apply();
        }
    }, {
        escape: true
    })
}
$scope.getProjectdetils();


$scope.uploadFile = function (type, userDocId, fileId,maxSize,minFileSize) {
    debugger;
    $scope.showSpinnereditProf = true;
    var file;

        file = document.getElementById(type).files[0];
        fileName = file.name;
        var typeOfFile = fileName.split(".");
        lengthOfType =  typeOfFile.length;
        if(typeOfFile[lengthOfType-1] != "pdf"){
            swal('info','Please choose pdf file only.','info');
            return;
        }
    console.log(file);
    maxFileSize=maxSize;
    if (file != undefined) {
        if (file.size <= maxFileSize) {
            
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
                }

            }
            fileReader.onerror = function (e) {
                swal('info','There was an error reading the file.  Please try again.','info');
                return;
            }
            fileReader.onabort = function (e) {
                swal('info','There was an error reading the file.  Please try again.','info');
                return;
            }

            fileReader.readAsBinaryString(file);  //Read the body of the file

        } else {
            swal('info','Your file is too large.  Please try again.','info');
            return;
            $scope.showSpinnereditProf = false;
        }
    } else {
        swal('info','You must choose a file before trying to upload it','info');
        return;
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
    ApplicantPortal_Contoller.doCUploadAttachmentAa(
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
                   // $scope.getCandidateDetails();\
                   else {
                    debugger;
                    positionIndex += chunkSize;
                    $scope.uploadAttachment(type,userDocId,result);
                }
                $scope.showUplaodUserDoc = false;
                } 
        },


        { buffer: true, escape: true, timeout: 120000 }
    );
}

$scope.saveandNext = function(){
    debugger;
    // for(var i=0;i<$scope.allDocs.length;i++){
    //     if($scope.allDocs[i].userDocument.Name == 'Scan copy of Passport/Proof of Date of birth.'){
    //         if($scope.allDocs[i].userDocument.Status__c != 'Uploaded'){
    //             swal('info','Please upload Scan copy of Passport/Proof of Date of birth.','info');
    //             return;
    //         }
    //     }else if($scope.allDocs[i].userDocument.Name == 'Educational Qualification certificates.'){
    //         if($scope.allDocs[i].userDocument.Status__c != 'Uploaded'){
    //             swal('info','Please upload Educational Qualification certificates.','info');
    //             return;
    //         }
    //     }else if($scope.allDocs[i].userDocument.Name == 'Invitation letter from the host organization'){
    //         if($scope.allDocs[i].userDocument.Status__c != 'Uploaded'){
    //             swal('info','Please upload Invitation letter from the host organization.','info');
    //             return;
    //         }  
    //     }else if($scope.allDocs[i].userDocument.Name == 'No Objection Certificate'){
    //         if($scope.allDocs[i].userDocument.Status__c != 'Uploaded'){
    //             swal('info','Please upload no objection certificate.','info');
    //             return;
    //         } 
    //     }else if($scope.allDocs[i].userDocument.Name == 'Proof of employment'){
    //         if($scope.allDocs[i].userDocument.Status__c != 'Uploaded'){
    //             swal('info','Please upload Proof of employment.','info');
    //             return;
    //         } 
    //     }
    // }
    swal({
        title: "Document Upload",
        text: "Documents have been saved successfully.",
        icon: "success",
        button: "ok!",
      }).then((value) => {
        $scope.redirectPageURL('Home');
          });    
}
});