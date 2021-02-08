public with sharing class EmailHandler {
    
    /**
     * notifyCommercialDirector                 Informs the User with Role 'Commercial Director' about all the products whose Selling_Price__c has changed by more than 10%
     * Custom labels from the connected org have been used in case multilingual email messages have to be supported
     * @param  priceSensitiveProductsNewValues  Map<Id,Staging_Product__c>
     * @param  priceSensitiveProductsOldValues  Map<Id,Staging_Product__c>
     * @return 'void'
     */
    public static void notifyCommercialDirector(Map<Id,Staging_Product__c> priceSensitiveProductsNewValues, Map<Id,Staging_Product__c> priceSensitiveProductsOldValues) {
        User commercialDirector = [
            SELECT Email
            FROM User 
            WHERE UserRoleId = :[SELECT Id FROM UserRole WHERE Name = 'Mr. Commercial Director' LIMIT 1].Id
            LIMIT 1
        ];
        if(commercialDirector != null) {
            Messaging.reserveSingleEmailCapacity(2);    
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(
                new List<String> {commercialDirector.Email}
            );
            mail.setSubject(System.Label.Price_Sensitivity_Subject);
            
            List<String> changedValues = new List<String>();
            for(Staging_Product__c sp: priceSensitiveProductsNewValues.values()) {
                //format the body of the email message so that it includes hyperlink towards the record with >10% change
                changedValues.add(
                    '<a href="'+ URL.getSalesforceBaseUrl().toExternalForm() + '/' + sp.Id +'">' + sp.Name +'</a>' + ' - ' + '[NEW]: ' + sp.Selling_Price__c + ' | [OLD]: ' + priceSensitiveProductsOldValues.get(sp.Id).Selling_Price__c + '<br>'
                );
            }
            mail.setHtmlBody(
                '<html>' + System.Label.Price_Sensitivity_Body + '<br><br>' + String.join(changedValues, ',') + '</html>'
            );
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}
