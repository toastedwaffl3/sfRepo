/**
 * Class BAT_MaskContactEmails
 *  Batch class to be run after sandbox refresh.  This class is called via the AfterRefresh class. 
 */
public class BAT_MaskContactEmails implements Database.Batchable<SObject>, Database.Stateful{
	List<Contact> contactList;
    List<DatabaseError> saveErrors;
    
    //Default constructor for AfterRefresh class
    public BAT_MaskContactEmails(){
        
    }
    
    //Custom constructor if user needs to execute batch on small amount of contacts
    public BAT_MaskContactEmails(List<Contact> contactList){
        this.contactList = contactList;
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Email FROM Contact WHERE Email != null';
        
        if(this.contactList != null){
            query += ' AND Id IN :contactList';
        }
        
        return Database.getQueryLocator(query);
    }
    
    /**
     * execute description
     * @param  bc    batchable context
     * @param  scope List of contacts with non blank emails
     */
    public void execute(Database.BatchableContext bc, List<Contact> scope) {
        List<Contact> updateList = new List<Contact>();        
        
        for(Contact c : scope){
            String emailAddress = String.isBlank(c.Email) ? '' : c.Email.toLowerCase();
            List<String> emailAddressParts = emailAddress.split('@');
            
            //post @ part of email
            if(emailAddressParts[1].contains('.invalid')){
                //regex to replace prefix of email past 1st character with *
                c.email = c.email.replaceAll('(^[^@]{1}|(?!^)\\G)[^@]', '$1*');
            }
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
        DatabaseError.sendErrorEmail(bc, String.valueOf(BAT_MaskContactEmails.class), this.saveErrors);
    }
}