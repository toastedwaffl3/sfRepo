/**
 * Class AfterRefresh
 *  Salesforce standard class to execute any methods after sandbox refresh.
 */
public class AfterRefresh implements System.SandboxPostCopy{
    
    /**
     * runApexClass description
     * @param  context    sandbox context
     */
    public void runApexClass(System.SandboxContext context){
        Database.executeBatch(new BAT_MaskContactEmails());
    }
}