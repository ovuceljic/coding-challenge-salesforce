public with sharing class StagingProductHandler {
    
    /*
     * After insert trigger handler method 
     */
    public static void afterInsert(List<Staging_Product__c> newStagingProducts) {
        List<Product2> productsToInsert = new List<Product2>();
        for(Staging_Product__c sp: newStagingProducts) {
            productsToInsert.add(
                new Product2(
                    Name = sp.Name, 
                    GTIN__c = sp.GTIN__c,
                    Purchasing_Price__c = sp.Purchasing_Price__c,
                    Selling_Price__c = sp.Selling_Price__c
                )
            );
        }
        insert productsToInsert;
    }

    /*
     * After update trigger handler method
     */
    public static void afterUpdate(List<Staging_Product__c> newStagingProducts) {
        Map<String, Product2> productsByGTIN = new Map<String, Product2>();
        for(Product2 p: [SELECT GTIN__c, Purchasing_Price__c, Selling_Price__c FROM Product2 WHERE GTIN__c IN :SObjectUtils.getSpecificIdentifiersFromObject(newStagingProducts, 'GTIN__c')]) {
            productsByGTIN.put(p.GTIN__c, p);
        }

        for(Staging_Product__c sp: newStagingProducts) {
            productsByGTIN.get(sp.GTIN__c).Purchasing_Price__c = sp.Purchasing_Price__c;
            productsByGTIN.get(sp.GTIN__c).Selling_Price__c = sp.Selling_Price__c;
        }
        update productsByGTIN.values();
    }

}
