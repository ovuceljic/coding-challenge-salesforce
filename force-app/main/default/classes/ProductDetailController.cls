public with sharing class ProductDetailController {

    @AuraEnabled(cacheable=true)
    public static List<Staging_Product__c> getStagingProductDetails(String productId) {
        return [
            SELECT
                Id,
                Name, 
                GTIN__c, 
                Age__c
            FROM Staging_Product__c 
            WHERE GTIN__c = :[SELECT GTIN__c FROM Product2 WHERE Id = :productId].GTIN__c
        ];
    }
}
