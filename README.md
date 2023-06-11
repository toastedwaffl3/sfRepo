README.MD

For a quick synopsis of what each class does, please view the below:

-  AfterRefresh : A class that implements the System.SandboxPostCopy to fire off any methods post sandbox refresh.
-  BAT_ContactEmailUpdate : Batch class that implements the Database.Batchable interface to update all empty contact email fields with the owner email fields.  This class also supports failed DML on the scope object and will email the running user info on the failed batch list.
-  BAT_MaskContactEmails :  Batch class that implements the Database.Batchable interface to mask all contact email fields prefix.  This class also supports failed DML on the scope object and will email the running user info on the failed batch list.
-  ContactTriggerHandler : Trigger Handler class that implements the ITriggerHandler for the contact standard sobject.  Here it defines all helper methods for ease of code readability for before and after DML operations.
-  ContactTriggerHelper : Trigger Helper class for  ContactTrigger. This class defines all custom made methods to be placed inside the ContactTriggerHandler.
-  DatabaseError : Database error class to implement methods for post failure CRUD operations and fields to persist.  Currently used whereever Database.(DML_OPERATION)(scope, false) is used.
-  ITriggerHandler : Defines all methods that should be implemented by a TriggerHandler class.
-  TriggerDispatcher : The dispatcher is responsible for making sure all of the applicable methods on your trigger handler are called, depending on the current trigger context. It also contains a check to make sure that the trigger has not been disabled.

____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

For each bullet point, we list the possible assumptions of the requirement and how it is fullfilled via the package.

1.  If accounts and contacts are coming from integration and if emails contain invalid' at end of email address, then system should remove " invalid' from Account and Contact emails and store in salesforce.

Assumptions:

- Integration is being done by some WSDL config inside Oracle ERP. If they are calling the default endpoint for any form of object DML, they will be calling the documented endpoint:

  https://MyDomainName.my.salesforce.com/services/data/vxx.×/sobjects/ExampleObject/001D000000INVe

- Accounts dont by default have an email, they are configured to have child records (Contacts) as the email. You can use the ACR record to link many to many relationships to these objects. but the requirement as to data cleansing emails on creation by Integration, there is no chance to link contacts -› accounts via either account update or contact update.

- In the case that there is an integration update to an existing account such that the ACR points to a different contact that did not have that contact.email field cleansed, that will need an update to the ACR record, which is not sent through DML's through integration.

- Since its a contact email, this is a salesforce standard email field, which means the REGEX email parsing is handled on salesforce's side. It follows salesforce standard for email structure and we can safely assume that the email follows xxxxx@xxx.com standards.

Achieved via:

- ContactTriggerHelper contains the method to check if the incoming traffic is from a rest api URL. Since salesforce standard has a lot of standard rest api's that can DML on other records, the specific one to sobjects (both custom and standard) parse the three params - services, data, sobjects. Once it has verified from the URL it contains these params, it splits the contact email into two parts and validates if the postfix contains any part of invalid -> in case of @td.invalid.com OR @td.com.invalid. The invalid postfix is then removed and appended to the contact.email once again in the before trigger for ease of precommitting to the database.

2.  If accounts and contacts are created from salesforce UI, then the system should not allow them to enter email addresses with ' invalid' postfix.

Assumptions:

- Same assumption as above, accounts dont by default have an email, only contacts have email. Salesforce UI doesnt allow child creation on record forms from parent.

- Same assumption as above, this is a salesforce standard email field, which means the REGEX email parsing is handled on salesforce's side. It follows salesforce standard for email structure and we can safely assume that the email follows xxxxx@xxx.com standards.

Achieved via:

- Validation rule on the contact. We split the contact email address and check if the postfix contains a invalid, similar to the trigger function in the contacttriggerhelper. This does not run into issues with the trigger above as if they are from integration, the before trigger will data cleanse the data -> and then this custom validation rule will run.

3.  Mask all the account and contact emails postfix with 'invalid' post fix.

Achieved via:

- Refreshing a sandbox will execute the runApexClass method, which comes from the System.SandboxPostCopy interface. We run a batch job here to mask all emails with a batch job.  We use a batch job for the ease of running through all contacts inside the system, to avoid Limit governor issues.  

4.  Please make Email field required on Contacts for internal sales reps. 

Assumptions:

- Since internal sales reps are not defined as a profile user, all internal users, etc, we assume sales reps users to be a specific type of user inside our internal salesforce system and are differentiated with profiles.  

- If sales reps are all internal users, this could be achieved easier just by making the standard field required via metadata.

Achieved via:

- Validation rule on the contact.  Validation rule runs in the context of the user and we can check directly the user's profile and if the field is empty or not.

5.  If email address is blank for existing contacts, populate email fields with contact owner’s email address. This should be a one-time task performed on all the contacts. 

Achieved via:

- Batch job to run through all contacts within the system that have an email field that is empty to be filled out via the owner's email address.  This can be run inside the developer console as an one time script by executing the Database.executeBatch() method on a new BAT_ContactEmailUpdate() class.
____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________


