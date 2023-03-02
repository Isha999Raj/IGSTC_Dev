angular.module('cp_app').controller('AttachmentsIF_Ctrl', function($scope,$rootScope) {
    debugger
    $scope.SignDate=new Date($rootScope.signDate);
    $scope.objContact={};
    $scope.disableSubmit = true;
    $scope.allDocs={};
    $scope.doc={};
    $scope.allSixDoc={};
debugger
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
    myModal.show('slow') ;
    $scope.$apply();

    //.ContentDistribution.DistributionPublicUrl
}

$scope.getProjectdetils = function () {
    debugger;
    $scope.selectedFile = '';
    $('#file_frame').attr('src', '');
    ApplicantPortal_Contoller.getContactUserDoc($rootScope.contactId, function (result, event) {
        debugger
        console.log('result return onload :: ');
        console.log(result);
        if (event.status) {
            $scope.allDocs = result;
            var uploadCount=0;
            for(var i=0;i<$scope.allDocs.length;i++){
                debugger;
                if($scope.allDocs[i].userDocument.Name == 'Acceptance Letter'){
                    $scope.acceptance=$scope.allDocs[i];
                    if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                        uploadCount=uploadCount+1;
                    }
                }else if($scope.allDocs[i].userDocument.Name == 'Recommendation Letter'){
                    $scope.recommendation=$scope.allDocs[i];
                    if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                        uploadCount=uploadCount+1;
                    }
                }else if($scope.allDocs[i].userDocument.Name == 'Permission Letter'){
                    $scope.permission=$scope.allDocs[i];
                    if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                        uploadCount=uploadCount+1;
                    }
                }else if($scope.allDocs[i].userDocument.Name == 'Two (2) letters of reference'){
                    $scope.reference=$scope.allDocs[i];
                    if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                        uploadCount=uploadCount+1;
                    }
                }else if($scope.allDocs[i].userDocument.Name == 'Proof of employment'){
                    $scope.proof=$scope.allDocs[i];
                    if($scope.allDocs[i].userDocument.Status__c == 'Uploaded'){
                        uploadCount=uploadCount+1;
                    }
                }else if($scope.allDocs[i].userDocument.Name == 'Scan copy of the front page of current Passport / Aadhar card'){
                    $scope.currentPassport=$scope.allDocs[i];
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
$scope.getOnload=function(){
    IndustrialFellowshipController.getContactSingh($rootScope.userHashId, function (result, event) {
        debugger
        console.log(result);
        console.log(event);
        if(event.status){
            if(result.Declaration_Sign_Date__c!=undefined && $rootScope.proposalStage){
                $scope.SignDate=new Date(result.Declaration_Sign_Date__c);
            }
            debugger;
            if(result.Industrial_Fellowship_Type__c != undefined){
                $scope.type = result.Industrial_Fellowship_Type__c;
            }
            $scope.objContact=result;
            $scope.$apply();
        }
    });    
}
$scope.getOnload();

$scope.submitProposalIF=function(saveType){
    debugger
    if($rootScope.proposalStage){
        $scope.redirectPageURL('Home');
        return; 
    }
    var year=0;
    var month=0;
    var day=0;
    if(saveType=='s'){
      if($scope.SignDate!=undefined && $scope.SignDate!=''){
        year = $scope.SignDate.getUTCFullYear();
        month = $scope.SignDate.getUTCMonth()+1;
        day = $scope.SignDate.getDate();
        // delete $scope.objContact.Birthdate;
      }
    }
else{
    $scope.submitApplicationDetail(saveType,year,month,day);  
}
    swal({
        title: "Are you sure?",
        text: "Once submitted, you will not be able to update proposal!",
        icon: "warning",
        buttons: true,
        dangerMode: true,
      })
      .then((willDelete) => {
        if (willDelete) {                    
            $scope.submitApplicationDetail(saveType,year,month,day);                     
        } else {
         return;
        }
      });
}
$scope.submitApplicationDetail=function(saveType,year,month,day){
    IndustrialFellowshipController.submitProposalIF($scope.objContact,saveType,$rootScope.projectId,year,month,day, function (result, event) {
        console.log(result);
        console.log(event);
        debugger
        if(event.status){
            if(saveType=='d')
                swal('success','Your Proposal has been saved as Draft','success');
            else{
                swal('success','Your Proposal has been submitted successfully','success');
                $rootScope.proposalStage=true;
                CKEDITOR.config.readOnly = true;
            }
                $scope.redirectPageURL('Home');
        }
    }); 
}


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
                    $scope.uploadAttachment(type , userDocId, fileId);
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
                        
                    }
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
    for(var i=0;i<$scope.allDocs.length;i++){
        if($scope.allDocs[i].userDocument.Name == 'Acceptance Letter'){
            if($scope.allDocs[i].userDocument.Status__c != 'Uploaded'){
                swal('info','Please upload Endorsement / acceptance letter from the host organisation on official letter head with signature and seal.','info');
                return;
            }
        }
        // else if($scope.allDocs[i].userDocument.Name == 'Recommendation Letter'){
        //     if($scope.allDocs[i].userDocument.Status__c != 'Uploaded'){
        //         swal('info','Please upload Recommendation letter from Mentor at parent organisation.','info');
        //         return;
        //     }
        // }
        // else if($scope.allDocs[i].userDocument.Name == 'Permission Letter'){
        //     if($scope.allDocs[i].userDocument.Status__c != 'Uploaded'){
        //         swal('info','Please upload Permission letter / NOC from applicant’s parent organisation endorsed by the head of the organisation / institute on official letter head, if applicant currently having institutional affiliation.','info');
        //         return;
        //     }  
        // }
        // else if($scope.allDocs[i].userDocument.Name == 'Two (2) letters of reference' && $scope.type == "PDIF"){
        //     if($scope.allDocs[i].userDocument.Status__c != 'Uploaded'){
        //         swal('info','Please upload Two (2) letters of reference, if applicant currently not having institutional affiliation.','info');
        //         return;
        //     } 
        // }
        // else if($scope.allDocs[i].userDocument.Name == 'Proof of employment'){
        //     if($scope.allDocs[i].userDocument.Status__c != 'Uploaded'){
        //         swal('info','Please upload Proof of employment.','info');
        //         return;
        //     } 
        // }
        else if($scope.allDocs[i].userDocument.Name == 'Scan copy of the front page of current Passport / Aadhar card'){
            if($scope.allDocs[i].userDocument.Status__c != 'Uploaded'){
                swal('info','Please upload Scan copy of the front and back page of current Passport / Aadhar card.','info');
                return;
            } 
        }
    }

    $scope.redirectPageURL('ReviewAndSubmitIF');
}
});