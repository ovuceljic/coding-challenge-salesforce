public with sharing class ProductDetailController {

    @AuraEnabled(cacheable=true)
    public static List<Staging_Product__c> getStagingProductDetails(String productId) {
        List<Product2> productList = [SELECT GTIN__c FROM Product2 WHERE Id = :productId];
        if(productList != null && productList.size() > 0) {
            return [SELECT Id,Name, GTIN__c, Age__c FROM Staging_Product__c WHERE GTIN__c = :[SELECT GTIN__c FROM Product2 WHERE Id = :productId].GTIN__c];
        }
        return new List<Staging_Product__c>();
    }
}
