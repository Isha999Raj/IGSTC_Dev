public withOut sharing class ApplicantPortal_Contoller {
    public string tabValues  {get;set;}
    public string thematicAreaList {get;set;}
    public string countrytype  {get;set;}
    public string countryCode  {get;set;}
    public string availingFellowship  {get;set;}
    public string pairedApplicant  {get;set;}
    public string participantType {get;set;}
    public string bankType {get;set;}
    public string participatingWorkshop {get;set;}
    // public string degree  {get;set;}
    public string specialization  {get;set;}
    public string presentingWorkshop  {get;set;}
    public string stage  {get;set;}
    public String ApplicantPortalSiteURL {get;set;}
    public string secondstage  {get;set;}
    public string emailVerified  {get;set;}
    public string proposalStage  {get;set;}
    public String candidateId {get;set;}
    public string campaigntype {get;set;}
    public String projectId {get;set;}
    public String campaignName {get;set;}
    public string contactId {get;set;}
    public string financialConDetails {get;set;}
    public string gender {get;set;}
    public string nationality {get;set;}
    public string country {get;set;}
    public string available_followship {get;set;}
    public string associated_with_igstc {get;set;}
    // public String nature_of_Job{get;set;}
    public String expanseHead {get;set;}
    public String applicantName {get;set;}
    public String applicantEmail {get;set;}
    public boolean isPrimaryContact {get;set;}
    public string accountId {get;set;}
    public string natureOfThesisWork {get;set;}
    public string natureOfPhDWork {get;set;}
    public string percentCGPA {get;set;}
    public string states {get;set;}
    public Date signDate {get;set;}
    public string campaignData {get;set;}
    public string currencyPickList  {get;set;}

    public ApplicantPortal_Contoller() {
        ApplicantPortalSiteURL = Constants.CANDIDATE_SITE ;
        list<Application_Portal_Tabs__c> cdTabs = [select name,Tab_Label__c,id,Controller_Name__c,Display_Order__c from Application_Portal_Tabs__c ORDER BY Display_Order__c];
        tabValues = JSON.serialize(cdTabs);
        thematicAreaList = JSON.serialize(fetchAllThematicArea());
        countrytype = JSON.serialize(Utility.getPicklistValues('Account' , 'Country_Type__c'));
        countryCode = JSON.serialize(Utility.getPicklistValues('Contact' , 'Country_Code__c'));
        natureOfThesisWork = JSON.serialize(Utility.getPicklistValues('Education_Details__c' , 'Nature_of_Thesis_Work__c'));
        natureOfPhDWork = JSON.serialize(Utility.getPicklistValues('Education_Details__c' , 'Nature_of_PhD_Work__c'));
        
        availingFellowship = JSON.serialize(Utility.getPicklistValues('Application_Proposal__c' , 'Availing_any_other_fellowship_currently__c'));
        pairedApplicant = JSON.serialize(Utility.getPicklistValues('Application_Proposal__c' , 'Paired_Applicant_associated_with_IGSTC__c'));
        participantType = JSON.serialize(Utility.getPicklistValues('Participants__c' , 'Participant_Type__c'));
        bankType = JSON.serialize(Utility.getPicklistValues('Bank_Details__c' , 'Bank_Type__c'));
        participatingWorkshop = JSON.serialize(Utility.getPicklistValues('Participants__c' , 'Whether_Participant_is_presenting__c'));
        // degree = JSON.serialize(Utility.getPicklistValues('Education_Details__c' , 'Degree__c'));
        specialization = JSON.serialize(Utility.getPicklistValues('Education_Details__c' , 'Specialization__c'));
        percentCGPA = JSON.serialize(Utility.getPicklistValues('Education_Details__c' , 'Percentage_cgpa__c'));
        states = JSON.serialize(Utility.getPicklistValues('Contact' , 'States__c'));
        presentingWorkshop = JSON.serialize(Utility.getPicklistValues('Contact' , 'Presenting_Workshop__c'));
        financialConDetails = JSON.serialize([SELECT German_Academia__c,German_Institute__c,Indian__c,Indian_Institute__c FROM Financial_Overview_Conditions__c limit 1]);
        campaignData=JSON.serialize([SELECT Id,Name,Description,EndDate,Image_URL__c,RedirectPage__c,(select name,id from Attachments order by createdDate DESC),(SELECT Id,Campaign__c,Name,Description__c FROM Campaign_Guidlines__r) FROM Campaign]);
        stage = JSON.serialize(Utility.getPicklistValues('Application_Proposal__c' , 'Stage__c'));
        candidateId = Apexpages.currentPage().getParameters().get('id'); 
        gender = JSON.serialize(Utility.getPicklistValues('Contact' , 'Gender__c'));
        nationality = JSON.serialize(Utility.getPicklistValues('Contact' , 'Nationality__c'));
        country = JSON.serialize(Utility.getPicklistValues('Contact' , 'Country__c'));
        available_followship = JSON.serialize(Utility.getPicklistValues('Contact' , 'Availing_Fellowship__c'));
        available_followship = JSON.serialize(Utility.getPicklistValues('Contact' , 'Associated_with_IGSTC__c'));
        // nature_of_Job = JSON.serialize(Utility.getPicklistValues('Employment_Details__c' , 'Nature_of_Job__c'));
        expanseHead = JSON.serialize(Utility.getPicklistValues('Financial_Contribution__c' , 'Expanse_Head__c'));
        currencyPickList = JSON.serialize(Utility.getPicklistValues('Existing_Grants__c' , 'Currency__c'));
        signDate = System.today();
        system.debug('candidateId---'+candidateId);
        if(!string.isBlank(candidateId)){
            List<contact> applicantDetails = [select Email,name,id,Account.Id,Proposals__c,Proposals__r.Campaign__r.Name,Email_Verified__c,Is_Primary__c,Campaign__c from contact where Login_hash_code__c =:candidateId];
            for(Contact conRec : applicantDetails){
                emailVerified = String.valueOf(conRec.Email_Verified__c);                
            } 
            if(!string.isBlank(applicantDetails[0].Proposals__c)){
                Application_Proposal__c proposal = [SELECT Id,Name,Stage__c,Proposal_Stages__c FROM Application_Proposal__c where Id =: applicantDetails[0].Proposals__c];
                secondstage = proposal.stage__c;
                proposalStage = proposal.Proposal_Stages__c;
            }

            if(applicantDetails.size() >0){
                projectId = applicantDetails[0].Proposals__c;
                campaignName = applicantDetails[0].Proposals__r.Campaign__r.Name;
                contactId = applicantDetails[0].Id;
                campaigntype = applicantDetails[0].Campaign__c;
                applicantName=applicantDetails[0].Name;
                applicantEmail=applicantDetails[0].Email;
                isPrimaryContact=applicantDetails[0].Is_Primary__c;
                accountId=applicantDetails[0].Account.Id;
            }
        }
        
    }

    public static String generateRandomString(){
        String charString = '!@#$%^&*()nopqrstuvwABCDPQRSTUVWXYZ0123456789abcdefghijkEFGHIJKLMNOlmxyz';
        String randomNew = '';
        while (randomNew .length() < 10){
        Integer changeInt = Math.mod(Math.abs(Crypto.getRandomInteger()), charString.length());
        randomNew += charString.substring(changeInt , changeInt +1);
        }
        return  randomNew;
    }


    @InvocableMethod(label='Update password' description='Updating null password for Contacts.' category='Contact')
  public static void updatePassword(List<string> ids) {
    List<Contact> conList = New List<Contact>();
    for(String con : ids){
        Contact conRec = New Contact();
        conRec.Id = con;
        conRec.Password__c = generateRandomString();
        conList.add(conRec);
    }
    update conList;
    system.debug('ids --> '+ids);
    // return null;
  }
    
    @RemoteAction
    public static List<Campaign> fetchCampaignsPrograms(){
        List<Campaign> campaignList = [SELECT Id,Name,Description,EndDate,Image_URL__c,RedirectPage__c,Cut_Off_Start_Date__c,Cut_Off_End_Date__c,(select name,id from Attachments order by createdDate DESC),(SELECT Id,Campaign__c,Name,Description__c FROM Campaign_Guidlines__r) FROM Campaign];
        if(!campaignList.isEmpty()){
            return campaignList; 
        }
        return Null;
    }
    @RemoteAction
    public static FAQ_Links__c getFAQLinks(String programme){
        FAQ_Links__c links = New FAQ_Links__c();
        try{
            links = [SELECT Id,Name,Basic_Guidelines__c,Call_Text__c,FAQs__c,Programme__c FROM FAQ_Links__c WHERE Programme__c =: programme];
            return links;
        }catch(Exception e){
            return links;
        }
    }
    @RemoteAction
    public static List<Campaign_Theme__c> fetchCampaignThemes(){
        List<Campaign_Theme__c> campaignThemeList = [SELECT Id,Name FROM Campaign_Theme__c];
        if(!campaignThemeList.isEmpty()){
            return campaignThemeList;
        }
        return Null;
    }

    //************************************** PROJECT DETAIL PAGE ***********************************************

    @RemoteAction
    public static Application_Proposal__c getApplicantDetails(String applicantHashCode){
        return Proposal_Controller.getApplicantDetails(applicantHashCode);
    }

    @RemoteAction
    public static String insertApplication(Application_Proposal__c applicantDetails, List<string> selThemeList, integer day, integer month, integer year, String conId, String recordType){
        return Proposal_Controller.insertApplication(applicantDetails, selThemeList, day, month, year, conId, recordType);
    }

    @RemoteAction
    public static List<Thematic_Area__c> fetchAllThematicArea(){
        return Proposal_Controller.fetchAllThematicArea(); 

    }

    @RemoteAction
    public static  void deleteThematicArea(String themeId){
        Proposal_Controller.deleteThematicArea(themeId);
    }
    

    //********************************** CONSORTIA DETAILS ***************************************************

    @RemoteAction
    public static string insertAccount(List<Account> accountDetails,List<Contact> contactDetails){
       return Proposal_Controller.insertAccount(accountDetails,contactDetails);
    }

    @RemoteAction
    public static Account saveAccount(Account accountDetails,string projectId){
        
        accountDetails.Proposals__c = projectId;
        accountDetails.NumberOfEmployees = Integer.valueOf(accountDetails.NumberOfEmployees);
       upsert accountDetails;
       return accountDetails;
    }

    @RemoteAction
    public static contact saveContact(Contact contactDetails,string accountId,string projectId){
        contactDetails.AccountId = accountId;
        contactDetails.Proposals__c = projectId;
       upsert contactDetails;
       return contactDetails;
    }

    @RemoteAction
    public static string insertAccountAndContact(account accDetails, list<contact> conListToInsert){
       return Proposal_Controller.insertAccountAndContact(accDetails,conListToInsert);
    }

    @RemoteAction
    public static  list<account> getPatnerDetails(string applicantHashCode){
        return Proposal_Controller.getPatnerDetails(applicantHashCode);
    }

    @RemoteAction
    public static  list<account> getPatnerDetails2(string applicantHashCode){
        return Proposal_Controller.getPatnerDetails2(applicantHashCode);
    }

    @RemoteAction
    public static string insertConsortiaDetailPage(list<Proposal_Controller.ConsortiaDetails> ConsortiaDetailsList,string projectId){
        return Proposal_Controller.insertConsortiaDetailPage(ConsortiaDetailsList,projectId);
    }

    @RemoteAction
    public static  void deleteContact(string contactId){
        Proposal_Controller.deleteContact(contactId);    
    }

    
    @RemoteAction
    public static  void deleteAccountDetails(string accId, list<string> contactIdList){
        Proposal_Controller.deleteAccountDetails(accId, contactIdList);    
    }

    //*************************************** CONSORTIUM PARTNER INFORMATION *********************************************
    
    @RemoteAction
    public static String insertPartnerInformation(Account contactDetails){
        return Proposal_Controller.insertPartnerInformation(contactDetails);
    }

    //************************************* CURRICULUM VITAE *********************************************************
    
    @RemoteAction
    public static String insertContactDetails(List<Contact> contactDetails, List<Education_Details__c> educationDetails, List<Employment_Details__c> employmentDetails, List<Publications_Patents__c> publicationDetails){
        //system.debug('method ::'+Proposal_Controller.insertContactDetails(contactDetails,educationDetails,employmentDetails,publicationDetails));
        return Proposal_Controller.insertContactDetails(contactDetails,educationDetails,employmentDetails,publicationDetails);
    }

    @RemoteAction
    public static Contact getContactDetails(string hashCode){
        return Proposal_Controller.getContactDetails(hashCode);
    }

    @RemoteAction
    public static Contact getCvDetails(string contactId){
        return Proposal_Controller.getCvDetails(contactId);
    }

    //******************************************* COMPANY PROFILE *********************************************
    
    @RemoteAction
    public static  Account getCompanyApplicantDetails(string applicantHashCode){
        return Proposal_Controller.getCompanyApplicantDetails(applicantHashCode);
    }

    @RemoteAction
    public static Account insertApplicant(Account applicantDetails){
        return Proposal_Controller.insertApplicant(applicantDetails); 
    }

    //****************************************** FINANCIAL OVERVIEW ***************************************************
    
    @RemoteAction
    public static  list<Account> getProjectDetailsDetails(string applicantHashCode){
        return Proposal_Controller.getProjectDetailsDetails(applicantHashCode);
    }

    @RemoteAction
    public static String insertFinancialDetails(List<Financial_Contribution__c> financialDetails){
        return Proposal_Controller.insertFinancialDetails(financialDetails);
    }

    //*************************************** PROJECT DETAIL ********************************************
    
    @RemoteAction
    public static string insertProjectDetails(Application_Proposal__c proposalDetails){
        return Proposal_Controller.insertProjectDetails(proposalDetails);
    }

    @RemoteAction
    public static Application_Proposal__c getProjectdetils(string hashcode){
        return Proposal_Controller.getProjectdetils(hashcode);
    }

    @RemoteAction
    public static String doCUploadAttachment(String attachmentBody, String attachmentName, string cvId, String udId){
        return Proposal_Controller.doCUploadAttachment(attachmentBody,attachmentName,cvId,udId);
    }

    @RemoteAction
    public static string createUserDocument(string udId, string conId, string pId, string fileId){
        return Proposal_Controller.createUserDocument(udId, conId, pId, fileId);
    }

    @RemoteAction
    public static string createUserDocumentPecfarDoc(string udId, string conId, string pId, string fileId){
        return Proposal_Controller.createUserDocumentPecfarDoc(udId, conId, pId, fileId);
    }

    //************************************** WORK PACKAGE **********************************************************

    @RemoteAction
    public static List<Work_Package__c> getWPDetails(string applicantHashCode){
        return Proposal_Controller.getWPDetails(applicantHashCode);
    }
    @RemoteAction
    public static List<Account> getProposalAccounts(String ProposalId){
        return Proposal_Controller.getProposalAccounts(ProposalId);
    }
    // @RemoteAction
    // public static list<Account> getWorkPackageDetails(string applicantHashCode){
    //     return Proposal_Controller.getWorkPackageDetails(applicantHashCode);
    // }

    // @RemoteAction
    // public static  String insertWPContactDetails(List<Work_Package__c> workPackDetails){
    //     system.debug('workPackDetails ::'+workPackDetails);
    //     return Proposal_Controller.insertWPContactDetails(workPackDetails);
    // }

    // @RemoteAction
    // public static  String insertWPContactDetailsAsDraft(List<Work_Package__c> workPackDetails){
    //     return Proposal_Controller.insertWPContactDetailsAsDraft(workPackDetails);
    // }

    // @RemoteAction
    // public static  void deleteWorkPackage(string wpId){
    //     Proposal_Controller.deleteWorkPackage(wpId);
    // }

    //************************************** Grant Application **********************************************************
    
    @RemoteAction
    public static  List<Account> getApplicantDetailsForGrant(string applicantHashCode){
        return Proposal_Controller.getApplicantDetailsForGrant(applicantHashCode);
    }

    @RemoteAction
    public static String insertExistingGrants(List<Proposal_Controller.ExistingGrantsWrapper> grantList){
        system.debug('grantList ---> '+grantList);
        return Proposal_Controller.insertExistingGrants(grantList);
    }

    @RemoteAction
    public static String insertExistingGrantsAsDraft(List<Proposal_Controller.ExistingGrantsWrapper> grantList){
        return Proposal_Controller.insertExistingGrantsAsDraft(grantList);
    }

    @RemoteAction
    public static  void deleteGrants(string grantstId){
        Proposal_Controller.deleteGrants(grantstId);
    }

    @RemoteAction
    public static Proposal_Controller.MyProposalWapper fetchProjectDetails(String projectId){
        system.debug('projectId :: '+projectId);
        return Proposal_Controller.fetchProjectDetails(projectId);
    }
    
    //************************************** PI Deliverables **********************************************************

    // @RemoteAction
    // public static  list<Account> getProjectDetailsForPI(string applicantHashCode){
    //     return Proposal_Controller.getProjectDetailsForPI(applicantHashCode);
    // }

    
    // @RemoteAction
    // public static  String insertDeliverables(List<Proposal_Controller.PiWrapper> deliverableList){
    //     System.debug('deliverableList---'+deliverableList);
    //      return Proposal_Controller.insertDeliverables(deliverableList);
    // }

    @RemoteAction
    public static List<PI_Deliverables__c> getDeliverablesDetails(string applicantHashCode){
        return Proposal_Controller.getDeliverablesDetails(applicantHashCode);
    }

    @RemoteAction 
    public static String saveDeliverables(List<Proposal_Controller.WrapperPIDeliverables> wrapper,String ProposalId){
        Proposal_Controller instance = new Proposal_Controller();
        return instance.saveDeliverables(wrapper,ProposalId);
    }

    @RemoteAction
    public static void deleteDeliverables(string deliverId){
        Proposal_Controller.deleteDeliverables(deliverId);
    }

    //************************************** Network Meeting **********************************************************

    // @RemoteAction
    // public static list<Account> getProjectDetailsForNetMeet(string applicantHashCode){
    //     return Proposal_Controller.getProjectDetailsForNetMeet(applicantHashCode);
    // }

    // @RemoteAction
    // public static String insertMeetingDetails(List<Proposal_Controller.NetworkMeetWrapper> meetingList){
    //     system.debug('MeetingList ---> '+meetingList);
    //     return Proposal_Controller.insertMeetingDetails(meetingList);
    // }

    // @RemoteAction
    // public static  void deleteMeeting(string netId){
    //     Proposal_Controller.deleteMeeting(netId);
    // }

    @RemoteAction
    public static List<Network_Meeting__c> getMeetingDetails(string applicantHashCode){
        return Proposal_Controller.getMeetingDetails(applicantHashCode);
    }

    @RemoteAction 
    public static String saveMeetingDetailss(List<Proposal_Controller.WrapperNetworkMeetings> wrapper,String ProposalId){
        Proposal_Controller instance = new Proposal_Controller();
        return instance.saveMeetingDetailss(wrapper,ProposalId);
    }

    @RemoteAction
    public static void deleteNetworkMeeting(string netMeetingId){
        Proposal_Controller.deleteNetworkMeeting(netMeetingId);
    }

    //************************************** Privacy Policy Acceptance **********************************************************

    @RemoteAction
    public static string insertPrivacyPolicy(Application_Proposal__c proposalDetails){
        return Proposal_Controller.insertPrivacyPolicy(proposalDetails);
    }

    @RemoteAction
    public static string finalSubmit(Application_Proposal__c proposalDetails){
        return Proposal_Controller.finalSubmit(proposalDetails);
    }
   //************************************** Industraial Fellowship ********************************************************** 
   @RemoteAction
   public static String updateIndusrianFellowshipBasicDet(String ContactId,Contact InstanceCon,Integer birthDay,Integer birthMonth,Integer birthYear,Integer phdEnrollYear,Integer phdEnrollMonth,Integer phdEnrollDay,Integer phdAwardYear,Integer phdAwardMonth,Integer phdAwardDay,Integer phdThesisYear,Integer phdThesisMonth,Integer phdThesisDay,Application_Proposal__c prop){
       IndustrialFellowshipHelper instanceIFH=new IndustrialFellowshipHelper();
       return instanceIFH.updateIndusrianFellowshipBasicDet(ContactId,InstanceCon,birthDay,birthMonth,birthYear,phdEnrollYear,phdEnrollMonth,phdEnrollDay,phdAwardYear,phdAwardMonth,phdAwardDay,phdThesisYear,phdThesisMonth,phdThesisDay,prop);
   }
    @RemoteAction
    public static String updatePersonalInfoIF(String ContactId,Contact InstanceCon,Integer birthDay,Integer birthMonth,Integer birthYear,Integer pasExYear,Integer pasExMonth,Integer pasExDay){
        IndustrialFellowshipHelper instanceIFH=new IndustrialFellowshipHelper();
        return instanceIFH.updatePersonalInfoIF(ContactId,InstanceCon,birthDay,birthMonth,birthYear,pasExYear,pasExMonth,pasExDay);
    }
    @RemoteAction
    public static Campaign getCampaignEndDate(String campaignName){
        IndustrialFellowshipModel instanceIFM=new IndustrialFellowshipModel();
        return instanceIFM.getCampaignEndDate(campaignName);
    }
    //************************************** WORKSHOP ********************************************************** 

    //************************************** Coordinators Page **********************************************************
    
    @RemoteAction
    public static List<Contact> getCoordinatorsDetails(string hashCode){
        return Proposal_Controller.getCoordinatorsDetails(hashCode);
    }
    
    @RemoteAction
    public static string SaveWorkshopContactDetails2(Contact conDataList, List<Education_Details__c> eduDetails, List<Employment_Details__c> empDetails){
        try{
            // conDataList.MailingState = conDataList.State__c;
            upsert conDataList;
            upsert eduDetails;
            upsert empDetails;
            return 'success';
        }catch(Exception e){
            return e.getMessage();
        }
    }

    @RemoteAction
    public static String insertCoordinatorsInformation(List<Account> accList,List<Contact> conList){
        return Proposal_Controller.insertCoordinatorsInformation(accList,conList);
    }

    //************************************** BasicDetails_Page **********************************************************

    @RemoteAction
    public static Application_Proposal__c getBasicDetails(String applicantHashCode){
        return Proposal_Controller.getBasicDetails(applicantHashCode);
    }

    @RemoteAction
    public static string insertBasicDetails (Application_Proposal__c applicantDetails, integer day, integer month, integer year, integer endday, integer emdmonth, integer endyear, String conId, String RecordType){
        return Proposal_Controller.insertBasicDetails(applicantDetails, day, month, year, endday, emdmonth, endyear, conId, recordType);
    }

    //************************************** Participants **********************************************************

    @RemoteAction
    public static List<Participants__c> getParticipantDetails(string hashcode){
        return Proposal_Controller.getParticipantDetails(hashcode);
    }

    @RemoteAction
    public static string insertParticipants(List<Participants__c> allParticipantDetails){
        return Proposal_Controller.insertParticipants(allParticipantDetails);
    }

    @RemoteAction
    public static  void deleteParticipant(string participantId){
        Proposal_Controller.deleteParticipant(participantId);    
    }

    ////////////////////////////////////////////// Curriculum /////////////////////////////////////

    @RemoteAction
    public static String insertCurriculumDetails(List<Contact> contactDetails, List<Education_Details__c> educationDetails, List<Employment_Details__c> employmentDetails, List<Publications_Patents__c> publicationDetails){
        return Proposal_Controller.insertCurriculumDetails(contactDetails, educationDetails, employmentDetails, publicationDetails);
    }
    @RemoteAction
    public static List<Contact> getCurriculumDetails(string hashCode){
        return Proposal_Controller.getCurriculumDetails(hashCode);
    }

    //************************************** Financial_Details **********************************************************

    @RemoteAction
    public static List<Contact> getAllFinancialDetails(string hashCode){
        return Proposal_Controller.getAllFinancialDetails(hashCode);
    }

    @RemoteAction
    public static string saveFinancialDetails(List<Financial_Contribution__c> financialList){
        return Proposal_Controller.saveFinancialDetails(financialList);
    }

    //************************************** BankDetailsForCoordinators **********************************************************

    @RemoteAction
    public static List<Account> getBankDetails(string hashCode){
        return Proposal_Controller.getBankDetails(hashCode);
    }

    @RemoteAction
    public static String upsertBankDetails(List<Bank_Details__c> bankDetailsList){
        return Proposal_Controller.upsertBankDetails(bankDetailsList);
    }


     //************************************** Project Details in Wiser **********************************************************
    @RemoteAction
    public static Application_Proposal__c getApplicantDetailsWiser(String applicantHashCode){
        return Proposal_Controller.getApplicantDetailsWiser(applicantHashCode);
    }

    @RemoteAction
    public static String insertApplicationWiser(Application_Proposal__c applicantDetails,  String conId, String recordType){
        return Proposal_Controller.insertApplicationWiser(applicantDetails, conId, recordType);
    }
    @RemoteAction
    public static String LogoutApplicant(String loginHasgCode){
        return Proposal_Controller.LogoutApplicant(loginHasgCode);
    }

    @RemoteAction
    public static String createExpenseDeclarationDetails(List<Expense_Line_Item__c> expenseLineItem,String proposalId,String accId){
        return Proposal_Controller.createExpenseDeclarationDetails(expenseLineItem, proposalId, accId);
    }

    @RemoteAction
    public static List<Expense_Line_Item__c> getExpenseRecords(String ProposalId){
        return Proposal_Controller.getExpenseRecords(ProposalId);
    }

    @RemoteAction
    public static Application_Proposal__c getConsentCheckbox(string proposalId){
        return Proposal_Controller.getConsentCheckbox(proposalId);
    }

    @RemoteAction
    public static string saveAsDraftWorkshop(Application_Proposal__c proposalList){
        return Proposal_Controller.saveAsDraftWorkshop(proposalList);
    }

    @RemoteAction
    public static string upsertCheckbox(Application_Proposal__c proposalList){
        return Proposal_Controller.upsertCheckbox(proposalList);
    }
    @RemoteAction
    public static Proposal_Controller.WrapProposalPendings getProposalPendings(String pid){
        return Proposal_Controller.getProposalPendings(pid);
    }

    @RemoteAction
    public static List<Proposal_Controller.accWrapper> getExpenseDetailsOfAccount(string proposalId){
        return Proposal_Controller.getExpenseDetailsOfAccount(proposalId);
    }

    @RemoteAction
    public static string saveExpenseDetails(List<Expense_Line_Item__c> listOfLineItem){
        return Proposal_Controller.saveExpenseDetails(listOfLineItem);
    }

    @RemoteAction
    public static  void deleteExpenseLineItems(string lineItemId){
        Proposal_Controller.deleteExpenseLineItems(lineItemId);
    }

    @RemoteAction
    public static String insertFellowship_Details(Contact applicantDetails, integer startday, integer startmonth, integer startyear, integer endday, integer endmonth, integer endyear,String conId, String recordType){
        return Proposal_Controller.insertFellowship_Details(applicantDetails, startday, startmonth, startyear, endday, endmonth, endyear, conId, recordType);
    }

    @RemoteAction
    public static List<Contact> getPairingDetails(string hashcode, string campaignId){
        return Proposal_Controller.getPairingDetails(hashcode,campaignId);
    }

    @RemoteAction
    public static String insertPairingDetails(List<Proposal_Controller.wrapperPairing> contactList){
        return Proposal_Controller.insertPairingDetails(contactList);
    }

    @RemoteAction
    public static Contact getPersonalInformation(string hashCode){
        return Proposal_Controller.getPersonalInformation(hashCode);
    }

    @RemoteAction
    public static string insertPersonalInfo(Contact conDetails, integer birthday, integer birthmonth, integer birthyear){
        return Proposal_Controller.insertPersonalInfo(conDetails, birthday, birthmonth, birthyear);
    }

    @RemoteAction
    public static String doCUploadAttachmentA(String attachmentBody, String attachmentName, string cvId, String udId,string projectid,string CreateTask,string TaskSubject) {
        system.debug('attachmentBody---'+attachmentName+'---attachmentId---'+cvId+'---cvId---'+udId);
        system.debug('cvId---'+cvId+'---udId---'+udId);
        User_Document__c userDocc = New User_Document__c();
        userDocc.Id = udId;
        userDocc.Status__c = 'Uploaded';
        upsert userDocc;
        if(String.isBlank(attachmentBody) || String.isBlank(udId))
            return 'ERROR';
        if(String.isBlank(cvId)) {
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; 
            conVer.PathOnClient = 'attachmentName'; 
            conVer.Title = attachmentName; 
            conVer.VersionData = EncodingUtil.base64Decode(attachmentBody); 
            conVer.isMajorVersion = false;
            insert conVer;   
            
            ContentDistribution cdl = new ContentDistribution();
            cdl.ContentVersionId = conVer.Id;
            cdl.Name = 'PublicShare';
            cdl.RelatedRecordId = udId;
            insert cdl;
            system.debug('ContentDistribution----'+cdl);
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = udId; 
            conDocLink.ContentDocumentId = conDoc; 
            conDocLink.shareType = 'V';
            insert conDocLink;
            if(CreateTask=='Create'){
                Task taskRecord = New Task();
                taskRecord.WhatId = projectid;
                taskRecord.Subject = TaskSubject;
                insert taskRecord;
            }
            return conVer.Id;

        }else {
            List<ContentVersion> cvList = [SELECT Id, VersionData FROM ContentVersion WHERE Id = :cvId];
            if(!cvList.isEmpty()) {
                ContentVersion cVersion = cvList[0];
                if(cVersion.VersionData != null) {
                    String newBody = EncodingUtil.base64Encode(cVersion.VersionData);
                    newBody += attachmentBody;
                    cVersion.VersionData = EncodingUtil.base64Decode(newBody); 
                    update cVersion;
                    if(CreateTask=='Create'){
                        Task taskRecord = New Task();
                        taskRecord.WhatId = projectid;
                        taskRecord.Subject = TaskSubject;
                        insert taskRecord;
                    }
                    return cVersion.Id;
                }   
            }
        }
        return 'Success';
    }

    @RemoteAction
    public static string doUploadAttachment (string type, String attachmentBody, String attachmentName,string conId, String fileId, string userDocId){
        return IndustrialFellowshipHelper.doUploadAttachment(type, attachmentBody, attachmentName, conId, fileId, userDocId);
    }

    @RemoteAction
    public static String doUploadProfilePic(String contactId, String attachmentBody, String attachmentName) {
        system.debug('contactId==>'+contactId+'attachmentBody==>'+attachmentBody+'attachmentName==>'+attachmentName);
        if(contactId != null && attachmentBody != null) {
            Attachment att = new Attachment();
            String newBody = '';
            newBody += attachmentBody;
            att.Body = EncodingUtil.base64Decode(newBody);
            att.Name = attachmentName;
            att.parentId = contactId;
            
            insert att;
            system.debug('Id ::'+att.Id);
            string attId = att.Id;
            if(attId != null){
                if(attId.length() == 18){
                    attId = attId.substring(0,attId.length()-3);
                }
            }
            
            update new Contact(Id = contactId,Profile_Pic_Attachment_Id__c = attId );
            return attId; 
        }
        return null;
    }

    @RemoteAction
    public static String doCUploadAttachmentB(String attachmentBody, String attachmentName, string cvId, Bank_Details__c bankInstance) {
        String udId;
        system.debug('attachmentBody---'+attachmentName+'---attachmentId---'+cvId+'---cvId---'+udId);
        system.debug('cvId---'+cvId+'---udId---'+udId);
        bankInstance.File_Upload_Status__c = 'Uploaded';
        upsert bankInstance;
        udId=bankInstance.Id;
        if(String.isBlank(attachmentBody) || String.isBlank(udId))
            return 'ERROR';
        if(String.isBlank(cvId)) {
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; 
            conVer.PathOnClient = 'attachmentName'; 
            conVer.Title = attachmentName; 
            conVer.VersionData = EncodingUtil.base64Decode(attachmentBody); 
            conVer.isMajorVersion = false;
            insert conVer;   
            
            ContentDistribution cdl = new ContentDistribution();
            cdl.ContentVersionId = conVer.Id;
            cdl.Name = 'PublicShare';
            cdl.RelatedRecordId = udId;
            insert cdl;
            system.debug('ContentDistribution----'+cdl);
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = udId; 
            conDocLink.ContentDocumentId = conDoc; 
            conDocLink.shareType = 'V';
            insert conDocLink;

            return conVer.Id;

        }else {
            List<ContentVersion> cvList = [SELECT Id, VersionData FROM ContentVersion WHERE Id = :cvId];
            if(!cvList.isEmpty()) {
                ContentVersion cVersion = cvList[0];
                if(cVersion.VersionData != null) {
                    String newBody = EncodingUtil.base64Encode(cVersion.VersionData);
                    newBody += attachmentBody;
                    cVersion.VersionData = EncodingUtil.base64Decode(newBody); 
                    update cVersion;
                    return cVersion.Id;
                }   
            }
        }
        return 'Success';
    }
    @RemoteAction
    public static List<Employment_Details__c> getEmpDetails(string hashcode){
        return Proposal_Controller.getEmpDetails(hashcode);
    }

    @RemoteAction
    public static string insertEmploymentDetailsPECFAR(List<Employment_Details__c> empDetails){
        return Proposal_Controller.insertEmploymentDetailsPECFAR(empDetails);
    }

    // @RemoteAction
    // public static string updateEmploymentDetails(List<Proposal_Controller.employmentWrapper> empList){
    //     return Proposal_Controller.updateEmploymentDetails(empList);
    // }

    @RemoteAction
    public static  void deleteEmployment(string empId){
        Proposal_Controller.deleteEmployment(empId);
    }

    @RemoteAction
    public static Contact getParentOrgDetails(string hashcode){
        return Proposal_Controller.getParentOrgDetails(hashcode);
    }
 
    @RemoteAction
    public static string updateconAccDetails(Account conAccDetails){
        return Proposal_Controller.updateconAccDetails(conAccDetails);
    }

    @RemoteAction
    public static Achievement__c getAchievements(string hashcode){
        return Proposal_Controller.getAchievements(hashcode);
    }

    @RemoteAction
    public static string updateAchievements(Achievement__c achievementList){
        return Proposal_Controller.updateAchievements(achievementList);
    }

    @RemoteAction
    public static string insertWiserDraft(string projectId, integer day, integer month, integer year){
        return Proposal_Controller.insertWiserDraft(projectId, day, month, year);
    }

    @RemoteAction
    public static string finalSubmitWiser(string projectId, integer day, integer month, integer year){
        return Proposal_Controller.finalSubmitWiser(projectId, day, month, year);
    }

    @RemoteAction
    public static Contact getDeclarationfields(string hashcode){
        return Proposal_Controller.getDeclarationfields(hashcode);
    }

    @RemoteAction
    public static string upsertSign(Contact conDetails,integer year,integer month,integer day){
        return Proposal_Controller.upsertSign(conDetails, year, month, day);
    }
    
    @RemoteAction
    public static list<Proposal_Controller.UserDocumentWrapper> getContactUserDoc(id parentId){
        return Proposal_Controller.getContactUserDoc(parentId);
    }
    @RemoteAction
    public static list<Proposal_Controller.UserDocumentWrapper> getReviewerUserDoc(id parentId){
        return Proposal_Controller.getReviewerUserDoc(parentId);
    }

    @RemoteAction
        public static Contact getcampaigntype(string hashcode){
            try{
                Contact conrec = [SELECT Id,Name,Campaign__c,Is_Primary__c from Contact where Login_Hash_Code__c=: hashcode];
                return conrec;
            }catch(exception e){
                return null;
            }
        }

    // @RemoteAction
    // public static ContentDocumentLink getSignature(string conId){
    //     return Proposal_Controller.getSignature(conId);
    // }

    @RemoteAction
    public static list<Proposal_Controller.MeetingThemeWrapper> getMeetingThemeDetails(string proposalId){
        return Proposal_Controller.getMeetingThemeDetails(proposalId);
    }

    @RemoteAction
    Public static string saveMeetingDetails(List<Proposal_Controller.MeetingThemeWrapper> meetingThemeWrapper){
        return Proposal_Controller.saveMeetingDetails(meetingThemeWrapper);
    }

    @RemoteAction
    public static list<Proposal_Controller.UserDocumentWrapper> getAllUserDoc(string parentId) {
        return Proposal_Controller.getAllUserDoc(parentId);
    }

    @RemoteAction
    public static string saveAsDraftPecfar(Application_Proposal__c proposalDetails){
        return Proposal_Controller.saveAsDraftPecfar(proposalDetails);
    }

    @RemoteAction
    public static string finalSubmitPecfar(Application_Proposal__c proposalDetails){
        return Proposal_Controller.finalSubmitPecfar(proposalDetails);
    }

    @RemoteAction
    public static String reviewAppDocGen(string proID){
        Proposal_Controller prosalInstance=new Proposal_Controller();
        return prosalInstance.reviewAppDocGen(proID);
    }
    @RemoteAction
    public static list<Attachment> getCongaDoc(string proID){
        Proposal_Controller prosalInstance=new Proposal_Controller();
        return prosalInstance.getCongaDoc(proID);
    }
    @RemoteAction
    public static String doCUploadProfilePic(String attachmentBody, String attachmentName, string cvId, String udId) {
        system.debug('attachmentBody---'+attachmentName+'---attachmentId---'+cvId+'---cvId---'+udId);
        system.debug('cvId---'+cvId+'---udId---'+udId);
        if(String.isBlank(attachmentBody) || String.isBlank(udId))
            return 'ERROR';
        if(String.isBlank(cvId)) {
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; 
            conVer.PathOnClient = 'attachmentName'; 
            conVer.Title = attachmentName; 
            conVer.VersionData = EncodingUtil.base64Decode(attachmentBody); 
            conVer.isMajorVersion = false;
            insert conVer;   
            
            ContentDistribution cdl = new ContentDistribution();
            cdl.ContentVersionId = conVer.Id;
            cdl.Name = 'PublicShare';
            cdl.RelatedRecordId = udId;
            insert cdl;
            system.debug('ContentDistribution----'+cdl);
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = udId; 
            conDocLink.ContentDocumentId = conDoc; 
            conDocLink.shareType = 'V';
            insert conDocLink;

            return conVer.Id;

        }else {
            List<ContentVersion> cvList = [SELECT Id, VersionData FROM ContentVersion WHERE Id = :cvId];
            if(!cvList.isEmpty()) {
                ContentVersion cVersion = cvList[0];
                if(cVersion.VersionData != null) {
                    String newBody = EncodingUtil.base64Encode(cVersion.VersionData);
                    newBody += attachmentBody;
                    cVersion.VersionData = EncodingUtil.base64Decode(newBody); 
                    update cVersion;
                    return cVersion.Id;
                }   
            }
        }
        return 'Success';
    }

    // @RemoteAction
    // public static string reviewApp(string proID,string CampaignType){
    //     return Proposal_Controller.reviewApp(proID,CampaignType);
    // }
    @RemoteAction
    public static string updateProfileAttId(string conId,string attId){
        update New Contact(id=conId,Profile_Pic_Attachment_Id__c=attId);
        return 'success';
    }
    @RemoteAction
    public static Contact getFellowshipDetails(string applicantHashCode){
        return Proposal_Controller.getFellowshipDetails(applicantHashCode);
    }
    // @RemoteAction
    // public static String doCUploadAttachmentReviewer(String attachmentBody, String attachmentName, string cvId, String udId) {
    //     system.debug('attachmentBody---'+attachmentName+'---attachmentId---'+cvId+'---cvId---'+udId);
    //     system.debug('cvId---'+cvId+'---udId---'+udId);
    //     Reviewer__c userDocc = New Reviewer__c();
    //     userDocc.Id = udId;
    //     userDocc.Status__c = 'Uploaded';
    //     system.debug('status ::'+userDocc);
    //     upsert userDocc;
    //     if(String.isBlank(attachmentBody) || String.isBlank(udId))
    //         return 'ERROR';
    //     if(String.isBlank(cvId)) {
    //         ContentVersion conVer = new ContentVersion();
    //         conVer.ContentLocation = 'S';
    //         conVer.PathOnClient = '/'+System.now()+attachmentName;//'attachmentName';
    //         conVer.Title = attachmentName;
    //         conVer.VersionData = EncodingUtil.base64Decode(attachmentBody);
    //         conVer.isMajorVersion = false;
    //         insert conVer;  
           
    //         ContentDistribution cdl = new ContentDistribution();
    //         cdl.ContentVersionId = conVer.Id;
    //         cdl.Name = 'PublicShare';
    //         cdl.RelatedRecordId = udId;
    //         insert cdl;
    //         system.debug('ContentDistribution----'+cdl);
    //         Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
    //         ContentDocumentLink conDocLink = New ContentDocumentLink();
    //         conDocLink.LinkedEntityId = udId;
    //         conDocLink.ContentDocumentId = conDoc;
    //         conDocLink.shareType = 'V';
    //         insert conDocLink;

    //         return conVer.Id;

    //     }else {
    //         List<ContentVersion> cvList = [SELECT Id, VersionData FROM ContentVersion WHERE Id = :cvId];
    //         if(!cvList.isEmpty()) {
    //             ContentVersion cVersion = cvList[0];
    //             if(cVersion.VersionData != null) {
    //                 String newBody = EncodingUtil.base64Encode(cVersion.VersionData);
    //                 newBody += attachmentBody;
    //                 cVersion.VersionData = EncodingUtil.base64Decode(newBody);
    //                 update cVersion;
    //                 return cVersion.Id;
    //             }  
    //         }
    //     }
    //     return 'Success';
    // }
    @RemoteAction
    public static String doCUploadAttachmentAa(String attachmentBody, String attachmentName, string cvId, String udId) {
        system.debug('attachmentBody---'+attachmentName+'---attachmentId---'+cvId+'---cvId---'+udId);
        system.debug('cvId---'+cvId+'---udId---'+udId);
        User_Document__c userDocc = New User_Document__c();
        userDocc.Id = udId;
        userDocc.Status__c = 'Uploaded';
        system.debug('status ::'+userDocc);
        upsert userDocc;
        if(String.isBlank(attachmentBody) || String.isBlank(udId))
            return 'ERROR';
        if(String.isBlank(cvId)) {
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S';
            conVer.PathOnClient = '/'+System.now()+attachmentName;//'attachmentName';
            conVer.Title = attachmentName;
            conVer.VersionData = EncodingUtil.base64Decode(attachmentBody);
            conVer.isMajorVersion = false;
            insert conVer;  
           
            ContentDistribution cdl = new ContentDistribution();
            cdl.ContentVersionId = conVer.Id;
            cdl.Name = 'PublicShare';
            cdl.RelatedRecordId = udId;
            insert cdl;
            system.debug('ContentDistribution----'+cdl);
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = udId;
            conDocLink.ContentDocumentId = conDoc;
            conDocLink.shareType = 'V';
            insert conDocLink;

            return conVer.Id;

        }else {
            List<ContentVersion> cvList = [SELECT Id, VersionData FROM ContentVersion WHERE Id = :cvId];
            if(!cvList.isEmpty()) {
                ContentVersion cVersion = cvList[0];
                if(cVersion.VersionData != null) {
                    String newBody = EncodingUtil.base64Encode(cVersion.VersionData);
                    newBody += attachmentBody;
                    cVersion.VersionData = EncodingUtil.base64Decode(newBody);
                    update cVersion;
                    return cVersion.Id;
                }  
            }
        }
        return 'Success';
    }

    @RemoteAction
    public static Map<String, List<String>> getFieldDependencies(String objectName, String controllingField, String dependentField){
        return Proposal_Controller.getFieldDependencies(objectName, controllingField, dependentField);
    }

    @RemoteAction
    public static string createAnotherCoord(string projectId){
        return Proposal_Controller.createAnotherCoord(projectId);
    }

    @RemoteAction
    public static Contact getCoodinatorDetList(string hashcode){
        return Proposal_Controller.getCoodinatorDetList(hashcode);
    }

    @RemoteAction
    public static void deleteEducationWorkshop(string eduId){
        Proposal_Controller.deleteEducationWorkshop(eduId);  
    }

    @RemoteAction
    public static void deleteEmploymentWorkshop(string empId){
        Proposal_Controller.deleteEmploymentWorkshop(empId);
    }

    @RemoteAction
    public static string SaveWorkshopContactDetails(Contact conDataList, List<Education_Details__c> eduDetails, List<Employment_Details__c> empDetails){
        return Proposal_Controller.SaveWorkshopContactDetails(conDataList, eduDetails, empDetails);
    }

    @RemoteAction
    public static Account getAddressDetails(string hashcode){
        return Proposal_Controller.getAddressDetails(hashcode);
    }

    @RemoteAction
    public static string saveAddressDetails(Account addressDetails, List<Contact> contactList){
        return Proposal_Controller.saveAddressDetails(addressDetails,contactList);
    }

    @RemoteAction
    public static List<Contact> getAllContacts(){
        return Proposal_Controller.getAllContacts();
    }

    @RemoteAction
    public static List<Contact> checkEmail(string email, string contId){
        return Proposal_Controller.checkEmail(email, contId);
    }

    @RemoteAction
    public static string getConForHostNationality(string userId){
        return Proposal_Controller.getConForHostNationality(userId);
    }

    @RemoteAction
    public static string createHostContact(string conID, string projectid){
        return Proposal_Controller.createHostContact(conID,projectid);
    }

    @RemoteAction
    public static Contact getCVDetailsForWiserApplicant(string userId){
        return Proposal_Controller.getCVDetailsForWiserApplicant(userId);
    }
    @RemoteAction
    public static WrapperProposalDet getPECFARProposalDetails(string ProposalId){
        List<Contact> listContact=[SELECT ID,Name,proposals__r.Tentative_plans_for_networking__c,proposals__r.Basis_for_choosing_the_pairing_fellow__c,proposals__r.Expected_Deliverables__c,
        proposals__r.Tentative_Start_Date__c,proposals__r.Research_Approach_Objectives__c,proposals__r.Tentative_End_Date__c,proposals__r.Availing_any_other_fellowship_currently__c,proposals__r.Paired_Applicant_associated_with_IGSTC__c,
        proposals__r.Availing_Other_Fellowship_Detail__c,proposals__r.Applicant_associated_with_IGSTC_Detail__c,FirstName,LastName,MailingStreet,Profile_Pic_Attachment_Id__c,Gender__c,MobilePhone,Designation__c,Institution_Name__c,Nationality__c,Institution__c,Email,Birthdate,Planned_research_activities_of_the_visit__c,Expected_outcomes__c,Basis_for_choosing_your_paired_member__c,Tentative_Start_Date__c,Tentative_End_Date__c,Availing_Fellowship__c,Associated_with_IGSTC__c,Give_Fellowship_Details__c,Give_Associated_Details__c,Account.Name,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,Account.BillingState,
        Account.BillingPostalCode,Account.Email__c,Account.Homepage_URL__c,Account.Organisation_Posrt__c,Uploaded__c,
        (select name,id from Attachments Order By CreatedDate DESC limit 1),(SELECT Name,Start_Year__c,End_Year__c,End_Date__c,Start_Date__c,Nature_of_PhD_Work__c,Nature_of_Thesis_Work__c,Institution_Name__c,Area_of_specialization__c,Percentage__c,Percentage_cgpa__c,
        Thesis_Supervisor__c,Thesis_Type__c,Recordtype.Name,RecordTypeId,Title_Thesis__c FROM Education_Details__r) FROM Contact WHERE Proposals__c=:ProposalId];
        //(SELECT id,Awards_Honours__c,List_of_Publications__c,List_of_Patents_filed__c,Book_Chapters__c,Any_other_achievements__c FROM Achievement__r)
        List<Id> listConatctId = new List<Id>();
        for(contact con:listContact){
            listConatctId.add(con.Id);
        }
        List<Achievement__c> listAchievement=[SELECT id,Awards_Honours__c,List_of_Publications__c,List_of_Patents_filed__c,Book_Chapters__c,Any_other_achievements__c FROM Achievement__c where contact__r.Id IN:listConatctId];
        WrapperProposalDet instanceWrapper=new WrapperProposalDet();
        instanceWrapper.Lcon=listContact;
        instanceWrapper.achievements=listAchievement;
        return instanceWrapper;
    }
    public class WrapperProposalDet {
        List<Contact> Lcon;
        List<Achievement__c> achievements;
    }

    @RemoteAction
    public static Account getMentorHostDetails(string userId){
        return Proposal_Controller.getMentorHostDetails(userId);
    }

    @RemoteAction
    public static string saveMentorHostDetails(Account AccountRecord, string userId, string proposalID){
        return Proposal_Controller.saveMentorHostDetails(AccountRecord, userId, proposalID);
    }

    @RemoteAction
    public static List<References__c> checkReferenceEmail(List<string> email, List<Id> ids){
        return Proposal_Controller.checkReferenceEmail(email,ids);
    }

    @RemoteAction
    public static List<Account> getApplicantDetailsForGrantWISER(string applicantHashCode){
        contact conRec = [select name,id,Proposals__c,AccountId,Account.Name from contact where Id =:applicantHashCode limit 1];
        System.debug('conRec-----'+conRec);
        list<Account> applicantList = New list<Account>();
        if(conRec.AccountId != null){
            system.debug('applicantList-----'+applicantList);
            applicantList = [select Id,Name,Proposals__c,(SELECT Id,Title__c,Funding_Agency__c,Budget__c,Starting_Date__c,End_Date__c,Role_in_the_Project__c,Account__c,Application__c,Currency__c FROM Existing_Grants__r),(Select Id,Login_Hash_Code__c From Contacts) from Account where Proposals__c=:conRec.Proposals__c];
            return applicantList;
        }
        return null;
    }
    
    @RemoteAction
    public static String insertExistingGrantsWISER(List<ExistingGrantsWrapper> grantList){
        try{
            system.debug('size ---> '+grantList.size());
            // List<Application_Proposal__c> applicationList = new List<Application_Proposal__c>();
            List<Existing_Grants__c> existingGrantList = New List<Existing_Grants__c>();
            Set<String> ids = New Set<String>();
            for(ExistingGrantsWrapper wrap : grantList){
                system.debug('wrap----'+wrap);
                Existing_Grants__c grantsRec = New Existing_Grants__c();
                grantsRec.Title__c = wrap.title;
                grantsRec.Funding_Agency__c = wrap.fundingagency;
                grantsRec.Account__c = wrap.Account;
                grantsRec.Application__c = wrap.Application;
                grantsRec.Budget__c = wrap.budget;
                grantsRec.Currency__c = wrap.currencyPick;
                grantsRec.Role_in_the_Project__c = wrap.role;
                grantsRec.Starting_Date__c = wrap.startDate;
                grantsRec.End_Date__c = wrap.endDate;
                if(wrap.id != null){
                    grantsRec.id = wrap.id;
                }
                existingGrantList.add(grantsRec);
                ids.add(grantsRec.Application__c);
            }
            system.debug('existingGrantList :: '+existingGrantList);
            // for(String grant : ids){
            //     Application_Proposal__c applicatProposal = New Application_Proposal__c();
            //     applicatProposal.Id = grant;
            //     applicatProposal.Stage__c = '2nd Stage';
            //     applicatProposal.Proposal_Stages__c = 'Submitted';
            //     applicationList.add(applicatProposal);
                
            // }
            // system.debug('applicationList::'+applicationList);
            // upsert applicationList;
            upsert existingGrantList;
            return 'SUCCESS';
            
        }catch(Exception e){
            return e.getMessage(); 
        }
    }

    public class ExistingGrantsWrapper{
        String title;
        String fundingagency;
        String Account;
        String AccountName;
        String budget;
        String currencyPick;
        String id;
        String Application;
        String startDate;
        String endDate;
        String role;
        // Integer startingday;
        // Integer startingmonth;
        // Integer startingyear;
    }

    @RemoteAction
    public Static List<References__c> getProposalDetailsReferences(String proposalId){
        try{
            List<References__c> getParticipantList = [SELECT Id,Name,Email__c,Phone__c,Proposals__c,Organisation_Institute__c,Designation__c FROM References__c WHERE Proposals__c =:proposalId];
            System.debug('getParticipantList ::'+getParticipantList);
            return getParticipantList;
        }catch(Exception e){
                System.debug('The Error '+e.getMessage()+' Line'+e.getLineNumber());
               return null;
            }
    }

    @RemoteAction
    public static void deleteParticipantsReferences(string partcpntId){
        delete New References__c(Id=partcpntId);
    }

    @RemoteAction 
    public Static string insertParticipantsReferences(List<References__c> insertParticipantsList, String proposalId){
        try{
            upsert insertParticipantsList;
            return 'success';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    @RemoteAction
    public static Application_Proposal__c getIntimationLetter(string conId){
        try{
            Application_Proposal__c IntimationLetter = New Application_Proposal__c();
            Contact conRec = [SELECT Id,Proposals__c FROM Contact WHERE Id=:conId];
            if(!string.isBlank(conRec.Proposals__c)){
              IntimationLetter = [SELECT Id,Intimation_Letter_Accepted__c FROM Application_Proposal__c WHERE Id=: conRec.Proposals__c];
            return IntimationLetter; 
            }else{
                return IntimationLetter;  
            }
            
        }catch(Exception e){
            return null;
        }
    }
    
    @RemoteAction
    public static string saveAccepted(Application_Proposal__c details){
        try{
            upsert details;
            return 'success';
            
        }catch(Exception e){
            return e.getMessage();
        }
    }

    @RemoteAction
    public static Application_Proposal__c getTentativeDate(string contactId){
        try{
            Application_Proposal__c appProposal = New Application_Proposal__c();
            Contact conRec = [SELECT Id,Proposals__c FROM Contact Where Id =: contactId];
            if(!string.isBlank(conRec.Proposals__c)){
                appProposal = [SELECT Id,Tentative_Start_Date__c FROM Application_Proposal__c WHERE Id=: conRec.Proposals__c];
            }
            return appProposal;
        }catch(Exception e){
            return null;
        }
    }

    @RemoteAction
    public static string saveTentativeDate(Application_Proposal__c applicantDetails, integer day, integer month, integer year){
        try{
            Application_Proposal__c app = New Application_Proposal__c(); 
            if(day==0 && month==0 && year==0){
                
            }else{
                app.Id = applicantDetails.Id;
                app.Tentative_Start_Date__c = Date.newInstance(year, month, day);
                
            }
            upsert app;
            return 'success';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static List<Contact> getCoordDetails(string projectId){
        return Proposal_Controller.getCoordDetails(projectId);
    }

    @RemoteAction
    public static Contact getConnectContact(string hasCode){
        try{
            Contact conRec = [SELECT Id,FirstName,LastName,Email,Department,Designation__c,Account.Name,Phone,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalCode,
            Proposals__r.Thematic_Area__c,Proposals__r.Title_Of__c,Proposals__r.Title_In_German__c,Proposals__r.Acronym__c,Proposals__r.Proposed_Date__c,Proposals__r.Workshop_Finish_Date__c,
            Proposals__r.Proposed_Venue__c,Proposals__r.Summary__c From Contact WHERE Login_Hash_Code__c =: hasCode];
            return conRec;
        }catch(Exception e){
            return null;
        }
    }

    @RemoteAction
    public static Account getHostDetailsConnect(string ptojectId){
        try{
            Account accRec = [SELECT Id,Name,BillingStreet,BillingCity,BillingCountry,BillingState,BillingPostalCode,Name_of_Mentor__c,
            Designation_Position_of_the_Mentor__c,Mentor_contact_number__c,Mentor_E_mail_Id__c From Account Where Host__c =: true AND Proposals__c=:ptojectId];
            return accRec;
        }catch(Exception e){
            return null;
        }
    }

    @RemoteAction
    public static string insertConnectadditionalPoints(Contact contactDetails, Account hostAccountRecord, Application_Proposal__c appRecord, integer day, integer month, integer year, integer endday, integer endmonth, integer endyear){
        try{
            if(day==0 && month==0 && year==0){
                
            }else{
                appRecord.Proposed_Date__c = Date.newInstance(year, month, day);
                
            }
            if(endday==0 && endmonth==0 && endyear==0){
                
            }else{
                appRecord.Workshop_Finish_Date__c = Date.newInstance(endyear, endmonth, endday);
                
            }
            hostAccountRecord.Proposals__c = appRecord.Id;
            hostAccountRecord.Host__c = true;
            upsert hostAccountRecord;
            upsert appRecord;
            upsert contactDetails;
            return 'success';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    @RemoteAction
    public static List<Contact> checkBulkEmail(List<string> email, List<Id> ids){
        try{
            List<Contact> refList = [SELECT Id,Name,Email FROM Contact WHERE Email IN: email AND Id NOT IN: ids];
            return refList;
        }catch(Exception e){
            return null;
        }
    }

    @RemoteAction
    public static Account getHostSing(string projectId){
        try{
            Account acc = [SELECT Id,Name,Email__c,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode,Phone,(SELECT Id,FirstName,LastName,Name,Designation__c,Email,
            MobilePhone,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalCode,Department FROM Contacts) From Account WHERE Proposals__c=: projectId AND Host__c = true];
            return acc;
        }catch(Exception e){
            return null;
        }
    }
    
    @RemoteAction
    public static string saveHostDetails(Account accRecord, Contact conRec, string projectId){
        try{
            accRecord.Proposals__c = projectId;
            accRecord.Host__c = true;
            upsert accRecord;
            conRec.AccountId = accRecord.Id;
            upsert conRec;
            return 'success';

        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
}