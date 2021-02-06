trigger StagingProductTrigger on Staging_Product__c (after insert, after update) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            StagingProductHandler.afterInsert(Trigger.new);
        }
        if(Trigger.isUpdate) {
            StagingProductHandler.afterUpdate(Trigger.new);
        }
    }
}