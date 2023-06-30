angular.module('cp_app').controller('pairing_ctrl', function($scope,$rootScope){

    debugger;
    $scope.siteURL = siteURL;
    $rootScope.projectId;
    $scope.disableAddButton=false;
    $scope.pairList = {"Account":{"Name":""}};
    $scope.pairingDetails = {"Account":{"Name":""}};
    $scope.mydate = new Date('2013', '10', '28');
    // $scope.birthday;

    $scope.checkEmail = function(email,contId){
        debugger;
        $scope.emailCheck = false;
        if(contId == undefined){
          contId = "";
        }
        ApplicantPortal_Contoller.checkEmail(email,contId,function(result,event){
          debugger;
          if(event.status){
            debugger;
            if(result.length > 0){
              $scope.emailCheck = true;
            }else{
              $scope.emailCheck = false;
            }
            $scope.$apply();
          }
        })
  
      }

    $scope.getcampaigntype = function(){
        debugger;
        $scope.primary = false;
        ApplicantPortal_Contoller.getcampaigntype($rootScope.userId, function(result,event){
            debugger;
            if(event.status && result != null){
                debugger;
                $scope.campaigntype = result.Campaign__c;
                if(result.Is_Primary__c == true){
                    $scope.primary = false;
                }else{
                    $scope.primary = true;
                }
                $scope.$apply();
            }
        })
    }
    $scope.getcampaigntype();

    $scope.getPairingDetails = function () {
        debugger;
        $scope.pairingDetails = [];
        if($rootScope.tagCampaignId == undefined){
            $rootScope.tagCampaignId = "";   
        }
        ApplicantPortal_Contoller.getPairingDetails($rootScope.userId,$rootScope.tagCampaignId, function (result, event) {
            if (event.status) {
                if(result != null){
                    for(var i=0;i<result.length;i++){
                        if(result[i].Birthdate!=null){
                            result[i].Birthdate = new Date(result[i].Birthdate);
                        }

                        if(result[i].Account != undefined){
                            if(result[i].FirstName != undefined || result[i].FirstName != ''){
                                result[i].FirstName = result[i].FirstName ? result[i].FirstName.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('&gt;','>').replaceAll('&amp;','&') : result[i].FirstName;  
                            }
                            if(result[i].LastName != undefined || result[i].LastName != ''){
                                result[i].LastName = result[i].LastName ? result[i].LastName.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('&gt;','>').replaceAll('&amp;','&') : result[i].LastName;  
                            }
                            if(result[i].Account.Name != undefined || result[i].Account.Name != ''){
                                result[i].Account.Name = result[i].Account.Name ? result[i].Account.Name.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('&gt;','>').replaceAll('&amp;','&') : result[i].Account.Name;  
                            }
                        }
                    }
                    if(result[0].Proposals__r.Campaign__r.EndDate != undefined){
                        $scope.endDate = new Date(result[0].Proposals__r.Campaign__r.EndDate);
                    }
                    
                }
                debugger;
                $rootScope.projectId = result[0].Proposals__c;

                if (result == null || result.length == 0) {
                    $scope.pairingDetails.push({
                        "FirstName": " ",
                        "LastName": " ",
                        "Email": " ",
                        "Birthdate":"",
                        "MailingCountry":"",
                        "Campaign__c":$scope.campaigntype
                    });
                }else{
                    for(var i=0;i<result.length;i++){
                        if(result[i].Is_Primary__c == true){
                            $scope.pairingDetails = result[i];
                            if($scope.pairingDetails.MailingCountry == "India"){
                                $scope.pairList.MailingCountry = "Germany";
                            }else{
                                $scope.pairList.MailingCountry = "India";
                            }
                        }else if(result[i].Is_Primary__c == false){
                            $scope.pairList = result[i];
                            if($scope.pairList.MailingCountry == "Germany"){
                                $scope.pairingDetails.MailingCountry = "India"
                            }else{
                                $scope.pairingDetails.MailingCountry = "Germany"
                            }
                        }
                    }
                }
                $scope.$apply();                    
                       
            }
        }, {
            escape: true
        })
    }
    $scope.getPairingDetails();

    $scope.insertPairingDetails = function(){
        debugger;
        var IndianCount = 0;
        var GermanyCount = 0;
        $scope.detailedList = [];
        $scope.conList = [];
        $scope.detailedList.push($scope.pairingDetails,$scope.pairList);
        console.log('detailedList :: '+$scope.detailedList);

        // for(var i=0;i<$scope.detailedList.length;i++){
            debugger;
            // if($scope.detailedList[i].MailingCountry == "India"){
                        // IndianCount = IndianCount+1

                        if($scope.pairingDetails != undefined){
                        if($scope.pairingDetails.FirstName == undefined || $scope.pairingDetails.FirstName == ""){
                            swal("info", "Please Enter First Name.");
                            $("#txtIndFN").addClass('border-theme');
                              return;
                        }
            
                        if($scope.pairingDetails.LastName == undefined || $scope.pairingDetails.LastName == ""){
                            swal("info", "Please Enter Last Name.");
                            $("#txtIndLN").addClass('border-theme');
                              return;
                        }
            
                        if($scope.pairingDetails.Email == undefined || $scope.pairingDetails.Email == ""){
                            swal("info", "Please Enter Email.");
                            $("#txtIndEmail").addClass('border-theme');
                              return;
                        }else{
                            if($scope.valid($scope.pairingDetails.Email)){
                                swal(
                                    'info',
                                    'Check Your Registered Email.',
                                    'info'
                                )
                                $("#txtIndEmail").addClass('border-theme');
                                return;
                            }
                        }
            
                            if($scope.pairingDetails.Account == undefined || $scope.pairingDetails.Account == ""){
                                      swal("info", "Please Enter Institution / Organization Name.");
                                      $("#txtIndOrg").addClass('border-theme');
                                        return;
                            }
                            
                            if($scope.pairingDetails.Account != undefined){
                                if($scope.pairingDetails.Account.Name == undefined){
                                    swal("info", "Please Enter Institution / Organization Name.");
                                    $("#txtIndOrg").addClass('border-theme');
                                      return;
                                }
                      }
            
                        if($scope.pairingDetails.Birthdate == undefined || $scope.pairingDetails.Birthdate == ""){
                            swal("info", "Please Enter BirthDate.");
                            $("#txtIndBD").addClass('border-theme');
                              return;
                        }

                        if($scope.emailCheck == true){
                            swal('info','Email already exists.','info');
                            $("#txtIndEmail").addClass('border-theme');
                                return;
                        }
                     }
                    // }
        
                    // if($scope.detailedList[i].MailingCountry == "Germany"){
                        // GermanyCount = GermanyCount+1

                        if($scope.pairList != undefined){
                            if($scope.pairList.FirstName == undefined || $scope.pairList.FirstName == ""){
                                swal("info", "Please Enter First Name.");
                                $("#txtGerFN").addClass('border-theme');
                                  return;
                            }
                
                            if($scope.pairList.LastName == undefined || $scope.pairList.LastName == ""){
                                swal("info", "Please Enter Last Name.");
                                $("#txtGerLn").addClass('border-theme');
                                  return;
                            }
                
                            if($scope.pairList.Email == undefined || $scope.pairList.Email == ""){
                                swal("info", "Please Enter Email.");
                                $("#txtGerEmail").addClass('border-theme');
                                  return;
                            }else{
                                if($scope.valid($scope.pairList.Email)){
                                    swal(
                                        'info',
                                        'Check Your Registered Email.',
                                        'info'
                                    )
                                    $("#txtGerEmail").addClass('border-theme');
                                    return;
                                }
                            }
                
                                if($scope.pairList.Account == undefined || $scope.pairList.Account == ""){
                                          swal("info", "Please Enter Institution / Organization Name.");
                                          $("#txtGerOrg").addClass('border-theme');
                                            return;
                                }
                                
                                if($scope.pairList.Account != undefined){
                                    if($scope.pairList.Account.Name == undefined){
                                        swal("info", "Please Enter Institution / Organization Name.");
                                        $("#txtGerOrg").addClass('border-theme');
                                          return;
                                    }
                          }
                
                            if($scope.pairList.Birthdate == undefined || $scope.pairList.Birthdate == ""){
                                swal("info", "Please Enter BirthDate.");
                                $("#txtGerBD").addClass('border-theme');
                                  return;
                            }
    
                            if($scope.emailCheck == true){
                                swal('info','Email already exists.','info');
                                $("#txtGerEmail").addClass('border-theme');
                                    return;
                            }
                        }
                        
                    // }
        
            // }
        
                // if($scope.detailedList.length==2 && IndianCount>1){
                //     swal("info", "Indian partner should be only one", "info");
                //     $("#txtPincode").addClass('border-theme');
                //         return;
                //     }
        
                // if($scope.detailedList.length==2 && GermanyCount>1){
                //     swal("info", "German partner should be only 1", "info");
                //     $("#txtPincode").addClass('border-theme');
                //         return;
                //     }

            for(let i=0; i<$scope.detailedList.length; i++){
                    delete ($scope.detailedList[i]['$$hashKey']);
                    var pairingObj = {"companyNmae":$scope.detailedList[i].Account.Name,"proposal":$rootScope.projectId,"accId":$scope.detailedList[i].AccountId,"birthyear":0,"birthmonth":0,"birthday":0,cont:{
                        "FirstName":$scope.detailedList[i].FirstName,"LastName":$scope.detailedList[i].LastName,"Id":$scope.detailedList[i].Id,"Email":$scope.detailedList[i].Email,"Campaign__c":$scope.campaigntype,"MailingCountry":$scope.detailedList[i].MailingCountry,AccountId:$scope.detailedList[i].AccountId,"Proposals__c":$rootScope.projectId
                    }};
                    pairingObj.companyNmae = $scope.detailedList[i].Account.Name;

                    if($scope.detailedList[i].Birthdate == undefined || $scope.detailedList[i].Birthdate == ''){
                        delete ($scope.detailedList[i].Birthdate); 
                    }else if($scope.detailedList[i].Birthdate != undefined || $scope.detailedList[i].Birthdate != ""){
                        pairingObj.birthyear = $scope.detailedList[i].Birthdate.getUTCFullYear();
                        pairingObj.birthmonth = $scope.detailedList[i].Birthdate.getUTCMonth()+1;
                        pairingObj.birthday = $scope.detailedList[i].Birthdate.getDate();

                        var deadline = moment($scope.endDate);
                        var BDate = moment($scope.detailedList[i].Birthdate);
                        var years = deadline.diff(BDate, 'days');
        
                        if($scope.detailedList[i].Is_Primary__c == true){
                            if(years > 12783){
                                swal("Pairing Detail", "Age can not be more than 35 years", "info");
                                    $("#txtIndBD").addClass('border-theme');
                                    return; 
                            }
                            if(years<7305){
                                swal("Pairing Detail", "Age can not be less than 20 years", "info");
                                $("#txtIndBD").addClass('border-theme');
                                return;
                              }
                        }else{
                            var age = moment().diff(''+pairingObj.birthyear+'-'+pairingObj.birthmonth+'-'+pairingObj.birthday+'', 'years');
                            if(years > 12783){
                                swal("Pairing Detail", "Age can not be more than 35 years", "info");
                                    $("#txtGerBD").addClass('border-theme');
                                    return; 
                            }else if(years<7305){
                                swal("Pairing Detail", "Age can not be less than 20 years", "info");
                                $("#txtGerBD").addClass('border-theme');
                                return;
                              }
                        }

                        // if($scope.detailedList[i].Is_Primary__c == false || $scope.detailedList[i].Is_Primary__c == undefined){
                            
                        // }
                    }
                    $scope.conList.push(pairingObj);
        
                }

                for(var i=0;i<$scope.detailedList.length;i++){
                    delete ($scope.detailedList[i].Birthdate);
                }

        // for(let i=0; i<$scope.pairingDetails.length; i++){

        //     if($scope.pairingDetails[i].MailingCountry == "India"){
        //         IndianCount = IndianCount+1
        //     }

        //     if($scope.pairingDetails[i].MailingCountry == "Germany"){
        //         GermanyCount = GermanyCount+1
        //     }

        //     if($scope.pairingDetails[i].FirstName == undefined || $scope.pairingDetails[i].FirstName == ""){
        //         swal("Pairing Detail", "Please Enter First Name!");
        //           return;
        //     }

        //     if($scope.pairingDetails[i].LastName == undefined || $scope.pairingDetails[i].LastName == ""){
        //         swal("Pairing Detail", "Please Enter Last Name!");
        //           return;
        //     }

        //     if($scope.pairingDetails[i].Email == undefined || $scope.pairingDetails[i].Email == ""){
        //         swal("Pairing Detail", "Please Enter Email!");
        //           return;
        //     }else{
        //         if($scope.valid($scope.pairingDetails[i].Email)){
        //             swal(
        //                 'info',
        //                 'Check Your Registered Email!',
        //                 'info'
        //             )
        //             return;
        //         }
        //     }

        //     if($scope.pairingDetails[i].Account.Name == undefined || $scope.pairingDetails[i].Account.Name == ""){
        //         swal("Pairing Detail", "Please Enter Company Name!");
        //           return;
        //     }

        //     if($scope.pairingDetails[i].Birthdate == undefined || $scope.pairingDetails[i].Birthdate == ""){
        //         swal("Pairing Detail", "Please Enter BirthDate!");
        //           return;
        //     }

        //     if($scope.pairingDetails[i].MailingCountry == undefined || $scope.pairingDetails[i].MailingCountry == ""){
        //         swal("Pairing Detail", "Please Enter Country!");
        //           return;
        //     }
        // }

        // if($scope.emailCheck == true){
        //     swal('info','Email already exists.','info');
        //         return;
        // }

        // if($scope.pairingDetails.length==2 && IndianCount>1){
        //     swal("Pairing Detail", "Indian partner should be only one", "info");
        //         return;
        //     }

        // if($scope.pairingDetails.length==2 && GermanyCount>1){
        //     swal("Pairing Detail", "German partner should be only 1", "info");
        //         return;
        //     }

        // for(let i=0; i<$scope.pairingDetails.length; i++){
        //     delete ($scope.pairingDetails[i]['$$hashKey']);

        //     var pairingObj = {"companyNmae":$scope.pairingDetails[i].Account.Name,"proposal":$rootScope.projectId,"accId":$scope.pairingDetails[i].AccountId,"birthyear":0,"birthmonth":0,"birthday":0,cont:{
        //         "FirstName":$scope.pairingDetails[i].FirstName,"LastName":$scope.pairingDetails[i].LastName,"Id":$scope.pairingDetails[i].Id,"Email":$scope.pairingDetails[i].Email,"Campaign__c":$scope.campaigntype,"MailingCountry":$scope.pairingDetails[i].MailingCountry,AccountId:$scope.pairingDetails[i].AccountId,"Proposals__c":$rootScope.projectId
        //     }};
        //     pairingObj.companyNmae = $scope.pairingDetails[i].Account.Name;
        //     $scope.detailedList.push(pairingObj);

        //     if($scope.pairingDetails[i].Birthdate == undefined || $scope.pairingDetails[i].Birthdate == ''){
        //         delete ($scope.pairingDetails[i].Birthdate); 
        //     }else if($scope.pairingDetails[i].Birthdate != undefined || $scope.pairingDetails[i].Birthdate != ""){
        //         pairingObj.birthyear = $scope.pairingDetails[i].Birthdate.getUTCFullYear();
        //         pairingObj.birthmonth = $scope.pairingDetails[i].Birthdate.getUTCMonth()+1;
        //         pairingObj.birthday = $scope.pairingDetails[i].Birthdate.getDate();

        //         var age = moment().diff(''+pairingObj.birthyear+'-'+pairingObj.birthmonth+'-'+pairingObj.birthday+'', 'years');
        //         if(age>35){
        //             swal("Pairing Detail", "Age can not be more than 35 years", "info");
        //             return;
        //         }else if(age<20){
        //             swal("Pairing Detail", "Age can not be less than 20 years", "info");
        //             return;
        //           }
        //     }

        //     delete ($scope.pairingDetails[i].Birthdate);
        // }

        ApplicantPortal_Contoller.insertPairingDetails($scope.conList, function(result, event){
            if(event.status){
             debugger;
             swal({
                title: "Pairing Details",
                text: 'Pairing details have been successfully saved.',
                icon: "success",
                button: "ok!",
              }).then((value) => {
                $scope.getPairingDetails(); 
                  $scope.redirectPageURL('Personal_Information');
                  });
            //  Swal.fire(
            //      'Success',
            //      'Pairing detail has been saved successfully.',
            //      'success'
            //  );
            // $scope.redirectPageURL('Personal_Information');
            $scope.$apply();  
         }
         else
              {
                swal({
                  title: "Pairing Details",
                  text: "Exception!",
                  icon: "error",
                  button: "ok!",
                });
              }
        },
        {escape:true}
        )
    }

    $scope.addParticipant=function(){
        debugger;
        if($scope.pairingDetails.length>1){
            swal("Max Account Limit", "You can add only 1 pair.")
        }
        else
        {
            $scope.pairingDetails.push({
                "companyNmae":"",
                "Proposals__c":$rootScope.projectId,
                cont:{"FirstName":"","LastName":"","Email":"","MailingCountry":"","Campaign__c":$scope.campaigntype,"Proposals__c":$rootScope.projectId
            }});
        }
        if($scope.pairingDetails.length>2){
            $scope.disableAddButton=true;
        }
    }

    $scope.redirectPageURL = function(pageName){
        debugger;
        var link=document.createElement("a");
        link.id = 'someLink'; //give it an ID!
        link.href="#/"+pageName;
        link.click();
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

     $scope.removeClass=function(controlid){
        $("#"+controlid+"").removeClass('border-theme');
      }

    
});