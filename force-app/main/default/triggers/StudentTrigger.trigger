trigger StudentTrigger on Student__c (before insert) {
    StudentTriggerHandler handler = new StudentTriggerHandler();
    
    if (Trigger.isBefore && Trigger.isInsert) {
        handler.onBeforeInsert(Trigger.new);
    }
}
