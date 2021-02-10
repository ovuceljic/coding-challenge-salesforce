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

    /**
     * @brief   Method used to create user with a specific profile.
     * @details It selects profile from database which has given name and creates user which will be used in test methods.
     * @param   profileName is name of profile which will have user.
     * @return  User which will be used in test methods.
     */
    public static User createUser(String profileName, String roleName) {
        Profile p = [SELECT Id, Name FROM profile WHERE name like :profileName LIMIT 1];
        User tester = new User();
        tester.Lastname = 'Tester';
        tester.Username = 'tester@picnic.com.'+ p.Name.replace(' ','_');
        tester.Alias = 'tester';
        tester.ProfileID = p.Id;
        tester.Email = 'tester@livit.com';
        tester.EmailEncodingKey = 'UTF-8';        
        tester.LanguageLocaleKey = 'en_US';        
        tester.TimeZoneSidKey = 'Europe/Berlin';
        tester.LocaleSidKey = 'en_US';
        tester.UserRoleId = [SELECT Id FROM UserRole WHERE Name = :roleName LIMIT 1].Id;     
        insert tester;  

        return tester;  
    }
}
