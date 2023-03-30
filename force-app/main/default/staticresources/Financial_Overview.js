angular.module('cp_app').controller('financialCtrl', function ($scope, $rootScope) {
    debugger;
    $scope.siteURL = siteURL;
    $rootScope.secondstage;
    //$rootScope.financialConDetails = financialConDetails;
    $scope.financialDetails = {};
    $scope.disable = false;
    $scope.disabled = true;
    $scope.input=[];
    $scope.financialOverViewList = [];
    var statusLoginHas=0;
    $scope.finance = [];
    $scope.indianIndus;
    $scope.indianAcademia;
    $scope.germanIndus;
    $scope.germanAcademia;
    $rootScope.isPrimaryContact;
    $scope.hodeTableAskedFunding=false;
    if($rootScope.isPrimaryContact=="true"){
        $scope.hodeTableAskedFunding=true;  
    }

    $scope.getApplicantDeetails = function () {
        ApplicantPortal_Contoller.getProjectDetailsDetails($rootScope.userId, function (result, event) {
            if (event.status) {
                debugger;
                console.log(result);
                for(var i=0;i<result.length;i++){
                    if(result[i].Financial_Contribution__r!=undefined){
                        if(result[i].Financial_Contribution__r[0].Total__c=='NaN' || result[i].Financial_Contribution__r[0].Total__c=='' || result[i].Financial_Contribution__r[0].Total__c==undefined){
                            result[i].Financial_Contribution__r[0].Total__c=0;
                        }
                        if(result[i].Financial_Contribution__r[0].Own_Contribution__c=='NaN' || result[i].Financial_Contribution__r[0].Own_Contribution__c=='' || result[i].Financial_Contribution__r[0].Own_Contribution__c==undefined){
                            result[i].Financial_Contribution__r[0].Own_Contribution__c=0;
                        }
                        if(result[i].Financial_Contribution__r[0].IGSTC_Contribution__c=='NaN' || result[i].Financial_Contribution__r[0].IGSTC_Contribution__c=='' || result[i].Financial_Contribution__r[0].IGSTC_Contribution__c==undefined){
                            result[i].Financial_Contribution__r[0].IGSTC_Contribution__c=0;
                        }
                    }
                    else
                    {
                        result[i].Financial_Contribution__r=[];
                        result[i].Financial_Contribution__r.push({Account__c:result[i].Id,Total__c:0,Own_Contribution__c:0,IGSTC_Contribution__c:0,Asked_From_IGSTC__c:0});
                    }
                }
                $scope.applicantDetails = result;
                if($rootScope.isPrimaryContact=="true"){
                    $scope.input=result;
                }
                for (var i = 0; i < $scope.applicantDetails.length; i++) {
                    if($rootScope.isPrimaryContact=="false"){
                        statusLoginHas=0;
                    
                    if ($scope.applicantDetails[i].Contacts != undefined){
                    for (j = 0; j < $scope.applicantDetails[i].Contacts.length; j++) {
                        if ($scope.applicantDetails[i].Contacts[j].Login_Hash_Code__c == $rootScope.userId) {
                            $scope.input.push($scope.applicantDetails[i]);
                            statusLoginHas=1;
                        }
                                            }
                    }
                    if(statusLoginHas==0){
                        $scope.financialOverViewList.push($scope.applicantDetails[i]);
                    }
                }
            console.log("financial contribution");
            console.log($scope.input);
            if($scope.applicantDetails[i].Financial_Contribution__r != undefined){
                for(var j=0;j<$scope.applicantDetails[i].Financial_Contribution__r.length;j++){
            if($scope.applicantDetails[i].BillingCountry == "India" && $scope.applicantDetails[i].Industry__c == true){
                $scope.indianIndus = $scope.applicantDetails[i].Financial_Contribution__r[j].IGSTC_Contribution__c ;
            }else if($scope.applicantDetails[i].BillingCountry == "India" && $scope.applicantDetails[i].Academia__c == true){
                $scope.indianAcademia = $scope.applicantDetails[i].Financial_Contribution__r[j].IGSTC_Contribution__c ;
            }else if($scope.applicantDetails[i].BillingCountry == "Germany" && $scope.applicantDetails[i].Industry__c == true){
                $scope.germanIndus = $scope.applicantDetails[i].Financial_Contribution__r[j].IGSTC_Contribution__c ;
            }else{
                $scope.germanAcademia = $scope.applicantDetails[i].Financial_Contribution__r[j].IGSTC_Contribution__c ;
            }

            $scope.TotalIndianContribution = Number($scope.indianIndus) + Number($scope.indianAcademia);
            $scope.TotalGermanContribution = Number($scope.germanIndus) + Number($scope.germanAcademia);
        }
    }
                //     if($scope.applicantDetails[i].Financial_Contribution__r != undefined){
                //         for(var j=0;j<$scope.applicantDetails[i].Financial_Contribution__r.length;j++){
                //         if($scope.applicantDetails[i].Financial_Contribution__r[j].Country__c == 'India' && $scope.applicantDetails[i].Financial_Contribution__r[j].Account_Type__c == 'Industry'){
                //             $scope.indianIndus = $scope.applicantDetails[i].Financial_Contribution__r[j].IGSTC_Contribution__c ;
                //         }
                //         if($scope.applicantDetails[i].Financial_Contribution__r[j].Country__c == 'India' && $scope.applicantDetails[i].Financial_Contribution__r[j].Account_Type__c == 'Academia'){
                //             $scope.indianAcademia = $scope.applicantDetails[i].Financial_Contribution__r[j].IGSTC_Contribution__c ;
                //         }
                //         if($scope.applicantDetails[i].Financial_Contribution__r[j].Country__c == 'Germany' && $scope.applicantDetails[i].Financial_Contribution__r[j].Account_Type__c == 'Industry'){
                //             $scope.germanIndus = $scope.applicantDetails[i].Financial_Contribution__r[j].IGSTC_Contribution__c ;
                //         }
                //         if($scope.applicantDetails[i].Financial_Contribution__r[j].Country__c == 'Germany' && $scope.applicantDetails[i].Financial_Contribution__r[j].Account_Type__c == 'Academia'){
                //             $scope.germanAcademia = $scope.applicantDetails[i].Financial_Contribution__r[j].IGSTC_Contribution__c ;
                //         }
                //     }
                // }
                    }

                    for(let i=0;i<$scope.input.length;i++){
                        var financialOverview = { "Name": $scope.input[i].Name, "Account__c": $scope.input[i].Id, "Own_Contribution__c": " ", "IGSTC_Contribution__c": "" };
                        if ($scope.input[i].Financial_Contribution__r == undefined){
                            var financeDet = [{ "Name": $scope.input[i].Name, "Account__c": $scope.input[i].Id, "Own_Contribution__c": " ", "IGSTC_Contribution__c": "" }];
                            $scope.input[i].Financial_Contribution__r = financeDet;
                    }
                }
                    $scope.$apply();
                }
            },
            { escape: true }
        )
    }

    // $scope.totalAmount = 0;
    // $scope.changeHandler = function(){
    //     debugger;
    //     $scope.totalAmount = $scope.input[0].Financial_Contribution__r[0].IGSTC_Contribution__c+$scope.input[0].Financial_Contribution__r[0].Own_Contribution__c;
    //     console.log('$scope.input',$scope.input);
    //     console.log('InputBaski',$scope.totalAmount);
    // }
    $scope.getApplicantDeetails();
$scope.calculateOtherField=function(index){
    debugger;
    for(var i=0;i<$scope.applicantDetails.length;i++){
        if($scope.applicantDetails[i].Financial_Contribution__r != undefined){
            for(var j=0;j<$scope.applicantDetails[i].Financial_Contribution__r.length;j++){
        if($scope.applicantDetails[i].BillingCountry == "India" && $scope.applicantDetails[i].Industry__c == true){
            $scope.indianIndus = $scope.applicantDetails[i].Financial_Contribution__r[j].IGSTC_Contribution__c ;
        }else if($scope.applicantDetails[i].BillingCountry == "India" && $scope.applicantDetails[i].Academia__c == true){
            $scope.indianAcademia = $scope.applicantDetails[i].Financial_Contribution__r[j].IGSTC_Contribution__c ;
        }else if($scope.applicantDetails[i].BillingCountry == "Germany" && $scope.applicantDetails[i].Industry__c == true){
            $scope.germanIndus = $scope.applicantDetails[i].Financial_Contribution__r[j].IGSTC_Contribution__c ;
        }else{
            $scope.germanAcademia = $scope.applicantDetails[i].Financial_Contribution__r[j].IGSTC_Contribution__c ;
        }

        $scope.TotalIndianContribution = Number($scope.indianIndus) + Number($scope.indianAcademia);
        $scope.TotalGermanContribution = Number($scope.germanIndus) + Number($scope.germanAcademia);
    }
    }
    }
    $scope.validateFinacialDet(index);    
    $scope.input[index].Financial_Contribution__r[0].Total__c=Number($scope.input[index].Financial_Contribution__r[0].IGSTC_Contribution__c)+Number($scope.input[index].Financial_Contribution__r[0].Own_Contribution__c);
    $scope.input[index].Financial_Contribution__r[0].Asked_From_IGSTC__c=(Number($scope.input[index].Financial_Contribution__r[0].IGSTC_Contribution__c)/(Number($scope.input[index].Financial_Contribution__r[0].IGSTC_Contribution__c)+Number($scope.input[index].Financial_Contribution__r[0].Own_Contribution__c)))*100;
}
$scope.validateFinacialDet=function(index){
    var FisrtAccountCountry=$scope.input[index].BillingCountry;
    var FirstAccountAcademia=$scope.input[index].Academia__c;
    var FirstAccountIndustry=$scope.input[index].Industry__c;
    var FisrtAccountIGSTContri=$scope.input[index].Financial_Contribution__r[0].IGSTC_Contribution__c;
    var SecondAccountAcademia=[];
    var SecondAccountIndustry=[];
    var SecondAccountIGSTCContr=[];

    if($rootScope.isPrimaryContact=="true"){    
        for(var i=0;i<$scope.input.length;i++){
            if($scope.input[i].BillingCountry==FisrtAccountCountry && $scope.input[i].Id!=$scope.input[index].Id){
                SecondAccountAcademia.push($scope.input[i].Academia__c);
                SecondAccountIndustry.push($scope.input[i].Industry__c);
                SecondAccountIGSTCContr.push($scope.input[i].Financial_Contribution__r[0].IGSTC_Contribution__c);
            }
        } 
    }
    else
    {
        for(var i=0;i<$scope.applicantDetails.length;i++){
            if($scope.applicantDetails[i].BillingCountry==FisrtAccountCountry && $scope.applicantDetails[i].Id!=$scope.applicantDetails[index].Id){
                SecondAccountAcademia.push($scope.applicantDetails[i].Academia__c);
                SecondAccountIndustry.push($scope.applicantDetails[i].Industry__c);
                SecondAccountIGSTCContr.push($scope.applicantDetails[i].Financial_Contribution__r[0].IGSTC_Contribution__c);
            }
        }   
    }  
        var TotalContri=FisrtAccountIGSTContri;
            for(var i=0;i<SecondAccountIGSTCContr.length;i++){
                TotalContri=parseInt(TotalContri)+parseInt(SecondAccountIGSTCContr[i]);
            } 
        if(FisrtAccountCountry=='Germany' && TotalContri>450000){
                swal('info','For Germay partners max. limit for IGSTC funding is euro 450000/-','info');
                //$("#total"+i+"").addClass('border-theme');
                return false;
        }
        else
        {
            if(FirstAccountAcademia){  
                if(TotalContri>35000000){              
                    swal('info','For Indian partners max. limit for IGSTC funding is Rs. 35000000/-','info');
                    //$("#total"+i+"").addClass('border-theme');
                    return false;
                }
            }else
            {
                if(FisrtAccountIGSTContri>15000000){
                    swal('info','For Indian indusry max. limit for IGSTC funding is Rs. 15000000/-','info');
                    //$("#total"+i+"").addClass('border-theme');
                    return false;
                }
                if(TotalContri>35000000){
                    swal('info','For Indian partners max. limit for IGSTC funding is Rs. 35000000/-','info');
                    //$("#total"+i+"").addClass('border-theme');
                    return false;
                }
            }
        }
        return true;
}
    let indianIndustryContri;
    $scope.submitFinancialDetails = function () {
        debugger;
        var financialList = [];
        financialList = $scope.input;
        
        for (let i = 0; i < financialList.length; i++) {
            if(financialList[i].Financial_Contribution__r != undefined){
            for(let j=0;j<financialList[i].Financial_Contribution__r.length;j++){
            if (financialList[i].Financial_Contribution__r[j].Country__c == 'India' && financialList[i].Financial_Contribution__r[j].Account_Type__c == 'Industry') {
                indianIndustryContri = financialList[i].Financial_Contribution__r[j].IGSTC_Contribution__c;
            }
        }
        }
    }
        for (let i = 0; i < financialList.length; i++) {
            if($rootScope.accountId==financialList[i].Id){
            for(let j=0;j<financialList[i].Financial_Contribution__r.length;j++){                
                if(financialList[i].Financial_Contribution__r[j].Own_Contribution__c == undefined || financialList[i].Financial_Contribution__r[j].Own_Contribution__c == ""){
                    swal("Financial Details", "Please Enter Own Contribution.");
                    $("#own"+j+"").addClass('border-theme');
                    return;
                }
                if(financialList[i].Financial_Contribution__r[j].IGSTC_Contribution__c == undefined || financialList[i].Financial_Contribution__r[j].IGSTC_Contribution__c == ""){
                    swal("Financial Details", "Please Enter IGSTC Contribution.");
                    $("#igstc"+j+"").addClass('border-theme');
                    return;
                }
                if(financialList[i].Financial_Contribution__r[j].Own_Contribution__c < 0){
                    swal("Financial Details", "Own Contribution should not be less than 0.");
                    $("#own"+j+"").addClass('border-theme');
                    return;
                }
                if(financialList[i].Financial_Contribution__r[j].IGSTC_Contribution__c <= 0){
                    swal("Financial Details", "IGSTC Contribution should be greater than 0.");
                    $("#igstc"+j+"").addClass('border-theme');
                    return;
                }
                if (financialList[i].BillingCountry == 'India' && financialList[i].Academia__c == true && (financialList[i].Financial_Contribution__r[j].IGSTC_Contribution__c > 35000000 - indianIndustryContri || financialList[i].Financial_Contribution__r[j].IGSTC_Contribution__c > 35000000)) {
                    swal("Financial Details", "For Indian Academia, IGSTC Contribution should be not greater than 3.5cr - Indian Industry IGSTC contribution.");
                    $("#igstc"+j+"").addClass('border-theme');
                    return;
                }
                if (financialList[i].BillingCountry == 'India' && financialList[i].Academia__c == true && financialList[i].Financial_Contribution__r[j].IGSTC_Contribution__c > 35000000) {
                    swal("Financial Details", "IGSTC Contribution should be not greater than 3.5cr.");
                    $("#igstc"+j+"").addClass('border-theme');
                    return;
                }
                if (financialList[i].BillingCountry == 'India' && financialList[i].Industry__c == true && financialList[i].Financial_Contribution__r[j].IGSTC_Contribution__c > 15000000) {
                    swal("Financial Details", "For Indian Industry, IGSTC Contribution should not be greater than 1.5cr.");
                    $("#igstc"+j+"").addClass('border-theme');
                    return;
                }
                if (financialList[i].BillingCountry == 'Germany' && financialList[i].Industry__c == true && financialList[i].Financial_Contribution__r[j].IGSTC_Contribution__c > 450000) {
                    swal("Financial Details", "For Germany Academia, IGSTC Contribution should be not greater than 4,50,000 €.");
                    $("#igstc"+j+"").addClass('border-theme');
                    return;
                }
                if (financialList[i].BillingCountry == 'Germany' && financialList[i].Academia__c == true && financialList[i].Financial_Contribution__r[j].IGSTC_Contribution__c > 450000) {
                    swal("Financial Details", "For Germany Industry, IGSTC Contribution should be not greater than 4,50,000 €.");
                    $("#igstc"+j+"").addClass('border-theme');
                    return;
                }
                // validation
                var firstAccountId=financialList[i].Id;
                for(var n=0;n<2;n++){
                var FisrtAccountCountry;
                var FirstAccountAcademia;
                var FisrtAccountIGSTContri;
                
                if(n==0){
                    FisrtAccountCountry=financialList[i].BillingCountry;
                    FirstAccountAcademia=financialList[i].Academia__c;
                    FisrtAccountIGSTContri=financialList[i].Financial_Contribution__r[0].IGSTC_Contribution__c;
                }
                else
                {
                    for(var o=0;o<$scope.applicantDetails.length;o++){
                        if(FisrtAccountCountry!=$scope.applicantDetails[o].BillingCountry){
                            FisrtAccountCountry=$scope.applicantDetails[o].BillingCountry;
                            FirstAccountAcademia=$scope.applicantDetails[o].Academia__c;
                            FisrtAccountIGSTContri=$scope.applicantDetails[o].Financial_Contribution__r[0].IGSTC_Contribution__c;
                            firstAccountId=$scope.applicantDetails[o].Id;
                            break;
                        }
                    }
                }

                var SecondAccountAcademia=[];
                var SecondAccountIndustry=[];
                var SecondAccountIGSTCContr=[];

                if($rootScope.isPrimaryContact=="true"){    
                    for(var k=0;k<financialList.length;k++){
                        if(financialList[k].BillingCountry==FisrtAccountCountry && financialList[k].Id!=firstAccountId){
                            SecondAccountAcademia.push(financialList[k].Academia__c);
                            SecondAccountIndustry.push(financialList[k].Industry__c);
                            SecondAccountIGSTCContr.push(financialList[k].Financial_Contribution__r[0].IGSTC_Contribution__c);
                        }
                    } 
                }
                else
                {
                    for(var l=0;l<$scope.applicantDetails.length;l++){
                        if($scope.applicantDetails[l].BillingCountry==FisrtAccountCountry && $scope.applicantDetails[l].Id!=firstAccountId){
                            SecondAccountAcademia.push($scope.applicantDetails[l].Academia__c);
                            SecondAccountIndustry.push($scope.applicantDetails[l].Industry__c);
                            SecondAccountIGSTCContr.push($scope.applicantDetails[l].Financial_Contribution__r[0].IGSTC_Contribution__c);
                        }
                    }   
                }  
                    var TotalContri=FisrtAccountIGSTContri;
                        for(var m=0;m<SecondAccountIGSTCContr.length;m++){
                            TotalContri = parseInt(TotalContri)+parseInt(SecondAccountIGSTCContr[m]);
                            // TotalContri=TotalContri+SecondAccountIGSTCContr[m];
                        } 
                    if(FisrtAccountCountry=='Germany' && TotalContri>450000){
                            swal('info','For Germay partners max. limit for IGSTC funding is euro 450000/-','info');
                            return;
                    }
                    else
                    {
                        if(FirstAccountAcademia){  
                            if(TotalContri>35000000){              
                                swal('info','For Indian partners max. limit for IGSTC funding is Rs. 35000000/-','info');
                                return;
                            }
                        }else
                        {
                            if(FisrtAccountIGSTContri>15000000){
                                swal('info','For Indian indusry max. limit for IGSTC funding is Rs. 15000000/-','info');
                                return false;
                            }
                            if(TotalContri>35000000){
                                swal('info','For Indian partners max. limit for IGSTC funding is Rs. 35000000/-','info');
                                return;
                            }
                        }
                    }
                }
                // end validating
            }
        }
    }
    // var retResult=$scope.validateFinacialDet(0);
    // if(!retResult){
    //     return;
    // }
    debugger
        for (let i = 0; i < financialList.length; i++) {
            delete (financialList[i]['Name']);
            delete (financialList[i]['$$hashKey']);
            delete (financialList[i].Contacts);
            if(financialList[i].Financial_Contribution__r != undefined && financialList[i].Financial_Contribution__r.length > 0){
            for(let j=0;j<financialList[i].Financial_Contribution__r.length;j++){
                $scope.finance.push(financialList[i].Financial_Contribution__r[j]);
            }
        }
        }

        // for(var i=0;i<$scope.finance.length;i++){
        //     if($scope.finance[i].Own_Contribution__c == undefined || $scope.finance[i].Own_Contribution__c == ""){
        //         swal("Financial Details", "Please Enter your Own Contribution");
        //     }
        //     if($scope.finance[i].IGSTC_Contribution__c == undefined || $scope.finance[i].IGSTC_Contribution__c == ""){
        //         swal("Financial Details", "Please Enter IGSTC Contribution");
        //     }
        //     if($scope.finance[i].IGSTC_Contribution__c <= 0){
        //         swal("Financial Details", "Own Contribution should be greate than 0");
        //     }
        //     if($scope.finance[i].IGSTC_Contribution__c <= 0){
        //         swal("Financial Details", "IGSTC Contribution should be greate than 0");
        //     }
        // }

        ApplicantPortal_Contoller.insertFinancialDetails($scope.finance, function (result, event) {
            if (event.status) {
                debugger;
                Swal.fire(
                    'Financial Detail',
                    'Your Financial detail has been saved successfully.',
                    'success'
                );
                $scope.redirectPageURL('ProjectDetail');
                $scope.finance = result;
                $scope.$apply();
            }
        },
            { escape: true }
        )
    }

    $scope.redirectPageURL = function (pageName) {
        debugger;
        var link = document.createElement("a");
        link.id = 'someLink'; //give it an ID!
        link.href = "#/" + pageName;
        link.click();
    }

    $scope.removeClass=function(controlid,index){
        debugger;
        var controlIdfor=controlid+""+index;
        $("#"+controlIdfor+"").removeClass('border-theme');
      }
});