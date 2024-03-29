/**
 * @author [Dinesh B]
 * @email dinesh.b@utilitarianLab.com
 * @create date 2022-07-05 11:52:25
 * @modify date 2022-07-05 11:52:25
 * @updated by - Baski
 * @desc [description]
 */


public withOut sharing class ReviewerPortal_Controller {
    public string tabValues  {get;set;}
    public String GradValues {get;set;}
    public String RatingValues {get;set;}
    public String stages {get;set;}
    public string reviewersIdd {get;set;}
    public String candidateId {get;set;}

      //************************************** Getting Custom Setting Data ***********************************************
    
    public ReviewerPortal_Controller() {
        list<Reviwer_Portal_Tabs__c> cdTabs = [select name,Tab_Label__c,id,Controller_Name__c,Display_Order__c from Reviwer_Portal_Tabs__c ORDER BY Display_Order__c];
        System.debug('cdTabs--'+cdTabs);
        tabValues = JSON.serialize(cdTabs);
        GradValues = JSON.serialize(Utility.getPicklistValues('Reviewer_Response_LineItem__c' , 'Grade_Value__c'));
        RatingValues = JSON.serialize(Utility.getPicklistValues('Reviewer_Response_LineItem__c' , 'Rating__c'));
        stages = JSON.serialize(Utility.getPicklistValues('Reviewer_Mapping__c' , 'Stage__c'));
        candidateId = Apexpages.currentPage().getParameters().get('id');

        if(!string.isBlank(candidateId)){
            List<Reviewer__c> applicantDetails = [select Email__c,name,Id from Reviewer__c where Login_hash_code__c =:candidateId];

            if(applicantDetails.size() >0){
                reviewersIdd = applicantDetails[0].Id;
            }
        }
    }
    
      //************************************** Reviewer DETAIL PAGE ***********************************************

    @RemoteAction
    public static Reviewer__c GetReviewerDetails(String hashCode) {
        List<Reviewer__c> RevList = [SELECT Id,Name,Email__c,Password__c,Login_Hash_Code__c FROM Reviewer__c WHERE Login_Hash_Code__c =: hashCode ];
        
        if(RevList.size()>0){
            System.debug('the GetReviewerDetails RecordID  :: '+RevList[0].Id);
            return RevList[0];
        }
        return null;
    }

    // This method fetch all Attachments under proposal
    @RemoteAction
    public static List<Attachment> getProAttachment(String proId){
        System.debug('proId----'+proId);
        // list<Contact> listId =[select id from contact where proposals__c=:proId];
        return [SELECT Id, ParentId , ContentType , Name FROM Attachment WHERE ParentId=:proId  ORDER BY LastModifiedDate DESC Limit 1];
    }
    @RemoteAction
    public static list<UserDocumentWrapper> getContactUserDoc(String proId) {
        try{
            list<Contact> parentId =[select id from contact where proposals__c=:proId];
            list<UserDocumentWrapper> udWrapperList = New List<UserDocumentWrapper>();
            map<string,ContentDocumentLink> userDocIdXcdLink = New map<string,ContentDocumentLink>();
            map<string,ContentDistribution> userDocIdXcDistrbtn = New map<string,ContentDistribution>();

            map<string,User_Document__c> idXUserDoc = New Map<string,User_Document__c>();
            map<string,ContentDocumentLink> udIdXcdLink = New Map<string,ContentDocumentLink>();
            list<User_Document__c> getUserDoc;
            if(parentId.getSObjectType().getDescribe().getName() == 'Contact'){
                getUserDoc = [select name,id,Status__c from User_Document__c where Contact__c in :parentId and Status__c='Uploaded'];
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
    @RemoteAction
    public static List<Reviewer_Mapping__c> onpageload(string reviewerId){
        List<Reviewer__c> rev=[select campaign__c from Reviewer__c where Login_Hash_Code__c=:reviewerId];
        Set<String> campaign = new Set<String>();
        for(Reviewer__c r : rev){
            campaign.add(r.Campaign__c);
        }
        // return [select id,Stage__c, Review_Due_Date__c, Proposals__r.Campaign__r.Name, Proposals__r.Name,Proposals__r.Acronym__c,Proposals__r.Title_Of__c,Proposals__r.Title_In_German__c,Proposals__r.KeyWords__c,Proposals__r.Duration_In_Months_Max_36__c,Proposals__r.Id from Reviewer_Mapping__c where Reviewer__r.Login_Hash_Code__c =: reviewerId and Proposals__r.campaign__r.Id=:campaign];
        return [select id,Stage__c, Review_Due_Date__c, Proposals__r.Campaign__r.Name, Proposals__r.Name,Proposals__r.Acronym__c,Proposals__r.Title_Of__c,Proposals__r.Title_In_German__c,Proposals__r.KeyWords__c,Proposals__r.Duration_In_Months_Max_36__c,Proposals__r.Id from Reviewer_Mapping__c where Reviewer__r.Login_Hash_Code__c =: reviewerId];
    }
    @RemoteAction
    public static List<Reviewer_Mapping__c> getProposalByDueDate(string reviewerId){
        Date todayDate=date.today().addDays(-20);
        List<Reviewer__c> rev=[select campaign__c from Reviewer__c where Login_Hash_Code__c=:reviewerId];
        Set<String> campaign = new Set<String>();
        for(Reviewer__c r : rev){
            campaign.add(r.Campaign__c);
        }
        // return [select id,Stage__c, Review_Due_Date__c, Proposals__r.Name,Proposals__r.Acronym__c,Proposals__r.Title_Of__c,Proposals__r.Title_In_German__c,Proposals__r.KeyWords__c,Proposals__r.Duration_In_Months_Max_36__c,Proposals__r.Id from Reviewer_Mapping__c where Reviewer__r.Login_Hash_Code__c =: reviewerId and Review_Due_Date__c>=:todayDate];
        // return [select id,Stage__c, Review_Due_Date__c, Proposals__r.Campaign__r.Name,Proposals__r.Name,Proposals__r.Acronym__c,Proposals__r.Title_Of__c,Proposals__r.Title_In_German__c,Proposals__r.KeyWords__c,Proposals__r.Duration_In_Months_Max_36__c,Proposals__r.Id from Reviewer_Mapping__c where Reviewer__r.Login_Hash_Code__c =: reviewerId and Proposals__r.campaign__r.Id=:campaign LIMIT 50];
        List<contact> sskk= [select id,Proposals__r.Campaign__r.Name,Proposals__r.Name,Proposals__r.Acronym__c,Proposals__r.Title_Of__c,Proposals__r.Title_In_German__c,Proposals__r.KeyWords__c,Proposals__r.Duration_In_Months_Max_36__c,Proposals__r.Id from contact ];
        return [select id,Stage__c, Review_Due_Date__c, Proposals__r.Campaign__r.Name,Proposals__r.Name,Proposals__r.Acronym__c,Proposals__r.Title_Of__c,Proposals__r.Title_In_German__c,Proposals__r.KeyWords__c,Proposals__r.Duration_In_Months_Max_36__c,Proposals__r.Id from Reviewer_Mapping__c where Reviewer__r.Login_Hash_Code__c =: reviewerId LIMIT 50];
    }
    @RemoteAction
    public static WrapperProposalDetails getProposalDetails(String pid) {
        // List<contact> listContact=[select id,name,account.name,Account_Country_Type__c,Tentative_Start_Date__c,Tentative_End_Date__c,AccountId,(select id,name,Bank_IFSC_Code__c,Bank_Account_Number__c,Bank_Name__c,Bank_Address__c from Bank_Details__r),account.Name_of_Mentor__c,account.ACCOUNT_ADDRESS_FORMULA__c,account.Phone,account.Email__c,proposals__c from contact where Proposals__c=:pid];
        // List<string> accountIds=new List<string>();
        // for(Contact acc:listContact){
        //     accountIds.add(acc.AccountId);
        // }
        Application_Proposal__c appList = [SELECT Id,Name,Campaign__r.Name,Proposed_Venue__c,Proposed_Date__c,Workshop_Finish_Date__c,Tentative_Start_Date__c,Tentative_End_Date__c,Title_Of__c,Title_In_German__c,Abstract_of_proposed_work__c,Work_plan__c,Background_Concept_Purpose__c,Basis_for_choosing_the_pairing_fellow__c,Tentative_plans_for_networking__c,Specific_Need_For_the_Bilateral_Event__c,Brief_Statement_of_Purpose__c,Proposed_area__c,Awarded_Amount__c,Proposal_Stages__c,Thematic_Topic__c,Equipment__c,Acronym__c,Summary__c,KeyWords__c,Criteria_For_Abandoning_The_Project__c,Current_State_Of_The_Art__c,Expected_Deliverables__c,Duration_In_Months_Max_36__c,Innovative_Aspects__c,Application_Date__c,Research_Scholars__c,Necessity_Of_Funding__c,Research_Approach_Objectives__c,Project_Description__c,Reasons_For_And_Benefits_Of_Cooperation__c,
        (SELECT  Name,AccountName__c,Department,Email,MailingAddress,Industrial_Fellowship_Type__c,Birthdate,DATE_BIRTH_FORMULA__c,Planned_research_activities_of_the_visit__c,Expected_outcomes__c,Account_Country_Type__c,Basis_for_choosing_your_paired_member__c,Tentative_plans__c,Tentative_Start_Date__c,Tentative_End_Date__c FROM Contacts__r), (SELECT Name,Title__c,Duration_End_Month__c,Duration_Start_Month__c FROM Work_Package__r), 
        (SELECT Id,ParentId,Name FROM Attachments order by createdDate desc limit 1), (SELECT Name FROM Proposal_Thematic_Areas__r), Question_Template__c,        
        (SELECT Id,Name,Stage__c FROM Reviewer_Mapping__r) FROM Application_Proposal__c WHERE id =: pid limit 1];        
        // List<Account> accountList=[SELECT name,Academia__c,Industry__c,Website,BillingCountry,(select Budget__c,Duration__c,Funding_Agency__c,Starting_Date__c,Title__c from Existing_Grants__r),(select Asked_From_IGSTC__c,IGSTC_Contribution__c,Partner_Name__c,Own_Contribution__c,Total__c from Financial_Contribution__r),(SELECT Id,ParentId,Name FROM Attachments) from Account where Proposals__c=:pid and id not in:accountIds];
        List<Account> accountList=[SELECT name,Name_of_Mentor__c,Academia__c,Industry__c,Host__c,Website,BillingCountry,(select Budget__c,Duration__c,Funding_Agency__c,Starting_Date__c,Title__c from Existing_Grants__r),(select Asked_From_IGSTC__c,IGSTC_Contribution__c,Partner_Name__c,Own_Contribution__c,Total__c from Financial_Contribution__r),(SELECT Id,ParentId,Name FROM Attachments) from Account where Proposals__c=:pid];
        List<Work_Package__c> workPackageList = [SELECT Id,TRL_Level__c,End_TRL_Level__c,WP_Sequence__c,Work_Package_Detail__c,Title__c,External_Id__c,Duration__c,Application__c,Account__c,Account__r.Name,(SELECT Id,Name,Account_Name__c,Account__c FROM Account_Mapping__r),
        (SELECT Id,Name From Accounts__r) From Work_Package__c WHERE Application__c =: pid];
        
        // List<Existing_Grants__c> esingGrants=[select Budget__c,Duration__c,Account__r.Name,Funding_Agency__c,Starting_Date__c,Title__c from Existing_Grants__c where Application__c=:pid];
        WrapperProposalDetails instanceWrapper=new WrapperProposalDetails();
        instanceWrapper.accountsList=accountList;
        instanceWrapper.proposalData=appList;
        instanceWrapper.workPackagesList=workPackageList;
        // instanceWrapper.contactsList=listContact;
        // instanceWrapper.existingGrantsList=esingGrants;
        return instanceWrapper;
    }    
    
          //************************************** Application Proposal DETAIL PAGE ***********************************************

    @RemoteAction
    public static List<Application_Proposal__c> getAllProposal(String hashId){    
        try{
            // List<Reviewer_Mapping__c> ReviewMappingList = [Select Id, Name,Stage__c,Reviewer__r.Name,Reviewer__r.Campaign__c,Reviewer__r.Email__c,Proposals__r.Name,Proposals__r.Title_Of__c,Proposals__r.Id From Reviewer_Mapping__c WHERE Reviewer__r.Login_Hash_Code__c =: hashId and Reviewer__r.Campaign__c!=null];
            List<Reviewer_Mapping__c> ReviewMappingList = [Select Id, Name,Stage__c,Reviewer__r.Name,Reviewer__r.Campaign__c,Reviewer__r.Email__c,Proposals__r.Name,Proposals__r.Title_Of__c,Proposals__r.Id From Reviewer_Mapping__c WHERE Reviewer__r.Login_Hash_Code__c =: hashId];
               // Getting Purposal Which Are present in the Reviewer_Mapping__c object.
            Set<String> PurposalId = new Set<String>();
            Set<String> campaign = new Set<String>();
            for(Reviewer_Mapping__c PurpoId : ReviewMappingList){
                PurposalId.add(PurpoId.Proposals__c);
                campaign.add(PurpoId.Reviewer__r.Campaign__c);
                System.debug('The Purposal ID :'+PurposalId);
                System.debug('The Campaign ID :'+PurpoId.Reviewer__r.Campaign__c);
            }
         
            List<Application_Proposal__c> PurposalList = [SELECT Id,Name,Title_Of__c,Title_In_German__c,Awarded_Amount__c,Proposal_Stages__c,
                                                          Thematic_Topic__c,Equipment__c,Acronym__c,Summary__c,KeyWords__c,Criteria_For_Abandoning_The_Project__c,
                                                          Current_State_Of_The_Art__c,Expected_Deliverables__c,Duration_In_Months_Max_36__c,Innovative_Aspects__c,
                                                          Application_Date__c,Research_Scholars__c,Necessity_Of_Funding__c,Research_Approach_Objectives__c,
                                                          Project_Description__c,Reasons_For_And_Benefits_Of_Cooperation__c,
                                                          (SELECT  Name,AccountName__c,Department,Email,Account_Phone__c,Account_BillingCity__c FROM Contacts__r),
                                                          (SELECT Name,Title__c,Duration_End_Month__c,Duration_Start_Month__c FROM Work_Package__r),
                                                          (SELECT Id,ParentId,Name FROM Attachments), (SELECT Name,Budget__c,Funding_Agency__c,Title__c FROM Existing_Grants__r),
                                                          (SELECT Name FROM Proposal_Thematic_Areas__r), Question_Template__c,
                                                          (SELECT Id,Name,Stage__c FROM Reviewer_Mapping__r 
                                                           WHERE Reviewer__r.Login_Hash_Code__c =: hashId) 
                                                          FROM Application_Proposal__c WHERE ID =: PurposalId];
            // String richTextToPlainText = PurposalList[0].Project_Description__c.stripHtmlTags();
            // System.debug('djsjdshdsjdsgd----'+richTextToPlainText);
            if(PurposalList.size()>0){
                System.debug('PurposalList-->'+PurposalList[0]);
                return PurposalList;
            }
            return null;
        }catch(Exception e){
            System.debug('The Error '+e.getMessage());
            return null;
        } 
    }
    @RemoteAction
    public static string updateReviewerDetails(Reviewer__c instanceReviewer,Integer birthDay,Integer birthMonth,Integer birthYear){
        Date newBirthDate;
        if(birthDay!=0){
            newBirthDate=Date.newInstance(birthYear,birthMonth,birthDay);
            instanceReviewer.Birthdate__c=newBirthDate;
        }
        upsert instanceReviewer;
        return 'success';
    }
    @RemoteAction
    Public Static Reviewer__c getReviewerDet(String ReviewerId){
        return [SELECT Id,Name,Birthdate__c,Email__c,Gender__c,Password__c,Phone__c,Skills__c,Profile_Pic_Attachment_Id__c,(select name,id from Attachments Order By CreatedDate DESC limit 1) from Reviewer__c where Login_Hash_Code__c=:ReviewerId];
    } 
//************************************** Questiotion& Response Wrapper Class DETAIL PAGE ***********************************************
@RemoteAction
    Public Static List<Reviewer_Mapping__c> getReviewersDet(String QuesTempId,String ReviewerMapId,String ProposalId,string hashId){
        system.debug('QuesTempId ::'+QuesTempId);
        // QLI : Question Line Item
        // RRLI:  Reviewer Response Line Item
        //select id,name,(select id from Reviewer_Response_LineItem__r WHERE Reviewer_Mapping__c !='a1T1y000001i0m9EAA'),Reviewer__r.Name from Reviewer_Mapping__c where Proposals__c='a081y0000029D81AAE' and id!='a1T1y000001i0m9EAA'
        return [SELECT Id,Name,QTID__c,Stage__c,Reviewer__r.Name,Reviewer__r.Email__c,Reviewer__r.Skills__c,(select id,Name,Grade_Value__c,Ratings__c,Response__c,
        Reviewer_Mapping__r.Stage__c from Reviewer_Response_LineItem__r) FROM Reviewer_Mapping__c WHERE Proposals__c=: ProposalId and Reviewer__r.Login_Hash_Code__c =: hashId and id!=:QuesTempId];


        
        // return [SELECT Id,Name,Question__c,Question_Template__c,Is_Comment_Applicable__c,Is_Grading_Applicable__c,Is_Rating_Applicable__c,Question_Template__r.Total_Questions__c,Question_Template__r.Name,
        // (SELECT Id,Name,Grade_Value__c,Rating__c,Response__c,Reviewer_Mapping__r.Stage__c FROM Reviewer_Response_LineItem__r WHERE Reviewer_Mapping__c !=: ReviewerMapId) 
        // FROM Question_Line_Item__c  WHERE Question_Template__c =:QuesTempId ORDER BY Name];
        
        // List<QuestionLIWrapper> WrapRes = new List<QuestionLIWrapper>();
        
        // for(Question_Line_Item__c QLIMRes : getAllQuesLintItem){
        //   QuestionLIWrapper wrap = new QuestionLIWrapper();
        //   if(QLIMRes.Reviewer_Response_LineItem__r.size()>0){
        //     wrap.RRLineItemList = QLIMRes.Reviewer_Response_LineItem__r[0];
        //   }
        //     wrap.getQuesLineItemList = QLIMRes;
        //     for(Reviewer_Response_LineItem__c rrl : QLIMRes.Reviewer_Response_LineItem__r){
        //         wrap.rmStage = rrl.Reviewer_Mapping__r.Stage__c;
        //     }
            
        //    WrapRes.add(wrap);
        // }
        
        // return WrapRes;
    }
@RemoteAction
    Public Static List<QuestionLIWrapper> getAllQLIAndRRLI(String QuesTempId,String ReviewerMapId){
        system.debug('QuesTempId ::'+QuesTempId);
        system.debug('ReviewerMapId ::'+ReviewerMapId);
        // QLI : Question Line Item
        // RRLI:  Reviewer Response Line Item
        //select id,name,(select id from Reviewer_Response_LineItem__r WHERE Reviewer_Mapping__c !='a1T1y000001i0m9EAA'),Reviewer__r.Name from Reviewer_Mapping__c where Proposals__c='a081y0000029D81AAE' and id!='a1T1y000001i0m9EAA'
        List<Question_Line_Item__c> getAllQuesLintItem = [SELECT Id,Name,Question__c,Question_Template__c,Is_Comment_Applicable__c,Is_Grading_Applicable__c,Is_Rating_Applicable__c,Question_Template__r.Total_Questions__c,Question_Template__r.Name,
        (SELECT Id,Name,Grade_Value__c,Ratings__c,Response__c,Reviewer_Mapping__r.Stage__c FROM Reviewer_Response_LineItem__r WHERE Reviewer_Mapping__c =: ReviewerMapId) 
        FROM Question_Line_Item__c  WHERE Question_Template__c =:QuesTempId ORDER BY Name];
        system.debug('getAllQuesLintItem ::'+getAllQuesLintItem);
        
        List<QuestionLIWrapper> WrapRes = new List<QuestionLIWrapper>();
        
        for(Question_Line_Item__c QLIMRes : getAllQuesLintItem){
          QuestionLIWrapper wrap = new QuestionLIWrapper();
          if(QLIMRes.Reviewer_Response_LineItem__r.size()>0){
            wrap.RRLineItemList = QLIMRes.Reviewer_Response_LineItem__r[0];
            system.debug('wrap.RRLineItemList--'+wrap.RRLineItemList);
          }
            wrap.getQuesLineItemList = QLIMRes;
            system.debug('wrap.RRLineItemList2222--'+wrap.RRLineItemList);
            for(Reviewer_Response_LineItem__c rrl : QLIMRes.Reviewer_Response_LineItem__r){
                wrap.rmStage = rrl.Reviewer_Mapping__r.Stage__c;
            }
            
           WrapRes.add(wrap);
        }
        
        return WrapRes;
    }


//************************************** Getting All Response Line Item DETAIL PAGE ***********************************************

    @RemoteAction 
    public Static string getAllResponseLineItem (List<QuestionLIWrapper> wrapperList, String ReviewerMapId, String param1,Decimal totalScore){
        system.debug('wrapperList---'+wrapperList);
        system.debug('ReviewerMapId---'+ReviewerMapId);
        List<Reviewer_Response_LineItem__c> reviwerResToUpsert = New List<Reviewer_Response_LineItem__c>();

        try{
              for(QuestionLIWrapper wrap:wrapperList){
                System.debug('The wrap Result ----> '+wrap);
                if(wrap.RRLineItemList != null){
                wrap.RRLineItemList.Question_Line_Item__c = wrap.getQuesLineItemList.Id;
                system.debug('wrap.getQuesLineItemList.Id ::'+wrap.getQuesLineItemList.Id);
                if( wrap.RRLineItemList.Id == null){
                    system.debug('ReviewerMapId ::'+ReviewerMapId);
                    wrap.RRLineItemList.Reviewer_Mapping__c = ReviewerMapId;
                }
                reviwerResToUpsert.add(wrap.RRLineItemList);
            }
            System.debug('The reviwerResToUpsert Result ----> '+reviwerResToUpsert);
        }
        upsert reviwerResToUpsert;
        Reviewer_Mapping__c revMap = New Reviewer_Mapping__c(Stage__c = param1,Total_Score__c=totalScore,Id=ReviewerMapId);

        update revMap;
        
        // return wrapperList;
return 'success';
        }catch(Exception e){
                System.debug('The Error '+e.getMessage());
                System.debug('Erron Line '+e.getLineNumber());
                return e.getMessage()+' '+e.getLineNumber();
            }

      //return null;
    }

    @RemoteAction
    public static string finalSubmission(List<QuestionLIWrapper> wrapperList, String ReviewerMapId){
        try{
            return 'success';
        }catch(Exception e){
            return 'error';
        }
    }
    @RemoteAction
    public static String doUploadProfilePicReviewer(String contactId, String attachmentBody, String attachmentName) {
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
           
            update new Reviewer__c(Id = contactId,Profile_Pic_Attachment_Id__c = attId );
            return attId;
        }
        return null;
    }
    public static String doCUploadAttachmentReviewerOld(String attachmentBody, String attachmentName, string cvId, String udId) {
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
    public static list<UserDocumentWrapper> getReviewerUserDoc(id parentId) {
        try{
            list<UserDocumentWrapper> udWrapperList = New List<UserDocumentWrapper>();
            map<string,ContentDocumentLink> userDocIdXcdLink = New map<string,ContentDocumentLink>();
            map<string,ContentDistribution> userDocIdXcDistrbtn = New map<string,ContentDistribution>();

            map<string,User_Document__c> idXUserDoc = New Map<string,User_Document__c>();
            map<string,ContentDocumentLink> udIdXcdLink = New Map<string,ContentDocumentLink>();
            list<User_Document__c> getUserDoc;
            if(parentId.getSObjectType().getDescribe().getName() == 'Reviewer__c'){
                getUserDoc = [select name,id,Status__c from User_Document__c where Reviewer__c =:parentId];
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
    @RemoteAction
    public static string LogoutReviewer(String hashCode){
        try{
            Reviewer__c conRec = [SELECT Name,Email__c,Password__c FROM Reviewer__c WHERE Login_Hash_Code__c=:hashcode LIMIT  1];
            conRec.Login_Hash_Code__c=null;
            update conRec;
            return 'success';
            }
            catch(Exception e){
                system.debug('The Error :: '+e.getMessage()+' AND Line No :: '+e.getLineNumber()+'');
                return 'Exception';
            }
    }   
    public class UserDocumentWrapper{
        public User_Document__c userDocument;
        public ContentVersion contentVersion;
        public ContentDistribution ContentDistribution;
    }
    public class WrapperProposalDetails{
        public Application_Proposal__c proposalData;
        public List<Account> accountsList;
        public List<Work_Package__c> workPackagesList;
        public List<Existing_Grants__c> existingGrantsList;
        public List<contact> contactsList;
    }
}