angular.module('cp_app').controller('AchievementsIF_Ctrl', function($scope,$rootScope) {
    $scope.siteURL = siteURL;  
    $scope.achievementDetails = {};
    $scope.objRtf=[{charCount:0,maxCharLimit:400,errorStatus:false}];
    $scope.objRtf.push({charCount:0,maxCharLimit:500,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:2000,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:400,errorStatus:false});
    $scope.objRtf.push({charCount:0,maxCharLimit:400,errorStatus:false});
    $scope.getAchievements = function(){
        debugger;
        ApplicantPortal_Contoller.getAchievements($rootScope.userId, function(result,event){
            debugger;
            if(event.status && result){
                $scope.achievementDetails = result;
                debugger;
                if(result.Awards_Honours__c != undefined || result.Awards_Honours__c != ""){
                    result.Awards_Honours__c = result.Awards_Honours__c ? result.Awards_Honours__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Awards_Honours__c;
                }
                if(result.List_of_Publications__c != undefined || result.List_of_Publications__c != ""){
                    result.List_of_Publications__c = result.List_of_Publications__c ? result.List_of_Publications__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.List_of_Publications__c;
                }
                if(result.List_of_Patents_filed__c != undefined || result.List_of_Patents_filed__c != ""){
                    result.List_of_Patents_filed__c = result.List_of_Patents_filed__c ? result.List_of_Patents_filed__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.List_of_Patents_filed__c;
                }
                if(result.Book_Chapters__c != undefined || result.Book_Chapters__c != ""){
                    result.Book_Chapters__c = result.Book_Chapters__c ? result.Book_Chapters__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Book_Chapters__c;
                }
                if(result.Any_other_achievements__c != undefined || result.Any_other_achievements__c != ""){
                    result.Any_other_achievements__c = result.Any_other_achievements__c ? result.Any_other_achievements__c.replace(/&amp;/g,'&').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : result.Any_other_achievements__c;
                }
                $scope.$apply();
            }
        },
                                                  {escape: true}
                                                 )
    }
    $scope.getAchievements();
    $scope.readCharacter=function(event,index){
        debugger
           try{
           var rtfString=event.toString().replace(/<[^>]*>|\s/g, '').replace(/\s+/g,'').replace(/&ndash;/g,'-').replace(/&euro;/g,'1').replace(/&amp;/g,'1').replace(/&#39;/g,'1').replace(/&quot;/g,'1').replace(/&nbsp;/g,'').replace(/&mdash;/g,'-').replace(/&gt;/g,'>').replace(/&lt;/g,'<').replace(/&bull;/g,'');
            charLength=rtfString.length;
            if(charLength>0){
             $scope.objRtf[index].charCount=charLength;
            }
            else{
                  $scope.objRtf[index].charCount=0;
            }
           }catch(e){}
       }
    $scope.redirectPageURL=function(URL){
        var link=document.createElement("a");
        link.id = 'someLink'; //give it an ID!
        link.href='#/'+URL+'';
        link.click();
      }
      $scope.saveDetails = function(){
        debugger;
        $scope.achievementDetails.Contact__c = $rootScope.contactId;
        // $scope.achievementDetailss = {"Awards_Honours__c":$scope.achievementDetails.Awards_Honours__c,"List_of_Publications__c":$scope.achievementDetails.List_of_Publications__c,
        // "List_of_Patents_filed__c":$scope.achievementDetails.List_of_Patents_filed__c,"Any_other_achievements__c":$scope.achievementDetails.Any_other_achievements__c,"Contact__c":$rootScope.contactId};

        ApplicantPortal_Contoller.updateAchievements($scope.achievementDetails, function(result,event){
            if(event.status){
                debugger;
                Swal.fire(
                    'Success',
                    'Your achievement details have been saved successfully.',
                    'success'
                );
                $scope.redirectPageURL('AttachmentsIF');
                $scope.$apply();
            }
        },
       {escape: true}
        )
    }
    $scope.clickPreviousAchievements=function(){
        var link=document.createElement("a");
        link.id = 'someLink'; //give it an ID!
        link.href="#/ProjectDetailIF";
        link.click();
    }
});