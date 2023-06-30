var workingDaysValues = [];
var userId;
var contId;
var siteURL;
var candidateId;
var getAllEvents;
var eventsOnLoad;
var maxStringSize = 6000000;    //Maximum String size is 6,000,000 characters
var maxFileSize = 4350000;      //After Base64 Encoding, this is the max file size
var chunkSize = 950000;         //Maximum Javascript Remoting message size is 1,000,000 characters
var attachment;
var attachmentName;
var fileSize;
var positionIndex;
var doneUploading;
var blobData;
var gender;
var country;
var nationality;
var available_followship;
var associated_with_igstc;
// var nature_of_Job;
var applicantName;
var profilePicURL;
var isCoordinator;

//var contactId;
// debugger;
var app = angular.module('cp_app');
debugger;
var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard';    // ======================>
app.config(function ($routeProvider, $locationProvider) {    
    $locationProvider.html5Mode(false).hashPrefix('');
    var rp = $routeProvider;

    for (var i = 0; i < tabValues.length; i++) {
        var pageName = '/' + tabValues[i].Name;

        if (tabValues[i].Apex_class_Name__c != undefined) {
            rp.when(pageName, {

                templateUrl: sitePrefix + pageName,
                controller: tabValues[i].Apex_class_Name__c
            });
        } else {
            rp.when(pageName, {
                templateUrl: sitePrefix + pageName,
            })
        }

    }
});
app.filter('specialChar',function(){
    return function(input)
    {
        return input ? input.replace(/&amp;/g,'&').replace(/&#39;/g,'\'').replaceAll('&amp;amp;','&').replaceAll('&amp;gt;','>').replaceAll('&lt;','<').replaceAll('lt;','<').replaceAll('&gt;','>').replaceAll('gt;','>').replaceAll('&amp;','&').replaceAll('amp;','&').replaceAll('&quot;','\'') : input;
    }
});

function wysiwygeditor($scope) {
    $scope.orightml = '<h2>Try me!</h2><p>textAngular is a super cool WYSIWYG Text Editor directive for AngularJS</p><p><b>Features:</b></p><ol><li>Automatic Seamless Two-Way-Binding</li><li>Super Easy <b>Theming</b> Options</li><li style="color: green;">Simple Editor Instance Creation</li><li>Safely Parses Html for Custom Toolbar Icons</li><li class="text-danger">Doesn&apos;t Use an iFrame</li><li>Works with Firefox, Chrome, and IE8+</li></ol><p><b>Code at GitHub:</b> <a href="https://github.com/fraywing/textAngular">Here</a> </p>';
    $scope.htmlcontent = $scope.orightml;
    $scope.disabled = false;
};

app.controller('cp_dashboard_ctrl', function ($scope, $rootScope, $timeout, $window, $location, $element) {
    $scope.config = {}; 
    debugger
    $scope.programmeHeaderName="Industrial Fellowship";
    var siteURL2=window.location.href
    var sitecampaign=siteURL2.split('&campaign=')[1];
    sitecampaign=sitecampaign.split('#/')[0];
    $rootScope.CampainURL=sitecampaign;
    switch($rootScope.CampainURL.toUpperCase()){
        case 'IF':
            $scope.programmeHeaderName="Industrial Fellowships";
            break;
            case 'PECFAR':
                $scope.programmeHeaderName="PECFAR";
                break;
            case 'WORKSHOP':
                $scope.programmeHeaderName="Workshop";
                break;
            case '2PLUS2':
                $scope.programmeHeaderName="2+2 Call";
                break;
                case 'WISER':
                $scope.programmeHeaderName="WISER";
                break;
                case 'SING':
                $scope.programmeHeaderName="SING";
                break;
                case 'CONNECT':
                $scope.programmeHeaderName="CONNECT PLUS";
                break;
                default:
                    $scope.programmeHeaderName="Industrial Fellowships";
                    break;
    }

    $scope.config.toolbarGroups = [
    { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
    { name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
    { name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
    { name: 'forms', groups: [ 'forms' ] },
    { name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
    { name: 'links', groups: [ 'links' ] },
    { name: 'insert', groups: [ 'insert' ] },
    { name: 'styles', groups: [ 'styles' ] },
    { name: 'colors', groups: [ 'colors' ] },
    { name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
    { name: 'tools', groups: [ 'tools' ] },
    { name: 'others', groups: [ 'others' ] },
    { name: 'about', groups: [ 'about' ] }
];
$scope.configg = {
    options: "",
    trackBy: 'Id',
    displayBy: ['Name'],
    multiSelect: true,
    preSelectItem: true,
    preSelectAll: false
};
$scope.config.removeButtons = 'BGColor,Anchor,Subscript,Superscript,Paste,Copy,Cut,Undo,Redo';
 $rootScope.countrytype = countrytype;
 $rootScope.campaignId;
 $rootScope.countryCode = countryCode;
 $rootScope.availingFellowship = availingFellowship;    
 $rootScope.pairedApplicant = pairedApplicant;
 $rootScope.campaignData=campaignData;
 debugger
 $rootScope.participantType = participantType;
 $rootScope.bankType = bankType;
 $rootScope.participatingWorkshop = participatingWorkshop;
//  $rootScope.degree = degree;
 $rootScope.specialization = specialization;
 $rootScope.presentingWorkshop = presentingWorkshop;
 $rootScope.currencyType2 = currencyType2;
 $rootScope.userId = userId;
 $rootScope.contId = contId;
 $rootScope.candidateId = candidateId;
 $rootScope.campaigntype = campaigntype;
 $rootScope.siteURL = siteURL;
 $rootScope.profilePicURL = profilePicURL;
 $rootScope.thematicAreaList = thematicAreaList;  
 $rootScope.gender=gender;
 $rootScope.campaignEndDate;
 $rootScope.cutOffSD;
 $rootScope.cutOffED;
 $rootScope.cutOffSDW;
 $rootScope.cutOffEDW;
 
 
 $rootScope.currencyPickList=currencyPickList;
//  $rootScope.accList = accList;
 $rootScope.country=country;
 $rootScope.nationality=nationality;
 $rootScope.available_followship=available_followship;
 $rootScope.associated_with_igstc=associated_with_igstc;
 $rootScope.expanseHead = expanseHead;
 $rootScope.applicantName=applicantName;
 $rootScope.applicantEmail=applicantEmail;
 $rootScope.isPrimaryContact=isPrimaryContact;
 $rootScope.accountId=accountId;
 $rootScope.natureOfThesisWork=natureOfThesisWork;
 $rootScope.natureOfPhDWork=natureOfPhDWork;
 $rootScope.percentCGPA=percentCGPA;
 $rootScope.states=states;
 $rootScope.signDate=signDate;
 $rootScope.secondStage = false;
 if(secondstage == "1st Stage"){
    $rootScope.secondStage = false;
 }else{
    $rootScope.secondStage = true;
 }
 if(secondstage == '' || secondstage == undefined){
    $rootScope.secondStage = false;
 }


    $rootScope.userDetails;
    $rootScope.activeTab = 0;
    $rootScope.siteURL = siteURL;
    $rootScope.userHashId = userId;
    $rootScope.candidateId = candidateId;
    $rootScope.contactId = contactId;
    $rootScope.projectId = projectId;
    $rootScope.campaignName = campaignName;
    $rootScope.isCoordinator=isCoordinator;
    $rootScope.secondstage = false;
    $rootScope.emailVerified;
    $rootScope.proposalStage = false;
    if(secondstage == "2nd Stage"){
        $rootScope.secondstage = true;
    }else{
        $rootScope.secondstage = false;
    }

    if(proposalStage != "Draft"){
        $rootScope.proposalStage = true;
        CKEDITOR.config.readOnly = true;
    }else{
        $rootScope.proposalStage = false;
    }
 if(proposalStage==undefined || proposalStage==''){
    $rootScope.proposalStage = false;
    CKEDITOR.config.readOnly = false;
 }
 
//  CKEDITOR.replace( 'Resolution', {
//     height: 800
// } );
//  $scope.checkCampaign = function(){
//     debugger;
//     if($rootScope.campaigntype.toUpperCase() != $scope.programmeHeaderName){
//         swal(
//             '',
//             'incorrect',
//             'error'
//         );
//         if($rootScope.campaigntype == "pecfar"){
//             var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard?campaign=Landing_Page_Pecfar';
//             setTimeout(function() {window.location.replace(window.location.origin + sitePrefix )}, 5000);
//         }
//         if($rootScope.campaigntype == "wiser"){
//             var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard?campaign=LANDING_PAGE_WISER';
//             setTimeout(function() {window.location.replace(window.location.origin + sitePrefix )}, 5000);
//         }
//         if($rootScope.campaigntype == "if"){
//             var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard?campaign=Landing_Page_Industrial_Fellowship';
//             setTimeout(function() {window.location.replace(window.location.origin + sitePrefix )}, 5000);
//         }
//         if($rootScope.campaigntype == "sing"){
//             var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard?campaign=LANDING_PAGE_SING';
//             setTimeout(function() {window.location.replace(window.location.origin + sitePrefix )}, 5000);
//         }
//         if($rootScope.campaigntype == "workshop"){
//             var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard?campaign=Landing_Page_Workshop';
//             setTimeout(function() {window.location.replace(window.location.origin + sitePrefix )}, 5000);
//         }
//         if($rootScope.campaigntype == "2plus2"){
//             var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard?campaign=Landing_Page_Two_Plus_Two';
//             setTimeout(function() {window.location.replace(window.location.origin + sitePrefix )}, 5000);
//         }
//         return;
//     }else{
//     }
// }
// $scope.checkCampaign();

CKEDITOR.addCss( 'border:solid 1px red !important;' );
    $scope.redirect = function(){
        debugger;
        if($scope.res == "workshop"){
            var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard?campaign=Landing_Page_Workshop';
            setTimeout(function() {window.location.replace(window.location.origin + sitePrefix )}, 5000);
            
        }else if($scope.res == "pecfar"){
            var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard?campaign=Landing_Page_Pecfar';
            setTimeout(function() {window.location.replace(window.location.origin + sitePrefix )}, 5000);
            
        }else if($scope.res == "if"){
            var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard?campaign=Landing_Page_Industrial_Fellowship';
            setTimeout(function() {window.location.replace(window.location.origin + sitePrefix )}, 5000);

        }
        else if($scope.res == "sing"){
            var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard?campaign=LANDING_PAGE_SING';
            setTimeout(function() {window.location.replace(window.location.origin + sitePrefix )}, 5000);

        }
        else if($scope.res == "wiser"){
            var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard?campaign=LANDING_PAGE_WISER';
            setTimeout(function() {window.location.replace(window.location.origin + sitePrefix )}, 5000);

        }
        else if($scope.res == "2plus2"){
            var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard?campaign=Landing_Page_Two_Plus_Two';
            setTimeout(function() {window.location.replace(window.location.origin + sitePrefix )}, 5000);
        }
        else if($scope.res == "connect"){
            var sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/ApplicantDashboard?campaign=Landing_Page_CONNECT_PLUS';
            setTimeout(function() {window.location.replace(window.location.origin + sitePrefix )}, 5000);
        }
        
            var sitePrefix; 
            // switch($rootScope.CampainURL.toUpperCase()){
            //         case 'if':
            //             sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/?campaign=Landing_Page_Industrial_Fellowship';
            //             break;
            //         case 'pecfar':
            //             sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/?campaign=Landing_Page_Pecfar';
            //             break;
            //         case 'workshop':
            //             sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/?campaign=Landing_Page_Workshop';
            //             break;
            //         case '2plus2':
            //             sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/?campaign=Landing_Page_Two_Plus_Two';
            //             break;
            //         case 'wiser':
            //             sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/?campaign=LANDING_PAGE_WISER';
            //             break;
            //         case 'sing':
            //             sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/?campaign=LANDING_PAGE_SING';
            //             break;
            //             // default:
            //             //     sitePrefix = window.location.href.includes('/apex') ? '/apex' : '/?campaign=Landing_Page_Industrial_Fellowship';
            //             //     break;
            // }  
            // window.location.replace(window.location.origin +sitePrefix);
            
    }
    $scope.LogoutApplicant=function(){        
        ApplicantPortal_Contoller.LogoutApplicant($rootScope.candidateId, function (result, event) {
            debugger
            console.log(result);
            console.log(event);
            if(event.status){
                $rootScope.applicantEmail='';
                $rootScope.applicantName='';
                $scope.res=result;
                $scope.redirect();
                $scope.$apply();
            }
        });   
    }
    $scope.getCampaignTheme=function(){
        ApplicantPortal_Contoller.fetchCampaignsPrograms(function(result, event){
            debugger;
            if(event.status && result && result.length){
                debugger;
    console.log('campaign::=>');
    console.log(result);
                for(var i=0;i<result.length; i++) {
                    if(result[i].Name.toUpperCase()==$scope.programmeHeaderName.toUpperCase()){
                        $rootScope.campaignId=result[i].Id;
                        $rootScope.disabledCampaign=result[i].Disable_Campaign__c;
                        $rootScope.campaignEndDate=new Date(result[i].EndDate);
                        $rootScope.campaignEndDate=moment($rootScope.campaignEndDate).format('Do MMMM YYYY');
                        if(result[i].Name.toUpperCase() == "WISER" || result[i].Name.toUpperCase() == "WORKSHOP"){
                            $rootScope.cutOffSD=new Date(result[i].Cut_Off_Start_Date__c);
                            $rootScope.cutOffED=new Date(result[i].Cut_Off_End_Date__c);
                            $rootScope.cutOffSD=moment($rootScope.cutOffSD).format('Do MMMM YYYY');
                            $rootScope.cutOffED=moment($rootScope.cutOffED).format('Do MMMM YYYY');
                            
                        }
                    }
                };
                $scope.$apply();
            }
        },
         {escape: true}
       );
    }
    $scope.getCampaignTheme();
});  