@isTest
public with sharing class StagingProductTriggerTest {
    
    @TestSetup
    static void makeData(){
        List<Staging_Product__c> stagingProductsToInsert = new List<Staging_Product__c>();
        for (Integer i = 0; i < 5; i++) {
            Staging_Product__c stagingProduct = new Staging_Product__c();
            stagingProduct.Name = 'TestProduct-'+i;
            stagingProduct.GTIN__c = SObjectUtils.generateRandomString();
            stagingProduct.Purchasing_Price__c = 150 + i;
            stagingProduct.Selling_Price__c = 170 + i;
            stagingProductsToInsert.add(stagingProduct);
        }
        insert stagingProductsToInsert;
    }

    @isTest
    static void createProductsFromStagingProducts_Positive() {
        List<Staging_Product__c> stagingProductsToInsert = new List<Staging_Product__c>();
        for (Integer i = 0; i < 10; i++) {
            Staging_Product__c stagingProduct = new Staging_Product__c();
            stagingProduct.Name = 'TestProduct-'+i;
            stagingProduct.GTIN__c = SObjectUtils.generateRandomString();
            stagingProduct.Purchasing_Price__c = 150 + i;
            stagingProduct.Selling_Price__c = 170 + i;
            stagingProductsToInsert.add(stagingProduct);
        }
        Test.startTest();
        insert stagingProductsToInsert;
        Test.stopTest();

        List<Product2> insertedProducts = [SELECT Name, GTIN__c, Purchasing_Price__c, Selling_Price__c FROM Product2 ORDER BY Name DESC];
        List<Staging_Product__c> insertedStagingProducts = [SELECT Name, GTIN__c, Purchasing_Price__c, Selling_Price__c FROM Staging_Product__c ORDER BY Name DESC];

        System.assertEquals(10, insertedProducts.size(), 'There should be 10 new products inserted');
        for (Integer i = 0; i < insertedStagingProducts.size(); i++) {
            System.assertEquals(insertedStagingProducts[i].Name, insertedProducts[i].Name, 'Names should match');
            System.assertEquals(insertedStagingProducts[i].GTIN__c, insertedProducts[i].GTIN__c, 'GTIN__c values should match');
            System.assertEquals(insertedStagingProducts[i].Purchasing_Price__c, insertedProducts[i].Purchasing_Price__c, 'Purchasing_Price__c values should match');
            System.assertEquals(insertedStagingProducts[i].Selling_Price__c, insertedProducts[i].Selling_Price__c, 'Selling_Price__c values should match');
        }
    }

    @isTest
    static void updateProductsFromStagingProducts_Positive() {
        List<Staging_Product__c> stagingProductsToUpdate = [SELECT Purchasing_Price__c, Selling_Price__c FROM Staging_Product__c];
        for(Staging_Product__c p: stagingProductsToUpdate) {
            p.Selling_Price__c = p.Selling_Price__c + 10;
        }
        Test.startTest();
        update stagingProductsToUpdate;
        Test.stopTest();
        List<Product2> updatedProducts = [SELECT Selling_Price__c FROM Product2 ORDER BY Name DESC];
        List<Staging_Product__c> updatedStagingProducts = [SELECT Selling_Price__c FROM Staging_Product__c ORDER BY Name DESC];

        for (Integer i = 0; i < updatedStagingProducts.size(); i++) {
            System.assertEquals(updatedStagingProducts[i].Name, updatedProducts[i].Name, 'Names should match');
            System.assertEquals(updatedStagingProducts[i].GTIN__c, updatedProducts[i].GTIN__c, 'GTIN__c values should match');
            System.assertEquals(updatedStagingProducts[i].Purchasing_Price__c, updatedProducts[i].Purchasing_Price__c, 'Purchasing_Price__c values should match');
            System.assertEquals(updatedStagingProducts[i].Selling_Price__c, updatedProducts[i].Selling_Price__c, 'Selling_Price__c values should match');
        }
    }
}
