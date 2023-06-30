angular.module('cp_app').controller('fellowshipP_ctrl', function($scope,$rootScope){

    debugger;
    $scope.siteURL = siteURL;
    $rootScope.userHashId;
    $rootScope.userId;
    $rootScope.candidateId;
    $rootScope.siteURL;
    $scope.tentitiveStartDate;
    $scope.tentitiveEndDate;
    $scope.announcementDate;
    $rootScope.availingFellowship;
    $rootScope.pairedApplicant;

    $scope.objRtf=[{charCount:0,maxCharLimit:1500,errorStatus:false}];
    $scope.objRtf.push({charCount:0,maxCharLimit:500,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:500,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:500,errorStatus:false});

    $scope.readCharacter=function(event,index){
        debugger
           try{
           var rtfString=event.toString().replace(/<[^>]*>|\s/g, '').replace(/\s+/g,'').replace(/&ndash;/g,'-').replace(/&euro;/g,'1').replace(/&amp;/g,'1').replace(/&#39;/g,'1').replace(/&quot;/g,'1').replace(/&nbsp;/g,'').replace(/&mdash;/g,'-').replace(/&gt;/g,'>').replace(/&lt;/g,'<').replace(/&bull;/g,'');
            charLength=rtfString.length;
            if(charLength>0){
             $scope.objRtf[index].charCount=charLength;
             if(charLength>$scope.objRtf[index].maxCharLimit){
                  $scope.objRtf[index].errorStatus=true;
             }else
             {
              $scope.objRtf[index].errorStatus=false;
             }
            }
            else{
                  $scope.objRtf[index].charCount=0;
                  $scope.objRtf[index].errorStatus=false;
            }
           }catch(e){}
       }

    $scope.getProjectdetils = function(){
        debugger;
        ApplicantPortal_Contoller.getFellowshipDetails($rootScope.userId, function(result,event){
            debugger;
            if(event.status){
                if(result != null){
                    // $rootScope.projectId = result.Id;
                    if(result.Proposals__r.Campaign__r.Result_Announcement_Date__c != null){
                        $scope.announcementDate = new Date(result.Proposals__r.Campaign__r.Result_Announcement_Date__c)
                    }
                    if(result.Tentative_Start_Date__c!=null){
                        $scope.tentitiveStartDate = new Date(result.Tentative_Start_Date__c);
                    }
                    if(result.Tentative_End_Date__c!=null){
                        $scope.tentitiveEndDate = new Date(result.Tentative_End_Date__c);
                    }
                }
                
                debugger;
                if(result.Planned_research_activities_of_the_visit__c != undefined || result.Planned_research_activities_of_the_visit__c != ""){
                    result.Planned_research_activities_of_the_visit__c = result.Planned_research_activities_of_the_visit__c ? result.Planned_research_activities_of_the_visit__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Planned_research_activities_of_the_visit__c;
                }
                if(result.Expected_outcomes__c != undefined || result.Expected_outcomes__c != ""){
                    result.Expected_outcomes__c = result.Expected_outcomes__c ? result.Expected_outcomes__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Expected_outcomes__c;
                }
                if(result.Basis_for_choosing_your_paired_member__c != undefined || result.Basis_for_choosing_your_paired_member__c != ""){
                    result.Basis_for_choosing_your_paired_member__c = result.Basis_for_choosing_your_paired_member__c ? result.Basis_for_choosing_your_paired_member__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Basis_for_choosing_your_paired_member__c;
                }
                if(result.Tentative_plans__c != undefined || result.Tentative_plans__c != ""){
                    result.Tentative_plans__c = result.Tentative_plans__c ? result.Tentative_plans__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Tentative_plans__c;
                }
                if(result.Give_Fellowship_Details__c != undefined || result.Give_Fellowship_Details__c != ""){
                    result.Give_Fellowship_Details__c = result.Give_Fellowship_Details__c ? result.Give_Fellowship_Details__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Give_Fellowship_Details__c;
                }
                if(result.Give_Associated_Details__c != undefined || result.Give_Associated_Details__c != ""){
                    result.Give_Associated_Details__c = result.Give_Associated_Details__c ? result.Give_Associated_Details__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Give_Associated_Details__c;
                }
                $scope.proposalDetails = result;
                $scope.$apply();
            }
        },
                                                  {escape: true}
                                                 )
    }
    $scope.getProjectdetils();
    $scope.proposalDetails = {};

    $scope.saveApplication = function(){
        debugger;

        if($scope.proposalDetails.Planned_research_activities_of_the_visit__c == undefined || $scope.proposalDetails.Planned_research_activities_of_the_visit__c == ""){
            swal("Proposal Detail", "Please Enter Reasearch Approach Objectives.");
            return; 
        }else{
        
            if($scope.objRtf[0].charCount > 1500){
                swal('info','Max character limit for Planned research activities of the visit is 1500 only','info');
                return;
          }
    }

        if($scope.proposalDetails.Expected_outcomes__c == undefined || $scope.proposalDetails.Expected_outcomes__c == ""){
            swal("Proposal Detail", "Please Enter Expected outcomes including future plans emerging out of the visit and value addition to the parent organization.");
            return; 
        }else{
            
      if($scope.objRtf[1].charCount > 500){
        swal('info','Max character limit for Expected outcomes including future plans emerging out of the visit and value addition to the parent organization is 500 only','info');
        return;
      }
    }

        if($scope.proposalDetails.Basis_for_choosing_your_paired_member__c == undefined || $scope.proposalDetails.Basis_for_choosing_your_paired_member__c == ""){
            swal("Proposal Detail", "Please Enter basis for choosing the pairing fellow.");
            return; 
        }else{
            
      if($scope.objRtf[2].charCount > 500){
        swal('info','Max character limit for What is the basis for choosing the pairing fellow is 500 only','info');
        return;
      }
    }

    if($scope.proposalDetails.Tentative_plans__c != undefined){
        
  if($scope.objRtf[3].charCount > 500){
    swal('info','Max character limit for Tentative plans for networking visits to different institutions during the fellowship is 500 only','info');
    return;
  } 
    }

                    var startyear = 0;
                    var startmonth = 0;
                    var startday = 0;
                    var endyear = 0;
                    var endmonth = 0;
                    var endday = 0;
                    var today = new Date();
                    var dd = today.getDate();
                    var mm = today.getMonth() + 1; //January is 0!
                    var yyyy = today.getFullYear();
        
            if($scope.tentitiveStartDate == undefined || $scope.tentitiveStartDate == ''){
                swal("Proposal Detail", "Please Enter Tentative Start Date.");
                $("#txtSD").addClass('border-theme');
                    return;
            }else if($scope.tentitiveStartDate != undefined || $scope.tentitiveStartDate != ""){
                startyear = $scope.tentitiveStartDate.getUTCFullYear();
                startmonth = $scope.tentitiveStartDate.getUTCMonth()+1;
                startday = $scope.tentitiveStartDate.getDate();
            }

            if($scope.tentitiveStartDate < $scope.announcementDate){
                swal("Proposal Detail", "Tentative Start Date should not be previous to result announcement date.");
                $("#txtSD").addClass('border-theme');
                return;  
            }

            if($scope.tentitiveEndDate == undefined || $scope.tentitiveEndDate == ''){
                swal("Proposal Detail", "Please Enter Tentative End Date.");
                $("#txtED").addClass('border-theme');
                    return;
            }else if($scope.tentitiveEndDate != undefined || $scope.tentitiveEndDate != ""){
            endyear = $scope.tentitiveEndDate.getUTCFullYear();
            endmonth = $scope.tentitiveEndDate.getUTCMonth()+1;
            endday = $scope.tentitiveEndDate.getDate();
        }

        console.log('tentitiveStartDate :',$scope.tentitiveStartDate);
        console.log('today :',today);
        console.log('tentitiveStartDate :',$scope.tentitiveStartDate);
        console.log('tentitiveEndDate1 :',new Date($scope.tentitiveEndDate).toLocaleString());
        console.log('announcementdate :',new Date($scope.announcementDate).toLocaleString());

        if($scope.tentitiveEndDate < $scope.announcementDate){
            swal("Proposal Detail", "Tentative End Date should not be previous to result announcement date.");
            $("#txtED").addClass('border-theme');
            return;  
        }


        if($scope.tentitiveStartDate > $scope.tentitiveEndDate){
            swal("Proposal Detail", "Tentative End Date should not be previous to Tentative Start Date.");
            $("#txtSD").addClass('border-theme');
            $("#txtED").addClass('border-theme');
            return;   
        }

        console.log('tentitiveStartDate :',$scope.tentitiveStartDate);
        console.log('tentitiveEndDate :',$scope.tentitiveEndDate);

        debugger;
        if($scope.tentitiveStartDate == $scope.tentitiveEndDate){
            swal("Proposal Detail", "Tentative End Date should not be same to Tentative Start Date.");
            $("#txtSD").addClass('border-theme');
            $("#txtED").addClass('border-theme');
            return;   
        }

        // var timeDiff = Math.abs($scope.tentitiveEndDate.getTime() - $scope.tentitiveStartDate.getTime());
        // $scope.dayDifference = Math.ceil(timeDiff / (1000 * 3600 * 24));
        // console.log('dayDifference :: '+$scope.dayDifference);

        // if($scope.dayDifference >= 365){
        //     swal("info", 'Duration must be less than one year.',"info");
        //     $("#txtED").addClass('border-theme');
        //     return;   
        // }
        if($scope.proposalDetails.Availing_Fellowship__c == undefined || $scope.proposalDetails.Availing_Fellowship__c == ""){
            swal("Proposal Detail", "Please Enter Are You Availing any other fellowship currently?");
            return; 
        }

        if($scope.proposalDetails.Associated_with_IGSTC__c == undefined || $scope.proposalDetails.Associated_with_IGSTC__c == ""){
            swal("Proposal Detail", "Please Enter Whether the paired applicant associated with IGSTC programmes in past?");
            return; 
        }

        if($scope.proposalDetails.Availing_Fellowship__c == 'Yes' && ($scope.proposalDetails.Give_Fellowship_Details__c == undefined || $scope.proposalDetails.Give_Fellowship_Details__c == "")){
            swal("Proposal Detail", "Please give details for availing fellowship.");
            return; 
        }
        if($scope.proposalDetails.Associated_with_IGSTC__c == 'Yes' && ($scope.proposalDetails.Give_Associated_Details__c == undefined || $scope.proposalDetails.Give_Associated_Details__c == "")){
            swal("Proposal Detail", "Please give details for previously associated with the IGSTC in past.");
            return; 
        }

        var endDate = moment($scope.tentitiveEndDate);
        var starDate = moment($scope.tentitiveStartDate);
        var years = endDate.diff(starDate, 'days');

        if(years > 60){
            swal("Basic Details", "Duration should not be more than 2 months", "info");
                $("#txtED").addClass('border-theme');
                return; 
        }
        
        if(years<21){
            swal("Basic Details", "Duration should not be less than 3 weeks", "info");
            $("#txtED").addClass('border-theme');
            return;
          }

        delete ($scope.proposalDetails.Tentative_Start_Date__c);
        delete ($scope.proposalDetails.Tentative_End_Date__c);
        delete ($scope.proposalDetails.Proposals__r);

    ApplicantPortal_Contoller.insertFellowship_Details($scope.proposalDetails,startday,startmonth,startyear,endday,endmonth,endyear,$rootScope.contactId,'PECFAR', function (result, event){
        debugger;   
        if(event.status && result != null) {
                debugger;
                swal({
                    title: "Fellowship Details",
                    text: 'Your fellowship details have been successfully saved.',
                    icon: "success",
                    button: "ok!",
                  }).then((value) => {
                    $scope.redirectPageURL('Achievements_Pecfar');
                    $rootScope.projectId = result;
                      });
                
                $scope.$apply(); 
                
        }
        else
              {
                swal({
                  title: "Fellowship Details",
                  text: "Exception!",
                  icon: "error",
                  button: "ok!",
                });
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

    $scope.removeClass2=function(controlid){
        $("#"+controlid+"").removeClass('border-theme');
      }
});