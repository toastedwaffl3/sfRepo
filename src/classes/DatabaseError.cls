/**
 * Class DatabaseError
 *  Database error class to implement methods for post failure CRUD operations and fields to persist. 
 */
public class DatabaseError {
    public String statusCode;
    public String message;
    public String recordId;
    public List<String> fields;
    public String objectType;
    
    public DatabaseError(String recordId,String objectType,String statusCode,String message, List<String> fields)
    {
        this.recordId = recordId;
        this.statusCode = statusCode;
        this.message = message;
        this.fields = fields;
        this.objectType = objectType;
    }
    
    /**
     * getDatabaseErrors Returns list of databaseErrors 
     * @param  scope Update scope
     * @param  srList DML Error List
     * @return  Converts DML Error List to readable error list with custom messages
     */
    public static List<DatabaseError> getDatabaseErrors(List<SObject> scope, List<Database.SaveResult> srList){
        List<DatabaseError> returnList = new List<DatabaseError>();
        
        for (Integer i = 0; i < srList.size(); i++) {
            Database.SaveResult s = srList[i];
            SObject c = scope[i];
            
            if (!s.isSuccess()) {
                for(Database.Error err : s.getErrors()) {
                    returnList.add(new DatabaseError(c.Id, c.getSObjectType().getDescribe().getLabel(), err.getStatusCode().name(), err.getMessage(), err.getFields()));                   
                }
            } 
        }
        
        return returnList;
    }
    
    /**
     * sendErrorEmail Sends Email if batch runs into issues or if there are database errors 
     * @param  bc  Batchable context
     * @param  className  Class that called this method
     * @param  dbErrorList  List of DatabaseErrors
     */
    public static void sendErrorEmail(Database.BatchableContext bc, String className, List<DatabaseError> dbErrorList){
        AsyncApexJob  a =  [SELECT Id, Status, NumberOfErrors,ExtendedStatus, JobItemsProcessed,TotalJobItems, CreatedBy.Email
                 FROM AsyncApexJob 
                 WHERE Id = :bc.getJobId()];
        
        if((a != null && a.NumberOfErrors > 0) || dbErrorList.size() > 0){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(new List<String>{String.valueOf(UserInfo.getUserEmail())});  
            mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures.  Attached are additional details:  Number of Database Errors:  ' + dbErrorList.size() + ' Exception: ' +  a.ExtendedStatus + '\n'); 
			Messaging.EmailFileAttachment[] efaList = new List<Messaging.EmailFileAttachment>();
            
            if(dbErrorList.size() > 0) {
               Messaging.EmailFileAttachment dbErrorAttachment = new Messaging.EmailFileAttachment();
               dbErrorAttachment.setFilename('dbErrorList.txt');
               dbErrorAttachment.setBody(Blob.valueOf(JSON.serializePretty(dbErrorList)));
               efaList.add(dbErrorAttachment); 
            }
            
            mail.setFileAttachments(efaList);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}