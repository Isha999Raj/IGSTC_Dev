public with sharing class SendEmailToAllReviewerOnCampaign {
    
    @AuraEnabled
    public static void runBatchClass(string campId) {
        system.debug('campId -----> '+campId);
        String campaignName = [SELECT Id,name from Campaign where id =: campId].Name;
        BatchToSendEmailToReviewers batchClass = new BatchToSendEmailToReviewers(campaignName);
        Database.executeBatch(batchClass);
    }

    public static String generateReviewerPassword(){
        String charString = '!@#$%^&*()nopqrstuvwABCDPQRSTUVWXYZ0123456789abcdefghijkEFGHIJKLMNOlmxyz';
        String randomNew = '';
        while (randomNew .length() < 10){
            Integer changeInt = Math.mod(Math.abs(Crypto.getRandomInteger()), charString.length());
            randomNew += charString.substring(changeInt , changeInt +1);
            }
            return  randomNew;
    }
    
}