/**
 * Class ContactTriggerHelper
 *  Helper class for  ContactTrigger. This class defines all custom made methods to be placed inside the 
 *  ContactTriggerHandler.  
 */
public class ContactTriggerHelper {
    
    /**
     * checkEmailAddress Checks Email Address to not contain .invalid if comes from integration
     * @newItems   New Contact Map
     * @oldItems   Old Contact Map
     */ 
    public static void checkEmailAddress(List<Contact> newItems, Map<Id, Contact> oldItems){
        Set<String> urlSections = new Set<String>(System.URL.getCurrentRequestUrl().toExternalForm().toLowerCase().split('/'));
        
        //Assuming integration from oracle is using the service/data/vxx.x/sobject rest api 
        if(urlSections.contains('service') && urlSections.contains('data') && urlSections.contains('sobject')){
            for(Contact c : newItems){
                String emailAddress = String.isBlank(c.Email) ? '' : c.Email;
                String oldEmailAddress = String.isBlank(oldItems.get(c.Id).Email) ? '' : oldItems.get(c.Id).Email;
                
                if(!emailAddress.equals(oldEmailAddress)){
                    emailAddress = emailAddress.toLowerCase();
                    List<String> emailAddressParts = emailAddress.split('@');
                    
                    if(emailAddressParts[1].contains('.invalid')){
                        c.email = emailAddressParts[0] + emailAddressParts[1].remove('.invalid');
                    }    
                }
            }
        }
        
    }
}