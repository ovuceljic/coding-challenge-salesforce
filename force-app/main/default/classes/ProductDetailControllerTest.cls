@isTest
public inherited sharing class ProductDetailControllerTest {
    
    @TestSetup
    static void makeData(){
        Staging_Product__c stagingProduct = new Staging_Product__c();
        stagingProduct.Name = 'TestProduct-1';
        stagingProduct.GTIN__c = SObjectUtils.generateRandomString();
        stagingProduct.Purchasing_Price__c = 150;
        stagingProduct.Selling_Price__c = 170;
        insert stagingProduct;
    }

    @isTest
    static void getProductFromStagingProduct_Positive() {
        Product2 p = [SELECT Id, GTIN__c FROM Product2 LIMIT 1][0];
        Test.startTest();
        List<Staging_Product__c> spList = ProductDetailController.getStagingProductDetails(p.Id);
        Test.stopTest();

        System.assertEquals(spList.size(), 1, 'There should be one element in the list.');
        System.assertEquals(spList[0].GTIN__c, p.GTIN__c, 'GTIN__c values should be the same.');
    }

    @isTest
    static void getProductFromStagingProduct_Negative() {
        Test.startTest();
        List<Staging_Product__c> spList = ProductDetailController.getStagingProductDetails(null);
        Test.stopTest();

        System.assertEquals(spList.size(), 0, 'There should be no elements in the list.');
    }
}
