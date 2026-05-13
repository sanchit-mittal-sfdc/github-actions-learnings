trigger AccountTrigger on Account (after insert, after update) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            //AccountTriggerHandler.handleAfterInsert(Trigger.newMap);
        }
        if (Trigger.isUpdate) {
            AccountTriggerHandler.handleAfterUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }
}