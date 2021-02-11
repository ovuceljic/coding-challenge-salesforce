# Author: [Ognjen Vuceljic](mailto:ognjen.vuceljic@gmail.com)
# Picnic Take-Home Assignment 


Dear all,

welcome to my Take-Home assignment solution. The aim of the document is to provide enough information about how the solution has been implemented, as well as the overview about created metadata in Developer Org.

The solution features updated data model, sharing settings, automation via APEX code, UI enhancements via LWC, and additional features (validation rules, flexipages, custom tabs, custom labels for multilanguage support, etc...)

After the configuration has been applied on the Developer Org, the corresponding metadata was retrieved in VS Code IDE using *sfdx:force:source:retrieve* command, and subsequently pushed to this git repository.

Once a new Developer/Admin clones the git repo to their local environment, the project can be easily deployed to a new target org using *sfdx:force:source:deploy* command (with -x argument referencing *package.xml* file).

Please find the created metadata overview below:

# Objects

    Product2 - with new custom fields

        - GTIN__c
        - Margin__c (formula field, calculated based on Purchasing and Selling Price)
        - Purchasing_Price__c 
        - Selling_Price__c

    Layout:

        - Product2 Layout


    Staging_Product__c

        - GTIN__c
        - Purchasing_Price__c
        - Selling_Price__c


    Validation Rule:

        - Staging_Product__c REGEX validation that ensures GTIN__c is always a 13-digit value 

    Layout:
    
        - Staging_Product__c Layout

# Custom Labels

    - CustomLabels.labels-meta.xml --> File was created in case multilingual support is required.

# Groups 

    - AllEmployees.group-meta.xml --> File was created as one of the requirements states that Staging_Product__c can be edited by anyone if Purchasing_Price__c < 5.00 

    AllEmployees group is referenced in the Sharing Setting.


# Permission Sets

    - Picnic_Employees_Permission_Set.permissionset-meta.xml    -->  Permission Set that handles field, object, and tab level security for Product2 and Staging_Product__c

# Quick Actions

    - Product2.Product_Detail_Page.quickAction-meta.xml   --> Quick Action that opens Product2 detail LWC

# Roles 

    - CEO.role-meta.xml
    - Mr_Commercial_Director.role-meta.xml
    - Other_Employees.role-meta.xml 

    Roles have been created for purposes of showing how record-level access is handled for different types of employees in the system.

# Sharing Rules 

    - Staging_Product__c.sharingRules-meta.xml   --> Sharing Rule that opens up record access based on criteria specified in the assignment requirements.

# Tabs

    - Staging_Product__c.tab-meta.xml   --> Custom object Tab that'll have to be added to App via AppManager


# Flexipages

    - Product.flexipage-meta.xml    --> Lightning record page for the Product object (includes Product Detail LWC)




# CUSTOM APEX CODE

Automation requirements have been handled via Apex Code, that has 100% test coverage.




# Triggers 

    - ProductTrigger.trigger
    - StagingProductTrigger.trigger 

# Trigger Handler Classes 

    - ProductHandler.cls 
    - StagingProductHandler.cls 

# Utility Classes 

    - SObjectUtils.cls  
    - TestDataFactory.cls 
    - EmailHandler.cls 
    - PicnicConstants.cls 


# Test Classes 

    - ProductTriggerTest.cls 
    - StagingProductHandlerTest.cls 
    - ProductDetailControllerTest.cls


# Test Code Coverage

    - 100% 



