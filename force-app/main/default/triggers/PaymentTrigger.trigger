trigger PaymentTrigger on Payment__c (after insert) {
    PaymentTriggerHandler handler = new PaymentTriggerHandler();
    
    if (Trigger.isAfter && Trigger.isInsert) {
        handler.onAfterInsert(Trigger.new);
    }
}
