public withOut sharing class Proposal_Controller {
    
    /* public string thematicAreaList {get;set;}
public string duration  {get;set;}
public String ApplicantPortalSiteURL {get;set;}
public String candidateId {get;set;}

public Proposal_Controller(){
ApplicantPortalSiteURL = Constants.CANDIDATE_SITE ;
thematicAreaList = JSON.serialize(fetchAllThematicArea());
duration = JSON.serialize(Utility.getPicklistValues('Application_Proposal__c' , 'Duration_In_Months_Max_36__c'));
candidateId = Apexpages.currentPage().getParameters().get('id'); 
system.debug('candidateId---'+candidateId);
}*/
    
    //************************************** PROJECT DETAIL PAGE ***********************************************
    
    
    public static Application_Proposal__c getApplicantDetails(string applicantHashCode){
        
        contact conRec = [select name,id,Proposals__c from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
        system.debug('applicantHashCode' +applicantHashCode);
        Application_Proposal__c proposalRecord;
        if(!string.isBlank(conRec.Proposals__c)){
            proposalRecord = [SELECT id,Name,Acronym__c,Title_Of__c,Title_In_German__c,Thematic_Topic__c,Duration_In_Months_Max_36__c,Tentative_Start_Date__c,Summary__c,KeyWords__c,Abstract_of_proposed__c,Project_Description__c,Stage__c,Proposed_Venue__c,Proposed_Date__c,(select name,id,Thematic_Area_Name__c	 from Application_Thematic_Area__r) FROM Application_Proposal__c WHERE Id=: conRec.Proposals__c];
            system.debug('proposalRecord----'+proposalRecord);
            return proposalRecord;
        }else{
            return proposalRecord;  
        }     
    }
    
    
    public static String insertApplication(Application_Proposal__c applicantDetails, List<string> setThemeList, integer day, integer month, integer year,String conId, String recordType){
        try{
            //system.debug('day----'+day+'---month----'+month+'year----'+year);
            if(day==0 && month==0 && year==0){
                
            }else{
                applicantDetails.Tentative_Start_Date__c = Date.newInstance(year, month, day);
                
            }
            
            applicantDetails.Stage__c = '1st Stage';
            applicantDetails.RecordTypeId = Utility.getProposalRecordType('Two Plus Two');
            applicantDetails.Proposal_Stages__c = 'Draft';
            upsert applicantDetails;
            system.debug('setThemeList----'+setThemeList);
            List<Application_Thematic_Area__c> deleteInstance=new List<Application_Thematic_Area__c>();
            deleteInstance=[select id from Application_Thematic_Area__c where Application__c=:applicantDetails.Id];
            delete deleteInstance;
            List<Application_Thematic_Area__c> appThemeticAreaList = New List<Application_Thematic_Area__c>();
            for(string theme:setThemeList){
                appThemeticAreaList.add(new Application_Thematic_Area__c(Application__c=applicantDetails.Id,Thematic_Area__c=theme));
            }
            system.debug('appThemeticAreaList----'+appThemeticAreaList);
            upsert appThemeticAreaList;
            system.debug('appThemeticAreaList-----------'+appThemeticAreaList);
            Contact con = new Contact(Id=conId,Proposals__c = applicantDetails.Id);
            update con;
            contact conRec = [select id,AccountId from Contact where id=:con.Id];
            if(!string.isBlank(conRec.AccountId)){
                Account acc = New Account();
                acc.Id = conRec.AccountId;
                acc.Proposals__c = applicantDetails.Id;
                update acc;
            }
            return applicantDetails.Id;
        }catch(Exception e){
            system.debug('exception ----'+e.getLineNumber()+'-----'+e.getMessage());
            return e.getLineNumber()+'-----'+e.getMessage();
        }
    }
    
    
    public static List<Thematic_Area__c> fetchAllThematicArea(){
        List<Thematic_Area__c> thematicAreaList = [SELECT Id,Name FROM Thematic_Area__c];
        if(!thematicAreaList.isEmpty()){
            return thematicAreaList;
        }
        return thematicAreaList;
    }
    
    public static  void deleteThematicArea(String themeId){
        delete new Application_Thematic_Area__c(id=themeId);
    }
    
    //********************************** CONSORTIA DETAILS ***************************************************
    
    
    public static string insertAccount(List<Account> accountDetails,List<Contact> contactDetails){
        try{
            upsert accountDetails;
            upsert contactDetails;
            return 'success';
        }catch (Exception e){
            return 'error';   
        }
    }
    
    
    public static string insertAccountAndContact(account accDetails, list<contact> conListToInsert){
        upsert accDetails;
        for(contact con:ConListToInsert){
            con.AccountId = accDetails.Id;
        }
        upsert ConListToInsert;
        return 'success';
    }
    
    public static string insertConsortiaDetailPage(list<ConsortiaDetails> ConsortiaDetailsList,string projectId){
        system.debug('accDetails---'+ConsortiaDetailsList);
        List<contact> contactToInsert = New List<contact>();
        List<Account> accountToInsert = New List<Account>();
        Map<string,List<contact>> accNameXcontactList = New Map<string,List<contact>>();
        for(ConsortiaDetails consortia:ConsortiaDetailsList){
            Account companyDetails = New Account(Name=consortia.company.Name,Website=consortia.company.Website,Country_Type__c=consortia.company.Country_Type__c,Proposals__c=projectId);
            if(!string.isBlank(consortia.company.Id)){
                companyDetails.Id = consortia.company.Id;
            }
            accountToInsert.add(companyDetails);
            accNameXcontactList.put(consortia.company.Name,consortia.partnerDetails);
        }
        system.debug('accNameXcontactList---'+accNameXcontactList);
        system.debug('accountToInsert---'+accountToInsert);
        upsert accountToInsert;
        Map<string,string> accNameXId = New Map<string,string>();
        for(Account acc:accountToInsert){
            accNameXId.put(acc.Name,acc.Id);
        }
        
        system.debug('accNameXId---'+accNameXId);
        for(string accName:accNameXcontactList.keyset()){
            for(Contact con : accNameXcontactList.get(accName)){
                con.AccountId = accNameXId.get(accName);
                con.Proposals__c = projectId;
                contactToInsert.add(con);
            }
        }
        system.debug('contactToInsert---'+contactToInsert);
        upsert contactToInsert;
        return 'success';
    }
    
    
    public static list<account> getPatnerDetails(string applicantHashCode){
        system.debug('applicantHashCode---'+applicantHashCode);
        contact conRec = [select name,id,Proposals__c,Account.Name,account.Website, 
        account.Id,account.Is_Coordinator__c,account.Is_Primary__c,account.Year_Of_Establishment__c,account.Last_Year_s_Balance__c,account.SME__c, account.Homepage_URL__c,account.Country_Type__c,account.Industry__c,
        account.Email__c,account.Is_DSIR_Available__c,account.DSIR_Recoginition_Details__c,account.Company_Profile__c,account.Ownership_Profile__c,account.Company_Website__c,account.Academia__c,account.Phone,account.Main_Business_Area__c,account.Infrastructural_Facilities__c,
        account.Domain_Expertise_Available__c,account.Large_Industry__c,account.Start_Up__c,account.BillingStreet,account.BillingCity,account.BillingState,account.BillingPostalCode,account.BillingCountry,account.Department__c
        from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
        list<contact> applicantList = New list<contact>();
        system.debug('conRec.Proposals__c---'+conRec.Proposals__c);
        if(!string.isBlank(conRec.Proposals__c)){
            List<account> accountContactList = [select Name,Website,Id,Is_Coordinator__c,Is_Primary__c,Year_Of_Establishment__c,Last_Year_s_Balance__c,SME__c, Homepage_URL__c,Country_Type__c,Industry__c,
                                                Email__c,Is_DSIR_Available__c,DSIR_Recoginition_Details__c,Company_Profile__c,Ownership_Profile__c,Company_Website__c,Academia__c,Phone,Main_Business_Area__c,Infrastructural_Facilities__c,
                                                Domain_Expertise_Available__c,Large_Industry__c,Start_Up__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Department__c,
                                                (select Title,name,id,Designation__c,FirstName,LastName,Email,Phone,Actual_Position__c,Head_Of_Project__c,Department,Profile_Pic_Attachment_Id__c from contacts order By createdDate ASC) from account where Proposals__c =:conRec.Proposals__c order By createdDate ASC]; 
            system.debug('accountContactList---'+accountContactList);
            return accountContactList;
        }
        return null;
    }
    public static contact getSinglePatnerDetails(string applicantHashCode){
        system.debug('applicantHashCode---'+applicantHashCode);
        try{
        contact conRec = [select name,id,Proposals__c,Account.Name,account.Website, 
        account.Id,account.Is_Coordinator__c,account.Is_Primary__c,account.Year_Of_Establishment__c,account.Last_Year_s_Balance__c,account.SME__c, account.Homepage_URL__c,account.Country_Type__c,account.Industry__c,
        account.Email__c,account.Is_DSIR_Available__c,account.DSIR_Recoginition_Details__c,account.Company_Profile__c,account.Ownership_Profile__c,account.Company_Website__c,account.Academia__c,account.Phone,account.Main_Business_Area__c,account.Infrastructural_Facilities__c,
        account.Domain_Expertise_Available__c,account.Large_Industry__c,account.Start_Up__c,account.BillingStreet,account.BillingCity,account.BillingState,account.BillingPostalCode,account.BillingCountry,account.Department__c
        from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
        return conRec;
        }
        catch(Exception e){
            system.debug('error -->'+e.getMessage());
            return null;
        }
        // list<contact> applicantList = New list<contact>();
        // system.debug('conRec.Proposals__c---'+conRec.Proposals__c);
        // if(!string.isBlank(conRec.Proposals__c)){
        //     List<account> accountContactList = [select Name,Website,Id,Is_Coordinator__c,Is_Primary__c,Year_Of_Establishment__c,Last_Year_s_Balance__c,SME__c, Homepage_URL__c,Country_Type__c,Industry__c,
        //                                         Email__c,Is_DSIR_Available__c,DSIR_Recoginition_Details__c,Company_Profile__c,Ownership_Profile__c,Company_Website__c,Academia__c,Phone,Main_Business_Area__c,Infrastructural_Facilities__c,
        //                                         Domain_Expertise_Available__c,Large_Industry__c,Start_Up__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Department__c,
        //                                         (select name,id,FirstName,LastName,Email,Phone,Actual_Position__c,Head_Of_Project__c,Department,Profile_Pic_Attachment_Id__c from contacts order By createdDate ASC) from account where Proposals__c =:conRec.Proposals__c order By createdDate ASC]; 
        //     system.debug('accountContactList---'+accountContactList);
        //     return accountContactList;
        // }        
    }
    public static  list<account> getPatnerDetails2(string applicantHashCode){
        system.debug('applicantHashCode---'+applicantHashCode);
        contact conRec = [select name,id,Proposals__c from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
        list<contact> applicantList = New list<contact>();
        system.debug('conRec.Proposals__c---'+conRec.Proposals__c);
        if(!string.isBlank(conRec.Proposals__c)){
            List<account> accountContactList = [select Name,Id, Homepage_URL__c,Country_Type__c,Academia__c,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,Department__c,Industry__c,
                                                (select Salutation,Name,FirstName,Id,LastName,Email,Phone,Department from contacts order By createdDate ASC) from account where Proposals__c =:conRec.Proposals__c order By createdDate ASC]; 
            system.debug('accountContactList---'+accountContactList);
            return accountContactList;
        }
        return null;
    }
    
    public static  void deleteContact(string contactId){
        delete new Contact(id=contactId);
    }
    
    public static  void deleteAccountDetails(string accId, list<string> contactIdList){
        
        List<contact> contactToDelete = NEw List<contact>();
        if(contactIdList.size() > 0){
            for(string cId:contactIdList){
                contactToDelete.add(New Contact(Id=cId));
            }
            delete contactToDelete;
        }
        Account accTODelete = new Account(id=accId);
        delete accTODelete;
        
    }
    
    //*************************************** CONSORTIUM PARTNER INFORMATION *********************************************
    
    
    public static String insertPartnerInformation(Account contactDetails){
        try{
            upsert contactDetails;
            return 'SUCCESS';
        }catch(Exception e){
            return 'ERROR';
        }
    }
    
    //************************************* CURRICULUM VITAE *********************************************************
    
    
    public static String insertContactDetails(List<Contact> contactDetails, List<Education_Details__c> educationDetails, List<Employment_Details__c> employmentDetails, List<Publications_Patents__c> publicationDetails){
        try{
            Upsert contactDetails;
            for(Contact con : contactDetails){
                for(Education_Details__c edu : educationDetails){
                    edu.Contact__c = con.Id;
                }
                Upsert educationDetails;
                for(Employment_Details__c emp : employmentDetails){
                    emp.Contact__c = con.Id;
                }
                Upsert employmentDetails;
                for(Publications_Patents__c patent : publicationDetails){
                    patent.Contact__c = con.Id;
                }
                Upsert publicationDetails;
            }
            return 'SUCCESS'; 
        }catch(exception e){
            system.debug('error -->'+e.getMessage());
            return 'ERROR';
        }
    }
    
    
    public static Contact getContactDetails(string hashCode){
        Contact conRec = [SELECT Id,Name,FirstName,LastName,Proposals__r.Name,Actual_Position__c,Department,Country__c,
                          Head_Of_Project__c,Homepage_URL__c,Email,Phone,Thesis_Submission_Date__c,Industrial_Fellowship_Type__c,Birthdate,PhD_Enroll_Date__c,Awarded_PhD__c,Country_Code__c,Uploaded__c,
                          PhD_Awarded_Date__c,Gender__c,Nationality__c,PassportNo__c,Passport_Expiry__c,Addess_same_as__c,MailingAddress,MailingStreet,MailingCity,MailingCountry,MailingState,MailingPostalCode,
                          OtherAddress,OtherStreet,OtherCountry,OtherCity,OtherState,OtherPostalCode,MobilePhone,OtherPhone,Profile_Pic_Attachment_Id__c,Proposals__r.Campaign__r.EndDate,(SELECT Id,Name,Institution_Name__c,Area_of_specialization__c,End_Year__c FROM Education_Details__r),
                          (SELECT Id,Name,Organization_Name__c,Position__c,End_Year__c FROM Employment_Details__r),(select name,id,description__c from Publications_Patents__r),(select name,id from Attachments Order By CreatedDate DESC limit 1)
                          From Contact WHERE Login_Hash_Code__c=: hashCode Limit 1];
        return conRec; 
    }
    
    public static Contact getCvDetails(string contactId){
        Contact conRec = [SELECT Id,Name,FirstName,LastName,Actual_Position__c,MailingCity,MailingState,MailingStreet,MailingCountry,Department,MailingPostalCode,
                          Head_Of_Project__c,Homepage_URL__c,Email,Phone,(SELECT Id,Name,Institution_Name__c,Area_of_specialization__c,Degree__c,End_Year__c FROM Education_Details__r),
                          (SELECT Id,Name,Organization_Name__c,Position__c,End_Year__c FROM Employment_Details__r),(select name,id,description__c from Publications_Patents__r)
                          From Contact WHERE Id=: contactId Limit 1];
        return conRec; 
    }
    
    //******************************************* COMPANY PROFILE *********************************************
    
    
    public static  Account getCompanyApplicantDetails(string applicantHashCode){
        contact conRec = [select name,id,AccountId from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
        system.debug('applicantHashCode' +applicantHashCode);
        if(conRec.AccountId != Null){
            Account acc = [SELECT id,Name,Year_Of_Establishment__c,Last_Year_s_Balance__c,Main_Business_Area__c,NumberOfEmployees,Infrastructural_Facilities__c,Domain_Expertise_Available__c,DSIR_Recoginition_Details__c,Large_Industry__c,SME__c,Start_Up__c FROM Account WHERE Id=: conRec.AccountId];
            return acc;
        }else{
            return Null;  
        }     
    }
    
    
    public static Account insertApplicant(Account applicantDetails){
        try{
            applicantDetails.NumberOfEmployees = integer.valueOf(applicantDetails.NumberOfEmployees);
            system.debug('applicantDetails.NumberOfEmployees ::'+applicantDetails.NumberOfEmployees);
            upsert applicantDetails;
            return applicantDetails;
        }catch (Exception e){
            system.debug('error ::'+e.getMessage());
            return null;   
        }
    }
    
    //****************************************** FINANCIAL OVERVIEW ***************************************************
    
    
    public static  list<Account> getProjectDetailsDetails(string applicantHashCode){
        system.debug('applicantHashCode---'+applicantHashCode);
        //Financial_Overview_Conditions__c financialConDetails = [SELECT German_Academia__c,German_Institute__c,Indian__c,Indian_Institute__c FROM Financial_Overview_Conditions__c];
        contact conRec = [select name,id,Proposals__c,AccountId,Account.Name from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
        list<Account> applicantList = New list<Account>();
        if(conRec.AccountId != null){
            applicantList = [select Id,Name,Country_Type__c,BillingCountry,Industry__c,Academia__c,(SELECT Id,Asked_From_IGSTC__c,IGSTC_Contribution__c,Own_Contribution__c,Total__c,Account_Type__c,Country__c,Account__c,Partner__c,Partner__r.AccountId,Account__r.Name FROM Financial_Contribution__r),(Select Id,Login_Hash_Code__c,Account.Name From Contacts),Proposals__r.Total_Amount__c from Account  where Proposals__c=:conRec.Proposals__c];
            return applicantList;
        }
        system.debug('applicantList--'+applicantList);
        return applicantList;
    }
    
    
    public static String insertFinancialDetails(List<Financial_Contribution__c> financialDetails){
        try{
            upsert financialDetails;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getLineNumber() + e.getMessage();
        }
    }
    
    //*************************************** PROJECT DETAIL ********************************************
    
    
    public static string insertProjectDetails(Application_Proposal__c proposalDetails){
        try{
            upsert proposalDetails;
            return 'Success';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    
    public static Application_Proposal__c getProjectdetils(string hashcode){
        contact userDetail = [select name,id,Proposals__c from contact where Login_Hash_Code__c =:hashcode limit 1];
        system.debug('userDetail ::'+userDetail.Proposals__c);
        Application_Proposal__c appProposal;
        if(userDetail.Proposals__c != null){
            appProposal = [select name,id,Research_Approach_Objectives__c,Current_State_Of_The_Art__c,Project_Description__c,Expected_Deliverables__c,Equipment__c,
                           Reasons_For_And_Benefits_Of_Cooperation__c,Criteria_For_Abandoning_The_Project__c,Innovative_Aspects__c,Research_Scholars__c,
                           Necessity_Of_Funding__c,Background_Concept_Purpose__c,Specific_Need_For_the_Bilateral_Event__c,Privacy_Policy_Accepted__c,
                           Basis_for_choosing_the_pairing_fellow__c,Tentative_plans_for_networking__c,Tentative_Start_Date__c,Tentative_End_Date__c,Availing_any_other_fellowship_currently__c,
                           Availing_Other_Fellowship_Detail__c,Paired_Applicant_associated_with_IGSTC__c,Applicant_associated_with_IGSTC_Detail__c from Application_Proposal__c where id=:userDetail.Proposals__c Limit 1];
        }
        system.debug('appproposal ::'+appProposal);
        return appProposal;
    }
    
    
    //////////////////////////////////////////// FOR Signature Pecfar ///////////////////////////////////////////

    public static String doCUploadAttachment(String attachmentBody, String attachmentName, string cvId, String udId) {
        system.debug('attachmentBody---'+attachmentName+'---attachmentId---'+cvId+'---cvId---'+udId);
        if(String.isBlank(attachmentBody) || String.isBlank(udId))
            return 'ERROR';
        if(String.isBlank(cvId)) {
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
            conVer.PathOnClient = 'attachmentName'; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = 'Signature - '+attachmentName; // Display name of the files
            conVer.VersionData = EncodingUtil.base64Decode(attachmentBody); // converting your binary string to Blog
            conVer.isMajorVersion = false;
            insert conVer;    //Insert ContentVersion
            
            ContentDistribution cdl = new ContentDistribution();
            cdl.ContentVersionId = conVer.Id;
            cdl.Name = 'PublicShare';
            cdl.RelatedRecordId = udId;
            insert cdl;
            system.debug('ContentDistribution----'+cdl);
            // First get the Content Document Id from ContentVersion Object
            Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
            //create ContentDocumentLink  record 
            ContentDocumentLink conDocLink = New ContentDocumentLink();
            conDocLink.LinkedEntityId = udId; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
            conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
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
                    cVersion.VersionData = EncodingUtil.base64Decode(newBody); // converting your binary string to Blog
                    update cVersion;
                    return cVersion.Id;
                }   
            }
        }
        return 'ERROR';
    }

    public static string createUserDocument(string udId, string conId, string pId, string fileId){
        try{
            User_Document__c userDocRecord = New User_Document__c();
            system.debug('udId----'+udId);
            if(!String.isBlank(udId)){
                userDocRecord.Id = udId;
            }
            userDocRecord.contact__c = conId;
            userDocRecord.proposals__c = pId;
            userDocRecord.Status__c = 'Uploaded';
            userDocRecord.Name = 'Signature';
            upsert userDocRecord;
            
            return userDocRecord.Id;
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();        }
    }

    public static string createUserDocumentPecfarDoc(string udId, string conId, string pId, string fileId){
        try{
            User_Document__c userDocRecord = New User_Document__c();
            system.debug('udId----'+udId);
            if(!String.isBlank(udId)){
                userDocRecord.Id = udId;
            }
            userDocRecord.contact__c = conId;
            userDocRecord.proposals__c = pId;
            userDocRecord.Status__c = 'Uploaded';
            userDocRecord.Name = 'Documents';
            upsert userDocRecord;
            
            return userDocRecord.Id;
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();        }
    }
    
    //************************************** WORK PACKAGE **********************************************************
    
    public static  list<Account> getWorkPackageDetails(string applicantHashCode){
        system.debug('applicantHashCode---'+applicantHashCode);
        contact conRec = [select name,id,Proposals__c,AccountId,Account.Name from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
        list<Account> applicantList = New list<Account>();
        if(conRec.AccountId != null){
            applicantList = [select Id,Name,(SELECT Id,TRL_Level__c,Application__c,Title__c,Duration__c,Account__r.Proposals__c FROM Work_Package__r) from Account where Proposals__c=:conRec.Proposals__c];
            return applicantList;
        }
        system.debug('applicantList--'+applicantList);
        return applicantList;
    }
    
    // public static String insertWPContactDetails(List<Work_Package__c> workPackDetails){
    //     try{
    
    //         Map<Id,Application_Proposal__c> applicationMap = new Map<Id,Application_Proposal__c>();
    
    //         List<String> workPackageList = new List<String>();
    
    //         System.debug('WorkPackDetails------'+workPackDetails);
    //         for(Work_Package__c wp : workPackDetails){
    //             workPackageList.add(wp.Id);
    //             if(!applicationMap.containsKey(wp.Application__c)){
    //                 applicationMap.put(wp.Application__c,new Application_Proposal__c(Id = wp.Application__c,Stage__c = '1st Stage',Proposal_Stages__c = 'Submitted'));
    //             }
    //             //wp.Application__r.Proposal_Stages__c = 'Submitted';
    //         }
    //         system.debug('applicationList ::'+applicationMap);
    //         if(!workPackageList.isEmpty()){
    //             // List<Work_Package__c> packageList = [SELECT Id,Application__c From Work_Package__c Where Id IN :workPackageList];
    //             // system.debug('packageList ::'+packageList);
    //             // for(Work_Package__c work : packageList){
    //             //     applicationList.add(new Application_Proposal__c(Id = work.Application__c,Stage__c = '1st Stage',Proposal_Stages__c = 'Submitted'));
    //             // }
    //             // system.debug('applicationList ::'+applicationList);
    //             upsert workPackDetails;
    //             upsert applicationMap.values();
    //         }
    //         return 'SUCCESS';
    
    //     }catch(Exception e){
    //         System.debug('The Error is  :'+e.getMessage());
    //         return e.getMessage(); 
    //     }
    // }
    
    // public static  String insertWPContactDetailsAsDraft(List<Work_Package__c> workPackDetails){
    
    //     //system.debug('applicationList ::'+applicationList);
    //             system.debug('workPackDetails ::'+workPackDetails);
    //     try{
    //         List<String> workPackageList = new List<String>();
    //         List<Application_Proposal__c> applicationList = new List<Application_Proposal__c>();
    //         for(Work_Package__c wp : workPackDetails){
    //             workPackageList.add(wp.Id);
    //         }
    //         if(!workPackageList.isEmpty()){
    //             List<Work_Package__c> workList = [SELECT Id,Application__c From Work_Package__c Where Id IN :workPackageList];
    //             for(Work_Package__c wp : workList){
    //                 Application_Proposal__c proposal = New Application_Proposal__c();
    //                 proposal.Id = wp.Application__c;
    //                 proposal.Stage__c = '1st Stage';
    //                 proposal.Proposal_Stages__c = 'Draft';
    //                 applicationList.add(proposal);
    //             }
    
    //             upsert applicationList;
    //             upsert workPackDetails;
    //         }
    
    //         return 'SUCCESS';
    
    //     }catch(Exception e){
    //         System.debug('The Error is  :'+e.getMessage());
    //         return e.getMessage()/*'ERROR'*/; 
    //     }
    // }
    
    // public static  void deleteWorkPackage(string wpId){
    //     delete new Work_Package__c(id=wpId);
    // }
    
    //************************************** PI Deliverables **********************************************************
    
    public class PiWrapper{
        String title;
        String Account;
        String id;
        Integer day;
        Integer month;
        Integer year;
    }
    
    public static  list<Account> getProjectDetailsForPI(string applicantHashCode){
        system.debug('applicantHashCode---'+applicantHashCode);
        contact conRec = [select name,id,Proposals__c,AccountId,Account.Name from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
        list<Account> applicantList = New list<Account>();
        if(conRec.AccountId != null){
            applicantList = [select Id,Name,(SELECT Id,Title__c,Due_Date__c,Account__c FROM PI_Deliverables__r) from Account where Proposals__c=:conRec.Proposals__c];
            return applicantList;
        }
        // if(!string.isBlank(conRec.Proposals__c)){
        //     applicantList = [select name,id,FirstName,LastName,(SELECT Id,Title__c,Due_Date__c,Responsible_Partner__c FROM PI_Deliverables__r) from Contact  where Proposals__c=:conRec.Proposals__c];
        //     return applicantList;
        // }
        system.debug('applicantList--'+applicantList);
        return applicantList;
    }
    
    public static  String insertDeliverables(List<PiWrapper> deliverableList){
        try{
            system.debug('deliverableList------'+deliverableList);
            List<PI_Deliverables__c> PIList = New List<PI_Deliverables__c>();
            for(PiWrapper wrap : deliverableList){
                PI_Deliverables__c pi = New PI_Deliverables__c();
                pi.Title__c = wrap.Title;
                pi.Account__c = wrap.Account;
                if(wrap.id != null){
                    pi.Id = wrap.id;
                }
                if(wrap.year != 0){
                    pi.Due_Date__c = Date.newInstance(wrap.year, wrap.month, wrap.day);
                }
                PIList.add(pi);
                system.debug('ghoomar ghoomar'+pi);
            }
            system.debug('goome re');
            system.debug('PIList --------> '+PIList);
            upsert PIList;
            return 'SUCCESS';
            
        }catch(Exception e){
            System.debug('The Error is  :'+e.getMessage());
            return e.getMessage(); 
        }
    }
    
    //************************************** Network Meeting **********************************************************
    
    // public class NetworkMeetWrapper{
    //     String meetingAgenda;
    //     String meetingVenue;
    //     String Account;
    //     String id;
    //     Integer tentativeday;
    //     Integer tentativemonth;
    //     Integer tentativeyear;
    //     Integer actualday;
    //     Integer actualmonth;
    //     Integer actualyear;
    // }
    
    // public static list<Account> getProjectDetailsForNetMeet(string applicantHashCode){
    //     contact conRec = [select name,id,Proposals__c,AccountId,Account.Name from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
    //     list<Account> applicantList = New list<Account>();
    //     if(conRec.AccountId != null){
    //         applicantList = [select Id,Name,(SELECT Id,Meeting_Agenda__c,Meeting_Venue__c,Tentative_Date__c,Participants__c,Actual_Date__c,Account__c FROM Network_Meetings__r) from Account where Proposals__c=:conRec.Proposals__c];
    //         return applicantList;
    //     }
    //     // if(!string.isBlank(conRec.Proposals__c)){
    //     //     applicantList = [select name,id,(SELECT Id,Meeting_Agenda__c,Meeting_Venue__c,Tentative_Date__c,Participants__c,Actual_Date__c,Contact__c FROM Network_Meetings__r) from Contact  where Proposals__c=:conRec.Proposals__c];
    //     //     return applicantList;
    //     // }
    //     return applicantList;
    // }
    
    
    // public static String insertMeetingDetails(List<NetworkMeetWrapper> meetingList){
    //     try{
    
    //         system.debug('size ---> '+meetingList.size());
    //         List<Network_Meeting__c> netMeetList = New List<Network_Meeting__c>();
    //         for(NetworkMeetWrapper wrapp : meetingList){
    //             Network_Meeting__c netMeet = New Network_Meeting__c();
    //             netMeet.Meeting_Agenda__c = wrapp.meetingAgenda;
    //             netMeet.Meeting_Venue__c = wrapp.meetingVenue;
    //             netMeet.Account__c = wrapp.Account;
    //             if(wrapp.id != null){
    //                 netMeet.id = wrapp.id;
    //             }
    //             if(wrapp.tentativeyear != 0){
    //                 netMeet.Tentative_Date__c = Date.newInstance(wrapp.tentativeyear, wrapp.tentativemonth, wrapp.tentativeday);
    //             }
    //             if(wrapp.actualyear != 0){
    //                 netMeet.Actual_Date__c = Date.newInstance(wrapp.actualyear, wrapp.actualmonth, wrapp.actualday);
    //             }
    //             netMeetList.add(netMeet);
    //         }
    //         system.debug('netMeetList :: '+netMeetList);
    //         upsert netMeetList;
    //         return 'SUCCESS';
    
    //     }catch(Exception e){
    //        return e.getMessage(); 
    //     }
    // }
    
    // public static  void deleteMeeting(string netId){
    //     delete new Network_Meeting__c(id=netId);
    // }
    
    //************************************** Grant Application **********************************************************
    
    public class ExistingGrantsWrapper{
        String title;
        String fundingagency;
        String Account;
        String AccountName;
        Integer duration;
        String budget;
        String id;
        String Application;
        Integer startingday;
        Integer startingmonth;
        Integer startingyear;
    }
    
    public static List<Account> getApplicantDetailsForGrant(string applicantHashCode){
        contact conRec = [select name,id,Proposals__c,AccountId,Account.Name from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
        list<Account> applicantList = New list<Account>();
        if(conRec.AccountId != null){
            applicantList = [select Id,Name,Proposals__c,(SELECT Id,Title__c,Funding_Agency__c,Budget__c,Starting_Date__c,Duration__c,Account__c,Application__c FROM Existing_Grants__r),(Select Id,Login_Hash_Code__c From Contacts) from Account where Proposals__c=:conRec.Proposals__c];
            return applicantList;
        }
        return applicantList;
    }
    
    public static String insertExistingGrants(List<ExistingGrantsWrapper> grantList){
        try{
            system.debug('size ---> '+grantList.size());
            List<Application_Proposal__c> applicationList = new List<Application_Proposal__c>();
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
                grantsRec.Duration__c = wrap.duration;
                if(wrap.id != null){
                    grantsRec.id = wrap.id;
                }
                if(wrap.startingyear != 0){
                    // grantsRec.Starting_Date__c = Date.newInstance(wrap.startingyear, wrap.startingmonth, wrap.startingday);
                }
                existingGrantList.add(grantsRec);
                ids.add(grantsRec.Application__c);
            }
            system.debug('existingGrantList :: '+existingGrantList);
            for(String grant : ids){
                Application_Proposal__c applicatProposal = New Application_Proposal__c();
                applicatProposal.Id = grant;
                applicatProposal.Stage__c = '2nd Stage';
                applicatProposal.Proposal_Stages__c = 'Submitted';
                applicationList.add(applicatProposal);
                
            }
            system.debug('applicationList::'+applicationList);
            upsert applicationList;
            upsert existingGrantList;
            return 'SUCCESS';
            
        }catch(Exception e){
            return e.getMessage(); 
        }
    }
    
    public static String insertExistingGrantsAsDraft(List<ExistingGrantsWrapper> grantList){
        try{
            system.debug('size ---> '+grantList.size());
            List<Application_Proposal__c> applicationList = new List<Application_Proposal__c>();
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
                grantsRec.Duration__c = wrap.duration;
                if(wrap.id != null){
                    grantsRec.id = wrap.id;
                }
                if(wrap.startingyear != 0){
                    // grantsRec.Starting_Date__c = Date.newInstance(wrap.startingyear, wrap.startingmonth, wrap.startingday);
                }
                existingGrantList.add(grantsRec);
                ids.add(grantsRec.Application__c);
            }
            system.debug('existingGrantList :: '+existingGrantList);
            for(String grant : ids){
                Application_Proposal__c applicatProposal = New Application_Proposal__c();
                applicatProposal.Id = grant;
                applicatProposal.Stage__c = '2nd Stage';
                applicatProposal.Proposal_Stages__c = 'Draft';
                applicationList.add(applicatProposal);
                
            }
            system.debug('applicationList::'+applicationList);
            upsert applicationList;
            upsert existingGrantList;
            return 'SUCCESS';
            
        }catch(Exception e){
            return e.getMessage(); 
        }
    }

    public static string insertWiserDraft(string projectId, integer day, integer month, integer year){
        try{
            Application_Proposal__c applicantDetails = New Application_Proposal__c();
            if(day==0 && month==0 && year==0){
                
            }else{
                applicantDetails.Proposed_Date__c = Date.newInstance(year, month, day);    
            }
            applicantDetails.Id = projectId;
            applicantDetails.Proposal_Stages__c = 'Draft';
            upsert applicantDetails;
            return 'success';

        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }

    public static string finalSubmitWiser(string projectId, string conId, integer day, integer month, integer year){
        try{
            Contact con = New Contact();
            Application_Proposal__c applicantDetails = New Application_Proposal__c();
            if(day==0 && month==0 && year==0){
                
            }else{
                Date newDate=Date.newInstance(year,month,day);
                con.Id = conId;
                con.Declaration_Sign_Date__c=newDate;
                applicantDetails.Proposed_Date__c = Date.newInstance(year, month, day);    
            }
            applicantDetails.Id = projectId;
            applicantDetails.Proposal_Stages__c = 'Submitted';
            applicantDetails.Submitted__c = true;
            upsert applicantDetails;
            upsert con;
            return 'success';

        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }
    
    public static  void deleteGrants(string grantstId){
        delete new Existing_Grants__c(id=grantstId);
    }
    
    public static MyProposalWapper fetchProjectDetails(String projectId){
        try{
            Application_Proposal__c ProposalRec = [SELECT Id,Name,Document_generated__c,(select id,name from attachments order by createdDate desc limit 1)Project_Description__c,Reasons_For_And_Benefits_Of_Cooperation__c,Research_Approach_Objectives__c,
                                                   Necessity_Of_Funding__c,Research_Scholars__c,Summary__c,Title_Of__c,Campaign__r.Name,Campaign__r.RedirectPage__c
                                                   FROM Application_Proposal__c WHERE Id =: projectId];

                                                   List<contact> instanceContact=[select id,Name,MailingCountry from contact where Proposals__c=:projectId];
                                                   MyProposalWapper myProposalInstance=new MyProposalWapper();
                                                   myProposalInstance.contactWrap=instanceContact;
                                                   myProposalInstance.proposalWrap= ProposalRec;
            return myProposalInstance;
        }catch(Exception e){
            return null;
        }
    }
    public class MyProposalWapper{
        public List<Contact> contactWrap;
        public Application_Proposal__c proposalWrap;
    }
    public class ConsortiaDetails{
        public Account company;
        public List<contact> partnerDetails;
    }
    
    //************************************** Privacy Policy Acceptance **********************************************************
    
    public static string insertPrivacyPolicy(Application_Proposal__c proposalDetails){
        try{
            proposalDetails.Stage__c = '1st Stage';
            proposalDetails.Proposal_Stages__c = 'Draft';
            upsert proposalDetails;
            return 'success';
        }catch(Exception e){
            return e.getMessage();
        }
    }
    
    public static string finalSubmit(Application_Proposal__c proposalDetails){
        try{
            proposalDetails.Stage__c = '1st Stage';
            proposalDetails.Proposal_Stages__c = 'Submitted';
            upsert proposalDetails;
            return 'success';
        }catch(Exception e){
            return e.getMessage();
        }
    }
    
    //************************************** Coordinators Page **********************************************************
    
    public static List<Contact> getCoordinatorsDetails(string hashCode){
        Contact conRec = [Select Id,Name,Proposals__c FROM Contact WHERE Login_Hash_Code__c=: hashCode];
        List<Contact> conList = New List<Contact>();
        if(!string.isBlank(conRec.Proposals__c)){
            conList = [SELECT Id,Name,FirstName,LastName,Department,Head_Of_Project__c,Homepage_URL__c,Email,Phone,
                       MailingAddress,MailingStreet,MailingCity,MailingCountry,MailingState,MailingPostalCode,Indian__c,German__c,Proposals__c,Account.Name From Contact WHERE Proposals__c=: conRec.Proposals__c];
            return conList;
        }
        system.debug('conList --> '+conList);
        return conList;
    }

    public static string createAnotherCoord(string projectId){
        try{
            Account acc = New Account();
            Contact con = New Contact();
            acc.Name = 'sdfh@@gyut!!gff%^%yutytyut';
            acc.Proposals__c = projectId;
            insert acc;
            con.LastName = 'sdfh@@gyut!!gff%^%yutytyut';
            con.Email = 'mzowndhe2088qsgrj00@mailiii.coom';
            con.AccountId = acc.Id;
            con.Proposals__c = projectId;
            insert con;
            return 'success';

        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }

    public static List<Contact> getCoordDetails(string projectId){
        try{
            List<Contact> conRec = [select name,id,FirstName,LastName,Email,Phone,Actual_Position__c,Head_Of_Project__c,Department,Profile_Pic_Attachment_Id__c,
            Account.Name,Account.Website,AccountId,Account.Year_Of_Establishment__c,Account.Last_Year_s_Balance__c,Account.SME__c, Account.Homepage_URL__c,Account.Country_Type__c,Account.Industry__c,
            Account.Email__c,Account.Is_DSIR_Available__c,Account.DSIR_Recoginition_Details__c,Account.Company_Profile__c,Account.Ownership_Profile__c,Account.Company_Website__c,Account.Academia__c,
            Account.Phone,Account.Main_Business_Area__c,Account.NumberOfEmployees,Account.Infrastructural_Facilities__c,Account.Domain_Expertise_Available__c,Account.Large_Industry__c,
            Account.Start_Up__c,Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingPostalCode,Account.BillingCountry,Account.Department__c from contact where Proposals__c =:projectId]; 

            return conRec;
        }catch(Exception e){
            return null;
        }
    }
    
    
    public static String insertCoordinatorsInformation(List<Account> accList,List<Contact> conList){
        try{
            
            system.debug('conList::'+conList);
            
            for(Account acc : accList){
                system.debug('acc::'+acc.BillingState);
                //acc.BillingState = acc.Shipping_State__c;
            }
            Map<String,String> accMap = New Map<String,String>();
            for(Account accRecord : accList){
                if(accRecord.Is_Coordinator__c){
                    accRecord.BillingState = accRecord.State__c;
                }
                accMap.put(accRecord.Name,''); 
            }
            upsert accList;
            for(Account acc : accList){
                accMap.containsKey(acc.Name);
                accMap.put(acc.Name, acc.Id);
            }
            for(Contact conRecord : conList){
                system.debug('conRecord.Lastname  ::'+conRecord.Lastname);                                
                if(conRecord.LastName == null || conRecord.LastName == ''){
                    conRecord.LastName = conRecord.FirstName;
                }
                if(accMap.containsKey(conRecord.AccountId)){
                    conRecord.AccountId = accMap.get(conRecord.AccountId);
                 }
            }
            system.debug('conList::'+conList);
            upsert accList;
            upsert conList;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }

    public static String insertCoordinatorsInformation2(List<Account> accList,List<Contact> conList){
        try{
            
            system.debug('conList::'+conList);
            
            for(Account acc : accList){
                system.debug('acc::'+acc.BillingState);
                acc.BillingState = acc.Shipping_State__c;
            }
            Map<String,String> accMap = New Map<String,String>();
            for(Account accRecord : accList){
                accMap.put(accRecord.Name,''); 
            }
            upsert accList;
            for(Account acc : accList){
                accMap.containsKey(acc.Name);
                accMap.put(acc.Name, acc.Id);
            }
            for(Contact conRecord : conList){
                system.debug('conRecord.Lastname  ::'+conRecord.Lastname);
                if(conRecord.LastName == null || conRecord.LastName == ''){
                    conRecord.LastName = conRecord.FirstName;
                }
                if(accMap.containsKey(conRecord.AccountId)){
                    conRecord.AccountId = accMap.get(conRecord.AccountId);
                 }
            }
            system.debug('conList::'+conList);
            upsert accList;
            upsert conList;
            return 'SUCCESS';
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }
    
    //************************************** BasicDetails Page **********************************************************
    
    public static Application_Proposal__c getBasicDetails(string applicantHashCode){
        
        contact conRec = [select name,id,Proposals__c from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
        system.debug('applicantHashCode' +applicantHashCode);
        Application_Proposal__c proposalRecord;
        if(!string.isBlank(conRec.Proposals__c)){
            proposalRecord = [SELECT id,Name,Acronym__c,Country_of_Venue__c,Thematic_Area__c,Campaign__c,Title_Of__c,Title_In_German__c,Summary__c,Proposed_Venue__c,Proposed_Date__c,Workshop_Finish_Date__c,Campaign__r.Result_Announcement_Date__c FROM Application_Proposal__c WHERE Id=: conRec.Proposals__c];
            system.debug('proposalRecord----'+proposalRecord);
            return proposalRecord;
        }else{
            return proposalRecord;  
        }     
    }
    
    
    public static string insertBasicDetails (Application_Proposal__c applicantDetails, integer day, integer month, integer year, integer endday, integer emdmonth, integer endyear, String conId, String recordType){
        try{
            if(day==0 && month==0 && year==0){
                
            }else{
                applicantDetails.Proposed_Date__c = Date.newInstance(year, month, day);
                
            }
            if(endday==0 && emdmonth==0 && endyear==0){
                
            }else{
                applicantDetails.Workshop_Finish_Date__c = Date.newInstance(endyear, emdmonth, endday);
                
            }
            applicantDetails.Stage__c = '1st Stage';
            applicantDetails.Proposal_Stages__c = 'Draft';
            applicantDetails.RecordTypeId = Utility.getProposalRecordType('Workshop');
            upsert applicantDetails;
            Contact con = new Contact(Id=conId,Proposals__c = applicantDetails.Id);
            update con;
            contact conRec = [select id,AccountId from Contact where id=:con.Id];
            if(!string.isBlank(conRec.AccountId)){
                Account acc = New Account();
                acc.Id = conRec.AccountId;
                acc.Proposals__c = applicantDetails.Id;
                update acc;
            }
            return applicantDetails.Id;
        }catch (Exception e){
            return 'ERROR';
        }
    }
    
    //************************************** Participants **********************************************************
    
    public static List<Participants__c> getParticipantDetails(string hashcode){
        contact conRec = [select name,id,Proposals__c from contact where Login_Hash_Code__c =:hashcode limit 1];
        system.debug('hashcode' +hashcode);
        List<Participants__c> participantList = New List<Participants__c>();
        if(!string.isBlank(conRec.Proposals__c)){
            participantList = [SELECT Id,Name,Affiliation__c,Email__c,Organisation_Institute__c,Participant_Type__c,Phone__c,Whether_Participant_is_presenting__c,Proposals__c From Participants__c WHERE Proposals__c=: conRec.Proposals__c];
            return participantList;
        }
        system.debug('participantList --> '+participantList);
        return participantList;
    }
    
    public static string insertParticipants(List<Participants__c> allParticipantDetails){
        try{
            system.debug('list --->'+allParticipantDetails);
            upsert allParticipantDetails;
            return 'SUCCESS';
        }catch(Exception e){
            System.debug('The Error is  :'+e.getMessage());
            return e.getMessage() + e.getLineNumber();
        }
    }
    
    public static  void deleteParticipant(string participantId){
        delete new Participants__c(id=participantId);
    }
    
    //************************************** CV of Coordinators **********************************************************
    
    
    public static List<Contact> getCurriculumDetails(string hashCode){
        Contact conRec = [Select Id,Name,Proposals__c FROM Contact WHERE Login_Hash_Code__c=: hashCode];
        List<Contact> conList = New List<Contact>();
        if(!string.isBlank(conRec.Proposals__c)){
            conList = [SELECT Id,Name,FirstName,LastName,Actual_Position__c,Department,Country__c,
                       Head_Of_Project__c,Homepage_URL__c,Email,Phone,Indian__c,German__c,
                       MailingAddress,MailingStreet,MailingCity,MailingCountry,MailingState,MailingPostalCode,
                       (SELECT Id,Name,Institution_Name__c,Area_of_specialization__c,Degree__c,End_Year__c FROM Education_Details__r),
                       (SELECT Id,Name,Organization_Name__c,Position__c,End_Year__c FROM Employment_Details__r),(select name,id,description__c from Publications_Patents__r)
                       From Contact WHERE Proposals__c=: conRec.Proposals__c];
            return conList;
        }
        system.debug('conList --> '+conList);
        return conList;
    }
    
    public static String insertCurriculumDetails(List<Contact> contactDetails, List<Education_Details__c> educationDetails, List<Employment_Details__c> employmentDetails, List<Publications_Patents__c> publicationDetails){
        try{
            upsert contactDetails;
            upsert educationDetails;
            upsert employmentDetails;
            upsert publicationDetails;
            return 'SUCCESS';
        }catch(exception e){
            system.debug('error -->'+e.getMessage());
            return 'ERROR';
        }
    }
    
    //************************************** Financial_Details **********************************************************
    
    public static List<Contact> getAllFinancialDetails(string hashCode){
        Contact conRec = [Select Id,Name,Proposals__c From Contact Where Login_Hash_Code__c=: hashCode];
        List<Contact> conList = New List<Contact>();
        if(!string.isBlank(conRec.Proposals__c)){
            conList = [SELECT Id,Indian__c,German__c,Proposals__c,(Select Id,Expanse_Head__c,Expanse_Name__c,Unit_Cost__c,Number__c,Total__c FROM Financial_Contribution__r) From Contact WHERE Proposals__c=: conRec.Proposals__c];
            return conList;
        }
        return conList;
    }
    
    public static string saveFinancialDetails(List<Financial_Contribution__c> financialList){
        try{
            upsert financialList;
            return 'Success';
        }catch(Exception e){
            return 'Error';
        }
    }
    
    // public static List<Account> getAccountExpenseDetails(string proposalId){
    //     try{
    //         List<Account> accListWithExpense = [Select Id,Name,Proposals__c,(select Id,Name From Expense_Head__c)]
    //     }catch(Exception e){
    
    //     }
    // }
    
    //************************************** BankDetailsForCoordinators **********************************************************
    
    public static List<Account> getBankDetails(string hashCode){
        Contact conRec = [Select Id,Name,Proposals__c From Contact Where Login_Hash_Code__c=: hashCode];
        List<Account> accList = New List<Account>();
        if(!string.isBlank(conRec.Proposals__c)){
            accList = [SELECT Id,Name,Proposals__c,Country_Type__c,(Select Id,Bank_Name__c,Bank_Type__c,Bank_IFSC_Code__c,Bank_SWIFT_Code__c,Bank_HSN_Code__c,Bank_Branch_Name__c,Bank_Account_Number__c,Account_Name__c,Bank_Address__c,Account__r.Country_Type__c From Bank_Details__r) From Account WHERE Proposals__c=: conRec.Proposals__c];
            return accList;
        }
        return accList;
    }
    
    public static String upsertBankDetails(List<Bank_Details__c> bankDetailsList){
        try{
            upsert bankDetailsList;
            return 'Success';
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }
    
    ///************************************** Project Details In Wiser **********************************************************
    
    public static Application_Proposal__c getApplicantDetailsWiser(string applicantHashCode){
        
        contact conRec = [select name,id,Proposals__c from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
        system.debug('applicantHashCode' +applicantHashCode);
        Application_Proposal__c proposalRecord;
        if(!string.isBlank(conRec.Proposals__c)){
            proposalRecord = [SELECT id,Name,Title_Of__c,Duration_In_Months_Max_36__c,KeyWords__c,Abstract_of_proposed_work__c,Broad_area_of_research__c,Project_Description__c FROM Application_Proposal__c WHERE Id=: conRec.Proposals__c];
            system.debug('proposalRecord----'+proposalRecord);
            return proposalRecord;
        }else{
            return proposalRecord;  
        }     
    }
    
    public static String insertApplicationWiser(Application_Proposal__c applicantDetails, String conId, String recordType){
        try{
            upsert applicantDetails;
            return applicantDetails.Id;
        }catch(Exception e){
            return 'Exception';
        }
    }
    
    //************************************** UPDATE WORK PACKAGE DETAILS **********************************************************
    
    public List<SelectOption> getAccountNames(string applicantHashCode) {
        contact conRec = [select name,id,Proposals__c,AccountId,Account.Name from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
        List<SelectOption> accOptions= new List<SelectOption>();
        accOptions.add( new SelectOption('','--Select--'));
        for( Account acc : [select Id,name,(SELECT Id,Title__c,Due_Date__c,Account__c FROM PI_Deliverables__r) from Account where Proposals__c=:conRec.Proposals__c]) {
            accOptions.add( new SelectOption(acc.Id,acc.name));
        }
        return accOptions;
    }
    
    public static List<Work_Package__c> getWPDetails(string applicantHashCode){
        List<Work_Package__c> workPackageList = New List<Work_Package__c>();
        
        Contact conRec = [Select Id,Name,Proposals__c From Contact WHERE Login_Hash_Code__c =:applicantHashCode limit 1];
        system.debug('applicantHashCode ::'+applicantHashCode);
        
        if(!string.isBlank(conRec.Proposals__c)){
            workPackageList = [SELECT Id,TRL_Level__c,End_TRL_Level__c,WP_Sequence__c,Work_Package_Detail__c,Title__c,External_Id__c,Duration__c,Application__c,Account__c,Account__r.Name,(SELECT Id,Name,Account_Name__c,Account__c FROM Account_Mapping__r),
                               (SELECT Id,Name From Accounts__r) From Work_Package__c WHERE Application__c =: conRec.Proposals__c];
        }
        // for(Work_Package__c wpack : workPackageList){
        //     wpack.WP_Sequence__c = Integer.valueOf(wpack.WP_Sequence__c);
        // }
        system.debug('workPackageList ::'+workPackageList);
        return workPackageList;
    }
    public static List<Account> getProposalAccounts(String ProposalId){
        try{
           List<Account> acc=[SELECT id,name,Country_Type__c from Account where proposals__c=:ProposalId];
            //return [select id,name,account.id,account.name,account.Country_Type__c from contact WHERE Login_Hash_Code__c =:applicantHashCode limit 1];
            return acc;
        }catch(Exception e){
            return null;
        }
        
    } 
    public static Contact getProposalAccount(String applicantHashCode){
        try{
        //    List<Account> acc=[SELECT id,name,Country_Type__c from Account where proposals__c=:ProposalId];
            return [select id,name,account.id,account.name,account.Country_Type__c from contact WHERE Login_Hash_Code__c =:applicantHashCode limit 1];
            //return acc;
        }catch(Exception e){
            return null;
        }
        
    } 
    public static String LogoutApplicant(String loginHasgCode){
        try{
           
            contact conRec = [select name,id,Proposals__c,Campaign__c from contact where Login_Hash_Code__c =:loginHasgCode limit 1];
            conRec.Login_Hash_Code__c=null;
            update conRec;
            return conRec.Campaign__c;
        }
        catch(Exception e){
            system.debug('The Error :: '+e.getMessage()+' AND Line No :: '+e.getLineNumber()+'');
            return 'Exception';
        }
    }
    
    //************************************** UPDATED PI DELIVERABLES DETAILS **********************************************************
    
    public static List<PI_Deliverables__c> getDeliverablesDetails(string applicantHashCode){
        List<PI_Deliverables__c> deliverableList = New List<PI_Deliverables__c>();
        
        Contact conRec = [Select Id,Name,Proposals__c From Contact WHERE Login_Hash_Code__c =:applicantHashCode limit 1];
        system.debug('applicantHashCode ::'+applicantHashCode);
        
        if(!string.isBlank(conRec.Proposals__c)){
            deliverableList = [SELECT Id,Title__c,External_Id__c,Due_Date__c,Application__c,Account__c,Account__r.Name,(SELECT Id,Name,Account_Name__c,Account__c FROM Deliverables_Account_Mapping__r),
                               (SELECT Id,Name From Accounts__r) From PI_Deliverables__c WHERE Application__c =: conRec.Proposals__c];
        }
        system.debug('deliverableList ::'+deliverableList);
        return deliverableList;
    }
    
    public string saveDeliverables(List<WrapperPIDeliverables> wrapper,String ProposalId){
        try{
            system.debug('wrapper::'+wrapper);
            Map<String,List<AccountListWrapper>> mapPiDeliverables=new Map<String,List<AccountListWrapper>>();
            List<PI_Deliverables__c> ListPiDeliverables=new List<PI_Deliverables__c>();
            List<Deliverables_Account_Mapping__c> amr=new List<Deliverables_Account_Mapping__c>();
            for(WrapperPIDeliverables piDeliver : wrapper){
                PI_Deliverables__c InstancePiDeliver=new PI_Deliverables__c();                
                if(piDeliver.Id!=''){
                    InstancePiDeliver.id=piDeliver.Id;
                }
                if(piDeliver.title != null){
                    InstancePiDeliver.Title__c=piDeliver.title;
                }
                if(piDeliver.year != 0){
                    InstancePiDeliver.Due_Date__c = Date.newInstance(piDeliver.year, piDeliver.month, piDeliver.day);
                }
                InstancePiDeliver.External_Id__c=piDeliver.ExternalId;
                InstancePiDeliver.Application__c=ProposalId;
                mapPiDeliverables.put(piDeliver.ExternalId,piDeliver.AccountListWrapper);
                ListPiDeliverables.add(InstancePiDeliver);
            }
            system.debug('ListPiDeliverables---'+ListPiDeliverables);
            upsert ListPiDeliverables;            
            Map<String,String> externalIdXpiDeliverid = New Map<String,String>();
            for(PI_Deliverables__c wp:ListPiDeliverables){
                externalIdXpiDeliverid.put(wp.External_Id__c,wp.Id);
            }
            system.debug('externalIdXpiDeliverid--'+externalIdXpiDeliverid);
            List<Deliverables_Account_Mapping__c> accMappingList = New List<Deliverables_Account_Mapping__c>();
            List<Deliverables_Account_Mapping__c> accMappingListToDelete = New List<Deliverables_Account_Mapping__c>();
            for(string externalId:mapPiDeliverables.keySet()){
                for(AccountListWrapper accWrapper:mapPiDeliverables.get(externalId)){
                    if(accWrapper.isSelected && String.isBlank(accWrapper.accountMappingId)){
                        Deliverables_Account_Mapping__c accMapping = New Deliverables_Account_Mapping__c();
                        accMapping.Account__c   = accWrapper.accnt.Id;
                        accMapping.PI_Deliverables__c = externalIdXpiDeliverid.get(externalId);
                        accMappingList.add(accMapping);
                    }else if(!accWrapper.isSelected && !String.isBlank(accWrapper.accountMappingId)){
                        accMappingListToDelete.add(New Deliverables_Account_Mapping__c(id=accWrapper.accountMappingId));
                    }
                }
            }
            system.debug('accMappingList--'+accMappingList);
            system.debug('accMappingListToDelete--'+accMappingListToDelete);
            if(!accMappingList.isEmpty())
                upsert accMappingList;
            if(!accMappingListToDelete.isEmpty())
                delete accMappingListToDelete;
            return 'success';
        }catch(Exception e){
            system.debug('The Error :: '+e.getMessage()+' AND Line No :: '+e.getLineNumber()+'');
            return 'Error Occured';
        }
    }
    
    public static string deleteDeliverables(string deliverId){
        try{
            List<Deliverables_Account_Mapping__c> accMappingList = [select name,id from Deliverables_Account_Mapping__c where PI_Deliverables__c =:deliverId];
            Delete accMappingList;
            Delete New PI_Deliverables__c(Id=deliverId);
            return 'Success';
        }catch(Exception e){
            system.debug('The Error :: '+e.getMessage()+' AND Line No :: '+e.getLineNumber()+'');
            return 'Error Occured';
        }
    }
    
    public class AccountListWrapper{
        public Account accnt;
        public Boolean isSelected;
        public String accountMappingId;
    }
    
    public class WrapperPIDeliverables {
        public Integer day;
        public Integer month;
        public Integer year;
        public String title;
        public String Id;
        public String ExternalId;
        public List<AccountListWrapper> AccountListWrapper;
        
    }
    
    //************************************** UPDATED NETWORK MEETING DETAILS  **********************************************************
    
    public static List<Network_Meeting__c> getMeetingDetails(string applicantHashCode){
        List<Network_Meeting__c> MeetingList = New List<Network_Meeting__c>();
        
        Contact conRec = [Select Id,Name,Proposals__c From Contact WHERE Login_Hash_Code__c =:applicantHashCode limit 1];
        system.debug('applicantHashCode ::'+applicantHashCode);
        
        if(!string.isBlank(conRec.Proposals__c)){
            MeetingList = [SELECT Id,Meeting_Agenda__c,Meeting_Venue__c,Tentative_Date__c,Actual_Date__c,External_Id__c,Proposals__c,Account__c,Account__r.Name,(SELECT Id,Name,Account_Name__c,Account__c FROM Network_Meeting_Account_Mapping__r),
                           (SELECT Id,Name From Accounts__r) From Network_Meeting__c WHERE Proposals__c =: conRec.Proposals__c];
        }
        system.debug('MeetingList ::'+MeetingList);
        return MeetingList;
    }
    
    public string saveMeetingDetailss(List<WrapperNetworkMeetings> wrapper,String ProposalId){
        try{
            system.debug('wrapper::'+wrapper);
            Map<String,List<AccountListWrapper>> mapNetworkMeeting=new Map<String,List<AccountListWrapper>>();
            List<Network_Meeting__c> listOfNetworkMeeting=new List<Network_Meeting__c>();
            List<Network_Meeting_Account_Mapping__c> amr=new List<Network_Meeting_Account_Mapping__c>();
            for(WrapperNetworkMeetings netMeeting : wrapper){
                Network_Meeting__c InstanceNetMeeting=new Network_Meeting__c();                
                if(netMeeting.Id!=''){
                    InstanceNetMeeting.id=netMeeting.Id;
                }
                if(netMeeting.meetingAgenda != null){
                    InstanceNetMeeting.Meeting_Agenda__c=netMeeting.meetingAgenda;
                }
                if(netMeeting.meetingVenue != null){
                    InstanceNetMeeting.Meeting_Venue__c=netMeeting.meetingVenue;
                }
                if(netMeeting.tentativeyear != 0){
                    InstanceNetMeeting.Tentative_Date__c = Date.newInstance(netMeeting.tentativeyear, netMeeting.tentativemonth, netMeeting.tentativeday);
                }
                if(netMeeting.actualyear != 0){
                    InstanceNetMeeting.Actual_Date__c = Date.newInstance(netMeeting.actualyear, netMeeting.actualmonth, netMeeting.actualday);
                }
                InstanceNetMeeting.External_Id__c=netMeeting.ExternalId;
                InstanceNetMeeting.Proposals__c=ProposalId;
                mapNetworkMeeting.put(netMeeting.ExternalId,netMeeting.AccountListWrapper);
                listOfNetworkMeeting.add(InstanceNetMeeting);
            }
            system.debug('listOfNetworkMeeting---'+listOfNetworkMeeting);
            upsert listOfNetworkMeeting;            
            Map<String,String> externalIdXnetMeetid = New Map<String,String>();
            for(Network_Meeting__c nm:listOfNetworkMeeting){
                externalIdXnetMeetid.put(nm.External_Id__c,nm.Id);
            }
            system.debug('externalIdXnetMeetid--'+externalIdXnetMeetid);
            List<Network_Meeting_Account_Mapping__c> accMappingList = New List<Network_Meeting_Account_Mapping__c>();
            List<Network_Meeting_Account_Mapping__c> accMappingListToDelete = New List<Network_Meeting_Account_Mapping__c>();
            for(string externalId:mapNetworkMeeting.keySet()){
                for(AccountListWrapper accWrapper:mapNetworkMeeting.get(externalId)){
                    if(accWrapper.isSelected && String.isBlank(accWrapper.accountMappingId)){
                        Network_Meeting_Account_Mapping__c accMapping = New Network_Meeting_Account_Mapping__c();
                        accMapping.Account__c   = accWrapper.accnt.Id;
                        accMapping.Network_Meeting__c = externalIdXnetMeetid.get(externalId);
                        accMappingList.add(accMapping);
                    }else if(!accWrapper.isSelected && !String.isBlank(accWrapper.accountMappingId)){
                        accMappingListToDelete.add(New Network_Meeting_Account_Mapping__c(id=accWrapper.accountMappingId));
                    }
                }
            }
            system.debug('accMappingList--'+accMappingList);
            system.debug('accMappingListToDelete--'+accMappingListToDelete);
            if(!accMappingList.isEmpty())
                upsert accMappingList;
            if(!accMappingListToDelete.isEmpty())
                delete accMappingListToDelete;
            return 'success';
        }catch(Exception e){
            system.debug('The Error :: '+e.getMessage()+' AND Line No :: '+e.getLineNumber()+'');
            return 'Error Occured';
        }
    }
    
    public static string deleteNetworkMeeting(string netMeetingId){
        try{
            List<Network_Meeting_Account_Mapping__c> accMappingList = [select name,id from Network_Meeting_Account_Mapping__c where Network_Meeting__c =:netMeetingId];
            Delete accMappingList;
            Delete New Network_Meeting__c(Id=netMeetingId);
            return 'Success';
        }catch(Exception e){
            system.debug('The Error :: '+e.getMessage()+' AND Line No :: '+e.getLineNumber()+'');
            return 'Error Occured';
        }
    }
    
    public class WrapperNetworkMeetings {
        public String meetingAgenda;
        public String meetingVenue;
        public Integer tentativeday;
        public Integer tentativemonth;
        public Integer tentativeyear;
        public Integer actualday;
        public Integer actualmonth;
        public Integer actualyear;
        public String Id;
        public String ExternalId;
        public List<AccountListWrapper> AccountListWrapper;
        
    }
    
    //************************************** Expense Declaration  **********************************************************
    
    public static string createExpenseDeclarationDetails(List<Expense_Line_Item__c> expenseLineItem,String proposalId,String accId){
        system.debug('expenseLineItem::'+expenseLineItem);
        system.debug('proposalId::'+proposalId);
        system.debug('accId::'+accId);
        List<Yearly_Expense__c> yearlyExpense = New List<Yearly_Expense__c>();
        List<Expense_Master__c> expenseMasterList = [select id from Expense_Master__c where Account__c =: accId and proposals__c =:proposalId];
        system.debug('expenseMasterList:'+expenseMasterList);
        Map<String,Yearly_Expense__c> mapofYearByExpense = New Map<String,Yearly_Expense__c>();
        List<Expense_Head__c> expenseHeadTobeInsert = New List<Expense_Head__c>();
        Set<String> yearSet = New Set<String>();
        List<Expense_Line_Item__c> expenseLineItemTobeInsert = New List<Expense_Line_Item__c>();
        if(!expenseMasterList.isEmpty()){
            Set<String> emSet = new Set<String>();
            for(Expense_Master__c em : expenseMasterList){
                emSet.add(em.Id);
            }
            if(!emSet.isEmpty()){
                yearlyExpense = [select id,Expense_Master__c,year__c from Yearly_Expense__c where Expense_Master__c in: emSet order by year__c];
                system.debug('yearlyExpense::'+yearlyExpense);
                integer counter = 0;
                
                for(Yearly_Expense__c yrExpense : yearlyExpense){
                    yearSet.add(yrExpense.Id);
                    mapofYearByExpense.put('year'+ ++counter,yrExpense);
                }
            }
            system.debug('mapofYearByExpense::'+mapofYearByExpense);
            Set<String> firstYearSet = New Set<String>();
            Set<String> secondYearSet = New Set<String>();
            Set<String> thirdYearSet = New Set<String>();
            List<Expense_Head__c> exheadList = new List<Expense_Head__c>();
            exheadList = [select id,Yearly_Expense__c,Name from Expense_Head__c where Yearly_Expense__c in: yearSet];
            Map<Id,List<Expense_Head__c>> mapofYearIdByHeadId = New Map<Id,List<Expense_Head__c>>();
            if(!exheadList.isEmpty()){
                for(Expense_Head__c eh : exheadList){
                    if(mapofYearIdByHeadId.containsKey(eh.Yearly_Expense__c)){
                        mapofYearIdByHeadId.get(eh.Yearly_Expense__c).add(eh);
                    }else{
                        mapofYearIdByHeadId.put(eh.Yearly_Expense__c, new List<Expense_Head__c>{eh});
                    }
                }
            }
            system.debug('exhead::'+exheadList);
            if(!expenseLineItem.isEmpty()){
                for(Expense_Line_Item__c eli : expenseLineItem){
                    system.debug('eli::'+eli);
                    integer expenseCount = 0;
                    if(eli.Expense_Type__c != '' && eli.Year1_Expense__c >0){
                        
                        if(!firstYearSet.contains(eli.Expense_Type__c)){
                            Expense_Head__c exHead = new Expense_Head__c();
                            system.debug('eli.Expense_Head__c::'+eli.Expense_Head__c);
                            
                            exHead.Name = eli.Expense_Type__c;
                            if(mapofYearIdByHeadId.get(mapofYearByExpense.get('year1').Id) != null){
                                for(Expense_Head__c exHead2 : mapofYearIdByHeadId.get(mapofYearByExpense.get('year1').Id)){
                                    if(exHead.Name == exHead2.Name){
                                        exHead.Id = exHead2.id;
                                    }
                                }
                            }
                            
                            exHead.Yearly_Expense__c = mapofYearByExpense.get('year1').Id;
                            firstYearSet.add(eli.Expense_Type__c);
                            expenseHeadTobeInsert.add(exHead);
                        }
                        
                    }
                    if(eli.Expense_Type__c != '' && eli.Year2_Expense__c > 0){
                        if(!secondYearSet.contains(eli.Expense_Type__c)){
                            Expense_Head__c exHead = new Expense_Head__c();
                            exHead.Name = eli.Expense_Type__c;
                            if(mapofYearIdByHeadId.get(mapofYearByExpense.get('year2').Id) != null){
                                for(Expense_Head__c exHead2 : mapofYearIdByHeadId.get(mapofYearByExpense.get('year2').Id)){
                                    if(exHead.Name == exHead2.Name){
                                        exHead.Id = exHead2.id;
                                    }
                                }
                            }
                            
                            exHead.Yearly_Expense__c = mapofYearByExpense.get('year2').Id;
                            secondYearSet.add(eli.Expense_Type__c);
                            expenseHeadTobeInsert.add(exHead);
                        }
                        
                    }
                    if(eli.Expense_Type__c != '' && eli.Year3_Expense__c > 0){
                        if(!thirdYearSet.contains(eli.Expense_Type__c)){
                            Expense_Head__c exHead = new Expense_Head__c();
                            exHead.Name = eli.Expense_Type__c;
                            if(mapofYearIdByHeadId.get(mapofYearByExpense.get('year3').Id) != null){
                                for(Expense_Head__c exHead2 : mapofYearIdByHeadId.get(mapofYearByExpense.get('year3').Id)){
                                    if(exHead.Name == exHead2.Name){
                                        exHead.Id = exHead2.id;
                                    }
                                }
                            }
                            
                            exHead.Yearly_Expense__c = mapofYearByExpense.get('year3').Id;
                            thirdYearSet.add(eli.Expense_Type__c);
                            expenseHeadTobeInsert.add(exHead);
                        }
                        
                    }
                    
                    
                }
                system.debug('expenseHeadTobeInsert::'+expenseHeadTobeInsert);
                if(!expenseHeadTobeInsert.isEmpty()){
                    upsert expenseHeadTobeInsert;
                }
                if(!yearSet.isEmpty()){
                    exheadList = [select id,Yearly_Expense__c,Name from Expense_Head__c where Yearly_Expense__c in: yearSet];
                }
                system.debug('exheadList::'+exheadList);
                set<Id> exHeadIdSet = new set<Id>();
                if(!exheadList.isEmpty()){
                    for(Expense_Head__c exHead : exheadList){
                        exHeadIdSet.add(exHead.Id);
                    }
                }
                Map<String,List<Expense_Head__c>> mapofYearidByExpenseHead = New Map<String,List<Expense_Head__c>>();
                for(Expense_Head__c exh : exheadList){
                    if(mapofYearidByExpenseHead.containsKey(exh.Yearly_Expense__c)){
                        mapofYearidByExpenseHead.get(exh.Yearly_Expense__c).add(exh);
                    }else{
                        mapofYearidByExpenseHead.put(exh.Yearly_Expense__c,new list<Expense_Head__c>{exh});
                    }
                    //mapofYearidByExpenseHead.put(exh.Yearly_Expense__c,exh);
                }
                List<Expense_Line_Item__c> expenseLineItemList = new List<Expense_Line_Item__c>();
                Map<Id,List<Expense_Line_Item__c>> mapofHeadIdByLineItems = New Map<Id,List<Expense_Line_Item__c>>();
                if(!exHeadIdSet.isEmpty()){
                    expenseLineItemList = [select id,Expense_Head__c,index__c from Expense_Line_Item__c where Expense_Head__c in : exHeadIdSet];
                    for(Expense_Line_Item__c exLine : expenseLineItemList){
                        if(mapofHeadIdByLineItems.containsKey(exLine.Expense_Head__c)){
                            mapofHeadIdByLineItems.get(exLine.Expense_Head__c).add(exLine);
                        }else{
                            mapofHeadIdByLineItems.put(exLine.Expense_Head__c,New List<Expense_Line_Item__c>{exLine});
                        }
                    }
                }
                
                
                for(Expense_Line_Item__c eli : expenseLineItem){
                    
                    system.debug('eli::'+eli);
                    if(eli.Year1_Expense__c > 0){
                        Expense_Line_Item__c newELI = New Expense_Line_Item__c();
                        //newELI = eli;
                        newELI.Description__c = eli.Description__c;
                        newELI.Multiplier__c = eli.Multiplier__c;
                        newELI.Unit_Price__c = eli.Unit_Price__c;
                        system.debug('mapofYearidByExpenseHead::'+mapofYearidByExpenseHead.get(mapofYearByExpense.get('year1').Id));
                        system.debug('mapofYearByExpense.getId::'+mapofYearByExpense.get('year1').Id);
                        for(Expense_Head__c exHead : mapofYearidByExpenseHead.get(mapofYearByExpense.get('year1').Id)){
                            system.debug('newELI.Expense_Type__c::'+eli.Expense_Type__c);
                            system.debug('exHead.Name::'+exHead.Name);
                            if(eli.Expense_Type__c == exHead.Name){
                                newELI.Expense_Head__c = exHead.Id;
                            }
                        }
                        //newELI.Expense_Head__c = mapofYearidByExpenseHead.get(mapofYearByExpense.get('year1').Id).Id;
                        newELI.Year2_Expense__c = 0;
                        newELI.Year3_Expense__c = 0;
                        newELI.Year1_Expense__c = eli.Year1_Expense__c;
                        newELI.Year1_Approved_Amount__c = eli.Year1_Approved_Amount__c;
                        newELI.index__c = eli.Index__c;
                        if(mapofHeadIdByLineItems.get(newELI.Expense_Head__c) != null){
                            for(Expense_Line_Item__c eli2 : mapofHeadIdByLineItems.get(newELI.Expense_Head__c)){
                                if(eli2.index__c == newELI.index__c){
                                    newELI.Id = eli2.Id;
                                }
                            } 
                        }
                        
                        
                        expenseLineItemTobeInsert.add(newELI);
                    }
                    system.debug('eli::'+eli);
                    system.debug('eli.Year2_Expense__c::'+eli.Year2_Expense__c);
                    if(eli.Year2_Expense__c > 0){
                        Expense_Line_Item__c newELI = New Expense_Line_Item__c();
                        //newELI = eli;
                        newELI.Description__c = eli.Description__c;
                        newELI.Multiplier__c = eli.Multiplier__c;
                        newELI.Unit_Price__c = eli.Unit_Price__c;
                        newELI.Year1_Expense__c = 0;
                        newELI.Year3_Expense__c = 0;
                        newELI.Year2_Expense__c = eli.Year2_Expense__c;
                        newELI.year2_Approved_Amount__c = eli.year2_Approved_Amount__c;
                        for(Expense_Head__c exHead : mapofYearidByExpenseHead.get(mapofYearByExpense.get('year2').Id)){
                            if(eli.Expense_Type__c == exHead.Name){
                                newELI.Expense_Head__c = exHead.Id;
                            }
                        }
                        //newELI.Expense_Head__c = mapofYearidByExpenseHead.get(mapofYearByExpense.get('year2').Id).Id;
                        newELI.index__c = eli.Index__c;
                        if(mapofHeadIdByLineItems.get(newELI.Expense_Head__c) != null){
                            for(Expense_Line_Item__c eli2 : mapofHeadIdByLineItems.get(newELI.Expense_Head__c)){
                                if(eli2.index__c == newELI.index__c){
                                    newELI.Id = eli2.Id;
                                }
                            } 
                        }
                        expenseLineItemTobeInsert.add(newELI);
                    }
                    if(eli.Year3_Expense__c > 0){
                        Expense_Line_Item__c newELI = New Expense_Line_Item__c();
                        //newELI = eli;
                        newELI.Description__c = eli.Description__c;
                        newELI.Multiplier__c = eli.Multiplier__c;
                        newELI.Unit_Price__c = eli.Unit_Price__c;
                        newELI.Year1_Expense__c = 0;
                        newELI.Year2_Expense__c = 0;
                        newELI.Year3_Expense__c = eli.Year3_Expense__c;
                        newELI.Year3_Approved_Amount__c = eli.Year3_Approved_Amount__c;
                        for(Expense_Head__c exHead : mapofYearidByExpenseHead.get(mapofYearByExpense.get('year3').Id)){
                            if(eli.Expense_Type__c == exHead.Name){
                                newELI.Expense_Head__c = exHead.Id;
                            }
                        }
                        //newELI.Expense_Head__c = mapofYearidByExpenseHead.get(mapofYearByExpense.get('year3').Id).Id;
                        newELI.index__c = eli.Index__c;
                        system.debug('newELI.index__c::'+newELI.index__c);
                        system.debug('newELI.index__c::'+newELI.Expense_Head__c);
                        system.debug('newELI.index__c::'+mapofHeadIdByLineItems.get(newELI.Expense_Head__c));
                        if(mapofHeadIdByLineItems.get(newELI.Expense_Head__c) != null){
                            for(Expense_Line_Item__c eli2 : mapofHeadIdByLineItems.get(newELI.Expense_Head__c)){
                                if(eli2.index__c == newELI.index__c){
                                    newELI.Id = eli2.Id;
                                }
                            } 
                        }
                        expenseLineItemTobeInsert.add(newELI);
                    }
                    
                }
            }
        }
        system.debug('expenseLineItem::'+expenseLineItemTobeInsert);
        upsert expenseLineItemTobeInsert;
        return 'success';
    }
    
    public static List<Expense_Line_Item__c> getExpenseRecords(String ProposalId){
        List<Expense_Line_Item__c> listOfExpense=[SELECT id,Index__c,name,Description__c,Expense_Type__c,Multiplier__c,Total_Expense__c,Unit_Price__c,Year3_Approved_Amount__c,year2_Approved_Amount__c,Year1_Approved_Amount__c,Year1_Expense__c,Year2_Expense__c,Year3_Expense__c,Expense_Head__c,
                                                  Expense_Head__r.Yearly_Expense__c,Expense_Head__r.Name,Expense_Head__r.Yearly_Expense__r.Expense_Master__c,Expense_Head__r.Yearly_Expense__r.Expense_Master__r.Account__c From Expense_Line_Item__c
                                                  where Expense_Head__r.Yearly_Expense__r.Expense_Master__r.Proposals__c =: ProposalId order by index__c asc];
        
        list<Expense_Line_Item__c> expenseListTobeReturn  =new list<Expense_Line_Item__c>();
        Map<String,List<Expense_Line_Item__c>> mapofExpenseHeadByLineItems = new Map<String,List<Expense_Line_Item__c>>();
        Map<String,Map<String,List<Expense_Line_Item__c>>> mapOfExpenseHeadByAccLineItems = new Map<String,Map<String,List<Expense_Line_Item__c>>>();
        
        if(!listOfExpense.isEmpty()){
            for(Expense_Line_Item__c exLine : listOfExpense){
                if(mapOfExpenseHeadByAccLineItems.containsKey(exLine.Expense_Head__r.Yearly_Expense__r.Expense_Master__r.Account__c)){
                    if(mapOfExpenseHeadByAccLineItems.get(exLine.Expense_Head__r.Yearly_Expense__r.Expense_Master__r.Account__c).containsKey(exLine.Expense_Head__r.Name)){
                        mapOfExpenseHeadByAccLineItems.get(exLine.Expense_Head__r.Yearly_Expense__r.Expense_Master__r.Account__c).get(exLine.Expense_Head__r.Name).add(exLine);
                    }else{
                        mapOfExpenseHeadByAccLineItems.get(exLine.Expense_Head__r.Yearly_Expense__r.Expense_Master__r.Account__c).put(exLine.Expense_Head__r.Name,new List<Expense_Line_Item__c>{exLine});
                    }
                }else{
					//mapofExpenseHeadByLineItems.put(exLine.Expense_Head__r.Name,new List<Expense_Line_Item__c>{exLine});                    
                    mapOfExpenseHeadByAccLineItems.put(exLine.Expense_Head__r.Yearly_Expense__r.Expense_Master__r.Account__c,new Map<String,List<Expense_Line_Item__c>>{exLine.Expense_Head__r.Name =>new List<Expense_Line_Item__c>{exLine}});
                }
                /*if(mapofExpenseHeadByLineItems.containsKey(exLine.Expense_Head__r.Name)){
                    mapofExpenseHeadByLineItems.get(exLine.Expense_Head__r.Name).add(exLine);
                }else{
                    
                }*/
            }
            Map<Decimal,List<Expense_Line_Item__c>> mapofIndexByListofExpense = new Map<Decimal,List<Expense_Line_Item__c>>();
            /*for(String mapKey : mapofExpenseHeadByLineItems.keySet()){

for(Expense_Line_Item__c exl : mapofExpenseHeadByLineItems.get(mapKey)){
if(mapofIndexByListofExpense.containsKey(exl.Index__c)){
mapofIndexByListofExpense.get(exl.Index__c).add(exl);
}else{
mapofIndexByListofExpense.put(exl.Index__c,new list<Expense_Line_Item__c>{exl});
}
}
}*/
            for(String accId : mapOfExpenseHeadByAccLineItems.KeySet()){
                List<Expense_Line_Item__c> exLineItem = new List<Expense_Line_Item__c>();
                system.debug('mapOfExpenseHeadByAccLineItems.get(accId).Values()::'+mapOfExpenseHeadByAccLineItems.get(accId).Values());
                system.debug('mapOfExpenseHeadByAccLineItems.get(accId).Values()::'+mapOfExpenseHeadByAccLineItems.get(accId).Values().size());
                //exLineItem.add(mapOfExpenseHeadByAccLineItems.get(accId).Values());
                for(List<Expense_Line_Item__c> mapKey : mapOfExpenseHeadByAccLineItems.get(accId).Values()){
                    
                    Expense_Line_Item__c ex;
                    for(Expense_Line_Item__c exl : mapKey){
                        system.debug('exl.Index__c::'+exl.Index__c);
                    if(ex != null && ex.Expense_Head__r.Name == exl.Expense_Head__r.Name && ex.Index__c == exl.Index__c){
                        if(exl.Year1_Expense__c != null && exl.Year1_Expense__c != 0){
                            ex.Year1_Expense__c = exl.Year1_Expense__c;
                            ex.Year1_Approved_Amount__c = exl.Year1_Approved_Amount__c;
                        }
                        if(exl.Year2_Expense__c != null && exl.Year2_Expense__c != 0){
                            ex.Year2_Expense__c = exl.Year2_Expense__c;
                            ex.year2_Approved_Amount__c = exl.year2_Approved_Amount__c;
                        }
                        if(exl.Year3_Expense__c != null && exl.Year3_Expense__c != 0){
                            ex.Year3_Expense__c = exl.Year3_Expense__c;
                            ex.Year3_Approved_Amount__c = exl.Year3_Approved_Amount__c;
                        }
                        
                        if(ex.Year1_Expense__c != null && ex.Year2_Expense__c != null && ex.Year3_Expense__c != null){
                            ex.Total_Expense__c = ex.Year1_Expense__c + ex.Year2_Expense__c + ex.Year3_Expense__c;
                        }
                    }else{
                        system.debug('Inside else part::');
                        ex = new Expense_Line_Item__c();
                        ex = exl;
                        system.debug('ex::'+ex);
                        system.debug('ex::'+ex.Index__c);
                        expenseListTobeReturn.add(ex);
                    }
                    }
                }
            }
            
            /*for(String  mapKey : mapofExpenseHeadByLineItems.keySet()){
                system.debug('mapKey::'+mapKey);
                Expense_Line_Item__c ex;
                for(Expense_Line_Item__c exl : mapofExpenseHeadByLineItems.get(mapKey)){
                    
                }
            }*/
            
        }
        
        system.debug('expenseListTobeReturn::'+expenseListTobeReturn.size());
        return expenseListTobeReturn;
    }
    
    public static void deleteExpenseLineItem(Id expenseLineItemId){
        if(expenseLineItemId != null && expenseLineItemId != ''){
            delete [select id from Expense_Line_Item__c where Id =: expenseLineItemId];
        }
    }
    
    public static Application_Proposal__c getConsentCheckbox(string proposalId){
        Application_Proposal__c appDetails = New Application_Proposal__c();
        try{
            appDetails = [SELECT Id,Name,Privacy_Policy_Accepted__c,(SELECT Id,Name,Account.Country_Type__c,Declaration_Sign_Date__c From Contacts__r) From Application_Proposal__c WHERE Id=: proposalId];
            return appDetails;
        }catch(Exception e){
            return appDetails;
        }
    }
    
    public static string saveAsDraftWorkshop(Application_Proposal__c proposalList, String projectId, Integer year, Integer month, Integer day){
        try{
            List<Contact> contactList = [SELECT Id,Name,Declaration_Sign_Date__c From Contact WHERE Proposals__c =: projectId];
            if(!contactList.isEmpty()){
                for(Contact con : contactList){
                    if(year == 0 && month == 0 && day == 0){

                    }else{
                        Date newDate=Date.newInstance(year,month,day);
                        con.Declaration_Sign_Date__c=newDate;
                    }
                }
            }
            
            update contactList;
            // proposalDetails.Stage__c = '1st Stage';
            proposalList.Proposal_Stages__c = 'Draft';
            proposalList.Submitted__c = true;
            upsert proposalList;
            return 'success';
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }
    
    public static string upsertCheckbox(Application_Proposal__c proposalList, String projectId, Integer year, Integer month, Integer day){
        try{
            List<Contact> contactList = [SELECT Id,Name,Declaration_Sign_Date__c From Contact WHERE Proposals__c =: projectId];
            if(!contactList.isEmpty()){
                for(Contact con : contactList){
                    if(year == 0 && month == 0 && day == 0){

                    }else{
                        Date newDate=Date.newInstance(year,month,day);
                        con.Declaration_Sign_Date__c=newDate;
                    }
                }
            }
            
            update contactList;
            // proposalDetails.Stage__c = '1st Stage';
            proposalList.Proposal_Stages__c = 'Submitted';
            proposalList.Submitted__c = true;
            upsert proposalList;
            return 'success';
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }
    public static WrapProposalPendings getProposalPendings(String pid){
        List<Account> listAccounts=[SELECT name,Academia__c,Industry__c,Website,Country_Type__c,(select Budget__c,Duration__c,Funding_Agency__c,Starting_Date__c,Title__c from Existing_Grants__r),(select Asked_From_IGSTC__c,IGSTC_Contribution__c,Partner_Name__c,Own_Contribution__c,Total__c from Financial_Contribution__r) from Account where Proposals__c=:pid];
        List<Work_Package__c> workPackageList = [SELECT Id,TRL_Level__c,End_TRL_Level__c,WP_Sequence__c,Work_Package_Detail__c,Title__c,External_Id__c,Duration__c,Application__c,Account__c,Account__r.Name,(SELECT Id,Name,Account_Name__c,Account__c FROM Account_Mapping__r),
                                                 (SELECT Id,Name From Accounts__r) From Work_Package__c WHERE Application__c =: pid];
        WrapProposalPendings wpp=new WrapProposalPendings();
        wpp.accountList=listAccounts;
        wpp.workPackagesList=workPackageList;
        return wpp;
    }
    public class WrapProposalPendings{
        public List<Account> accountList;
        public List<Work_Package__c> workPackagesList;
    }

    // public static void getExPenseDetails(string hashcode){
    //     try{
    //        Contact conRec = [SELECT Id,Name,AccountId,Proposals__c FROM Contact WHERE Login_Hash_Code__c =: hashcode];
    //        Account accRec = [SELECT Id,Name,() FROM Account WHERE Proposals__c=: conRec.Proposals__c]; 
    //     }catch(Exception e){

    //     }
    // }

    public static List<Expense_Head__c> getExpenseFromProposal(string proposalId){
        try{
            List<Expense_Head__c> expensehead = [SELECT Id,Name,Proposals__r.Total_funding_requested_from_IGSTC__c,Proposals__r.Country_of_Venue__c,Proposals__r.Funding_from_other_sources_own_contrib__c,(SELECT Id,Name,Expense_Head__c,Multiplier__c,Total_Expense__c,Unit_Price__c,Description__c,Currency_Type2__c From Expense_Line_Items__r) FROM Expense_Head__c WHERE Proposals__c =: proposalId];
                return expensehead;

        }catch(Exception e){
            return null;
        }
    }
    
    public static List<accWrapper> getExpenseDetailsOfAccount(string proposalId){
        try{
            Contact conRec = [SELECT Id,Name,AccountId,Proposals__c FROM Contact WHERE Login_Hash_Code__c =: proposalId];
            List<accWrapper> accWrapperList = New List<accWrapper>();
            Map<Id,Account> maPOfAcc = New Map<Id,Account>([Select Id,Name,BillingCountry From Account Where Id=: conRec.AccountId]);
            system.debug('maPOfAcc----'+maPOfAcc);
            Map<Id,Expense_Head__c> expenseList = New Map<Id,Expense_Head__c>([SELECT Id,Name,Account__c,Account__r.Name,Proposals__c,(SELECT Id,Name,Expense_Head__c,Multiplier__c,Total_Expense__c,Unit_Price__c From Expense_Line_Items__r) From Expense_Head__c WHERE Account__c=: maPOfAcc.keySet()]);
            Map<Id,List<Expense_Head__c>> mapOfAccExList = new Map<Id,List<Expense_Head__c>>();
            map<string,List<expenseHeadWrapper>> accIdXExpheadwrapList = New map<string,List<expenseHeadWrapper>>();
            for(Expense_Head__c exHead : expenseList.values()){
                if(mapOfAccExList.containsKey(exHead.Account__c)){
                    mapOfAccExList.get(exHead.Account__c).add(exHead);
                }else{
                    mapOfAccExList.put(exHead.Account__c,new List<Expense_Head__c>{exHead});
                }
                
                expenseHeadWrapper expHead = New expenseHeadWrapper();
                expHead.expenseHead = exHead;
                expHead.expenseLineItemList = exHead.Expense_Line_Items__r;
                if(accIdXExpheadwrapList.containsKey(exHead.Account__c)){
                    accIdXExpheadwrapList.get(exHead.Account__c).add(expHead);
                }else{
                    accIdXExpheadwrapList.put(exHead.Account__c,new List<expenseHeadWrapper>{expHead});
                }
            }
            for(string appId:maPOfAcc.keySet()){
                accWrapper accWrap = New accWrapper();
                accWrap.accRec = maPOfAcc.get(appId);
                accWrap.exHeadWrapper = accIdXExpheadwrapList.get(appId);
                accWrapperList.add(accWrap);
            }
            return accWrapperList;
        }catch(Exception e){
            return null;
        }
    }
    
    
    public class expenseHeadWrapper{
        public Expense_Head__c expenseHead;
        public List<Expense_Line_Item__c> expenseLineItemList;
    }
    
    public class accWrapper{
        public Account accRec;
        public List<expenseHeadWrapper> exHeadWrapper;
    }
    
    
    public static string saveExpenseDetails(List<Expense_Line_Item__c> listOfLineItem, Application_Proposal__c appRecord){
        try{
            appRecord.Total_funding_requested_from_IGSTC__c = string.valueOf(appRecord.Total_funding_requested_from_IGSTC__c);
            appRecord.Funding_from_other_sources_own_contrib__c = string.valueOf(appRecord.Funding_from_other_sources_own_contrib__c);
            upsert appRecord;
            upsert listOfLineItem;
            // Map<String,List<Expense_Line_Item__c>> mapOfExpenseHeadwithLineItems = New Map<String,List<Expense_Line_Item__c>>();
            // Map<String,Id> indexOfExHeadById = New Map<String,Id>();
            // List<expenseHeadWrapper> expenWrap=new list<expenseHeadWrapper>();
            // List<Expense_Head__c> expenheadList=new List<Expense_Head__c>();
            // for(accWrapper acc : wrapper){
            //     expenWrap=acc.exHeadWrapper;
            //     for(expenseHeadWrapper exwr: expenWrap){
            //         exwr.expenseHead.Account__c = acc.accRec.id;
            //         mapOfExpenseHeadwithLineItems.put(exwr.expenseHead.Index__c,exwr.expenseLineItemList);
            //         expenheadList.add(exwr.expenseHead);
            //     }
            // }
            // //upsert expenheadList;
            // List<Expense_Line_Item__c> listexpenseLineItem = new List<Expense_Line_Item__c>();
            // for(Expense_Head__c exhead:expenheadList){
            //     for(Expense_Line_Item__c expLineItem:mapOfExpenseHeadwithLineItems.get(exhead.Index__c)){
            //         expLineItem.Expense_Head__c=exhead.Id;
            //         listexpenseLineItem.add(expLineItem);
            //     }
            // }
            // upsert listexpenseLineItem;
            return 'success';
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }
    
    
    
    public static  void deleteExpenseLineItems(string lineItemId){
        delete new Expense_Line_Item__c(id=lineItemId);
    }
    
    
    
    //************************************** PECFAR MODULE  **********************************************************
    
    //************************************** Fellowship_Details  **********************************************************
    
    public static String insertFellowship_Details(Contact proposalDetails, integer startday, integer startmonth, integer startyear, integer endday, integer endmonth, integer endyear,String conId, String recordType){
        try{
            system.debug('startday ::'+startday);
            system.debug('startmonth ::'+startmonth);
            system.debug('startyear ::'+startyear);
            system.debug('endday ::'+endday);
            system.debug('endmonth ::'+endmonth);
            system.debug('endyear ::'+endyear);
            system.debug('proposalDetails ::'+proposalDetails);
            if(startday==0 && startmonth==0 && startyear==0){
                
            }else{
                proposalDetails.Tentative_Start_Date__c = Date.newInstance(startyear,startmonth,startday);
                
            }
            
            if(endday==0 && endmonth==0 && endyear==0){
                
            }else{
                proposalDetails.Tentative_End_Date__c = Date.newInstance(endyear,endmonth,endday);
                
            }
            // proposalDetails.RecordTypeId = Utility.getProposalRecordType('PECFAR');
            // proposalDetails.Stage__c = '1st Stage';
            // proposalDetails.Proposal_Stages__c = 'Draft';
            upsert proposalDetails;
            Contact con = new Contact(Id=conId,Proposals__c = proposalDetails.Id);
            update con;
            contact conRec = [select id,AccountId from Contact where id=:con.Id];
            if(!string.isBlank(conRec.AccountId)){
                Account acc = New Account();
                acc.Id = conRec.AccountId;
                acc.Proposals__c = proposalDetails.Id;
                update acc;
            }
            return proposalDetails.Id;
        }catch(Exception e){
            system.debug('exception ----'+e.getLineNumber()+'-----'+e.getMessage());
            return e.getLineNumber()+'-----'+e.getMessage();
        }
    }
    
    public static List<Contact> getPairingDetails(string hashcode, string campaignId){
        Contact conRec = [SELECT Id,FirstName,LastName,Email,AccountId,Account.Name,Account.Proposals__c,MailingCountry,Is_Primary__c,Birthdate,Proposals__c,Proposals__r.Campaign__r.Result_Announcement_Date__c FROM Contact WHERE Login_Hash_Code__c=: hashcode];
        Application_Proposal__c app = New Application_Proposal__c();
        if(conRec.Proposals__c == null){
            app.Campaign__c = campaignId;
            app.RecordTypeId = Utility.getProposalRecordType('PECFAR');
            app.Proposal_Stages__c = 'Draft';
            insert app;
            conRec.Proposals__c = app.Id;
            update conRec;
        }
        system.debug('app ::'+app);
        system.debug('conRec.Proposals__c ::'+conRec.Proposals__c);
        List<Contact> conList = [SELECT Id,FirstName,LastName,Email,AccountId,Account.Name,Account.Proposals__c,MailingCountry,Is_Primary__c,Birthdate,Proposals__c,Proposals__r.Campaign__r.Result_Announcement_Date__c,Proposals__r.Campaign__r.EndDate FROM Contact WHERE Proposals__c=: conRec.Proposals__c];
        return conList;
    }
    
    public static String insertPairingDetails(List<wrapperPairing> contactList){
        try{
            
            system.debug('size ---> '+contactList.size());
            system.debug('size ---> '+contactList);
            String ExsitingAccountId;
            List<Contact> contList = New List<Contact>();
            List<Account> accList = New List<Account>();
            for(wrapperPairing wrapp : contactList){
                Account acc = new Account();
                // Code to be changed here;
                acc.Name = wrapp.companyNmae;
                acc.Proposals__c = wrapp.proposal;
                system.debug('wrapp.accId ::'+wrapp.accId);
                if(wrapp.accId!=null ){
                    acc.Id=wrapp.accId;
                    ExsitingAccountId=wrapp.accId;
                }
                accList.add(acc);
            }
            upsert accList;
            system.debug('accList----'+accList);
            String NewAccountId;
            Map<string,string> accNameXaccId = New Map<string,string>();
            for(Account accountSingle : accList){
                accNameXaccId.put(accountSingle.Name,accountSingle.Id);
                if(accountSingle.Id!=ExsitingAccountId){
                    NewAccountId=accountSingle.Id;
                }
            }
            for(wrapperPairing wrapp : contactList){
                Contact con = new Contact();
                if(wrapp.birthyear != 0){
                    con.Birthdate = Date.newInstance(wrapp.birthyear, wrapp.birthmonth, wrapp.birthday);
                }
                // if(wrapp.cont.AccountId==null){
                //     con.AccountId=NewAccountId;
                // }
                con.Id = wrapp.cont.Id;
                con.AccountId = accNameXaccId.get(wrapp.companyNmae);
                con.FirstName=wrapp.cont.FirstName;
                con.LastName=wrapp.cont.LastName;
                con.Campaign__c = wrapp.cont.Campaign__c;
                con.Email=wrapp.cont.Email;
                con.MailingCountry=wrapp.cont.MailingCountry;
                con.Proposals__c = wrapp.proposal;
                contList.add(con);
            }
            system.debug('netMeetList :: '+contList);
            System.debug('Exsiting accunt id :: '+NewAccountId);
            system.debug('contList---'+contList);
            upsert contList;
            return 'SUCCESS';
            
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber(); 
        }
    }
    
    public class wrapperPairing {
        public Contact cont;
        public Integer birthyear;
        public Integer birthmonth;
        public Integer birthday;
        public string companyNmae;
        public string proposal;
        public string accId;  
    }
    
    public static Contact getPersonalInformation(string hashCode){
        Contact conRec = [SELECT Id,Profile_Pic_Attachment_Id__c,Name,FirstName,LastName,Birthdate,Gender__c,Designation__c,Institution_Name__c,Country_Code__c,Nationality__c,MailingAddress,MailingStreet,MailingCity,MailingState,MailingCountry,Nationalities__c,
                          MailingPostalCode,Email,MobilePhone,Account.Name,Uploaded__c,(select name,id from Attachments Order By CreatedDate DESC limit 1) From Contact Where Login_Hash_Code__c =: hashcode];
        return conRec;
    }
    
    public static string insertPersonalInfo(Contact conDetails, integer birthday, integer birthmonth, integer birthyear){
        try{
            conDetails.MailingState = conDetails.State__c;
            if(birthday == 0 && birthmonth==0 && birthyear==0){
                
            }else{
                conDetails.Birthdate = Date.newInstance(birthyear, birthmonth, birthday); 
            }
            upsert conDetails;
            return 'success';
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }
    
    public static List<Employment_Details__c> getEmpDetails(string hashcode){
        try{
            List<Employment_Details__c> empList = [Select Id,Name,Start_Date__c,End_Date__c,Position__c,Organization_Name__c,Nature_of_Job__c,Contact__c,current_employement__c,
            Contact__r.Previous_industrial_internship__c,Contact__r.Availing_Fellowship__c,Contact__r.Fellowship_Details__c,Contact__r.Associated_with_IGSTC__c,Contact__r.Associated_Details__c,
            Contact__r.Abstract_of_Ongoing_Work__c From Employment_Details__c Where Contact__r.Login_Hash_Code__c =: hashcode];
            return empList;
        }catch(Exception e){
            return null;
        }
    }

    public static string insertEmploymentDetailsPECFAR(List<Employment_Details__c> empDetails){
        try{
            upsert empDetails;
            return 'success';
        }catch(Exception e){
            return e.getMessage()+e.getLineNumber();
        }
    }
    
    // public static string updateEmploymentDetails(List<employmentWrapper> empList){
    //     try{
            
    //         system.debug('size ---> '+empList.size());
    //         List<Employment_Details__c> employList = New List<Employment_Details__c>();
    //         Set<String> ids = New Set<String>();
    //         for(employmentWrapper wrap : empList){
    //             system.debug('wrap----'+wrap);
    //             Employment_Details__c emRec = New Employment_Details__c();
    //             emRec.Organization_Name__c = wrap.employmentDetails.Organization_Name__c;
    //             emRec.Position__c = wrap.employmentDetails.Position__c;
    //             emRec.Nature_of_Job__c = wrap.employmentDetails.Nature_of_Job__c;
    //             emRec.Contact__c = wrap.employmentDetails.Contact__c;
    //             emRec.current_employement__c=wrap.employmentDetails.current_employement__c;
    //             if(wrap.employmentDetails.Id != null){
    //                 emRec.Id = wrap.employmentDetails.Id;
    //             }
    //             if(wrap.startYear != 0){
    //                 emRec.Start_Date__c = Date.newInstance(wrap.startYear, wrap.startMonth, wrap.startDay);
    //             }
    //             if(wrap.endYear != 0){
    //                 emRec.End_Date__c = Date.newInstance(wrap.endYear, wrap.endMonth, wrap.endDay);
    //             }
    //             employList.add(emRec);
    //         }
    //         system.debug('employList ::'+employList);
    //         upsert employList;
    //         system.debug('employList ::'+employList);
            
    //         return 'success';
    //     }catch(Exception e){
    //         system.debug('eror ::'+e.getMessage() +e.getLineNumber());
    //         return e.getMessage() + e.getLineNumber();
    //     }
    // }
    
    // public class employmentWrapper{
    //     public Employment_Details__c employmentDetails;
    //     public Integer startYear;
    //     public Integer startMonth;
    //     public Integer startDay;
    //     public Integer endYear;
    //     public Integer endMonth;
    //     public Integer endDay; 
    // }
    
    public static  void deleteEmployment(string empId){
        delete new Employment_Details__c(id=empId);
    }
    
    public static Contact getParentOrgDetails(string hashcode){
        try{
            Contact conAccRecord = [SELECT Id,Login_Hash_Code__c,AccountId,Account.Name,Account.BillingStreet,Account.BillingCity,Account.BillingCountry,Account.BillingState,Account.BillingPostalCode,
                                    Account.Email__c,Account.Homepage_URL__c,Account.Organisation_Posrt__c,Account.Name_of_Mentor__c,Account.Designation_Position_of_the_Mentor__c,
                                    Account.Mentor_contact_number__c,Account.Mentor_E_mail_Id__c From Contact Where Login_Hash_Code__c =: hashcode];
            return conAccRecord;
        }catch(Exception e){
            return null;
        }
    }
    
    public static string updateconAccDetails(Account conAccDetails){
        try{
            system.debug('conAccDetails ::'+conAccDetails);
            conAccDetails.BillingState = conAccDetails.Shipping_State__c;
            upsert conAccDetails;
            return 'success';
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }
    
    public static Achievement__c getAchievements(string hashcode){
        try{
            List<Achievement__c> achieveRecord = [SELECT id,contact__c,Awards_Honours__c,List_of_Publications__c,List_of_Patents_filed__c,Book_Chapters__c,Any_other_achievements__c FROM Achievement__c where contact__r.Login_Hash_Code__c=:hashcode];
            if(achieveRecord.size() > 0){
                return achieveRecord[0];
            }
            return null;
        }catch(Exception e){
            system.debug('error ::'+e.getMessage() + e.getLineNumber());
            return null;
        }
    }
    
    public static string updateAchievements(Achievement__c achievementList){
        try{
            upsert achievementList;
            return 'success';
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }
    
    public static Contact getDeclarationfields(string hashcode){
        try{
            Contact conRec = [SELECT Id,Name,Declaration_Sign_Date__c FROM Contact WHERE Login_Hash_Code__c=: hashcode];
            return conRec;
        }catch(Exception e){
            return null;
        }
    }

    
    public static string upsertSign(Contact conDetails,integer year,integer month,integer day){
        try{
            if(year == 0 && month == 0 && day == 0){

            }else{
                Date newDate=Date.newInstance(year,month,day);
                conDetails.Declaration_Sign_Date__c=newDate;
            }
            update conDetails;
            return 'Success';
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }
    public static string submit2plus2(Contact conDetails,integer year,integer month,integer day, string proposalID){
        try{
            if(year == 0 && month == 0 && day == 0){

            }else{
                Date newDate=Date.newInstance(year,month,day);
                conDetails.Declaration_Sign_Date__c=newDate;
            }
            update conDetails;
            Application_Proposal__c prop=new Application_Proposal__c(Id=ProposalId);
            prop.Proposal_Stages__c='Submitted';
            prop.Submitted__c = true;
            update prop;
            return 'Success';
        }catch(Exception e){
            return e.getMessage() + e.getLineNumber();
        }
    }
    public static list<UserDocumentWrapper> getReviewerUserDoc(id parentId) {
        try{
            list<UserDocumentWrapper> udWrapperList = New List<UserDocumentWrapper>();
            map<string,ContentDocumentLink> userDocIdXcdLink = New map<string,ContentDocumentLink>();
            map<string,ContentDistribution> userDocIdXcDistrbtn = New map<string,ContentDistribution>();

            map<string,User_Document__c> idXUserDoc = New Map<string,User_Document__c>();
            map<string,ContentDocumentLink> udIdXcdLink = New Map<string,ContentDocumentLink>();
            list<User_Document__c> getUserDoc;
            if(parentId.getSObjectType().getDescribe().getName() == 'Reviewer__c'){
                getUserDoc = [select name,id,Status__c from User_Document__c where Contact__c =:parentId];
            }
            // if(parentId.getSObjectType().getDescribe().getName() == 'Application_Proposal__c'){
            //     getUserDoc = [select name,id,Status__c from User_Document__c where Proposals__c =:parentId];
            // }
            system.debug('getUserDoc----'+getUserDoc);
            set<string> userDocIdSet = New set<string>();
            for(User_Document__c userDoc:getUserDoc){
                userDocIdSet.add(userDoc.id);
                idXUserDoc.put(userDoc.Id,userDoc);
            }
           
           list<ContentDocumentLink> allDocuments = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
            ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:userDocIdSet order by ContentDocument.createdDate];
            List<ContentDistribution> ContentDistrbtn = [SELECT DistributionPublicUrl,PdfDownloadUrl,RelatedRecordId FROM ContentDistribution where RelatedRecordId IN :userDocIdSet order by CreatedDate];
            system.debug('allDocuments---'+allDocuments);
            system.debug('ContentDistrbtn---'+ContentDistrbtn);
            set<string> allDocId = New set<string>();    
            for(ContentDocumentLink doc:allDocuments){
                system.debug('doc--'+doc.Id);
                userDocIdXcdLink.put(doc.LinkedEntityId,doc);
                allDocId.add(doc.ContentDocumentId);  
            }

            for(ContentDistribution doc:ContentDistrbtn){
                userDocIdXcDistrbtn.put(doc.RelatedRecordId,doc);
            }

            for(string userDocId:userDocIdSet ){
                udIdXcdLink.put(userDocId,userDocIdXcdLink.get(userDocId));
            }
            Map<string,ContentDocumentLink> docNameXcVersion = New Map<string,ContentDocumentLink>();
           
            Map<string,ContentVersion> cdocIdXcVersion = New Map<string,ContentVersion>();
            ContentVersion[] cvs = [SELECT Id, Title, ContentDocumentId from  contentversion where isLatest=true and ContentDocumentId IN :allDocId order by CreatedDate];
            system.debug('cvs--'+cvs);
            for(ContentVersion doc :cvs){
                cdocIdXcVersion.put(doc.ContentDocumentId,doc);
            }
            system.debug('cdocIdXcVersion--'+cdocIdXcVersion);
            for(string udId: userDocIdSet){
                system.debug('udId----------'+udId);
                UserDocumentWrapper udWrapper = New UserDocumentWrapper();
                udWrapper.userDocument = idXUserDoc.get(udId);
                System.debug('@@@@@'+userDocIdXcdLink.get(udId) );
               
                if(userDocIdXcdLink.get(udId) != null){
                    System.debug('@@@@@-----------'+cdocIdXcVersion.get(userDocIdXcdLink.get(udId).ContentDocumentId));
                    udWrapper.contentVersion = cdocIdXcVersion.get(userDocIdXcdLink.get(udId).ContentDocumentId) ;
                }
                if(userDocIdXcDistrbtn.get(udId) != null){
                    System.debug('@@@@@-----------'+userDocIdXcDistrbtn.get(udId));
                    udWrapper.ContentDistribution = userDocIdXcDistrbtn.get(udId) ;
                }
                udWrapperList.add(udWrapper);
            }
            return udWrapperList;
    }catch(Exception e){
            //HandleBusinessException.captureError('CandidateDashboard_Helper', 'getAllUserDoc', e);
            system.debug(e.getLineNumber()+'-----get Message----'+e.getMessage());
            return null;
    }
    }
    public static list<UserDocumentWrapper> getContactUserDoc(id parentId) {
        try{
            list<UserDocumentWrapper> udWrapperList = New List<UserDocumentWrapper>();
            map<string,ContentDocumentLink> userDocIdXcdLink = New map<string,ContentDocumentLink>();
            map<string,ContentDistribution> userDocIdXcDistrbtn = New map<string,ContentDistribution>();

            map<string,User_Document__c> idXUserDoc = New Map<string,User_Document__c>();
            map<string,ContentDocumentLink> udIdXcdLink = New Map<string,ContentDocumentLink>();
            list<User_Document__c> getUserDoc;
            if(parentId.getSObjectType().getDescribe().getName() == 'Contact'){
                getUserDoc = [select name,id,Status__c,(select id from attachments order by createdDate DESC) from User_Document__c where Contact__c =:parentId];
            }
            // if(parentId.getSObjectType().getDescribe().getName() == 'Application_Proposal__c'){
            //     getUserDoc = [select name,id,Status__c from User_Document__c where Proposals__c =:parentId];
            // }
            system.debug('getUserDoc----'+getUserDoc);
            set<string> userDocIdSet = New set<string>();
            for(User_Document__c userDoc:getUserDoc){
                userDocIdSet.add(userDoc.id);
                idXUserDoc.put(userDoc.Id,userDoc);
            }
           
           list<ContentDocumentLink> allDocuments = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
            ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:userDocIdSet order by ContentDocument.createdDate];
            List<ContentDistribution> ContentDistrbtn = [SELECT DistributionPublicUrl,PdfDownloadUrl,RelatedRecordId FROM ContentDistribution where RelatedRecordId IN :userDocIdSet order by CreatedDate];
            system.debug('allDocuments---'+allDocuments);
            system.debug('ContentDistrbtn---'+ContentDistrbtn);
            set<string> allDocId = New set<string>();    
            for(ContentDocumentLink doc:allDocuments){
                system.debug('doc--'+doc.Id);
                userDocIdXcdLink.put(doc.LinkedEntityId,doc);
                allDocId.add(doc.ContentDocumentId);  
            }

            for(ContentDistribution doc:ContentDistrbtn){
                userDocIdXcDistrbtn.put(doc.RelatedRecordId,doc);
            }

            for(string userDocId:userDocIdSet ){
                udIdXcdLink.put(userDocId,userDocIdXcdLink.get(userDocId));
            }
            Map<string,ContentDocumentLink> docNameXcVersion = New Map<string,ContentDocumentLink>();
           
            Map<string,ContentVersion> cdocIdXcVersion = New Map<string,ContentVersion>();
            ContentVersion[] cvs = [SELECT Id, Title, ContentDocumentId from  contentversion where isLatest=true and ContentDocumentId IN :allDocId order by CreatedDate];
            system.debug('cvs--'+cvs);
            for(ContentVersion doc :cvs){
                cdocIdXcVersion.put(doc.ContentDocumentId,doc);
            }
            system.debug('cdocIdXcVersion--'+cdocIdXcVersion);
            for(string udId: userDocIdSet){
                system.debug('udId----------'+udId);
                UserDocumentWrapper udWrapper = New UserDocumentWrapper();
                udWrapper.userDocument = idXUserDoc.get(udId);
                System.debug('@@@@@'+userDocIdXcdLink.get(udId) );
               
                if(userDocIdXcdLink.get(udId) != null){
                    System.debug('@@@@@-----------'+cdocIdXcVersion.get(userDocIdXcdLink.get(udId).ContentDocumentId));
                    udWrapper.contentVersion = cdocIdXcVersion.get(userDocIdXcdLink.get(udId).ContentDocumentId) ;
                }
                if(userDocIdXcDistrbtn.get(udId) != null){
                    System.debug('@@@@@-----------'+userDocIdXcDistrbtn.get(udId));
                    udWrapper.ContentDistribution = userDocIdXcDistrbtn.get(udId) ;
                }
                udWrapperList.add(udWrapper);
            }
            return udWrapperList;
    }catch(Exception e){
            //HandleBusinessException.captureError('CandidateDashboard_Helper', 'getAllUserDoc', e);
            system.debug(e.getLineNumber()+'-----get Message----'+e.getMessage());
            return null;
    }
    }
      public static list<UserDocumentWrapper> getAllUserDoc(string parentId) {
        try{
            list<UserDocumentWrapper> udWrapperList = New List<UserDocumentWrapper>();
            map<string,ContentDocumentLink> userDocIdXcdLink = New map<string,ContentDocumentLink>();
            map<string,ContentDistribution> userDocIdXcDistrbtn = New map<string,ContentDistribution>();
            
            map<string,User_Document__c> idXUserDoc = New Map<string,User_Document__c>();
            map<string,ContentDocumentLink> udIdXcdLink = New Map<string,ContentDocumentLink>();
            list<User_Document__c> getUserDoc = [select name,id,Status__c,(select id from attachments) from User_Document__c where Proposals__c =:parentId];
            system.debug('getUserDoc----'+getUserDoc);
            set<string> userDocIdSet = New set<string>();
            for(User_Document__c userDoc:getUserDoc){
                userDocIdSet.add(userDoc.id);
                idXUserDoc.put(userDoc.Id,userDoc);
            }
            
            list<ContentDocumentLink> allDocuments = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
                                                      ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:userDocIdSet];
            List<ContentDistribution> ContentDistrbtn = [SELECT DistributionPublicUrl,PdfDownloadUrl,RelatedRecordId FROM ContentDistribution where RelatedRecordId IN :userDocIdSet];
            system.debug('ContentDistrbtn---'+ContentDistrbtn);
            system.debug('allDocuments---'+allDocuments);
            set<string> allDocId = New set<string>();     
            for(ContentDocumentLink doc:allDocuments){
                system.debug('doc--'+doc.Id);
                userDocIdXcdLink.put(doc.LinkedEntityId,doc);
                allDocId.add(doc.ContentDocumentId);  
            }
            for(ContentDistribution doc:ContentDistrbtn){
                userDocIdXcDistrbtn.put(doc.RelatedRecordId,doc);
            }
            for(string userDocId:userDocIdSet){
                udIdXcdLink.put(userDocId,userDocIdXcdLink.get(userDocId));
            }
            Map<string,ContentDocumentLink> docNameXcVersion = New Map<string,ContentDocumentLink>();
            
            Map<string,ContentVersion> cdocIdXcVersion = New Map<string,ContentVersion>();
            ContentVersion[] cvs = [SELECT Id, Title, ContentDocumentId from  contentversion where isLatest=true and ContentDocumentId IN :allDocId order by CreatedDate desc];
            system.debug('cvs--'+cvs);
            for(ContentVersion doc :cvs){
                cdocIdXcVersion.put(doc.ContentDocumentId,doc);
            }
            
            
            
            
            system.debug('cdocIdXcVersion--'+cdocIdXcVersion);
            for(string udId: userDocIdSet){
                system.debug('udId----------'+udId);
                UserDocumentWrapper udWrapper = New UserDocumentWrapper();
                udWrapper.userDocument = idXUserDoc.get(udId);
                System.debug('@@@@@'+userDocIdXcdLink.get(udId) );
                
                if(userDocIdXcdLink.get(udId) != null){
                    System.debug('@@@@@-----------'+cdocIdXcVersion.get(userDocIdXcdLink.get(udId).ContentDocumentId));
                    udWrapper.contentVersion = cdocIdXcVersion.get(userDocIdXcdLink.get(udId).ContentDocumentId) ;
                }
                if(userDocIdXcDistrbtn.get(udId) != null){
                    System.debug('@@@@@-----------'+userDocIdXcDistrbtn.get(udId));
                    udWrapper.ContentDistribution = userDocIdXcDistrbtn.get(udId) ;
                }
                system.debug('udWrapper---'+udWrapper);
                udWrapperList.add(udWrapper);
            }
            return udWrapperList;
        }catch(Exception e){
            //HandleBusinessException.captureError('CandidateDashboard_Helper', 'getAllUserDoc', e);
            system.debug(e.getLineNumber()+'-----get Message----'+e.getMessage());
            return null;
        }
    }
    public static list<ProposalDocumentWrapper> getAllProposalDoc(string parentId) {
        try{
            list<ProposalDocumentWrapper> udWrapperList = New List<ProposalDocumentWrapper>();
            map<string,ContentDocumentLink> userDocIdXcdLink = New map<string,ContentDocumentLink>();
            map<string,ContentDistribution> userDocIdXcDistrbtn = New map<string,ContentDistribution>();
            
            map<string,Proposal_Document__c> idXUserDoc = New Map<string,Proposal_Document__c>();
            map<string,ContentDocumentLink> udIdXcdLink = New Map<string,ContentDocumentLink>();
            list<Proposal_Document__c> getUserDoc = [select name,id,Status__c,(select id from attachments) from Proposal_Document__c where Proposals__c =:parentId];
            system.debug('getUserDoc----'+getUserDoc);
            set<string> userDocIdSet = New set<string>();
            for(Proposal_Document__c userDoc:getUserDoc){
                userDocIdSet.add(userDoc.id);
                idXUserDoc.put(userDoc.Id,userDoc);
            }
            
            list<ContentDocumentLink> allDocuments = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
                                                      ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:userDocIdSet];
            List<ContentDistribution> ContentDistrbtn = [SELECT DistributionPublicUrl,PdfDownloadUrl,RelatedRecordId FROM ContentDistribution where RelatedRecordId IN :userDocIdSet];
            system.debug('ContentDistrbtn---'+ContentDistrbtn);
            system.debug('allDocuments---'+allDocuments);
            set<string> allDocId = New set<string>();     
            for(ContentDocumentLink doc:allDocuments){
                system.debug('doc--'+doc.Id);
                userDocIdXcdLink.put(doc.LinkedEntityId,doc);
                allDocId.add(doc.ContentDocumentId);  
            }
            for(ContentDistribution doc:ContentDistrbtn){
                userDocIdXcDistrbtn.put(doc.RelatedRecordId,doc);
            }
            for(string userDocId:userDocIdSet){
                udIdXcdLink.put(userDocId,userDocIdXcdLink.get(userDocId));
            }
            Map<string,ContentDocumentLink> docNameXcVersion = New Map<string,ContentDocumentLink>();
            
            Map<string,ContentVersion> cdocIdXcVersion = New Map<string,ContentVersion>();
            ContentVersion[] cvs = [SELECT Id, Title, ContentDocumentId from  contentversion where isLatest=true and ContentDocumentId IN :allDocId order by CreatedDate desc];
            system.debug('cvs--'+cvs);
            for(ContentVersion doc :cvs){
                cdocIdXcVersion.put(doc.ContentDocumentId,doc);
            }
            
            
            
            
            system.debug('cdocIdXcVersion--'+cdocIdXcVersion);
            for(string udId: userDocIdSet){
                system.debug('udId----------'+udId);
                ProposalDocumentWrapper udWrapper = New ProposalDocumentWrapper();
                udWrapper.userDocument = idXUserDoc.get(udId);
                System.debug('@@@@@'+userDocIdXcdLink.get(udId) );
                
                if(userDocIdXcdLink.get(udId) != null){
                    System.debug('@@@@@-----------'+cdocIdXcVersion.get(userDocIdXcdLink.get(udId).ContentDocumentId));
                    udWrapper.contentVersion = cdocIdXcVersion.get(userDocIdXcdLink.get(udId).ContentDocumentId) ;
                }
                if(userDocIdXcDistrbtn.get(udId) != null){
                    System.debug('@@@@@-----------'+userDocIdXcDistrbtn.get(udId));
                    udWrapper.ContentDistribution = userDocIdXcDistrbtn.get(udId) ;
                }
                system.debug('udWrapper---'+udWrapper);
                udWrapperList.add(udWrapper);
            }
            return udWrapperList;
        }catch(Exception e){
            //HandleBusinessException.captureError('CandidateDashboard_Helper', 'getAllUserDoc', e);
            system.debug(e.getLineNumber()+'-----get Message----'+e.getMessage());
            return null;
        }
    }
    public static list<UserDocumentWrapper> getAllUserDocSignature(string parentId) {
        try{
            list<UserDocumentWrapper> udWrapperList = New List<UserDocumentWrapper>();
            map<string,ContentDocumentLink> userDocIdXcdLink = New map<string,ContentDocumentLink>();
            map<string,ContentDistribution> userDocIdXcDistrbtn = New map<string,ContentDistribution>();
            
            map<string,User_Document__c> idXUserDoc = New Map<string,User_Document__c>();
            map<string,ContentDocumentLink> udIdXcdLink = New Map<string,ContentDocumentLink>();
            list<User_Document__c> getUserDoc = [select name,id,Status__c,(select id from attachments) from User_Document__c where Proposals__c =:parentId];
            system.debug('getUserDoc----'+getUserDoc);
            set<string> userDocIdSet = New set<string>();
            for(User_Document__c userDoc:getUserDoc){
                userDocIdSet.add(userDoc.id);
                idXUserDoc.put(userDoc.Id,userDoc);
            }
            
            list<ContentDocumentLink> allDocuments = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
                                                      ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId =:userDocIdSet];
            List<ContentDistribution> ContentDistrbtn = [SELECT DistributionPublicUrl,PdfDownloadUrl,RelatedRecordId FROM ContentDistribution where RelatedRecordId IN :userDocIdSet];
            system.debug('ContentDistrbtn---'+ContentDistrbtn);
            system.debug('allDocuments---'+allDocuments);
            set<string> allDocId = New set<string>();     
            for(ContentDocumentLink doc:allDocuments){
                system.debug('doc--'+doc.Id);
                userDocIdXcdLink.put(doc.LinkedEntityId,doc);
                allDocId.add(doc.ContentDocumentId);  
            }
            for(ContentDistribution doc:ContentDistrbtn){
                userDocIdXcDistrbtn.put(doc.RelatedRecordId,doc);
            }
            for(string userDocId:userDocIdSet){
                udIdXcdLink.put(userDocId,userDocIdXcdLink.get(userDocId));
            }
            Map<string,ContentDocumentLink> docNameXcVersion = New Map<string,ContentDocumentLink>();
            
            Map<string,ContentVersion> cdocIdXcVersion = New Map<string,ContentVersion>();
            ContentVersion[] cvs = [SELECT Id, Title, ContentDocumentId from  contentversion where isLatest=true and ContentDocumentId IN :allDocId order by CreatedDate desc];
            system.debug('cvs--'+cvs);
            for(ContentVersion doc :cvs){
                cdocIdXcVersion.put(doc.ContentDocumentId,doc);
            }
            
            
            
            
            system.debug('cdocIdXcVersion--'+cdocIdXcVersion);
            for(string udId: userDocIdSet){
                system.debug('udId----------'+udId);
                UserDocumentWrapper udWrapper = New UserDocumentWrapper();
                udWrapper.userDocument = idXUserDoc.get(udId);
                System.debug('@@@@@'+userDocIdXcdLink.get(udId) );
                
                if(userDocIdXcdLink.get(udId) != null){
                    System.debug('@@@@@-----------'+cdocIdXcVersion.get(userDocIdXcdLink.get(udId).ContentDocumentId));
                    udWrapper.contentVersion = cdocIdXcVersion.get(userDocIdXcdLink.get(udId).ContentDocumentId) ;
                }
                if(userDocIdXcDistrbtn.get(udId) != null){
                    System.debug('@@@@@-----------'+userDocIdXcDistrbtn.get(udId));
                    udWrapper.ContentDistribution = userDocIdXcDistrbtn.get(udId) ;
                }
                system.debug('udWrapper---'+udWrapper);
                udWrapperList.add(udWrapper);
            }
            return udWrapperList;
        }catch(Exception e){
            //HandleBusinessException.captureError('CandidateDashboard_Helper', 'getAllUserDoc', e);
            system.debug(e.getLineNumber()+'-----get Message----'+e.getMessage());
            return null;
        }
    }
    
    public static list<MeetingThemeWrapper> getMeetingThemeDetails(string proposalId){
        List<Meeting_Theme__c>  meetingThemeList = [select name,id,Meeting_Date__c,External_Id__c,(select name,id from Meeting_Themes__r) from Meeting_Theme__c where Meeting_Date__c != null AND  Proposals__c=:proposalId];
        System.debug('meetingThemeList: ' +meetingThemeList);
        List<Meeting_Theme__c>  meetingThemeNameList = [select name,id,Meeting_Theme__c,Meeting_Theme_Title__c,Meeting_Date__c,External_Id__c,(select name,id from Meeting_Agenda__r) from Meeting_Theme__c where Meeting_Theme__r.Proposals__c=:proposalId];
        System.debug('meetingThemeNameList: ' +meetingThemeNameList);
        List<MeetingDetails> MeetingDetlList = New List<MeetingDetails>();
        Map<string, List<MeetingDetails>> meetingThemeIdXmdList = new Map<string, List<MeetingDetails>>();
        for (Meeting_Theme__c mTheme : meetingThemeNameList) {
            if(meetingThemeIdXmdList.containsKey(mTheme.Meeting_Theme__c)){
                MeetingDetails mDetail = New MeetingDetails();
                mDetail.meetingTopic = mTheme;
                mDetail.meetingAgenda = mTheme.Meeting_Agenda__r;
                List<MeetingDetails> mdList = meetingThemeIdXmdList.get(mTheme.Meeting_Theme__c);
                mdList.add(mDetail);
                meetingThemeIdXmdList.put(mTheme.Meeting_Theme__c,mdList);
            }else{
                MeetingDetails mDetail = New MeetingDetails();
                mDetail.meetingTopic = mTheme;
                mDetail.meetingAgenda = mTheme.Meeting_Agenda__r;
                meetingThemeIdXmdList.put(mTheme.Meeting_Theme__c,New List<MeetingDetails>{mDetail});
            }
        }
        
        List<MeetingThemeWrapper> MeetingThemeWrapperList = new List<MeetingThemeWrapper>();
        for(Meeting_Theme__c theme:meetingThemeList){
            MeetingThemeWrapper mTWrapper = New MeetingThemeWrapper();
            mTWrapper.meetingTheme = theme;
            mTWrapper.MeetingDetailList = meetingThemeIdXmdList.get(theme.Id);
            MeetingThemeWrapperList.add(mTWrapper);
        }
        System.debug('MeetingThemeWrapperList: ' +MeetingThemeWrapperList);
        return MeetingThemeWrapperList;
    }
    Public static string saveMeetingDetails(List<MeetingThemeWrapper> meetingThemeWrapper){
        List<Meeting_Theme__c> meetingThemeToUpdate = new List<Meeting_Theme__c>();
        Map<string, list<Meeting_Theme__c>> extrnalIdXchildMeetingTheme = new Map<string, list<Meeting_Theme__c>>();
        Map<string, list<Meeting_Agenda__c>> extrnalIdXMeetingAgenda = new Map<string, list<Meeting_Agenda__c>>();
        for(meetingThemeWrapper mtWrapper:meetingThemeWrapper){
            if(mtWrapper.meetingYear !=0){
                mtWrapper.meetingTheme.Meeting_Date__c = Date.newInstance(mtWrapper.meetingYear,mtWrapper.meetingMonth,mtWrapper.meetingYear);
            }
            meetingThemeToUpdate.add(mtWrapper.meetingTheme);
            for(MeetingDetails meetingDetl:mtWrapper.MeetingDetailList){
                if(extrnalIdXchildMeetingTheme.containsKey(mtWrapper.meetingTheme.External_Id__c)){
                    extrnalIdXchildMeetingTheme.get(mtWrapper.meetingTheme.External_Id__c).add(meetingDetl.meetingTopic);
                }else{
                    extrnalIdXchildMeetingTheme.put(mtWrapper.meetingTheme.External_Id__c,New List<Meeting_Theme__c>{meetingDetl.meetingTopic});
                }
                
                if(extrnalIdXMeetingAgenda.containsKey(meetingDetl.meetingTopic.External_Id__c)){
                    List<Meeting_Agenda__c> meetingAgendaList = extrnalIdXMeetingAgenda.get(meetingDetl.meetingTopic.External_Id__c);
                    meetingAgendaList.addAll(meetingDetl.meetingAgenda);
                    extrnalIdXMeetingAgenda.put(meetingDetl.meetingTopic.External_Id__c,meetingAgendaList);
                }else{
                    extrnalIdXMeetingAgenda.put(mtWrapper.meetingTheme.External_Id__c,meetingDetl.meetingAgenda);
                }
            }
        }
        Map<string,string> meetingDateEIdXmeetingDateId = New map<string,string>();
        Map<string,string> childmThemeEIdXchildmThemeId = New map<string,string>();
        upsert meetingThemeToUpdate;
        for(Meeting_Theme__c updatedMtheme:meetingThemeToUpdate){
            meetingDateEIdXmeetingDateId.put(updatedMtheme.External_Id__c,updatedMtheme.Id);
        }
        List<Meeting_Theme__c> childMeetingThemeToUpdate = new List<Meeting_Theme__c>();
        List<Meeting_Agenda__c> meetingAgendaToUpdate = new List<Meeting_Agenda__c>();
        for(string externalId:extrnalIdXchildMeetingTheme.keySet()){
            for (Meeting_Theme__c mTheme : extrnalIdXchildMeetingTheme.get(externalId)) {
                mTheme.Meeting_Theme__c = meetingDateEIdXmeetingDateId.get(externalId);
                childMeetingThemeToUpdate.add(mTheme);
            }
        }
        upsert childMeetingThemeToUpdate;
        for(Meeting_Theme__c updatedMtheme:childMeetingThemeToUpdate){
            childmThemeEIdXchildmThemeId.put(updatedMtheme.External_Id__c,updatedMtheme.Id);
        }
        
        for(string externalId:extrnalIdXMeetingAgenda.keySet()){
            for (Meeting_Agenda__c mAgenda : extrnalIdXMeetingAgenda.get(externalId)) {
                mAgenda.Meeting_Theme__c = childmThemeEIdXchildmThemeId.get(externalId);
                meetingAgendaToUpdate.add(mAgenda);
            }
        }
        System.debug('extrnalIdXchildMeetingTheme: ' +extrnalIdXchildMeetingTheme);
        System.debug('extrnalIdXMeetingAgenda: ' +extrnalIdXMeetingAgenda);
        System.debug('meetingDateEIdXmeetingDateId: ' +meetingDateEIdXmeetingDateId);
        System.debug('childmThemeEIdXchildmThemeId: ' +childmThemeEIdXchildmThemeId);
        System.debug('meetingAgendaToUpdate: ' +meetingAgendaToUpdate);
        
        upsert meetingAgendaToUpdate;
        return null;
    }
    
    
    public class ContactUserDocumentWrapper{
        public list<UserDocumentWrapper> userDocWrapper;
        public Contact userDetails;
        public Contact applicationProposal;
    }
    
    public class UserDocumentWrapper{
        public User_Document__c userDocument;
        public ContentVersion contentVersion;
        public ContentDistribution ContentDistribution;
    }
    public class ProposalDocumentWrapper{
        public Proposal_Document__c userDocument;
        public ContentVersion contentVersion;
        public ContentDistribution ContentDistribution;
    }
    
    
    Public class MeetingThemeWrapper{
        public Meeting_Theme__c meetingTheme;
        public integer meetingDay;
        public integer meetingMonth;
        public integer meetingYear;
        public List<MeetingDetails> MeetingDetailList;
        
    }
    
    public class MeetingDetails{
        public Meeting_Theme__c meetingTopic; 
        public list<Meeting_Agenda__c> meetingAgenda; 
    }
    
    public static string saveAsDraftPecfar(Application_Proposal__c proposalDetails){
        try{
            proposalDetails.Stage__c = '1st Stage';
            proposalDetails.Proposal_Stages__c = 'Draft';
            upsert proposalDetails;
            return 'success';
        }catch(Exception e){
            return e.getMessage();
        }
    }
    
    public static string finalSubmitPecfar(Application_Proposal__c proposalDetails){
        try{
            proposalDetails.Stage__c = '1st Stage';
            proposalDetails.Proposal_Stages__c = 'Submitted';
            proposalDetails.Submitted__c = true;
            upsert proposalDetails;
            return 'success';
        }catch(Exception e){
            return e.getMessage();
        }
    }

    public static Contact getFellowshipDetails(string applicantHashCode){
        try{
            Contact conRec = [SELECT Id,Planned_research_activities_of_the_visit__c,Expected_outcomes__c,Basis_for_choosing_your_paired_member__c,Tentative_plans__c,Tentative_Start_Date__c,Tentative_End_Date__c,
            Availing_Fellowship__c,Associated_with_IGSTC__c,Give_Fellowship_Details__c,Give_Associated_Details__c,Proposals__r.Campaign__r.Result_Announcement_Date__c FROM Contact WHERE Login_Hash_Code__c =: applicantHashCode];
            return conRec;
        }catch(Exception e){
            return null;
        }
        
        // contact conRec = [select name,id,Proposals__c from contact where Login_Hash_Code__c =:applicantHashCode limit 1];
        // system.debug('applicantHashCode' +applicantHashCode);
        // Application_Proposal__c proposalRecord;
        // if(!string.isBlank(conRec.Proposals__c)){
        //     proposalRecord = [SELECT id,Name,Research_Approach_Objectives__c,Expected_Deliverables__c,Basis_for_choosing_the_pairing_fellow__c,Tentative_plans_for_networking__c,Tentative_Start_Date__c,
        //     Tentative_End_Date__c,Availing_any_other_fellowship_currently__c,Paired_Applicant_associated_with_IGSTC__c,Availing_Other_Fellowship_Detail__c,Applicant_associated_with_IGSTC_Detail__c,Campaign__r.Result_Announcement_Date__c  FROM Application_Proposal__c WHERE Id=: conRec.Proposals__c];
        //     system.debug('proposalRecord----'+proposalRecord);     
    }

    public String validFor; 
        
        public static Map<String, List<String>> getFieldDependencies(String objectName, String controllingField, String dependentField)
        {
            Map<String, List<String>> controllingInfo = new Map<String, List<String>>();
            
            Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
            
            Schema.DescribeSObjectResult describeResult = objType.getDescribe();
            Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();
            Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(dependentField).getDescribe();
            
            List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
            List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();
            
            for(Schema.PicklistEntry currControllingValue : controllingValues)
            {
                System.debug('ControllingField: Label:' + currControllingValue.getLabel());
                controllingInfo.put(currControllingValue.getLabel(), new List<String>());
            }
            
            for(Schema.PicklistEntry currDependentValue : dependentValues)
            {
                String jsonString = JSON.serialize(currDependentValue);
                
                MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);
                
                String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();
                
                System.debug('DependentField: Label:' + currDependentValue.getLabel() + ' ValidForInHex:' + hexString + ' JsonString:' + jsonString);
                
                Integer baseCount = 0;
                
                for(Integer curr : hexString.getChars())
                {
                    Integer val = 0;
                    
                    if(curr >= 65)
                    {
                        val = curr - 65 + 10;
                    }
                    else
                    {
                        val = curr - 48;
                    }
                    
                    if((val & 8) == 8)
                    {
                        System.debug('Dependent Field: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 0].getLabel());
                        controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
                    }
                    if((val & 4) == 4)
                    {
                        System.debug('Dependent Field: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 1].getLabel());
                        controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());                    
                    }
                    if((val & 2) == 2)
                    {
                        System.debug('Dependent Field: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 2].getLabel());
                        controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());                    
                    }
                    if((val & 1) == 1)
                    {
                        System.debug('Dependent Field: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 3].getLabel());
                        controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());                    
                    }
                    
                    baseCount += 4;
                }            
            } 
            
            System.debug('ControllingInfo: ' + controllingInfo);
            
            return controllingInfo;
        }
        class MyPickListInfo {
            public String active {get; set;}
            public String defaultValue {get; set;}
            public String label {get; set;}
            public String value {get; set;}
            public String validFor {get; set;}
		}

        public static Contact getCoodinatorDetList(string hashcode){
            Contact ContactRecord = [SELECT Id,Title,FirstName,LastName,Name,Email,Actual_Position__c,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalCode,Country__c,States__c,Account.Name,Publications_Patents__c,Publications_Patents_Relevant__c,
            Account.BillingCountry,(SELECT Name,Degree__c,Start_Year__c,End_Year__c,CGPA__c,End_Date__c,Start_Date__c,Institution_Name__c,Area_of_specialization__c,Percentage__c,Percentage_cgpa__c 
            FROM Education_Details__r),(SELECT Id,Organization_Name__c,Position__c,Start_Year__c,End_Year__c FROM Employment_Details__r)
            FROM Contact WHERE Login_Hash_Code__c=: hashcode];
            return ContactRecord;
        }

        public static List<Contact> getCoordCVDetails(string proposalid){
            try{
                List<Contact> conList = [SELECT Id,Name,FirstName,LastName,Is_Primary__c,Email,Actual_Position__c,MailingStreet,MailingCity,MailingState,MailingCountry,MailingPostalCode,Country__c,States__c,Account.Name,Publications_Patents__c,
                Account.BillingCountry,(SELECT Name,Degree__c,Start_Year__c,End_Year__c,CGPA__c,End_Date__c,Start_Date__c,Institution_Name__c,Area_of_specialization__c,Percentage__c,Percentage_cgpa__c 
                FROM Education_Details__r),(SELECT Id,Organization_Name__c,Position__c,Start_Year__c,End_Year__c FROM Employment_Details__r)
                FROM Contact WHERE Proposals__c=: proposalid];

                return conList;
            }catch(Exception e){
                return null;
            }
        }

        public static void deleteEducationWorkshop(string eduId){
            delete new Education_Details__c(id=eduId);
        }
    
        public static void deleteEmploymentWorkshop(string empId){
            delete new Employment_Details__c(id=empId);
        }

        public static string SaveWorkshopContactDetails(List<Contact> conDataList, List<Education_Details__c> eduDetails, List<Employment_Details__c> empDetails){
            try{
                for(Contact con : conDataList){
                    con.MailingState = con.State__c;
                }
                upsert conDataList;
                upsert eduDetails;
                upsert empDetails;
                return 'success';
            }catch(Exception e){
                return e.getMessage();
            }
        }

        public static Account getAddressDetails(string hashcode){
            try{
                Contact conRec = [Select Id,Name,AccountId FROM Contact WHERE Login_Hash_Code__c=: hashcode];
                Account accRecord = [SELECT Id,Title__c,Head_Of_Project__c,Industry__c,Academia__c,Name,BillingStreet,BillingCity,BillingState,BillingCountry,BillingPostalCode,Homepage_URL__c,Year_Of_Establishment__c,Main_Business_Area__c,NumberOfEmployees,
                Infrastructural_Facilities__c,Domain_Expertise_Available__c,Ownership_Profile__c,Last_Year_s_Balance__c,Website,DSIR_Recoginition_Details__c,Country_Type__c,
                (SELECT Id,Title,Name,LastName,Email,Phone,Department,Designation__c FROM Contacts) FROM Account WHERE Id=: conRec.AccountId];
                return accRecord;
            }catch(Exception e){
                return null;
            }
        }

        public static string saveAddressDetails(Account addressDetails, List<Contact> contactList){
            try{
                addressDetails.NumberOfEmployees = Integer.valueOf(addressDetails.NumberOfEmployees);
                addressDetails.BillingState = addressDetails.Shipping_State__c;
                upsert contactList;
                upsert addressDetails;
                return 'success';
            }catch(Exception e){
                return e.getMessage() + e.getLineNumber();
            }
        }

        public static List<Contact> getAllContacts(){
            try{
                List<Contact> conRec = [SELECT Id,Name,Email FROM Contact];
                return conRec;
            }catch(Exception e){
                return null;
            }
        }

        public static List<References__c> checkReferenceEmail(List<string> email, List<Id> ids){
            try{
                List<References__c> refList = [SELECT Id,Name,Email__c FROM References__c WHERE Email__c IN: email AND Id NOT IN: ids];
                return refList;
            }catch(Exception e){
                return null;
            }
        }

        public static List<Contact> checkEmail(string email, string contId){
            try{
                List<Contact> conRec = [SELECT Id,Name,Email FROM Contact WHERE Email =: email AND Id !=: contId];
                return conRec;
            }catch(Exception e){
                return null;
            }
        }

        public static string getConForHostNationality(string userId){
            try{
                Contact conRec = [SELECT Id,Name,Nationalities__c,Nationality__c,MailingCountry FROM Contact WHERE Login_Hash_Code__c =: userId];
                return conRec.MailingCountry;
            }catch(Exception e){
                return e.getMessage()+e.getLineNumber();
            }
        }

        public static string createHostContact(string conID, string projectid){
            try{
                Account acc = New Account();
                acc.Name = 'hostaccABC';
                // acc.Proposals__c = projectId;
                upsert acc;
                Contact conRec = New Contact();
                ConRec.LastName = 'hostaccABC';
                conRec.AccountId = acc.Id;
                conRec.Proposals__c = projectid;

                
                // conRec.Proposals__c = projectId;
                upsert conRec;

                Contact primCon = New Contact();
                primCon.Id = conID;
                primCon.Host_Details__c = conRec.Id;
                update primCon;
                return conRec.Id;

            }catch(Exception e){
                return e.getMessage()+e.getLineNumber();
            }
        }

        public static Contact getCVDetailsForWiserApplicant(string userId){
            try{
                Contact conRec = [SELECT Id,Name,FirstName,LastName,Phone,Email,Publications_Patents__c,List_Of_Patents_Filed_Granted__c,Book_Chapters_Monographs__c,Any_Other_Notable_Achievements__c,
                (SELECT Id,Degree__c,End_Year__c,Start_Year__c,Institution_Name__c,Percentage__c,Percentage_cgpa__c,Area_of_specialization__c FROM Education_Details__r),
                (SELECT Id,End_Year__c,Start_Year__c,Position__c,current_employement__c,Organization_Name__c,Nature_of_Job__c FROM Employment_Details__r) FROM Contact WHERE Login_Hash_Code__c=: userId];
                return conRec;

            }catch(Exception e){
                return null;
            }
        }

        public static Account getMentorHostDetails(string userId){
            try{
                Contact conRec = [SELECT Id,Name,AccountID,Account.Host_Account__c FROM Contact WHERE Login_Hash_Code__c=: userId];
                system.debug('conRec ::'+conRec);
                Account accRec = New Account();
                if(!string.isBlank(conRec.Account.Host_Account__c)){
                    accRec = [SELECT Id,Name,BillingCity,BillingStreet,BillingState,BillingCountry,BillingPostalCode,Name_of_Mentor__c,Designation_Position_of_the_Mentor__c,
                Mentor_contact_number__c,Mentor_E_mail_Id__c,Organisation_Posrt__c,Proposals__c FROM Account WHERE Id=: conRec.Account.Host_Account__c];
                }
                system.debug('accRec ::'+accRec);
                return accRec;
            }catch(Exception e){
                return null;
            }
        }
        // public static String reviewApp(string proID,string CampaignType){
        //     try{
        //         return UtilityMethodsForDocGeneration.generateTempForAppPortal(proID, CampaignType);
        //     }catch(Exception e){
        //         system.debug('The Error :: '+e.getMessage()+' AND Line No :: '+e.getLineNumber()+'');
        //         return 'Error Occured';
        //         }
        //    }
        public String reviewAppDocGen(string proID){
            try{
                // UtilityMethodsForDocGeneration.generateTempForAppPortal(proID, CampaignType);
                // UtilityMethodsForDocGeneration.generateTempForAppPortal(proID, CampaignType);
                CongaDocGeneration.generateIFTemplateFromProposal(proID);
                return 'success';
            }catch(Exception e){
                system.debug('The Error :: '+e.getMessage()+' AND Line No :: '+e.getLineNumber()+'');
                return 'Error Occured';
                }
           }
    
           public list<Attachment> getCongaDoc(string proID){
            
            try{
                string attId=CongaDocGeneration.getLatestAttachmentId(proID);
                if(attId!=null){
                    return [SELECT Id, ParentId , ContentType , Name FROM Attachment where id=:attId];
                }else{
                    return new List<attachment>();
                }
            }catch(Exception e){
                system.debug('The Error :: '+e.getMessage()+' AND Line No :: '+e.getLineNumber()+'');
                return new List<attachment>();
                }
           }
    
        public String updateIFDocStatus(Application_Proposal__c instanceProposal){
            try{
                upsert instanceProposal;
                return 'success';
            }catch(Exception e){
                system.debug('The Error :: '+e.getMessage()+' AND Line No :: '+e.getLineNumber()+'');
                return 'Error Occured';
                }
           }

        public static string saveMentorHostDetails(Account AccountRecord, string userId, string proposalID){
            try{
                AccountRecord.BillingState = AccountRecord.Shipping_State__c;
                AccountRecord.Proposals__c = proposalID;
                AccountRecord.Host__c = true;
                upsert AccountRecord;
                Contact conRec = [SELECT Id,Name,AccountId FROM Contact Where Login_Hash_Code__c=: userId];
                Account accRec = [SELECT Id,Host_Account__c From Account WHERE Id=: conRec.AccountId];
                    accRec.Host_Account__c = AccountRecord.Id;
                upsert accRec;
                system.debug('conRecconRec ::'+conRec);
                system.debug('accRec.Host_Account__c ::'+accRec.Host_Account__c);
                return 'SUCCESS';
            }catch(Exception e){
                return e.getMessage()+e.getLineNumber();
            }
        }

        @AuraEnabled
        public static List<Evaluation_Step__c> getEvaluationRecords(string proposalId){
            try{
                if(!String.isBlank(proposalId)){
                    List<Evaluation_Step__c> evaluationStepList = [SELECT Id,Name,Subject__c,Comments__c,Yes__c From Evaluation_Step__c WHERE Proposals__c =: proposalId];
                    if(evaluationStepList.size() > 0){
                        system.debug('evaluationStepList -----> '+evaluationStepList);
                        return evaluationStepList;
                    }
                }
                system.debug('null ------> ');
                return null;
            }catch(Exception e){
                return null;
            }
        }

        @AuraEnabled
        public static string saveEvaluationRecords(List<Evaluation_Step__c> evaluationRecordList){
            System.debug('evaluationRecordList === >'+evaluationRecordList);
            try{

                set <Id> evaluationIdSet = New set<Id>();
                for(Evaluation_Step__c eve : evaluationRecordList){
                    evaluationIdSet.add(eve.Id);
                }
                List<Evaluation_Step__c> listOfEligibilityRec = [SELECT Id,Proposals__c From Evaluation_Step__c WHERE Id IN : evaluationIdSet];
                String propId = listOfEligibilityRec[0].Proposals__c;

                Application_Proposal__c apptoUpdate = New Application_Proposal__c();
                apptoUpdate.Id = propId;
                apptoUpdate.Eligibility_Status__c = 'Submitted';
                
                update apptoUpdate;
                update evaluationRecordList;
                return 'SUCCESS';
            }catch(Exception e){
                return e.getMessage() + e.getLineNumber();
            }
        }

        @AuraEnabled
        public static string SaveDraftEvaluationRecords(List<Evaluation_Step__c> evaluationRecordList){
            System.debug('evaluationRecordList === >'+evaluationRecordList);
            try{
                set <Id> evaluationIdSet = New set<Id>();
                for(Evaluation_Step__c eve : evaluationRecordList){
                    evaluationIdSet.add(eve.Id);
                }
                List<Evaluation_Step__c> listOfEligibilityRec = [SELECT Id,Proposals__c From Evaluation_Step__c WHERE Id IN : evaluationIdSet];
                String propId = listOfEligibilityRec[0].Proposals__c;

                Application_Proposal__c apptoUpdate = New Application_Proposal__c();
                apptoUpdate.Id = propId;
                apptoUpdate.Eligibility_Status__c = 'Draft';

                update apptoUpdate;
                update evaluationRecordList;
                return 'SUCCESS';
            }catch(Exception e){
                return e.getMessage() + e.getLineNumber();
            }
        }

        @AuraEnabled
        public static string getAttachmentId(string propId){
            return [SELECT Id, Name FROM Attachment WHERE ParentID =: propId Order by LastModifiedDate ASC LIMIT 1].Id;
        }
}