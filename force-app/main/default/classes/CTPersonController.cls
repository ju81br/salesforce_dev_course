public with sharing class CTPersonController {

    /**
     * @description generate token using mobile
     * @param mobileNo
     * @return base64 encoded string
     */
    public static String getToken(String mobileNo){
        Blob value = Blob.valueOf(mobileNo);
        Blob hash = Crypto.generateDigest('MD5', value);

        // GET THE STRING VALUE OF HASH BLOB
        return EncodingUtil.base64Encode(hash);
            /* 
            Debug
            String mobileNo = '13997955239';
            String uniqueToken = CTPersonController.getToken(mobileNo);
            System.debug(uniqueToken);
            */
    }

/**
 * @description Get 100 contacts with recent health status change
 * @return List<Person__c>
 */ 
    public static List<Person__c> getRecentHealthChanges(){
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

/**
 * @description search people by name, mobile or token
 * @param searchTerm
 * @return List<Person__c>
 */
    public static List<Person__c> searchPeople(String searchTerm){
        searchTerm = searchTerm + '%';
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c
                  FROM Person__c
                 WHERE Name LIKE :searchTerm
                    OR Mobile__c LIKE :searchTerm
                    OR Token__c LIKE :searchTerm
                    ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

/**
 * @description get person by Id
 * @param personId
 * @return Person__c
 */
    public static Person__c getPersonById(String personId) {
      List<Person__c> people = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c
                                  FROM Person__c
                                 WHERE Id = :personId];
      if (people != null && people.size() > 0) {
        return people[0];
       }
        return null;
     }

    /**
     * @description get health status count
     * @param None
     * @return healthCountMap;

     */
    public static Map<String, Integer> getHealthStatusCount(){
        Map<String, Integer> healthCountMap = new Map<String, Integer>();
        for (AggregateResult ar : [SELECT Health_Status__c, COUNT(Id) total
                                     FROM Person__c
                                    GROUP BY Health_Status__c]){
            String healthStatus = String.valueOf(ar.get('Health_Status__c'));
            Integer count = Integer.valueOf(ar.get('total'));
            healthCountMap.put(healthStatus, count);
        }
        return healthCountMap;
    }
    

    }