public class ProposalTriggerHandler {
    static ProposalTriggerHandler proposalInstance;
    
    public static ProposalTriggerHandler getInstance(){
        if(proposalInstance==null)
            proposalInstance = new ProposalTriggerHandler();
        return proposalInstance;    
    }
    
    public void afterInsert(Map<Id,Application_Proposal__c> proposalMap){
        List<String> proposalIds = new List<String>();
        for(String Str : proposalMap.keySet()){
            proposalIds.add(Str);
        }
        //SharePointCallout.createFolder(proposalMap.keySet());
        sharePointBatch batch = new sharePointBatch(proposalIds);
        Database.executeBatch(batch);
    } 
    
    public static void beforeDelete(List<Application_Proposal__c> newPropList){
       // system.debug('newPropList'+newPropList);
       // for(Application_Proposal__c appProp : newPropList){
            //if(appProp.Id == 'a081y000002xuye' || appProp.Id == 'a081y000002xpMl' ||appProp.Id == 'a081y000002xv1N' || appProp.Id == 'a081y000002xmqYAAQ' || appProp.Id == 'a081y000002xnZ7AAI'){
                //appProp.addError('These records are being used for testing and cannot be deleted.');
           // }
        //}
    }
    
    public void createMasterExpenseRecord(List<Application_Proposal__c> proposalList,Map<Id,Application_Proposal__c> oldProposalMap){
        Set<String> proposalIdSet = new Set<String>();
        Map<String,String> mapofAccidByPropId = New Map<String,String>();
        List<Expense_Master__c> emListTobeInsert = New List<Expense_Master__c>();
        for(Application_Proposal__c ap : proposalList){
            if(ap.Stage__c != null && ap.Stage__c != oldProposalMap.get(ap.Id).Stage__c && ap.Stage__c == '2nd Stage'){
                proposalIdSet.add(ap.Id);
            }
        }
        
        if(!proposalIdSet.isEmpty()){
            List<Account> accList = [select id,proposals__c from account where proposals__c in: proposalIdSet];
            for(Account acc : accList){
                mapofAccidByPropId.put(acc.Id,acc.proposals__c);
            }
            for(Account acc : accList){
                Expense_Master__c em = new Expense_Master__c();
                em.Account__c = acc.id;
                em.Proposals__c = mapofAccidByPropId.get(acc.id);
                emListTobeInsert.add(em);
            }
            if(!emListTobeInsert.isEmpty()){
                insert emListTobeInsert;
            }
        }
    }
    
    public void createDisbursmentFRecord(Map<Id, Application_Proposal__c> newProposalMap,Map<Id,Application_Proposal__c> oldProposalMap){
        Set<id> proposalId = New Set<Id>();
        List<Disbursement_Schedule__c> disbursementList = New List<Disbursement_Schedule__c>();
        Decimal perDayAmount;
        Long Difference;
        
        for(Application_Proposal__c proposalRec : newProposalMap.values()){
            system.debug('proposalRec--->'+proposalRec.RecordType_Name__c);
            system.debug('proposalRec.Proposal_Stages__c ::'+proposalRec.Proposal_Stages__c);
            system.debug('RecordType ::'+proposalRec.RecordType_Name__c);
            if(proposalRec.Proposal_Stages__c != null && proposalRec.Proposal_Stages__c != oldProposalMap.get(proposalRec.Id).Proposal_Stages__c && proposalRec.Proposal_Stages__c == 'Under Decision'){
                if(proposalRec.RecordType_Name__c == 'Industrial Fellowship'){
                    proposalId.add(proposalRec.Id);
                }
            }
        }
        system.debug('proposalId ::'+proposalId);
        List<Contact> contactList = [SELECT Id,Name,Proposals__c,Industrial_Fellowship_Type__c,Proposals__r.Tentative_End_Date__c,Proposals__r.Tentative_Start_Date__c,Proposals__r.RecordType_Name__c FROM Contact WHERE Proposals__c In : proposalId Limit 1];
        system.debug('contactList ::'+contactList);
        if(!contactList.isEMpty()){
            if(contactList[0].Proposals__r.Tentative_Start_Date__c != null && contactList[0].Proposals__r.Tentative_End_Date__c != null){
                Difference = contactList[0].Proposals__r.Tentative_Start_Date__c.monthsBetween(contactList[0].Proposals__r.Tentative_End_Date__c);
            }
            system.debug('Difference ::'+Difference);
            if(contactList[0].Industrial_Fellowship_Type__c == 'PDIF' && contactList[0].Proposals__r.RecordType_Name__c == 'Industrial Fellowship'){
                List<Grant_Portal_Docs__c> getCurrencyForPDIF = [Select Id,Name,Amount__c,Campaign__c,Campaign_Type__c From Grant_Portal_Docs__c WHERE Campaign__c = 'IF' AND Campaign_Type__c = 'PDIF'];
                Date tentitiveEndDate,tentitiveStartDate;
                for(Integer i=0;i<Difference;i++){
                    Disbursement_Schedule__c disbursementRecord = New Disbursement_Schedule__c();
                    disbursementRecord.Proposals__c = contactList[0].Proposals__c;
                    
                    disbursementRecord.Tranche__c = string.valueOf( i + 1 );
                    
                    Integer tentativeday = contactList[0].Proposals__r.Tentative_Start_Date__c.Day();
                    system.debug('tentativeday -----'+tentativeday);
                    Integer tentativemonth = contactList[0].Proposals__r.Tentative_Start_Date__c.Month();
                    system.debug('tentativemonth ----'+tentativemonth);
                    Integer tentativeyear = contactList[0].Proposals__r.Tentative_Start_Date__c.Year();
                    system.debug('tentativeyear ----'+tentativeyear);
                    Integer TotalnumberDays = date.daysInMonth(Integer.valueOf(tentativeyear), Integer.valueOf(tentativemonth));
                    system.debug('TotalnumberDays ------'+TotalnumberDays);
                    Integer TentativeRemainingDays = TotalnumberDays - tentativeday;
                    system.debug('TentativeRemainingDays ------'+TentativeRemainingDays);
                    tentitiveStartDate = contactList[0].Proposals__r.Tentative_End_Date__c;
                    
                    if(i== 0){
                        tentativeday = tentativeday + TentativeRemainingDays;
                        tentitiveStartDate = contactList[0].Proposals__r.Tentative_Start_Date__c;//.addDays(TentativeRemainingDays);
                        system.debug('tentitiveEndDate adding remaining days ------- '+tentitiveEndDate);
                        disbursementRecord.Start_Date__c = tentitiveStartDate;
                        tentitiveEndDate = tentitiveStartDate.addDays(TentativeRemainingDays);
                        tentitiveEndDate = tentitiveEndDate.addMonths(1);
                        disbursementRecord.End_Date__c = tentitiveEndDate;
                        system.debug('disbursementRecord.End_Date__c adding 1 month ------ '+disbursementRecord.End_Date__c);
                        system.debug('tentitiveStartDate--->'+tentitiveStartDate);
                        system.debug('tentitiveEndDate--->'+tentitiveEndDate);
                    }else{
                        disbursementRecord.Start_Date__c = tentitiveEndDate.addMonths(i-1);
                        system.debug(i+ 'Start Date -------- '+disbursementRecord.Start_Date__c);
                        disbursementRecord.End_Date__c = tentitiveEndDate.addMonths(i);
                        system.debug(i+ 'End Date -------- '+disbursementRecord.End_Date__c);
                        system.debug('tentitiveStartDate--->'+tentitiveStartDate);
                        system.debug('tentitiveEndDate--->'+tentitiveEndDate);
                    }
                    
                    if(disbursementRecord.Start_Date__c.day() <= 15 && i == 0){
                        disbursementRecord.Amount__c = getCurrencyForPDIF[0].Amount__c * 2;  
                    }else if(disbursementRecord.Start_Date__c.day() > 15 && i == 0){
                        Integer day = disbursementRecord.Start_Date__c.Day();
                        system.debug('day -----'+day);
                        Integer month = disbursementRecord.Start_Date__c.Month();
                        system.debug('month ----'+month);
                        Integer year = disbursementRecord.Start_Date__c.Year();
                        system.debug('year ----'+year);
                        
                        Integer numberDays = date.daysInMonth(Integer.valueOf(year), Integer.valueOf(month));
                        system.debug('numberDays ------'+numberDays);
                        Integer RemainingDays = numberDays - day;
                        system.debug('remaining days::'+RemainingDays);
                        perDayAmount = getCurrencyForPDIF[0].Amount__c/numberDays;
                        disbursementRecord.Amount__c = perDayAmount*RemainingDays+getCurrencyForPDIF[0].Amount__c;
                    }
                    else{
                        disbursementRecord.Amount__c = getCurrencyForPDIF[0].Amount__c;  
                    }
                    disbursementRecord.Release_Grant_Amount__c = disbursementRecord.Amount__c;
                    disbursementList.add(disbursementRecord);
                }
            } else{
                List<Grant_Portal_Docs__c> getCurrencyForPIEF = [Select Id,Name,Amount__c,Campaign__c,Campaign_Type__c From Grant_Portal_Docs__c WHERE Campaign__c = 'IF' AND Campaign_Type__c = 'PIEF'];
                Date tentitiveEndDate,tentitiveStartDate;
                for(Integer i=0;i<Difference;i++){
                    Disbursement_Schedule__c disbursementRecord = New Disbursement_Schedule__c();
                    disbursementRecord.Proposals__c = contactList[0].Proposals__c;
                    
                    disbursementRecord.Tranche__c = string.valueOf( i + 1 );
                    
                    Integer tentativeday = contactList[0].Proposals__r.Tentative_Start_Date__c.Day();
                    system.debug('tentativeday -----'+tentativeday);
                    Integer tentativemonth = contactList[0].Proposals__r.Tentative_Start_Date__c.Month();
                    system.debug('tentativemonth ----'+tentativemonth);
                    Integer tentativeyear = contactList[0].Proposals__r.Tentative_Start_Date__c.Year();
                    system.debug('tentativeyear ----'+tentativeyear);
                    Integer TotalnumberDays = date.daysInMonth(Integer.valueOf(tentativeyear), Integer.valueOf(tentativemonth));
                    system.debug('TotalnumberDays ------'+TotalnumberDays);
                    Integer TentativeRemainingDays = TotalnumberDays - tentativeday;
                    system.debug('TentativeRemainingDays ------'+TentativeRemainingDays);
                    tentitiveStartDate = contactList[0].Proposals__r.Tentative_End_Date__c;
                    
                    if(i== 0){
                        tentativeday = tentativeday + TentativeRemainingDays;
                        tentitiveStartDate = contactList[0].Proposals__r.Tentative_Start_Date__c;//.addDays(TentativeRemainingDays);
                        system.debug('tentitiveEndDate adding remaining days ------- '+tentitiveEndDate);
                        disbursementRecord.Start_Date__c = tentitiveStartDate;
                        tentitiveEndDate = tentitiveStartDate.addDays(TentativeRemainingDays);
                        tentitiveEndDate = tentitiveEndDate.addMonths(1);
                        disbursementRecord.End_Date__c = tentitiveEndDate;
                        system.debug('disbursementRecord.End_Date__c adding 1 month ------ '+disbursementRecord.End_Date__c);
                        system.debug('tentitiveStartDate--->'+tentitiveStartDate);
                        system.debug('tentitiveEndDate--->'+tentitiveEndDate);
                    }else{
                        disbursementRecord.Start_Date__c = tentitiveEndDate.addMonths(i-1);
                        system.debug(i+ 'Start Date -------- '+disbursementRecord.Start_Date__c);
                        disbursementRecord.End_Date__c = tentitiveEndDate.addMonths(i);
                        system.debug(i+ 'End Date -------- '+disbursementRecord.End_Date__c);
                        system.debug('tentitiveStartDate--->'+tentitiveStartDate);
                        system.debug('tentitiveEndDate--->'+tentitiveEndDate);
                    }
                    
                    if(disbursementRecord.Start_Date__c.day() <= 15 && i == 0){
                        disbursementRecord.Amount__c = getCurrencyForPIEF[0].Amount__c * 2;  
                    }else if(disbursementRecord.Start_Date__c.day() > 15 && i == 0){
                        Integer day = disbursementRecord.Start_Date__c.Day();
                        system.debug('day -----'+day);
                        Integer month = disbursementRecord.Start_Date__c.Month();
                        system.debug('month ----'+month);
                        Integer year = disbursementRecord.Start_Date__c.Year();
                        system.debug('year ----'+year);
                        
                        Integer numberDays = date.daysInMonth(Integer.valueOf(year), Integer.valueOf(month));
                        system.debug('numberDays ------'+numberDays);
                        Integer RemainingDays = numberDays - day;
                        system.debug('remaining days::'+RemainingDays);
                        perDayAmount = getCurrencyForPIEF[0].Amount__c/numberDays;
                        disbursementRecord.Amount__c = perDayAmount*RemainingDays+getCurrencyForPIEF[0].Amount__c;
                    }
                    else{
                        disbursementRecord.Amount__c = getCurrencyForPIEF[0].Amount__c;  
                    }
                    disbursementRecord.Release_Grant_Amount__c = disbursementRecord.Amount__c;
                    disbursementList.add(disbursementRecord);
                }
            }
            
            if(!disbursementList.isEmpty()){
                insert disbursementList;
            }
        }
        
    }

    public void createDisbursmentFRecordForPECFAR(Map<Id, Application_Proposal__c> newProposalMap,Map<Id,Application_Proposal__c> oldProposalMap){
        Set<id> proposalId = New Set<Id>();
        List<Disbursement_Schedule__c> disbursementList = New List<Disbursement_Schedule__c>();
        Decimal perDayAmount;
        
        for(Application_Proposal__c proposalRec : newProposalMap.values()){
            system.debug('proposalRec--->'+proposalRec.RecordType_Name__c);
            system.debug('proposalRec.Proposal_Stages__c ::'+proposalRec.Proposal_Stages__c);
            system.debug('RecordType ::'+proposalRec.RecordType_Name__c);
            if(proposalRec.Proposal_Stages__c != null && proposalRec.Proposal_Stages__c != oldProposalMap.get(proposalRec.Id).Proposal_Stages__c && proposalRec.Proposal_Stages__c == 'Under Decision'){
                if(proposalRec.RecordType_Name__c == 'PECFAR'){
                    proposalId.add(proposalRec.Id);
                }
            }
        }
        system.debug('proposalId ::'+proposalId);
        List<Contact> contactList = [SELECT Id,Name,Proposals__c,Tentative_End_Date__c,Tentative_Start_Date__c,Proposals__r.RecordType_Name__c FROM Contact WHERE Proposals__c In : proposalId];
        system.debug('contactList ::'+contactList);

        if(!contactList.isEMpty()){
          for(Contact con : contactList){
            Long Difference = con.Tentative_Start_Date__c.daysBetween(con.Tentative_End_Date__c);
            system.debug('Difference ::'+Difference);
            if(Difference <= 21){
                List<Grant_Portal_Docs__c> getCurrencyForTwoMonths = [Select Id,Name,Amount__c,Campaign__c,Campaign_Type__c From Grant_Portal_Docs__c WHERE Campaign__c = 'PECFAR' AND Campaign_Type__c = 'Less Two Months'];
                        Disbursement_Schedule__c disbursementRecord = New Disbursement_Schedule__c();
                        Long daysBetweenTwoDates = con.Tentative_Start_Date__c.daysBetween(con.Tentative_End_Date__c);
                        system.debug('daysBetweenTwoDates -----> '+daysBetweenTwoDates);
                        disbursementRecord.Contact__c = con.Id;
                        disbursementRecord.Tranche__c = '1';
                        disbursementRecord.Start_Date__c = con.Tentative_Start_Date__c;
                        disbursementRecord.End_Date__c = con.Tentative_End_Date__c;
                        Decimal TotalAmount = getCurrencyForTwoMonths[0].Amount__c/31*daysBetweenTwoDates;
                        system.debug('TotalAmount --------> '+TotalAmount);
                        disbursementRecord.Amount__c = TotalAmount/90*100;
                        disbursementRecord.Release_Grant_Amount__c = disbursementRecord.Amount__c;
                        disbursementList.add(disbursementRecord);

            }else if (Difference >21 && Difference <= 31){
                List<Grant_Portal_Docs__c> getCurrencyForLessTwoMonths = [Select Id,Name,Amount__c,Campaign__c,Campaign_Type__c From Grant_Portal_Docs__c WHERE Campaign__c = 'PECFAR' AND Campaign_Type__c = 'Two Months'];
                system.debug('getCurrencyForLessTwoMonths -----------> '+getCurrencyForLessTwoMonths);
                Long MonthsDifference = con.Tentative_Start_Date__c.monthsBetween(con.Tentative_End_Date__c);
                system.debug('MonthsDifference ----> '+MonthsDifference);
                    Disbursement_Schedule__c disbursementRecord = New Disbursement_Schedule__c();
                    disbursementRecord.Contact__c = con.Id;
                    disbursementRecord.Tranche__c = '1';
                    disbursementRecord.Start_Date__c = con.Tentative_Start_Date__c;
                    disbursementRecord.End_Date__c = con.Tentative_End_Date__c;
                    disbursementRecord.Amount__c = getCurrencyForLessTwoMonths[0].Amount__c;
                    disbursementRecord.Release_Grant_Amount__c = disbursementRecord.Amount__c;
                    disbursementList.add(disbursementRecord);
            }else{
                List<Grant_Portal_Docs__c> getCurrencyForLessTwoMonths = [Select Id,Name,Amount__c,Campaign__c,Campaign_Type__c From Grant_Portal_Docs__c WHERE Campaign__c = 'PECFAR' AND Campaign_Type__c = 'Two Months'];
                Disbursement_Schedule__c disbursementRecord = New Disbursement_Schedule__c();
                    disbursementRecord.Contact__c = con.Id;
                    disbursementRecord.Tranche__c = '1';
                    disbursementRecord.Start_Date__c = con.Tentative_Start_Date__c;
                    disbursementRecord.End_Date__c = con.Tentative_Start_Date__c.addMonths(1);
                    disbursementRecord.Amount__c = getCurrencyForLessTwoMonths[0].Amount__c;
                    disbursementRecord.Release_Grant_Amount__c = disbursementRecord.Amount__c;
                    disbursementList.add(disbursementRecord);

                Disbursement_Schedule__c disbursementRecord2 = New Disbursement_Schedule__c();
                disbursementRecord2.Contact__c = con.Id;
                disbursementRecord2.Tranche__c = '2';
                disbursementRecord2.Start_Date__c = con.Tentative_Start_Date__c.addMonths(1);
                disbursementRecord2.End_Date__c = con.Tentative_End_Date__c.addMonths(2);
                disbursementRecord2.Amount__c = getCurrencyForLessTwoMonths[0].Amount__c;
                disbursementRecord2.Release_Grant_Amount__c = disbursementRecord2.Amount__c;
                disbursementList.add(disbursementRecord2);
            }
           
          }
          if(!disbursementList.isEmpty()){
            insert disbursementList; 
          } 
        }
        
    }



    public void createDisbursmentFRecordForSING(Map<Id, Application_Proposal__c> newProposalMap,Map<Id,Application_Proposal__c> oldProposalMap){
        Set<id> proposalId = New Set<Id>();
        List<Disbursement_Schedule__c> disbursementList = New List<Disbursement_Schedule__c>();
        Decimal perDayAmount;
        
        for(Application_Proposal__c proposalRec : newProposalMap.values()){
            system.debug('proposalRec--->'+proposalRec.RecordType_Name__c);
            system.debug('proposalRec.Proposal_Stages__c ::'+proposalRec.Proposal_Stages__c);
            system.debug('RecordType ::'+proposalRec.RecordType_Name__c);
            if(proposalRec.Proposal_Stages__c != null && proposalRec.Proposal_Stages__c != oldProposalMap.get(proposalRec.Id).Proposal_Stages__c && proposalRec.Proposal_Stages__c == 'Under Award'){
                if(proposalRec.RecordType_Name__c == 'SING'){
                    proposalId.add(proposalRec.Id);
                }
            }
        }
        system.debug('proposalId ::'+proposalId);
        List<Disbursement_Schedule__c> existingDisbursementRecords = New List<Disbursement_Schedule__c>();
        List<Application_Proposal__c> applicationRecord = [SELECT Id,Name,Tentative_Start_Date__c,Tentative_End_Date__c,RecordType.Name,Total_funding_requested_from_IGSTC__c FROM Application_Proposal__c WHERE Id In : proposalId];
        if(!applicationRecord.isEmpty()){
            existingDisbursementRecords = [SELECT Id From Disbursement_Schedule__c WHERE Proposals__c =: applicationRecord[0].Id];
        }
        system.debug('applicationRecord ::'+applicationRecord);

        if(!applicationRecord.isEMpty()){
            if(existingDisbursementRecords.size() > 0){

            }else{
                for(Application_Proposal__c app : applicationRecord){
                    String invalidNumbers = '[^0-9]';
                    Integer TotalAmount = Integer.valueOf(app.Total_funding_requested_from_IGSTC__c.replaceAll(invalidNumbers,''));
                    Disbursement_Schedule__c disbursementRecord = New Disbursement_Schedule__c();
                    disbursementRecord.Proposals__c = app.Id;
                    disbursementRecord.Tranche__c = '1'; 
                    if(app.Tentative_Start_Date__c != null){
                        disbursementRecord.Start_Date__c = app.Tentative_Start_Date__c; 
                    }
                    system.debug('TotalAmount ----> '+TotalAmount);
                    disbursementRecord.Amount__c = TotalAmount*90/100;
                    system.debug('Amount 1 ----> '+disbursementRecord.Amount__c);
                    disbursementRecord.Release_Grant_Amount__c = disbursementRecord.Amount__c;
                    disbursementList.add(disbursementRecord);
        
                    Disbursement_Schedule__c disbursementRecord2 = New Disbursement_Schedule__c();
                    disbursementRecord2.Proposals__c = app.Id;
                    disbursementRecord2.Tranche__c = '2';
                    if(app.Tentative_End_Date__c != null){
                        disbursementRecord2.Start_Date__c = app.Tentative_End_Date__c; 
                    }
                    disbursementRecord2.Amount__c = TotalAmount*10/100;
                    system.debug('Amount 2 ----> '+disbursementRecord.Amount__c);
                    disbursementRecord2.Release_Grant_Amount__c = disbursementRecord2.Amount__c;
                    disbursementList.add(disbursementRecord2);
                  }
                  if(!disbursementList.isEmpty()){
                    insert disbursementList; 
                  } 
            }
        }
        
    }

    public void validationOnSCReviewStageChange(List<Application_Proposal__c> appProposalList, Map<Id, Application_Proposal__c> oldProposalsMap){
        try{
            List<Application_Proposal__c> proposalsToUpdate = new List<Application_Proposal__c>();
            for (Application_Proposal__c prop : appProposalList){
                Application_Proposal__c oldProposal = oldProposalsMap.get(prop.Id);
                if (prop.SC_Review_Stages__c == 'SC Review Rejected' && oldProposal.SC_Review_Stages__c == 'Sc Review Approved') {
                    prop.addError('SC Review Stage cannot be chang from Approved to Rejected.');
                }
                else if (prop.SC_Review_Stages__c == 'SC Review Waitlisted' && oldProposal.SC_Review_Stages__c == 'Sc Review Approved') {
                    prop.addError('SC Review Stage cannot be change from Approved to waitlist.');
                }


                else if (prop.SC_Review_Stages__c == 'SC Review Waitlisted' && oldProposal.SC_Review_Stages__c == 'SC Review Decline') {
                    prop.addError('SC Review Stage cannot be change from Decline to waitlist.');
                }
                else if (prop.SC_Review_Stages__c == 'Sc Review Approved' && oldProposal.SC_Review_Stages__c == 'SC Review Decline') {
                    prop.addError('SC Review Stage cannot be chang from Decline to Approved.');
                }
                else if (prop.SC_Review_Stages__c == 'SC Review Rejected' && oldProposal.SC_Review_Stages__c == 'SC Review Decline') {
                    prop.addError('SC Review Stage cannot be chang from Decline to Rejected.');
                }


                else if (prop.SC_Review_Stages__c == 'SC Review Waitlisted' && oldProposal.SC_Review_Stages__c == 'SC Review Rejected') {
                    prop.addError('SC Review Stage cannot be change from Rejected to waitlist.');
                }
                else if (prop.SC_Review_Stages__c == 'Sc Review Approved' && oldProposal.SC_Review_Stages__c == 'SC Review Rejected') {
                    prop.addError('SC Review Stage cannot be chang from Rejected to Approved.');
                }
                else if (prop.SC_Review_Stages__c == 'SC Review Decline' && oldProposal.SC_Review_Stages__c == 'SC Review Rejected') {
                    prop.addError('SC Review Stage cannot be chang from Rejected to Decline.');
                }
            }
        }catch(Exception e){

        }
    }
}