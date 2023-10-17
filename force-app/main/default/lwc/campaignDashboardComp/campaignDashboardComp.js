import { LightningElement,wire,api,track } from 'lwc';

import getCampaignsRecords from '@salesforce/apex/campaignDashboardController.getAllCampaignsDetails';
import getselectedCampRecord from '@salesforce/apex/campaignDashboardController.getselectedCampDetails';

export default class CampaignDashboardComp extends LightningElement {
    @track listOfCampaigns = [];
    @track finalCampList = [];
    @track showDetailsIF = false;
    @track showDetailsPECFAR = false;
    @track showDetailsWISER = false;
    @track showDetailsSING = false;
    @track showDetailsConnect = false;
    @track showDetailsTPT = false;
    @track showDetailsWorkshop = false;
    @track campName;

    @track scApproved = 0;
    @track scRejected = 0;
    @track scWaitlisted = 0;
    @track scDeclined = 0;

    @track reviewCompleted = 0;
    @track underReview = 0;

    @track eligibilitycheck = 0;
    @track eligibilityFailed = 0;

    @track travelSent = 0;
    @track travelSubmitted = 0;
    @track travelApproved = 0
    @track travelRejected = 0;

    @track bankSent = 0;
    @track bankSubmitted = 0;
    @track bankApproved = 0;
    @track bankRejected = 0;

    @track decisionLeterSent = 0;
    @track decisionNotSent = 0;

    @track visaSent = 0;
    @track visaSubmitted = 0;
    @track visaApproved = 0;
    @track visaRejected = 0;

    @track undertakingSent = 0;
    @track undertakingSubmitted = 0;
    @track undertakingApproved = 0;
    @track undertakingRejected = 0;

    @track invitationSent = 0;
    @track invitationSubmitted = 0;
    @track invitationApproved = 0;
    @track invitationRejected = 0;

    @track indianInvoiceSent = 0;
    @track indianInvoiceSubmitted = 0;
    @track indianInvoiceApproved = 0;
    @track indianInvoiceRejected = 0;

    @track germanInvoiceSent = 0;
    @track germanInvoiceSubmitted = 0;
    @track germanInvoiceApproved = 0;
    @track germanInvoiceRejected = 0;

    @wire(getCampaignsRecords)
    wiredResponse(result){
        if(result.data){
            console.log('Campaign Records-------',result.data);
          
            this.listOfCampaigns = result.data;
            
            for (let i = 0; i < this.listOfCampaigns.length; i++){
                let singProposalDCount = 0;
                let singProposalSCount = 0;
                if(this.listOfCampaigns[i].Proposals__r  != undefined){
                    for(let j=0; j<this.listOfCampaigns[i].Proposals__r.length; j++){
                        if(this.listOfCampaigns[i].Proposals__r[j].Proposal_Stages__c == 'Draft'){
                            singProposalDCount = singProposalDCount+1;
                        }else if(this.listOfCampaigns[i].Proposals__r[j].Submitted__c == true){
                            singProposalSCount = singProposalSCount+1;
                        }else{
                            singProposalDCount = 0;
                            singProposalSCount = 0;
                        }
                    }
                }
                    this.finalCampList.push({
                        "Id":this.listOfCampaigns[i].Id,
                        "Name":this.listOfCampaigns[i].Name,
                        "StartDate":this.listOfCampaigns[i].StartDate,
                        "EndDate":this.listOfCampaigns[i].EndDate,
                        "DraftCount":singProposalDCount,
                        "SubmittedCount":singProposalSCount
                    });
            }
            
        }else{
            console.log("Error to fetch Campaigns Records :: ",result);
        }
    }

    handleClickSelectedCamp(event){
        debugger;
       this.campName = event.currentTarget.dataset.name;

       getselectedCampRecord({
        campName: this.campName
       }).then(result => {
        console.log('result-->', JSON.stringify(result));
        if(result.Proposals__r != undefined){
            for(let i = 0; i < result.Proposals__r.length; i++){
                if(result.Proposals__r[i].SC_Review_Stages__c == 'Sc Review Approved'){
                    this.scApproved = this.scApproved+1;
                }
                if(result.Proposals__r[i].SC_Review_Stages__c == 'SC Review Rejected'){
                    this.scRejected = this.scRejected+1;
                }
                if(result.Proposals__r[i].SC_Review_Stages__c == 'SC Review Waitlisted'){
                    this.scWaitlisted = this.scWaitlisted+1;
                }
                if(result.Proposals__r[i].SC_Review_Stages__c == 'SC Review Decline'){
                    this.scDeclined = this.scDeclined+1;
                }
                if(result.Proposals__r[i].Proposal_Stages__c == 'Under Review'){
                    this.underReview = this.underReview+1;
                }
                if(result.Proposals__r[i].Review_Completed__c == true){
                    this.reviewCompleted = this.reviewCompleted+1;
                }
                if(result.Proposals__r[i].Eligibility_Checked__c == true){
                    this.eligibilitycheck = this.eligibilitycheck+1;
                }
                if(result.Proposals__r[i].Eligibility_Checked__c == false){
                    this.eligibilityFailed = this.eligibilityFailed+1;
                }
                if(result.Proposals__r[i].Travel_Form_Status__c == 'Sent'){
                    this.travelSent = this.travelSent+1;
                }
                if(result.Proposals__r[i].Travel_Form_Status__c == 'Submitted'){
                    this.travelSubmitted = this.travelSubmitted+1;
                }
                if(result.Proposals__r[i].Travel_Form_Status__c == 'Approved'){
                    this.travelApproved = this.travelApproved+1;
                }
                if(result.Proposals__r[i].Travel_Form_Status__c == 'Rejected'){
                    this.travelRejected = this.travelRejected+1;
                }
                if(result.Proposals__r[i].Decision_Letter_Sent__c == true){
                    this.decisionLeterSent = this.decisionLeterSent+1;
                }
                if(result.Proposals__r[i].Decision_Letter_Sent__c == false){
                    this.decisionNotSent = this.decisionNotSent+1;
                }
                if(result.Proposals__r[i].Visa_Stages__c == 'Sent'){
                    this.visaSent = this.visaSent+1;
                }
                if(result.Proposals__r[i].Visa_Stages__c == 'Submitted'){
                    this.visaSubmitted = this.visaSubmitted+1;
                }
                if(result.Proposals__r[i].Visa_Stages__c == 'Approved'){
                    this.visaApproved = this.visaApproved+1;
                }
                if(result.Proposals__r[i].Visa_Stages__c == 'Rejected'){
                    this.visaRejected = this.visaRejected+1;
                }
                if(result.Proposals__r[i].Undertaking_Status__c == 'Sent'){
                    this.undertakingSent = this.undertakingSent+1;
                }
                if(result.Proposals__r[i].Undertaking_Status__c == 'Submitted'){
                    this.undertakingSubmitted = this.undertakingSubmitted+1;
                }
                if(result.Proposals__r[i].Undertaking_Status__c == 'Approved'){
                    this.undertakingApproved = this.undertakingApproved+1;
                }
                if(result.Proposals__r[i].Undertaking_Status__c == 'Rejected'){
                    this.undertakingRejected = this.undertakingRejected+1;
                }
                if(result.Proposals__r[i].Bank_Status__c == 'Sent'){
                    this.bankSent = this.bankSent+1;
                }
                if(result.Proposals__r[i].Bank_Status__c == 'Submitted'){
                    this.bankSubmitted = this.bankSubmitted+1;
                }
                if(result.Proposals__r[i].Bank_Status__c == 'Approved'){
                    this.bankApproved = this.bankApproved+1;
                }
                if(result.Proposals__r[i].Bank_Status__c == 'Rejected'){
                    this.bankRejected = this.bankRejected+1;
                }
                if(result.Proposals__r[i].Invitation_Letter_Form_Status__c == 'Sent'){
                    this.invitationSent = this.invitationSent+1;
                }
                if(result.Proposals__r[i].Invitation_Letter_Form_Status__c == 'Submitted'){
                    this.invitationSubmitted = this.invitationSubmitted+1;
                }
                if(result.Proposals__r[i].Invitation_Letter_Form_Status__c == 'Approved'){
                    this.invitationApproved = this.invitationApproved+1;
                }
                if(result.Proposals__r[i].Invitation_Letter_Form_Status__c == 'Rejected'){
                    this.invitationRejected = this.invitationRejected+1;
                }
                if(result.Proposals__r[i].Indian_Invoice_Status__c == 'Sent'){
                    this.indianInvoiceSent = this.indianInvoiceSent+1;
                }
                if(result.Proposals__r[i].Indian_Invoice_Status__c == 'Submitted'){
                    this.indianInvoiceSubmitted = this.indianInvoiceSubmitted+1;
                }
                if(result.Proposals__r[i].Indian_Invoice_Status__c == 'Approved'){
                    this.indianInvoiceApproved = this.indianInvoiceApproved+1;
                }
                if(result.Proposals__r[i].Indian_Invoice_Status__c == 'Rejected'){
                    this.indianInvoiceRejected = this.indianInvoiceRejected+1;
                }
                if(result.Proposals__r[i].German_Invoice_Status__c == 'Sent'){
                    this.germanInvoiceSent = this.germanInvoiceSent+1;
                }
                if(result.Proposals__r[i].German_Invoice_Status__c == 'Submitted'){
                    this.germanInvoiceSubmitted = this.germanInvoiceSubmitted+1;
                }
                if(result.Proposals__r[i].German_Invoice_Status__c == 'Approved'){
                    this.germanInvoiceApproved = this.germanInvoiceApproved+1;
                }
                if(result.Proposals__r[i].German_Invoice_Status__c == 'Rejected'){
                    this.germanInvoiceRejected = this.germanInvoiceRejected+1;
                }
                
            }
        }
        if(this.campName == 'Industrial Fellowships'){
            this.showDetailsIF = true;
            this.showDetailsConnect = false;
            this.showDetailsPECFAR = false;
            this.showDetailsSING = false;
            this.showDetailsTPT = false;
            this.showDetailsWorkshop = false;
            this.showDetailsWISER = false;
        }else if(this.campName == 'SING'){
            this.showDetailsIF = false;
            this.showDetailsConnect = false;
            this.showDetailsPECFAR = false;
            this.showDetailsSING = true;
            this.showDetailsTPT = false;
            this.showDetailsWorkshop = false;
            this.showDetailsWISER = false;
        }else if(this.campName == 'WISER'){
            this.showDetailsIF = false;
            this.showDetailsConnect = false;
            this.showDetailsPECFAR = false;
            this.showDetailsSING = false;
            this.showDetailsTPT = false;
            this.showDetailsWorkshop = false;
            this.showDetailsWISER = true;
        }else if(this.campName == '2+2 Call'){
            this.showDetailsIF = false;
            this.showDetailsConnect = false;
            this.showDetailsPECFAR = false;
            this.showDetailsSING = false;
            this.showDetailsTPT = true;
            this.showDetailsWorkshop = false;
            this.showDetailsWISER = false;
        }else if(this.campName == 'PECFAR'){
            this.showDetailsIF = false;
            this.showDetailsConnect = false;
            this.showDetailsPECFAR = true;
            this.showDetailsSING = false;
            this.showDetailsTPT = false;
            this.showDetailsWorkshop = false;
            this.showDetailsWISER = false;
        }else if(this.campName == 'Workshop'){
            this.showDetailsIF = false;
            this.showDetailsConnect = false;
            this.showDetailsPECFAR = false;
            this.showDetailsSING = false;
            this.showDetailsTPT = false;
            this.showDetailsWorkshop = true;
            this.showDetailsWISER = false;
        }else if(this.campName == 'Connect Plus'){
            this.showDetailsIF = false;
            this.showDetailsConnect = true;
            this.showDetailsPECFAR = false;
            this.showDetailsSING = false;
            this.showDetailsTPT = false;
            this.showDetailsWorkshop = false;
            this.showDetailsWISER = false;
        }
    })
    }
}