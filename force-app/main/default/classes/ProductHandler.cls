public with sharing class ProductHandler {
    
    /**
     * afterUpdate                     After update trigger handler method
     * @param  newStagingProductsMap   Map of new trigger values for Product2
     * @param  oldStagingProductsMap   Map of old trigger values for Product2
     * Email-related logic handed over to EmailHandler class
     * @return 'void'
     */
    public static void afterUpdate(Map<Id,Product2> newStagingProductsMap, Map<Id,Product2> oldStagingProductsMap) {
        //these maps will be used in case there has been a Selling Price change by more than 10%
        Map<Id,Product2> priceSensitiveProductsMapNewValues = new Map<Id, Product2>();
        Map<Id,Product2> priceSensitiveProductsMapOldValues = new Map<Id, Product2>();

        for(Product2 sp: newStagingProductsMap.values()) {
            //check if the price has changed by more than 10% (both up and down)
            if((sp.Selling_Price__c > oldStagingProductsMap.get(sp.Id).Selling_Price__c*1.1) || (sp.Selling_Price__c < oldStagingProductsMap.get(sp.Id).Selling_Price__c*0.9)) {
                priceSensitiveProductsMapNewValues.put(sp.Id, sp);
                priceSensitiveProductsMapOldValues.put(sp.Id, oldStagingProductsMap.get(sp.Id));
            }
        }        
        if(priceSensitiveProductsMapNewValues.size() > 0 && priceSensitiveProductsMapOldValues.size() > 0) {
            EmailHandler.notifyCommercialDirector(
                priceSensitiveProductsMapNewValues,
                priceSensitiveProductsMapOldValues
            );
        }
    }
}
