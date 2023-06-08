/**
 *  Class TriggerDispatcher
 *  The dispatcher is responsible for making sure all of the applicable methods on your trigger handler are called, 
 *  depending on the current trigger context. It also contains a check to make sure that the trigger has not been disabled.
 */
public class TriggerDispatcher {   
    /**
     * Run This method will fire the appropriate methods on the handler depending on the trigger context.
     * @param  handler Instance of a trigger handler which implements ITriggerHandler
     */
    public static void Run(ITriggerHandler handler) {
        // Check to see if the trigger has been disabled. If it has, return
        if (handler.isDisabled()) {
            return;
        }
                             
        // Detect the current trigger context and fire the relevant methods on the trigger handler:
 
        // Before trigger logic
        if (Trigger.isBefore) {
            if (Trigger.isInsert) {
                handler.onBeforeInsert(Trigger.new);
            }                
 
            if (Trigger.isUpdate) {
                handler.onBeforeUpdate(Trigger.newMap, Trigger.oldMap);
            }                
 
            if (Trigger.isDelete) {
                handler.onBeforeDelete(Trigger.oldMap);
            }                
        }
         
        // After trigger logic
        if (Trigger.isAfter) {
            if (Trigger.isInsert) {
                handler.onAfterInsert(Trigger.newMap);
            }                
 
            if (Trigger.isUpdate) {
                handler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
            }               
 
            if (Trigger.isDelete) {
                handler.onAfterDelete(Trigger.oldMap);
            }    
 
            if (Trigger.isUndelete) {
                handler.onAfterUndelete(Trigger.newMap);
            }                
        }
    }
}