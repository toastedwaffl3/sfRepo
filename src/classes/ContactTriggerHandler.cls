/**
 * Class ContactTriggerHandler
 *  Trigger handler class for  ContactTrigger. This class implements the ITriggerHandler interface 
 *  and defines all the methods inside the interface. Each public method is related to one trigger event.
 */
public with sharing class ContactTriggerHandler implements ITriggerHandler {

    /**
     * isDisabled Is the Trigger disabled
     * @return   return Indicates if trigger is disabled
     */      
    public Boolean isDisabled() {return false;}
    
    /**
     * onBeforeInsert Before insert event of trigger
     * @param  newItems New records being created
     */ 
    public void onBeforeInsert(List<SObject> newItems) {
        ContactTriggerHelper.checkEmailAddress((List<Contact>)newItems, new Map<Id, Contact>());
    }
    
    /**
     * onBeforeUpdate Before update event of trigger
     * @param  newItems Map of records being updated with new values
     * @param  oldItems Map of records being updated with old values
     */ 
    public void onBeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
		ContactTriggerHelper.checkEmailAddress((List<Contact>)newItems.values(), (Map<Id, Contact>)oldItems);
    }    
    
    /**
     * onBeforeDelete Before delete event of trigger
     * @param  deletedSObjects Map of records being deleted
     */  
    public void onBeforeDelete(Map<Id, SObject> newItems) {
		// Not used
    }
    
    /**
     * onAfterInsert After insert event of trigger 
     * @param  newItems Map of new records being inserted
     */
    public void onAfterInsert(Map<Id, SObject> newItems) {  
        // Not used
    }
    
    /**
     * onAfterUpdate description
     * @param  newItems Map of records being updated with new values
     * @param  oldItems Map of records being updated with old values
     */  
    public void onAfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        // Not used
    }
    
    /**
     * onAfterDelete After delete event of trigger
     * @param  newItems Map of records being delete
     */  
    public void onAfterDelete(Map<Id, SObject> newItems) {
        // Not used
    }
    
    /**
     * onAfterUndelete After undelete event of trigger
     * @param  newItems Map of records being undeleted
     */  
    public void onAfterUndelete(Map<Id, SObject> newItems) {
        // Not used
    }   
}