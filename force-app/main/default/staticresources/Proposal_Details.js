angular.module('cp_app').controller('proposal_ctrl', function($scope, $rootScope){
    debugger;
    $rootScope.siteURL = siteURL;
    $rootScope.proposalDetails = {};
    $scope.config.height=500;

    $scope.objRtf=[{charCount:0,maxCharLimit:0,errorStatus:false}];
    $scope.objRtf.push({charCount:0,maxCharLimit:0,errorStatus:false});

    $scope.readCharacter=function(event,index){
        debugger
           try{
           var rtfString=event.toString().replace(/<[^>]*>|\s/g, '').replace(/\s+/g,'').replace(/&ndash;/g,'-').replace(/&euro;/g,'1').replace(/&amp;/g,'1').replace(/&#39;/g,'1').replace(/&quot;/g,'1').replace(/&nbsp;/g,'').replace(/&mdash;/g,'-').replace(/&gt;/g,'>').replace(/&lt;/g,'<').replace(/&bull;/g,'');
            charLength=rtfString.length;
            if(charLength>0){
             $scope.objRtf[index].charCount=charLength;
             if(charLength>$scope.objRtf[index].maxCharLimit){
                  $scope.objRtf[index].errorStatus=true;
             }else{
                  $scope.objRtf[index].errorStatus=false;
            }
            }
            else{
                  $scope.objRtf[index].charCount=0;
                  $scope.objRtf[index].errorStatus=false;
            }
           }catch(e){}
       }

    $scope.getProposalDetails = function(){
        debugger;

        ApplicantPortal_Contoller.getProjectdetils($rootScope.userId, function(result, event){
            if(event.status){
                $scope.proposalDetails = result;
                if(result.Background_Concept_Purpose__c != undefined || result.Background_Concept_Purpose__c != ""){
                    result.Background_Concept_Purpose__c = result.Background_Concept_Purpose__c ? result.Background_Concept_Purpose__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Background_Concept_Purpose__c;
                }
                if(result.Specific_Need_For_the_Bilateral_Event__c != undefined || result.Specific_Need_For_the_Bilateral_Event__c != ""){
                    result.Specific_Need_For_the_Bilateral_Event__c = result.Specific_Need_For_the_Bilateral_Event__c ? result.Specific_Need_For_the_Bilateral_Event__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Specific_Need_For_the_Bilateral_Event__c;
                }
                $scope.$apply();
                
                if(result.Specific_Need_For_the_Bilateral_Event__c != undefined || result.Specific_Need_For_the_Bilateral_Event__c != ""){
                    result.Specific_Need_For_the_Bilateral_Event__c = result.Specific_Need_For_the_Bilateral_Event__c ? result.Specific_Need_For_the_Bilateral_Event__c.replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Specific_Need_For_the_Bilateral_Event__c;
                }
            }
        },
        {escape: true}
        )
    }

    $scope.getProposalDetails();

    $scope.saveProposalDetails = function(){
        debugger;
        if($scope.proposalDetails.Background_Concept_Purpose__c == undefined || $scope.proposalDetails.Background_Concept_Purpose__c == ""){
            swal("Proposal Details", "Please Enter Background Concept Purpose of Proposal.");
              return;
        }
        if($scope.proposalDetails.Specific_Need_For_the_Bilateral_Event__c == undefined || $scope.proposalDetails.Specific_Need_For_the_Bilateral_Event__c == ""){
            swal("Proposal Details", "Please Enter Specific Need For the Bilateral Event of Proposal.");
              return;
        }
        ApplicantPortal_Contoller.insertProjectDetails($scope.proposalDetails, function(result, event){
            if(event.status){
                debugger;
                Swal.fire(
                    'Success',
                    'Your Proposal detail has been saved successfully.',
                    'success'
                );
                $scope.redirectPageURL('Participants');
                $scope.proposalDetails = result;
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
})