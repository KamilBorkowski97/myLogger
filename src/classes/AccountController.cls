/**
 * Created by Kamil on 11.10.2019.
 */
public without sharing class AccountController {

    @AuraEnabled
    public static Account updateAccount2(Account acc) {

        try {

            update acc;
            LoggerTransactions.saveLogVerbose('AccountController', 'updateAccount2', acc.Id, 'trying to lock account');

        } catch (DmlException e) {
            LoggerTransactions.saveLogException('AccountController', 'updateAccount2', acc.Id, e.getMessage(), e.getStackTraceString());
        } catch (Exception e) {
            LoggerTransactions.saveLogException('AccountController', 'updateAccount2', acc.Id, e.getMessage(), e.getStackTraceString());
        }
        return acc;
    }

    @AuraEnabled
    public static Account getAccount(Id recordId) {
        return [SELECT Id, Locked_status__c, Name FROM Account WHERE Id = :recordId];
    }

    @AuraEnabled
    public static Account updateAccount(Account acc) {
        update acc;
        return acc;
    }
}