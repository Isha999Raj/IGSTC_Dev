angular.module('cp_app').controller('ProjectDetailsSing_Ctrl', function($scope,$rootScope) {
    $scope.objContact={};
    $scope.objProposal={};
    $scope.objKeyword=[];
    $scope.config.height=400;
    $scope.objKeyword.push({keyword:""});
    $scope.objRtf=[{charCount:0,maxCharLimit:2500,errorStatus:false}];
    $scope.objRtf.push({charCount:1,maxCharLimit:1000,errorStatus:false});
    $scope.getProposalDet=function(){
        IndustrialFellowshipController.getProposalDet($rootScope.userId, function (result, event) {
          debugger
                console.log(result);
                console.log(event);
                $scope.objContact=result;
                if(result.Proposals__r!=undefined && result.Proposals__r!=''){
                    $scope.objProposal=result.Proposals__r;
                } 
                if($scope.objProposal.KeyWords__c!=undefined && $scope.objProposal.KeyWords__c!=''){
                  var keyword=$scope.objProposal.KeyWords__c.split(';');
                  $scope.objKeyword.splice(0,1);
                  for(var k=0;k<keyword.length;k++){
                    $scope.objKeyword.push({"keyword":keyword[k]});
                  }
                }  
                if(result.Proposals__r.Summary__c != undefined || result.Proposals__r.Summary__c != ''){
                  $scope.objContact.Proposals__r.Summary__c = $scope.objContact.Proposals__r.Summary__c ? $scope.objContact.Proposals__r.Summary__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('&gt;','>').replaceAll('&amp;','&') : $scope.objContact.Proposals__r.Summary__c;  
                  // $scope.objContact.Proposals__r.Summary__c = $scope.objContact.Proposals__r.Summary__c ? $scope.objContact.Proposals__r.Summary__c.replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : $scope.objContact.Proposals__r.Summary__c; 
                }
                if(result.Proposals__r.Research_Approach_Objectives__c != undefined || result.Proposals__r.Research_Approach_Objectives__c != ''){
                  $scope.objContact.Proposals__r.Research_Approach_Objectives__c = $scope.objContact.Proposals__r.Research_Approach_Objectives__c ? $scope.objContact.Proposals__r.Research_Approach_Objectives__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('&gt;','>').replaceAll('&amp;','&') : $scope.objContact.Proposals__r.Research_Approach_Objectives__c;  
                }
                
                $scope.$apply(); 
        });
    }
    $scope.addKeyword=function(){
      debugger
      if($scope.objKeyword.length<=4){
          $scope.objKeyword.push({keyword:""});
          $scope.$apply();
      }
    }
    $scope.removeKeyword=function(index){
      if($scope.objKeyword.length>1){
      $scope.objKeyword.splice(index, 1);
      }  
    }
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
  
    $scope.removeClass=function(){
      $("input[name=txtInputs]").removeClass('border-theme');
    }
    $scope.saveProjectDetailsSing=function(){
      if($rootScope.proposalStage){
        $scope.redirectPageURL('AttachmentsSing');
        return;
      }
      $scope.objProposal.Campaign__c = $rootScope.tagCampaignId;
      if($scope.objProposal.Brief_Statement_of_Purpose__c==undefined || $scope.objProposal.Brief_Statement_of_Purpose__c=='' || $scope.objProposal.Brief_Statement_of_Purpose__c==' '){
        swal('info','Please enter brief description of the organization.','info');
        $("#txtBStatement").addClass('border-theme');
        return;
      }
      if($scope.objProposal.Title_Of__c==undefined || $scope.objProposal.Title_Of__c=='' || $scope.objProposal.Title_Of__c==' '){
        swal('info','Please enter title of the research.','info');
        $("#txtTitle").addClass('border-theme');
        return;
      }
      if($scope.objProposal.Proposed_area__c==undefined || $scope.objProposal.Proposed_area__c=='' || $scope.objProposal.Proposed_area__c==' '){
        swal('info','Please enter broad area of research.','info');
        $("#txtBrdAreaResearch").addClass('border-theme');
        return;
      }
      if($scope.objProposal.Abstract_of_proposed__c==undefined || $scope.objProposal.Abstract_of_proposed__c=='' || $scope.objProposal.Abstract_of_proposed__c==' '){
        swal('info','Please enter abstract of proposed work.','info');
        $("#txtProposedWork").addClass('border-theme');
        return;
      }
      if($scope.objProposal.Research_Approach_Objectives__c==undefined || $scope.objProposal.Research_Approach_Objectives__c=='' || $scope.objProposal.Research_Approach_Objectives__c==' '){
        swal('info','Please enter enhance Indo-German Colloboration.','info');
        $("#txtIndoGerman").addClass('border-theme');
        return;
      }
      if($scope.objProposal.Purpose_for_applying__c==undefined || $scope.objProposal.Purpose_for_applying__c=='' || $scope.objProposal.Purpose_for_applying__c==' '){
        swal('info','Please select purpose for applying to SING.','info');
        return;
      }
      if($scope.objRtf[0].charCount > $scope.objRtf[0].maxCharLimit){
        swal('info','Max characters limit for Project Description is '+$scope.objRtf[0].maxCharLimit+' only','info');
        return;
      }
        delete $scope.objContact.Proposals__r;
        debugger
        var keyword="";
        for(var i=0;i<$scope.objKeyword.length;i++){
          if(i==0)
          keyword=$scope.objKeyword[i].keyword;
          else
          keyword=keyword+';'+$scope.objKeyword[i].keyword;
        }
        $scope.objProposal.KeyWords__c=keyword;
        if($scope.objProposal.KeyWords__c==undefined || $scope.objProposal.KeyWords__c=='' || $scope.objProposal.KeyWords__c==' '){
          swal('info','Please enter altleast one keyword.','info');
          $("#txtKeyword0").addClass('border-theme');
          return;
        }
        if(!$rootScope.proposalStage){
          $scope.objProposal.Proposal_Stages__c = 'Draft';    
        }
        else
        {
            $scope.objProposal.Proposal_Stages__c = 'Submitted';
        }
        if(!$rootScope.secondstage){
            $scope.objProposal.Stage__c = '1st Stage';    
        }
        else
        {
            $scope.objProposal.Stage__c = '2nd Stage';
        }
        $scope.objProposal.Campaign__c = $rootScope.campaignId;
        IndustrialFellowshipController.saveProjectDetailsSing($rootScope.userId,$scope.objContact,$scope.objProposal,$rootScope.accountId,'SING', function (result, event) {
          debugger     
          console.log(result);
                console.log(event);
                if (event.status) {
                  $rootScope.projectId=result;
                    swal({
                      title: "Project Details",
                      text: "Details of the Proposed work have been saved successfully.",
                      icon: "success",
                      button: "ok!",
                    }).then((value) => {
                      $scope.redirectPageURL('AttachmentsSing');
                        });
                  }
                  else
                  {
                    swal({
                      title: "Basic Details",
                      text: "Exception!",
                      icon: "error",
                      button: "ok!",
                    });
                  }
        });  
    }
    $scope.redirectPageURL=function(URL){
      var link=document.createElement("a");
      link.id = 'someLink'; //give it an ID!
      link.href='#/'+URL+'';
      link.click();
    }
    $scope.getProposalDet();
});