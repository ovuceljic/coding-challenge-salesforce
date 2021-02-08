public with sharing class StagingProductHandler {
    
    /**
     * afterInsert                  After insert trigger handler method
     * @param  newStagingProducts   List of Trigger.new instances of Staging_Product__c
     * Bulkified insert considered
     * @return 'void'
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

    /**
     * afterUpdate                     After update trigger handler method
     * @param  newStagingProductsMap   Map of new trigger values for Staging_Product__c
     * @param  oldStagingProductsMap   Map of old trigger values for Staging_Product__c
     * Method utilizes SObjectUtils class to fetch Product2 instances by GTIN__c identifier 
     * Bulkified update considered
     * @return 'void'
     */
    public static void afterUpdate(Map<Id,Staging_Product__c> newStagingProductsMap, Map<Id,Staging_Product__c> oldStagingProductsMap) {
        Map<String, Product2> productsByGTIN = new Map<String, Product2>();
        for(Product2 p: [SELECT GTIN__c, Purchasing_Price__c, Selling_Price__c FROM Product2 WHERE GTIN__c IN :SObjectUtils.getSpecificIdentifiersFromObject(newStagingProductsMap.values(), 'GTIN__c')]) {
            productsByGTIN.put(p.GTIN__c, p);
        }

        //these maps will be used in case there has been a Selling Price change by more than 10%
        Map<Id,Staging_Product__c> priceSensitiveProductsMapNewValues = new Map<Id, Staging_Product__c>();
        Map<Id,Staging_Product__c> priceSensitiveProductsMapOldValues = new Map<Id, Staging_Product__c>();

        for(Staging_Product__c sp: newStagingProductsMap.values()) {
            productsByGTIN.get(sp.GTIN__c).Purchasing_Price__c = sp.Purchasing_Price__c;
            productsByGTIN.get(sp.GTIN__c).Selling_Price__c = sp.Selling_Price__c;

            //check if the price has changed by more than 10% (both up and down)
            if((sp.Selling_Price__c > oldStagingProductsMap.get(sp.Id).Selling_Price__c*1.1) || (sp.Selling_Price__c < oldStagingProductsMap.get(sp.Id).Selling_Price__c*0.9)) {
                priceSensitiveProductsMapNewValues.put(sp.Id, sp);
                priceSensitiveProductsMapOldValues.put(sp.Id, oldStagingProductsMap.get(sp.Id));
            }
        }
        update productsByGTIN.values();
        
        if(priceSensitiveProductsMapNewValues.size() > 0 && priceSensitiveProductsMapOldValues.size() > 0) {
            EmailHandler.notifyCommercialDirector(
                priceSensitiveProductsMapNewValues,
                priceSensitiveProductsMapOldValues
            );
        }
    }

}
