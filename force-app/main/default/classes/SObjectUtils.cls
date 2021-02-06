public with sharing class SObjectUtils {
    
    public static Set<String> getSpecificIdentifiersFromObject(List<SObject> sObjects, String fieldName) {
        Set<String> objectIds = new Set<String>();
        for(SObject sObj: sObjects) {
            objectIds.add(String.valueOf(sObj.get(fieldName)));
        }
        return objectIds;
    }
}
