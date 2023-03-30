angular.module('cp_app').controller('address_ctrl', function($scope,$sce,$rootScope) {

    $scope.siteURL = siteURL;

    $scope.selectedFile;

    $scope.filePreviewHandler = function(fileContent){
        debugger;
        $scope.selectedFile = fileContent;
    
        console.log('selectedFile---', $scope.selectedFile);
        var jhj=$scope.selectedFile.userDocument.Attachments[0].Id;
        console.log(jhj);
        $scope.filesrec = $sce.trustAsResourceUrl(window.location.origin +'/ApplicantDashboard/servlet/servlet.FileDownload?file='+$scope.selectedFile.userDocument.Attachments[0].Id);
        //$scope.filesrec = window.location.origin +'/ApplicantDashboard/servlet/servlet.FileDownload?file='+$scope.selectedFile.userDocument.Attachments[0].Id;
        // $('#file_frame').attr('src', $scope.selectedFile.ContentDistribution.DistributionPublicUrl);
        $('#file_frame').attr('src', $scope.filesrec);
    
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
                if($scope.allDocs[i].userDocument.Name == 'DSIR'){
                    $scope.doc=$scope.allDocs[i];
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

    $scope.getDependentPicklistValues = function(){
        debugger;
        $scope.indianStates = [];
        $scope.germanStates = [];
        ApplicantPortal_Contoller.getFieldDependencies('Contact','Country__c','States__c', function(result,event){
            debugger;
            if(event.status && result != null){
                debugger;
                $scope.indianStates = result.India;
                $scope.germanStates = result.Germany;
                $scope.allStates = result.India.concat(result.Germany);
                $scope.$apply();
            }
        }
        )  
    }
    $scope.getDependentPicklistValues();

    $scope.getAddressDetails = function(){
        debugger;
        ApplicantPortal_Contoller.getAddressDetails($rootScope.userId, function(result, event){
            if(event.status) {
                debugger;
                $scope.addressDetails = result;
                    if($scope.addressDetails.BillingCountry == 'India'){
                        $scope.stateList = $scope.indianStates;
                    }else if($scope.addressDetails.BillingCountry == 'Germany'){
                        $scope.stateList = $scope.germanStates; 
                    }
                //$scope.addressDetails.ShippingCountry = $scope.addressDetails.BillingCountry; 
                $scope.$apply();
            }
        },
            {escape: true}
        )
    }
    $scope.getAddressDetails();

    $scope.redirectPageURL = function (pageName){
        var link = document.createElement("a");
        link.id = 'someLink'; //give it an ID!
        link.href = "#/" + pageName;
        link.click();
    }

    $scope.saveAddressDetails = function(){
        debugger;

        if($scope.addressDetails.Name == undefined || $scope.addressDetails.Name == ""){
            swal("Address Details", "Please Enter Institution/Industry Name.");
            $("#inst").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.BillingCountry == 'India' && $scope.addressDetails.Industry__c == true && $scope.addressDetails.DSIR_Recoginition_Details__c == undefined){
            swal("Address Details", "Please Enter DSIR Number.");
            $("#dsir").addClass('border-theme');
            return;
        }
        if($scope.addressDetails.Contacts[0].Name == undefined || $scope.addressDetails.Contacts[0].Name == ""){
            swal("Address Details", "Please Enter Head of Project.");
            $("#head").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.Contacts[0].Phone == undefined || $scope.addressDetails.Contacts[0].Phone == ""){
            swal("Address Details", "Please Enter Phone.");
            $("#phone").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.Contacts[0].Department == undefined || $scope.addressDetails.Contacts[0].Department == ""){
            swal("Address Details", "Please Enter Department.");
            $("#dept").addClass('border-theme');
                return;
        }

        if($scope.addressDetails.BillingStreet == undefined || $scope.addressDetails.BillingStreet == ""){
            swal("Address Details", "Please Enter Street.");
            $("#IStreet").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.BillingCity == undefined || $scope.addressDetails.BillingCity == ""){
            swal("Address Details", "Please Enter City.");
            $("#ICity").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.BillingCountry == undefined || $scope.addressDetails.BillingCountry== ""){
            swal("Address Details", "Please Enter Country.");
            $("#ICountry").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.BillingState == undefined || $scope.addressDetails.BillingState == ""){
            swal("Address Details", "Please Enter State.");
            $("#IState").addClass('border-theme');
                return;
        }
        if($scope.addressDetails.BillingPostalCode == undefined || $scope.addressDetails.BillingPostalCode == ""){
            swal("Address Details", "Please Enter Post Code.");
            $("#IPcode").addClass('border-theme');
                return;
        }

        if($scope.addressDetails.Industry__c == true){
            if($scope.addressDetails.Year_Of_Establishment__c == undefined || $scope.addressDetails.Year_Of_Establishment__c == ""){
                swal("Address Details", "Please Enter Year Of Establishment.");
                $("#establish").addClass('border-theme');
                return;
            }
            if($scope.addressDetails.Main_Business_Area__c == undefined || $scope.addressDetails.Main_Business_Area__c == ""){
                swal("Address Details", "Please Enter Main Business Area.");
                $("#business").addClass('border-theme');
                return;
            }
            if($scope.addressDetails.NumberOfEmployees == undefined || $scope.addressDetails.NumberOfEmployees == ""){
                swal("Address Details", "Please Enter Number Of Permanent Employees.");
                $("#employees").addClass('border-theme');
                return;
            }
            if($scope.addressDetails.Infrastructural_Facilities__c == undefined || $scope.addressDetails.Infrastructural_Facilities__c == ""){
                swal("Address Details", "Please Enter Infrastructural Facilities.");
                $("#facility").addClass('border-theme');
                return;
            }
            if($scope.addressDetails.Domain_Expertise_Available__c == undefined || $scope.addressDetails.Domain_Expertise_Available__c == ""){
                swal("Address Details", "Please Enter Domain Expertise Available/Existing.");
                $("#domain").addClass('border-theme');
                return;
            }
            if($scope.addressDetails.Ownership_Profile__c == undefined || $scope.addressDetails.Ownership_Profile__c == ""){
                swal("Address Details", "Please Enter Ownership profile.");
                $("#ownership").addClass('border-theme');
                return;
            }
            if($scope.addressDetails.Last_Year_s_Balance__c == undefined || $scope.addressDetails.Last_Year_s_Balance__c == ""){
                swal("Address Details", "Please Enter Last year's balance.");
                $("#balance").addClass('border-theme');
                return;
            }
        }

        $scope.contactList = [];  
        if($scope.addressDetails.Contacts != undefined){
            $scope.contactList.push($scope.addressDetails.Contacts[0]);
        }
        $scope.addressDetails['Shipping_State__c'] = $scope.addressDetails['BillingState'];
        // $scope.addressDetails.NumberOfEmployees = Number($scope.addressDetails.NumberOfEmployees);

        delete ($scope.addressDetails['Contacts']);
        delete ($scope.addressDetails['$$hashKey']);
        delete ($scope.addressDetails['stateList']);
         debugger;
        ApplicantPortal_Contoller.saveAddressDetails($scope.addressDetails,$scope.contactList, function(result,event){
            debugger;
            if(event.status){
                debugger;
                Swal.fire(
                    'Success',
                    'Consortia Details has been saved successfully.',
                    'success'
                );
                $scope.disableSubmit = true; 
                $scope.redirectPageURL('ConsortiaContacts');
            }
        },
        {escape:true}
        )
    }

    $scope.removeClass2=function(controlid){
        $("#"+controlid+"").removeClass('border-theme');
      }
});