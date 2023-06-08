/*
* Trigger ContactTrigger
* Master trigger for Contact object which calls the trigger handler - ContactTriggerHandler
*/
trigger ContactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    TriggerDispatcher.run(new ContactTriggerHandler());
}