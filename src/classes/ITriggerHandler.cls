/*
 * Interface ITriggerHandler
 * Defines all methods that should be implemented by a TriggerHandler class
 * 
 * */
public interface ITriggerHandler {
    /**
     * isDisabled Is the Trigger disabled
     */     
    Boolean isDisabled();

    /**
     * onBeforeInsert Before insert event of trigger
     * @param  newItems New records being created
     */
    void onBeforeInsert(List<SObject> newItems);
    
    /**
     * onBeforeUpdate Before update event of trigger
     * @param  newItems Map of records being updated with new values
     * @param  oldItems Map of records being updated with old values
     */
    void onBeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);

    /**
     * onBeforeDelete Before delete event of trigger
     * @param  deletedSObjects Map of records being deleted
     */
    void onBeforeDelete(Map<Id, SObject> deletedSObjects);

    /**
     * onAfterInsert After insert event of trigger 
     * @param  newItems Map of new records being inserted
     */
    void onAfterInsert(Map<Id, SObject> newItems);
    
    /**
     * onAfterUpdate After update event of trigger
     * @param  newItems Map of records being updated with new values
     * @param  oldItems Map of records being updated with old values
     */    
    void onAfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems);
    
    /**
     * onAfterDelete After delete event of trigger
     * @param  newItems Map of records being deleted
     */
    void onAfterDelete(Map<Id, SObject> newItems);
    
    /**
     * onAfterUndelete After undelete event of trigger
     * @param  newItems Map of records being undeleted
     */
    void onAfterUnDelete(Map<Id, SObject> newItems);    
}