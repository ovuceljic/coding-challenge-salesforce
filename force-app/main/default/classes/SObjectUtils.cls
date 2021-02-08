public with sharing class SObjectUtils {
    
    /**
     * getSpecificIdentifiersFromObject       Method is used to obtain specific field values from objects, as identifiers
     * @param  sObjects                       list of SObject instances
     * @param  fieldName                      name of the identifying field on object
     */
    public static Set<String> getSpecificIdentifiersFromObject(List<SObject> sObjects, String fieldName) {
        Set<String> objectIds = new Set<String>();
        for(SObject sObj: sObjects) {
            objectIds.add(String.valueOf(sObj.get(fieldName)));
        }
        return objectIds;
    }

    /**
     * generateRandomString       Method is used generate random 13-digit string, for test purposes
     * @return String             Returns a randomly generated String (13 digit) 
     */
    @TestVisible
    private static String generateRandomString() {
        final String chars = '0123456789';
        String randStr = '';
        while (randStr.length() < 13) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
}
