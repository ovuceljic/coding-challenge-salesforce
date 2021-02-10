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
        User u = TestDataFactory.createUser(
            'Standard User',
            PicnicConstants.COMMERCIAL_DIRECTOR_ROLE_NAME
        );
        User u2 = TestDataFactory.createUser(
            'System Administrator',
            'CEO'
        );

        System.runAs(u2) {
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
        }

        List<Product2> insertedProducts = [SELECT Name, GTIN__c, Purchasing_Price__c, Selling_Price__c FROM Product2 ORDER BY Name DESC];
        List<Staging_Product__c> insertedStagingProducts = [SELECT Name, GTIN__c, Purchasing_Price__c, Selling_Price__c FROM Staging_Product__c ORDER BY Name DESC];

        System.assertEquals(15, insertedProducts.size(), 'There should be 15 new products inserted');
        for (Integer i = 0; i < insertedStagingProducts.size(); i++) {
            System.assertEquals(insertedStagingProducts[i].Name, insertedProducts[i].Name, 'Names should match');
            System.assertEquals(insertedStagingProducts[i].GTIN__c, insertedProducts[i].GTIN__c, 'GTIN__c values should match');
            System.assertEquals(insertedStagingProducts[i].Purchasing_Price__c, insertedProducts[i].Purchasing_Price__c, 'Purchasing_Price__c values should match');
            System.assertEquals(insertedStagingProducts[i].Selling_Price__c, insertedProducts[i].Selling_Price__c, 'Selling_Price__c values should match');
        }
    }

    @isTest
    static void updateProductsFromStagingProducts_Positive() {
        User u = TestDataFactory.createUser(
            'Standard User',
            PicnicConstants.COMMERCIAL_DIRECTOR_ROLE_NAME
        );
        User u2 = TestDataFactory.createUser(
            'System Administrator',
            'CEO'
        );

        List<Staging_Product__c> updatedStagingProducts = null;
        List<Product2> updatedProducts = null;
        
        System.runAs(u2) {
            List<Staging_Product__c> stagingProductsToUpdate = [SELECT Purchasing_Price__c, Selling_Price__c FROM Staging_Product__c];
            for(Staging_Product__c p: stagingProductsToUpdate) {
                p.Selling_Price__c = p.Selling_Price__c + 10;
            }
            
            Test.startTest();
            update stagingProductsToUpdate;
            Test.stopTest();
        
            updatedProducts = [SELECT Selling_Price__c FROM Product2 ORDER BY Name DESC];
            updatedStagingProducts = [SELECT Selling_Price__c FROM Staging_Product__c ORDER BY Name DESC];        
        }

        for (Integer i = 0; i < updatedStagingProducts.size(); i++) {
            System.assertEquals(updatedStagingProducts[i].Selling_Price__c, updatedProducts[i].Selling_Price__c, 'Selling_Price__c values should match after propagation');
        }
    }

    @isTest 
    static void updateProductsAndNotifyCommercialDirector() {
        User u = TestDataFactory.createUser(
            'Standard User',
            PicnicConstants.COMMERCIAL_DIRECTOR_ROLE_NAME
        );
        User u2 = TestDataFactory.createUser(
            'System Administrator',
            'CEO'
        );
        Integer emailInvocations;
        System.runAs(u2) {
            List<Staging_Product__c> stagingProductsToUpdate = [SELECT Purchasing_Price__c, Selling_Price__c FROM Staging_Product__c];
            for(Staging_Product__c p: stagingProductsToUpdate) {
                p.Selling_Price__c = p.Selling_Price__c + 200;
            }
            Test.startTest();
            update stagingProductsToUpdate;
            emailInvocations = Limits.getEmailInvocations();
            Test.stopTest();
        }
        System.assertEquals(1, emailInvocations, 'An email should be sent to notify the commercial director about the Selling Price uptick');
    }
}
