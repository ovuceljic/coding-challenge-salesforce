public with sharing class TestDataFactory {
    
    /**
     * createProduct                Create test instance of Product2 object
     * @param  name                 String, name of the test Product2 instance
     * @param  gtin                 String, will be generated randomly by SObjectUtils method
     * @param  purchasingPrice      Decimal, Purchasing_Price__c
     * @param  sellingPrice         Decimal, Selling_Price__c
     * @param  toInsert             Boolean, indicates whether created test record should be inserted to database
     * @return                      Product2, newly created instance
     */
    public static Product2 createProduct(String name, String gtin, Decimal purchasingPrice, Decimal sellingPrice, Boolean toInsert) {
        Product2 p = new Product2(
            Name = name,
            GTIN__c = gtin,
            Purchasing_Price__c = purchasingPrice,
            Selling_Price__c = sellingPrice
        );

        if(toInsert) {
            insert p;
        }
        return p;
    }
}
