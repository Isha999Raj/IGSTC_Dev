angular.module('cp_app').controller('Consortia_Ctrl', function($scope,$rootScope) {
    debugger
        $scope.basicDetails=true;
        $scope.companyDetails=false;
        $scope.countrytype = countrytype;
        $scope.consortiaDetails=[];
        $scope.signleConsortiaDetails={};
        $scope.disble_button_ins=false;
        $scope.disble_button=false;
        $scope.disableAddButton=false;
        $scope.saveStatus=false;
        $scope.listOfIds = [];
        $scope.arrySaveStatus=[{status:true},{status:true},{status:true},{status:true},{status:true},{status:true}];

        $scope.selectedFile;

$scope.filePreviewHandler = function(fileContent){
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
        // $scope.checkEmail = function(email,contId){
        //     debugger;
        //     $scope.emailCheck = false;
        //     if(contId == undefined){
        //       contId = "";
        //     }
        //     ApplicantPortal_Contoller.checkEmail(email,contId,function(result,event){
        //       debugger;
        //       if(event.status){
        //         debugger;
        //         if(result.length > 0){
        //           $scope.emailCheck = true;
        //         }else{
        //           $scope.emailCheck = false;
        //         }
        //         $scope.$apply();
        //       }
        //     })
      
        //   }
        
        // $scope.NextIns=function(index,divid){  
            
        //     $scope.signleConsortiaDetails=$scope.consortiaDetails[index];
        //     debugger;
        //     $scope.ConsortiaDetailsList = [];
        //     delete($scope.signleConsortiaDetails['$$hashKey']);
        //     delete($scope.signleConsortiaDetails['RecordTypeId']);
        //     delete($scope.signleConsortiaDetails['Contacts']);
        //     if($scope.signleConsortiaDetails.Id==""){
        //         delete($scope.signleConsortiaDetails['Id']);
        //     }
            
        //     if($scope.signleConsortiaDetails.Name==undefined || $scope.signleConsortiaDetails.Name==''){
        //         swal("Required", "Please enter Institution/Industry name.")
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.Department__c==undefined || $scope.signleConsortiaDetails.Department__c==''){
        //         swal("Required", "Please enter Department / Division.")
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.ShippingPostalCode==undefined || $scope.signleConsortiaDetails.ShippingPostalCode==''){
        //         swal("Required", "Please Enter Postal Code.")
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.ShippingCountry==undefined || $scope.signleConsortiaDetails.ShippingCountry==''){
        //         swal("Required", "Please Enter Country.")
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.Head_Of_Project__c==undefined || $scope.signleConsortiaDetails.Head_Of_Project__c==''){
        //         swal("Required", "Please Enter Head Of Project.")
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.Email__c==undefined || $scope.signleConsortiaDetails.Email__c==''){
        //         swal("Required", "Please Enter Email.")
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.Phone==undefined || $scope.signleConsortiaDetails.Phone==''){
        //         swal("Required", "Please Enter Phone Number.")
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.Industry__c==true && ($scope.signleConsortiaDetails.Year_Of_Establishment__c==undefined || $scope.signleConsortiaDetails.Year_Of_Establishment__c=='')){
        //         swal("Required", "Please Enter Year Of Establishment.")
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.Industry__c==true && ($scope.signleConsortiaDetails.NumberOfEmployees==undefined || $scope.signleConsortiaDetails.NumberOfEmployees=='')){
        //         swal("Required", "Please Enter Number Of Permant Employees.")
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.Industry__c==true && ($scope.signleConsortiaDetails.Last_Year_s_Balance__c==undefined || $scope.signleConsortiaDetails.Last_Year_s_Balance__c=='')){
        //         swal("Required", "Please Enter Last Year's Balance.")
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.Website==undefined || $scope.signleConsortiaDetails.Website==''){
        //         swal("Required", "Please enter website.")
        //         return
        //     }
        //     $scope.disble_button_ins=true;
        // IndustrialFellowshipController.upsertConsortiaAccountDet($scope.signleConsortiaDetails, $rootScope.projectId, function (result, event) {            
        //     $scope.disble_button_ins=false;    
        //     console.log(result);
        //         console.log(event);
        //         if (event.status) {
        //             debugger;
        //             if($rootScope.proposalStage == false){
        //                 swal(
        //                     'Success',
        //                     'Institution/Industry details has been saved successfully.',
        //                     'success'
        //                 );
        //             }
        //             if(divid=='basic'){
        //             $("#basicDetailsId"+index+"").hide();
        //             if($scope.signleConsortiaDetails.Industry__c==true){
        //                 $("#companyDetailsId"+index+"").show();
        //             }
        //             else
        //             {
        //                 $("#acedmiaDetails"+index+"").show();                        
        //             }
        //         }
        //         else
        //         {
        //             $("#basicDetailsId"+index+"").show();
        //             $("#companyDetailsId"+index+"").hide();
        //             $("#acedmiaDetails"+index+"").hide(); 
        //         }
        //         $scope.$apply();
                    
        //         }
        //     }, {
        //         escape: true
        //     })            
        // }
        // $scope.Next=function(index,divid){  
        //     debugger
        //     if($scope.consortiaDetails.length>6){
        //         swal("Consortia!", "Maximum 6 partners are allowed", "info");
        //         return;
        //     }
            
        //     $scope.signleConsortiaDetails=$scope.consortiaDetails[index];
        //     debugger;
        //     $scope.ConsortiaDetailsList = [];
        //     delete($scope.signleConsortiaDetails['$$hashKey']);
        //     delete($scope.signleConsortiaDetails['RecordTypeId']);
        //     delete($scope.signleConsortiaDetails['Contacts']);
        //     if($scope.signleConsortiaDetails.Id==""){
        //         delete($scope.signleConsortiaDetails['Id']);
        //     }
        //     if($scope.signleConsortiaDetails.Name==undefined || $scope.signleConsortiaDetails.Name=='' || $scope.signleConsortiaDetails.Name==' '){
        //         swal("Required", "Please enter name.");
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.Website==undefined || $scope.signleConsortiaDetails.Website==''){
        //         swal("Required", "Please enter website.");
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.Industry__c==false && $scope.signleConsortiaDetails.Academia__c==false){
        //         swal("Required", "Please choose industry or academia.");
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.Industry__c==undefined && $scope.signleConsortiaDetails.Academia__c==undefined){
        //         swal("Required", "Please choose industry or academia.");
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.BillingCountry==undefined){
        //         swal("Required", "Please select country");
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.DSIR_Recoginition_Details__c==undefined && $scope.signleConsortiaDetails.Industry__c==true && $scope.signleConsortiaDetails.BillingCountry=='India'){
        //         swal("Required", "Please Enter DSIR Details");
        //         return
        //     }
        //     if($scope.signleConsortiaDetails.Industry__c==true && $scope.signleConsortiaDetails.BillingCountry=='India'){
        //     var file = document.getElementById('attachmentFiles').files[0];
        //                 if (file != undefined) {
        //                     if (file.size <= maxFileSize) {
                                
        //                         attachmentName = file.name;
        //                         const myArr = attachmentName.split(".");
        //                         if (myArr[1] != "pdf") {
        //                             swal("Required", "Please upload in PDF format only")
        //                             return;
        //                         }
        //                     }else
        //                     {
        //                     }
        //                 }
        //             }
        //     $scope.disble_button=true;
        // IndustrialFellowshipController.upsertConsortiaAccountDet($scope.signleConsortiaDetails, $rootScope.projectId, function (result, event) {            
        //     $scope.disble_button=false;    
        //     console.log(result);
        //         console.log(event);
        //         if (event.status) {
        //             debugger;
                    
        //             $scope.arrySaveStatus[index].status=true;
        //             $scope.consortiaDetails[index].Id=result;
        //             $scope.consortiaDetails[index].ShippingCountry=$scope.consortiaDetails[index].BillingCountry;
        //             if($rootScope.proposalStage == false){
        //                 swal(
        //                     'Success',
        //                     'Basic details has been saved successfully.',
        //                     'success'
        //                 );
        //             }
        //             if(divid=='basic'){
        //             $("#basicDetailsId"+index+"").hide();
        //             if($scope.signleConsortiaDetails.Industry__c==true){
        //                 $("#companyDetailsId"+index+"").show();
        //             }
        //             else
        //             {
        //                 $("#acedmiaDetails"+index+"").show();                        
        //             }
        //             if(!$scope.signleConsortiaDetails.Academia__c){                        
        //                 $scope.uploadFile('attachment', result, '');
        //                 }
        //         }
        //         else
        //         {
        //             $("#acedmiaDetails"+index+"").hide();
        //             $("#companyDetailsId"+index+"").hide();
        //             $("#divContact"+index+"").show();
        //         }
        //         $scope.$apply();
                    
        //         }
        //     }, {
        //         escape: true
        //     })            
        // }
        // $scope.backBasic=function(index){
        //     debugger
        //     $("#companyDetailsId"+index+"").hide();
        //     $("#basicDetailsId"+index+"").show();
        // }
        // $scope.NextInstitute=function(){
        //     $scope.companyDetails=false;
        //     $scope.acedmiaDetails=true;
        // }
        // $scope.backComp=function(index){
        //     debugger
        //     $("#acedmiaDetails"+index+"").hide();
        //     $("#basicDetailsId"+index+"").show();
        // }
        $scope.industryAcademia=function(industryType,index){
            $scope.arrySaveStatus[index].status=false;
            debugger
            if(industryType=="academia"){
                $scope.allCoordinatorDetails[index].Industry__c=false;
                $scope.allCoordinatorDetails[index].Academia__c=true; 
            }else{
                $scope.allCoordinatorDetails[index].Industry__c=true;
                $scope.allCoordinatorDetails[index].Academia__c=false; 
            }
            $scope.$apply();
        }
        // $scope.getPatnerDetails = function () {
        //     debugger;
        //     $scope.consortiaDetails = [];
        //     ApplicantPortal_Contoller.getPatnerDetails($rootScope.userId, function (result, event) {
        //         console.log('patner details');
        //         console.log(result);
        //         console.log(event);
        //         if (event.status) {
        //             debugger;

        //             if (result == null || result.length == 0) {
        //                 $scope.consortiaDetails.push({
        //                     "Name": " ",
        //                     "Phone": " ",
        //                     Contacts: [{
        //                         "FirstName": " ",
        //                         "LastName": " "
        //                     }]
        //                 });
        //             } else {
        //                 for(var i=0;i<result.length;i++){
        //                     if(result[i].Contacts == undefined){
        //                         result[i].Contacts =[{"FirstName": " ","LastName": " "}]
        //                     }
        //                 }
        //                 $scope.consortiaDetails = result;                        
        //             }
        //             $scope.$apply();                    
        //             $("#panelsStayOpencollapse1,#panelsStayOpencollapse2,#panelsStayOpencollapse3,#panelsStayOpencollapse4,#panelsStayOpencollapse5").removeClass();
        //             $("#panelsStayOpencollapse1,#panelsStayOpencollapse2,#panelsStayOpencollapse3,#panelsStayOpencollapse4,#panelsStayOpencollapse5").addClass('accordion-collapse collapse');
                           
        //         }
        //     }, {
        //         escape: true
        //     })
        // }
        // $scope.getApplicantDetails = function () {
        //     ApplicantPortal_Contoller.getCompanyApplicantDetails($rootScope.userId, function (result, event) {
        //         console.log('applicant')
        //         console.log(result)
        //         console.log(event)
        //         if (event.status) {
        //             debugger;
        //             $scope.applicantDetails = result;
        //             $scope.$apply();
        //         }
        //     }, {
        //         escape: true
        //     })
        // }
        // $scope.getContactDetails = function () {
        //     ApplicantPortal_Contoller.getContactDetails($rootScope.userId, function (result, event) {
        //         console.log('contact')
        //         console.log(result)
        //         console.log(event)
        //         if (event.status) {
        //             $scope.contactDetails = result;
        //             $scope.contactDetails = {
        //                 'FirstName': result.FirstName,
        //                 'LastName': result.LastName,
        //                 'Actual_Position__c': result.Actual_Position__c,
        //                 'MailingCity': result.MailingCity,
        //                 'MailingState': result.MailingState,
        //                 'MailingCountry': result.MailingCountry,
        //                 'Id': result.Id
        //             };
        //             if (result.Education_Details__r != undefined)
        //                 $scope.educationList = result.Education_Details__r;
        //             if (result.Employment_Details__r != undefined)
        //                 $scope.employmentList = result.Employment_Details__r;
        //             if (result.Publications_Patents__r != undefined)
        //                 $scope.publicationList = result.Publications_Patents__r;
        //             $scope.$apply();
        //         }
        //     }, {
        //         escape: true
        //     })
        // }
        $scope.addAccount=function(){
            debugger;
            if($scope.allCoordinatorDetails.length>5){
                swal("Max Account Limit", "You can add maximum six account.")
            }
            else
            {
                $scope.allCoordinatorDetails.push({
                    "Name": "",
                    "Phone": "",
                    "Academia__c":true,
                    "Industry__c":false,
                    "Contacts":[{"FirstName":"","Campaign__c":$scope.campaigntype}],
                    "Proposals__c":$rootScope.projectId,
                });
            }
            if($scope.allCoordinatorDetails.length>5){
                $scope.disableAddButton=true;
            }
        }
        $scope.removeAccount=function(index,accountid){
            debugger
            if($scope.allCoordinatorDetails.length==1){
              return;
            }
            swal({
                title: "Are you sure?",
                text: "Once deleted, you will not be able to recover this account!",
                icon: "warning",
                buttons: true,
                dangerMode: true,
              })
              .then((willDelete) => {
                if (willDelete) {                    
                  swal("Account has been deleted successfully!", {
                    icon: "success",
                  });
                  $scope.allCoordinatorDetails.splice(index,1);
                  $scope.$apply();
                  if(accountid!='' && accountid!=undefined){ $scope.deleteAccount(index,accountid);}                  
                } else {
                 return;
                }
              });
              if($scope.allCoordinatorDetails.length<6){
                $scope.disableAddButton=false;
              }
            $scope.$apply();
        }
        $scope.deleteAccount=function(index,accountid){
            IndustrialFellowshipController.deleteAccount(accountid, function (result, event) {
                if(result.status){
                    $scope.allCoordinatorDetails.splice(index,1);
                }
            });
        }
        $scope.redirectPageURL = function (pageName){
            var link = document.createElement("a");
            link.id = 'someLink'; //give it an ID!
            link.href = "#/" + pageName;
            link.click();
        }
        // $scope.saveAndNext=function(pageName){
        //     debugger;
        //     var IndianCount=0;
        //     var germanCount=0;
        //     var IndianIndustryCount=0;
        //     var indianAcademiaCount=0;
        //     var GermanIndustryCount=0;
        //     var GermanAcademiaCount=0;
        //     debugger
        //     for(var i=0;i<$scope.consortiaDetails.length;i++){
        //         if(!$scope.arrySaveStatus[i].status){
        //             swal("Consortia!", "Please save changes", "info");
        //             return;
        //         }
        //     }
        //     if($scope.consortiaDetails.length<4){
        //         swal("Consortia!", "Please add minimum four partners.", "info");
        //         return;
        //     }
        //     if($scope.consortiaDetails.length>6){
        //         swal("Consortia!", "maximum six partners are allowed.", "info");
        //         return;
        //     }
        //     for(var i=0;i<$scope.consortiaDetails.length;i++){
        //         if($scope.consortiaDetails[i].BillingCountry=="India"){
        //             IndianCount=IndianCount+1;                    
        //         }
        //         else
        //         {
        //             germanCount=germanCount+1;
        //         }
        //     }
        //     if($scope.consortiaDetails.length==4 && (IndianCount<2 || IndianCount>2)){
        //             swal("Consortia!", "Indian partner should be equal german partner", "info");
        //                 return;
        //             }
        //     if($scope.consortiaDetails.length==6 && (IndianCount<3 || IndianCount>3)){
        //             swal("Consortia!", "Indian and german partner must be in 2+2 or 3+3 format", "info");
        //                 return;
        //     }
        //     for(var i=0;i<$scope.consortiaDetails.length;i++){
        //         if($scope.consortiaDetails[i].BillingCountry=="India"){
        //             if($scope.consortiaDetails[i].Industry__c==true){
        //                 IndianIndustryCount=IndianIndustryCount+1;
        //             }  
        //             else
        //             {
        //                 indianAcademiaCount=indianAcademiaCount+1;
        //             }               
        //         }
        //         else
        //         {
        //             if($scope.consortiaDetails[i].Industry__c==true){
        //                 GermanIndustryCount=GermanIndustryCount+1;
        //             }  
        //             else
        //             {
        //                 GermanAcademiaCount=GermanAcademiaCount+1;
        //             } 
        //         }
        //     }
        //     if(IndianIndustryCount==0 || indianAcademiaCount==0){
        //         swal("Consortia!", "One industry and one academia is mandatory", "info");
        //         return;
        //     }
        //     if(GermanIndustryCount==0 || GermanAcademiaCount==0){
        //         swal("Consortia!", "One industry and one academia is mandatory", "info");
        //         return;
        //     }
        //     for(var i=0;i<$scope.consortiaDetails.length;i++){
        //         if($scope.consortiaDetails[i].Industry__c==true){
        //             if($scope.consortiaDetails[i].Name==undefined || $scope.consortiaDetails[i].Name=='' || $scope.consortiaDetails[i].Name==' '){
        //                 swal("Consortia!", "Please save Academia details all partners", "info");
        //                 return;
        //             } 
        //             if($scope.consortiaDetails[i].ShippingPostalCode==undefined || $scope.consortiaDetails[i].ShippingPostalCode=='' || $scope.consortiaDetails[i].ShippingPostalCode==' '){
        //                 swal("Consortia!", "Please enter post code for "+$scope.consortiaDetails[i].Name+"", "info");
        //                 return;
        //             }
        //             if($scope.consortiaDetails[i].Head_Of_Project__c==undefined || $scope.consortiaDetails[i].Head_Of_Project__c=='' || $scope.consortiaDetails[i].Head_Of_Project__c==' '){
        //                 swal("Consortia!", "Please enter name of the project head for "+$scope.consortiaDetails[i].Name+"", "info");
        //                 return;
        //             }
        //             if($scope.consortiaDetails[i].Email__c==undefined || $scope.consortiaDetails[i].Email__c=='' || $scope.consortiaDetails[i].Email__c==' '){
        //                 swal("Consortia!", "Please enter e-mail id for "+$scope.consortiaDetails[i].Name+"", "info");
        //                 return;
        //             }
        //             if($scope.consortiaDetails[i].Phone==undefined || $scope.consortiaDetails[i].Phone=='' || $scope.consortiaDetails[i].Phone==' '){
        //                 swal("Consortia!", "Please enter phone number for "+$scope.consortiaDetails[i].Name+"", "info");
        //                 return;
        //             }
        //             if($scope.consortiaDetails[i].Year_Of_Establishment__c==undefined || $scope.consortiaDetails[i].Year_Of_Establishment__c=='' || $scope.consortiaDetails[i].Year_Of_Establishment__c==' '){
        //                 swal("Consortia!", "Please enter establishment year for "+$scope.consortiaDetails[i].Name+"", "info");
        //                 return;
        //             }
        //             if($scope.consortiaDetails[i].NumberOfEmployees==undefined || $scope.consortiaDetails[i].NumberOfEmployees=='' || $scope.consortiaDetails[i].NumberOfEmployees==' '){
        //                 swal("Consortia!", "Please enter number of permanent employees for "+$scope.consortiaDetails[i].Name+"", "info");
        //                 return;
        //             }
        //             if($scope.consortiaDetails[i].Last_Year_s_Balance__c==undefined || $scope.consortiaDetails[i].Last_Year_s_Balance__c=='' || $scope.consortiaDetails[i].Last_Year_s_Balance__c==' '){
        //                 swal("Consortia!", "Please enter last year's balance for "+$scope.consortiaDetails[i].Name+"", "info");
        //                 return;
        //             }
        //         }  
        //         else
        //         {
        //             if($scope.consortiaDetails[i].Name==undefined || $scope.consortiaDetails[i].Name=='' || $scope.consortiaDetails[i].Name==' '){
        //                 swal("Consortia!", "Please save Academia details all partners", "info");
        //                 return;
        //             }
        //             if($scope.consortiaDetails[i].Department__c==undefined || $scope.consortiaDetails[i].Department__c=='' || $scope.consortiaDetails[i].Department__c==' '){
        //                 swal("Consortia!", "Please enter Department/Division for "+$scope.consortiaDetails[i].Name+"", "info");
        //                 return;
        //             }
        //             if($scope.consortiaDetails[i].ShippingPostalCode==undefined || $scope.consortiaDetails[i].ShippingPostalCode=='' || $scope.consortiaDetails[i].ShippingPostalCode==' '){
        //                 swal("Consortia!", "Please enter post code for "+$scope.consortiaDetails[i].Name+"", "info");
        //                 return;
        //             }
        //             if($scope.consortiaDetails[i].Head_Of_Project__c==undefined || $scope.consortiaDetails[i].Head_Of_Project__c=='' || $scope.consortiaDetails[i].Head_Of_Project__c==' '){
        //                 swal("Consortia!", "Please enter name of the project head for "+$scope.consortiaDetails[i].Name+"", "info");
        //                 return;
        //             }
        //             if($scope.consortiaDetails[i].Email__c==undefined || $scope.consortiaDetails[i].Email__c=='' || $scope.consortiaDetails[i].Email__c==' '){
        //                 swal("Consortia!", "Please enter e-mail id for "+$scope.consortiaDetails[i].Name+"", "info");
        //                 return;
        //             }
        //             if($scope.consortiaDetails[i].Phone==undefined || $scope.consortiaDetails[i].Phone=='' || $scope.consortiaDetails[i].Phone==' '){
        //                 swal("Consortia!", "Please enter phone number for "+$scope.consortiaDetails[i].Name+"", "info");
        //                 return;
        //             }
        //         }  
        //     }
        //     var srrEmail=[];
        //     for (var i = 0; i < $scope.consortiaDetails.length; i++) 
        //     {
        //         if($scope.consortiaDetails[i].Email__c!=undefined && $scope.consortiaDetails[i].Email__c!=''){
        //         srrEmail.push($scope.consortiaDetails[i].Email__c);
        //         }
        //     }
        //       var duplicateEmailStatus=srrEmail.every(num => srrEmail.indexOf(num) === srrEmail.lastIndexOf(num));
        //       if(!duplicateEmailStatus){
        //         swal("Consortia!", "Please enter unique e-mail id for each partner.", "info");
        //         return;
        //       }
        //     $scope.redirectPageURL(pageName);
        // }
//         $scope.SaveParticipants=function(account,contactId,index,parentIndex){
//             debugger
//             $scope.signleConsortiaDetails=account.Contacts[index];
//             $scope.accountId=account.Id;
//             debugger;
//             $scope.ConsortiaDetailsList = [];
//             delete($scope.signleConsortiaDetails['$$hashKey']);
//             delete($scope.signleConsortiaDetails['RecordTypeId']);
            
//         IndustrialFellowshipController.upsertConsortiaContactsDet($scope.signleConsortiaDetails, $scope.accountId, $rootScope.projectId, function (result, event) {
//             console.log('save participants');            
//                 console.log(result);
//                 console.log(event);
//                 if (event.status) { 
//                     $scope.getPatnerDetails();                   
//                     debugger;
//                     Swal.fire(
//                         'Success',
//                         'Your data has been saved successfully.',
//                         'success'
//                     );                    
//                     $scope.getContactEduOtherDet(contactId,parentIndex);
//                     $scope.$apply();
//                 }
//             }, {
//                 escape: true
//             })          
//         }
//         $scope.getContactEduOtherDet=function(accountid,parentIndex){
//             debugger
//             IndustrialFellowshipController.getContactEduOtherDet(accountid, function (result, event) {
//                 debugger
//                 console.log('publication details');
//                 console.log(result);
//                 console.log(event);
//                 $scope.otherDet=[];
//                 $scope.eduDet=[];
//                 $scope.employmentDet=[];
//                 $scope.publicationDet=[];
//                 $scope.otherDet=result;
//                 debugger
//                 if(result.Education_Details__r==undefined){
//                     $scope.eduDet.push({
//                         Contact__c:contactid
//                     });
//                 }
//                 else
//                 {
//                     $scope.eduDet=result.Education_Details__r;
//                 }
//                 if(result.Employment_Details__r==undefined){
//                     $scope.employmentDet.push({
//                         Contact__c:contactid
//                     });
//                 }else{
//                     $scope.employmentDet=result.Employment_Details__r;
//                 }
//                 if(result.Publications_Patents__r==undefined){
//                     $scope.publicationDet.push({
//                         Contact__c:contactid,
//                         Description__c:""
//                     });
//                 }else{
//                     $scope.publicationDet=result.Publications_Patents__r;
//                 }
//                 $("#divEduOther"+parentIndex+"").show();
//                     $("#contactBasicDet"+index+"").hide();
//                 $scope.$apply();
//             });
//         }
//         $scope.backToConatctBasic=function(index){
// $("#divEduOther"+index+"").hide();
// $("#contactBasicDet"+index+"").show();
//         }
//         $scope.saveOtherDet=function(){
//             debugger
//             for(var i=0;i<$scope.eduDet.length;i++){
//                 delete($scope.eduDet[i]['$$hashKey']);
//             }
//             for(var i=0;i<$scope.employmentDet.length;i++){
//                 delete($scope.employmentDet[i]['$$hashKey']);
//             }
//             for(var i=0;i<$scope.publicationDet.length;i++){
//                 delete($scope.publicationDet[i]['$$hashKey']);
//             }
//             debugger
//             IndustrialFellowshipController.saveOtherDet($scope.eduDet,$scope.employmentDet,$scope.publicationDet, function (result, event) {
//                     console.log('save other det');
//                     console.log(result);
//                     console.log(event);
//                     swal("Contact Details", result);
//             });
//         }

//         $scope.criteriaMatch = function( criteria ) {
//             return function( item ) {
//               return item.Contact__c === criteria;
//             };
//           };
//           $scope.setSaveStatus=function(index){
//             debugger
//             $scope.arrySaveStatus[index].status=false;
//           }

        var inputQuantity = [];
    $(function() {     
      $(".zipcode-number").on("keyup", function (e) {
        var $field = $(this),
            val=this.value,
            $thisIndex=parseInt($field.data("idx"),10); 
        if (this.validity && this.validity.badInput || isNaN(val) || $field.is(":invalid") ) {
            this.value = inputQuantity[$thisIndex];
            return;
        } 
        if (val.length > Number($field.attr("maxlength"))) {
          val=val.slice(0, 5);
          $field.val(val);
        }
        inputQuantity[$thisIndex]=val;
      });      
    });

    /*////////////////////////////////////////// AFETR UI CHANGE //////////////////////////////////////////////*/

    $scope.getPatnerDetails = function () {
        debugger;
        $scope.allCoordinatorDetails = [];
        ApplicantPortal_Contoller.getPatnerDetails($rootScope.userId, function (result, event) {
            if (event.status) {
                debugger;

                if (result == null || result.length == 0) {
                    $scope.allCoordinatorDetails.push({
                        "Name": "",
                        "Phone": "",
                        "Contacts": [{"FirstName":"","Proposals__c":$rootScope.projectId}],
                        "Proposals__c": $rootScope.projectId
                    });
                } else {
                    // for(var i=0;i<result.length;i++){
                        
                    // }
                    $scope.allCoordinatorDetails = result; 
                    for(var i=0;i<$scope.allCoordinatorDetails.length;i++){
                        if($scope.allCoordinatorDetails[i].Contacts[0].Department!=undefined){
                            console.log("before replace=>"+$scope.allCoordinatorDetails[i].Contacts[0].Department);
                            $scope.allCoordinatorDetails[i].Contacts[0].Department=$scope.allCoordinatorDetails[i].Contacts[0].Department.replace(/&amp;/g,'&').replace(/&#39;/g,'\'').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'');
                            console.log("after replace=>"+$scope.allCoordinatorDetails[i].Contacts[0].Department);
                            $scope.allCoordinatorDetails[i].Name=$scope.allCoordinatorDetails[i].Name.replace(/&amp;/g,'&').replace(/&#39;/g,'\'').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'');
                        }
                    }                         
                }
                // for(var i=0;i<$scope.allCoordinatorDetails.length;i++){
                //     if($scope.allCoordinatorDetails[i].ShippingCountry == 'India'){
                //         //$scope.allCoordinatorDetails[i].stateList = $scope.indianStates;
                //     }else if($scope.allCoordinatorDetails[i].ShippingCountry == 'Germany'){
                //        // $scope.allCoordinatorDetails[i].stateList = $scope.germanStates; 
                //     }
                // }
                $scope.$apply();                    
                $("#panelsStayOpencollapse1,#panelsStayOpencollapse2,#panelsStayOpencollapse3,#panelsStayOpencollapse4,#panelsStayOpencollapse5").removeClass();
                $("#panelsStayOpencollapse1,#panelsStayOpencollapse2,#panelsStayOpencollapse3,#panelsStayOpencollapse4,#panelsStayOpencollapse5").addClass('accordion-collapse collapse');
                       
            }
        }, {
            escape: true
        })
    }
    $scope.getPatnerDetails();
    $scope.setCoordinator=function(index){
        debugger
     for(var i=0;i<$scope.allCoordinatorDetails.length;i++){
        if(i==index){
            $scope.allCoordinatorDetails[i].Is_Coordinator__c=true;
            $scope.allCoordinatorDetails[i].Is_Primary__c=true;
        }else{
            $scope.allCoordinatorDetails[i].Is_Coordinator__c=false;
            $scope.allCoordinatorDetails[i].Is_Primary__c=false;
        }
     }   
    }
    $scope.submitDetails = function(){
        debugger;
        var IndianCount = 0;
        var GermanyCount = 0;
        var IndianIndustryCount=0;
        var indianAcademiaCount=0;
        var GermanIndustryCount=0;
        var GermanAcademiaCount=0;

        for(let i=0; i<$scope.allCoordinatorDetails.length; i++){
            delete ($scope.allCoordinatorDetails[i]['$$hashKey']);
        }

        for(i=0;i<$scope.allCoordinatorDetails.length;i++){

            $scope.allCoordinatorDetails[i].Contacts[0].Proposals__c = $rootScope.projectId;
            if($scope.allCoordinatorDetails[i].Id == undefined || $scope.allCoordinatorDetails.Id == ""){
                $scope.allCoordinatorDetails[i].Contacts[0].AccountId = $scope.allCoordinatorDetails[i].Name;
            }

            if($scope.allCoordinatorDetails[i].Name == undefined || $scope.allCoordinatorDetails[i].Name == ""){
                swal("Coordinator Details", "Please Enter Institution/Industry Name.");
                $("#inst"+i+"").addClass('border-theme');
                return;  
            }
            if($scope.allCoordinatorDetails[i].BillingCountry == undefined || $scope.allCoordinatorDetails[i].BillingCountry == ""){
                swal("Coordinator Details", "Please select Country.");
                $("#country"+i+"").addClass('border-theme');
                return;  
            }
            // if($scope.allCoordinatorDetails[i].BillingCountry == 'India' && $scope.allCoordinatorDetails[i].Industry__c == true && $scope.allCoordinatorDetails[i].DSIR_Recoginition_Details__c == undefined){
            //     swal("Coordinator Details", "Please Enter DSIR Number.");
            //     $("#dsir"+i+"").addClass('border-theme');
            //     return;
            // }
            if($scope.allCoordinatorDetails[i].Academia__c == false && $scope.allCoordinatorDetails[i].Industry__c == false){
                swal("Coordinator Details", "Please Select either Academia or Industry.");
                return; 
            }
            if($scope.allCoordinatorDetails[i].Contacts != undefined){
                for(var j=0;j<$scope.allCoordinatorDetails[i].Contacts.length;j++){
                    if($scope.allCoordinatorDetails[i].Contacts[j].FirstName == undefined || $scope.allCoordinatorDetails[i].Contacts[j].FirstName == ""){
                        swal("Coordinator Details", "Please Enter Head of project.");
                        $("#head"+i+"").addClass('border-theme');
                        return;
                    }
                    if($scope.allCoordinatorDetails[i].Contacts[j].Department == undefined || $scope.allCoordinatorDetails[i].Contacts[j].Department == ""){
                        swal("Coordinator Details", "Please Enter Department.");
                        $("#dept"+i+"").addClass('border-theme');
                        return;
                    }
                    if($scope.allCoordinatorDetails[i].Contacts[j].Email == undefined || $scope.allCoordinatorDetails[i].Contacts[j].Email == ""){
                        swal("Coordinator Details", "Please Enter Email.");
                        $("#email"+i+"").addClass('border-theme');
                        return;
                    }else{
                        if($scope.valid($scope.allCoordinatorDetails[i].Contacts[j].Email)){
                            swal(
                                'info',
                                'Check Your Registered Email.',
                                'info'
                            );
                            $("#email"+i+"").addClass('border-theme');
                            return;
                        }
                    }

                    if($scope.allCoordinatorDetails[i].Contacts[j].Phone == undefined || $scope.allCoordinatorDetails[i].Contacts[j].Phone == ""){
                        swal("Coordinator Details", "Please Enter Phone.");
                        $("#phone"+i+"").addClass('border-theme');
                        return;
                    }
                }
            }
        }

        for(i=0;i<$scope.allCoordinatorDetails.length;i++){
            if($scope.allCoordinatorDetails[i].BillingCountry == "India"){
                IndianCount = IndianCount+1
            }

            if($scope.allCoordinatorDetails[i].BillingCountry == "Germany"){
                GermanyCount = GermanyCount+1
            }
        }
        if($scope.allCoordinatorDetails.length < 4){
            swal("Consortia!", "Please add minimum four partners.", "info");
                return;  
        }
        if($scope.allCoordinatorDetails.length > 6){
            swal("Consortia!", "maximum six partners are allowed.", "info");
                return; 
        }
        if($scope.allCoordinatorDetails.length==4 && (IndianCount<2 || IndianCount>2)){
            swal("Consortia!", "Indian partner should be equal german partner", "info");
                return;
            }
        if($scope.allCoordinatorDetails.length==6 && (IndianCount<3 || IndianCount>3)){
                swal("Consortia!", "Indian and german partner must be in 2+2 or 3+3 format", "info");
                    return;
        }

        for(var i=0;i<$scope.allCoordinatorDetails.length;i++){
            if($scope.allCoordinatorDetails[i].BillingCountry=="India"){
                if($scope.allCoordinatorDetails[i].Industry__c==true){
                    IndianIndustryCount=IndianIndustryCount+1;
                }  
                else
                {
                    indianAcademiaCount=indianAcademiaCount+1;
                }               
            }
            else if($scope.allCoordinatorDetails[i].BillingCountry=="Germany")
            {
                if($scope.allCoordinatorDetails[i].Industry__c==true){
                    GermanIndustryCount=GermanIndustryCount+1;
                }  
                else
                {
                    GermanAcademiaCount=GermanAcademiaCount+1;
                } 
            }
        }
        if(IndianIndustryCount==0 || indianAcademiaCount==0){
            swal("Consortia!", "One industry and one academia is mandatory", "info");
            return;
        }
        if(GermanIndustryCount==0 || GermanAcademiaCount==0){
            swal("Consortia!", "One industry and one academia is mandatory", "info");
            return;
        }
            $scope.contactList = [];
            for(var i=0;i<$scope.allCoordinatorDetails.length;i++){
                if($scope.allCoordinatorDetails[i].Contacts != undefined){
                            $scope.contactList.push($scope.allCoordinatorDetails[i].Contacts[0]);
                    }
                    debugger;
            }

            if($scope.emailCheck == true){
               swal('info','Email already exists.','info');
               //$("#email"+ind+"").addClass('border-theme');
                   return;
           }

            for(let i=0; i<$scope.allCoordinatorDetails.length; i++){
                delete ($scope.allCoordinatorDetails[i]['Contacts']);
                // delete ($scope.allCoordinatorDetails[i]['stateList']);
            }
            $("#btnPreview").html('<i class="fa-solid fa-spinner fa-spin-pulse me-3"></i>Please wait...');
        ApplicantPortal_Contoller.insertCoordinatorsInformation($scope.allCoordinatorDetails,$scope.contactList, function(result, event){
            $("#btnPreview").html('<i class="fa-solid fa-check me-2"></i>Save and Next');
            if(event.status){
             debugger;
             swal({
                title: "Success",
                text: "Co-Ordinators detail has been saved successfully.",
                icon: "success",
                buttons: true,
                dangerMode: false,
            }).then((willDelete) => {
                if (willDelete) {                    
                    $scope.disableSubmit = true; 
             $scope.redirectPageURL('ConsortiaAddress');
             $scope.accList = result;
             $scope.$apply(); 
                } else {
                 return;
                }
              });
            //  Swal.fire(
            //      'Success',
            //      'Co-Ordinators detail has been saved successfully.',
            //      'success'
            //  );
            //  $scope.disableSubmit = true; 
            //  $scope.redirectPageURL('ConsortiaAddress');
            //  $scope.accList = result;
            //  $scope.$apply();  
         }
        },
        {escape:true}
        )
    }

    $scope.valid = function(value){
        if(value!=undefined){
             var x=value;
             var atpos = x.indexOf("@");
             var dotpos = x.lastIndexOf(".");
            if (atpos<1 || dotpos<atpos+2 || dotpos+2>=x.length) {
                
                return true;
            }
            return false;
         }
     }

    $scope.removeClass=function(controlid,index){
        var controlIdfor=controlid+""+index;
        $("#"+controlIdfor+"").removeClass('border-theme');
      }


    $scope.checkEmail = function(){
        var coordinatiorStatus=false;
        for(var i=0;i<$scope.allCoordinatorDetails.length;i++){
                if($scope.allCoordinatorDetails[i].Is_Coordinator__c){
                    coordinatiorStatus=true;
                }
         }
if(!coordinatiorStatus){
    swal('info','Please select coordinator.','info');
    return;
}
        $scope.emailList = [];
        debugger;
        $scope.emailCheck = false;


        for(var i=0;i<$scope.allCoordinatorDetails.length;i++){
            if($scope.allCoordinatorDetails[i].Contacts[0].Email != undefined){
                if($scope.emailList.indexOf($scope.allCoordinatorDetails[i].Contacts[0].Email) != -1){
                    swal("info", "DUPLICATE Email, Please check.","info");
                    return;
               }
               else{
                    $scope.emailList.push($scope.allCoordinatorDetails[i].Contacts[0].Email);
               }
               if($scope.allCoordinatorDetails[i].Contacts[0].Id != undefined){
                    $scope.listOfIds.push($scope.allCoordinatorDetails[i].Contacts[0].Id);
               }
            }
          }
        ApplicantPortal_Contoller.checkBulkEmail($scope.emailList,$scope.listOfIds,function(result,event){
          debugger;
          debugger;
          if(event.status){
            debugger;
            if(result.length > 0){
              $scope.emailCheck = true;
            }else{
              $scope.emailCheck = false;
            }
            $scope.submitDetails();
            $scope.$apply();
          }
        })
  
      }
});