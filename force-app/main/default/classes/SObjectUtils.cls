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
}
