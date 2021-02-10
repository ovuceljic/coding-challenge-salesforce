@isTest
public with sharing class ProductTriggerTest {
    
    @TestSetup
    static void makeData(){
        Product2 testProduct = TestDataFactory.createProduct(
            'TestProductName',
            SObjectUtils.generateRandomString(),
            150.0,
            160.0,
            true
        );
    }

    @isTest
    static void updateProductWithEmailSending_PriceIncreased() {
        User u = TestDataFactory.createUser(
            'Standard User',
            PicnicConstants.COMMERCIAL_DIRECTOR_ROLE_NAME
        );
        User u2 = TestDataFactory.createUser(
            'System Administrator',
            'CEO'
        );

        Integer emailInvocations = null;
        System.runAs(u2) {
            Product2 p = [SELECT Selling_Price__c FROM Product2 LIMIT 1];
            Test.startTest();
            p.Selling_Price__c = p.Selling_Price__c*1.2;
            update p;
            emailInvocations = Limits.getEmailInvocations();
            Test.stopTest();
        }
        System.assertEquals(1, emailInvocations, 'Email should be sent to Commercial Director as a result of Product update');
    }

    @isTest
    static void updateProductWithEmailSending_PriceDecreased() {
        User u = TestDataFactory.createUser(
            'Standard User',
            PicnicConstants.COMMERCIAL_DIRECTOR_ROLE_NAME
        );
        User u2 = TestDataFactory.createUser(
            'System Administrator',
            'CEO'
        );
        Integer emailInvocations = null;
        System.runAs(u2) {
            Product2 p = [SELECT Selling_Price__c FROM Product2 LIMIT 1];
            Test.startTest();
            p.Selling_Price__c = p.Selling_Price__c*0.8;
            update p;
            emailInvocations = Limits.getEmailInvocations();
            Test.stopTest();
        }
        System.assertEquals(1, emailInvocations, 'Email should be sent to Commercial Director as a result of Product update');
    }

    @isTest
    static void updateProductWithNoEmailSending_PriceIncreased_Edge() {
        User u = TestDataFactory.createUser(
            'Standard User',
            PicnicConstants.COMMERCIAL_DIRECTOR_ROLE_NAME
        );
        User u2 = TestDataFactory.createUser(
            'System Administrator',
            'CEO'
        );

        Integer emailInvocations = null;
        System.runAs(u2) {
            Product2 p = [SELECT Selling_Price__c FROM Product2 LIMIT 1];
            Test.startTest();
            p.Selling_Price__c = p.Selling_Price__c*1.1;
            update p;
            emailInvocations = Limits.getEmailInvocations();
            Test.stopTest();
        }
        System.assertEquals(0, emailInvocations, 'No Email should be sent to Commercial Director as a result of Product update');
    }

    @isTest
    static void updateProductWithNoEmailSending_PriceDecreased_Edge() {
        User u = TestDataFactory.createUser(
            'Standard User',
            PicnicConstants.COMMERCIAL_DIRECTOR_ROLE_NAME
        );
        User u2 = TestDataFactory.createUser(
            'System Administrator',
            'CEO'
        );

        Integer emailInvocations = null;
        System.runAs(u2) {
            Product2 p = [SELECT Selling_Price__c FROM Product2 LIMIT 1];
            Test.startTest();
            p.Selling_Price__c = p.Selling_Price__c*0.9;
            update p;
            emailInvocations = Limits.getEmailInvocations();
            Test.stopTest();
        }

        System.assertEquals(0, emailInvocations, 'No Email should be sent to Commercial Director as a result of Product update');
    }
}
