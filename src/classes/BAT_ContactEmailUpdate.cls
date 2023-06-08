/**
 * Class BAT_MaskContactEmails
 *  Batch class to be run once to update blank contact emails with contact owner emails.   
 */
public class BAT_ContactEmailUpdate implements Database.Batchable<SObject>, Database.Stateful{
    List<Contact> contactList;
    List<DatabaseError> saveErrors;
    
    //Default constructor 
    public BAT_ContactEmailUpdate(){
        
    }
    
    //Custom constructor if user needs to execute batch on small amount of contacts
    public BAT_ContactEmailUpdate(List<Contact> contactList){
        this.contactList = contactList;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Email, Owner.Email FROM Contact WHERE Email = null';
        
        if(this.contactList != null){
            query += ' AND Id IN :contactList';
        }
        
        return Database.getQueryLocator(query);
    }
    
    /**
     * execute description
     * @param  bc    batchable context
     * @param  scope List of active community user
     */
    public void execute(Database.BatchableContext bc, List<Contact> scope) {
        List<Contact> updateList = new List<Contact>();        
        
        for(Contact c : scope){
            c.Email = c.Owner.Email;
        }
        
        Database.SaveResult[] errorSaveList = Database.update(updateList, false);
        this.saveErrors.addAll(DatabaseError.getDatabaseErrors(scope, errorSaveList));
    }
    
    /**
     * finish Batch apex method
     * @param  bc Batchable context
     */
    public void finish(Database.BatchableContext bc) {
        //Sends database error email if batchable fails or if theres saveerrors.
        DatabaseError.sendErrorEmail(bc, String.valueOf(BAT_ContactEmailUpdate.class), this.saveErrors);
    }
}