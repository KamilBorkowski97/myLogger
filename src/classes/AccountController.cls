/**
 * Created by Kamil on 11.10.2019.
 */
public without sharing class AccountController {

    @AuraEnabled
    public static Account updateAccount2(Account acc) {

        Logger_level__mdt logger_level = [SELECT Level__c FROM Logger_level__mdt WHERE Label = 'MainLoggerLevel'];

        try {

            update acc;

            if (logger_level.Level__c == 'verbose')
                LoggerTransactions.saveLogVerbose('AccountController', 'updateAccount2', acc.Id, 'trying to lock account');

        } catch (DmlException e) {
            if (logger_level.Level__c != 'off')
                LoggerTransactions.saveLogException('AccountController', 'updateAccount2', acc.Id, e.getMessage(), e.getStackTraceString());
        } catch (Exception e) {
            if (logger_level.Level__c != 'off')
                LoggerTransactions.saveLogException('AccountController', 'updateAccount2', acc.Id, e.getMessage(), e.getStackTraceString());
        }
        return acc;
    }

    @AuraEnabled
    public static Account getAccount(Id recordId) {
        Account acc = [SELECT Id, Locked_status__c, Name FROM Account WHERE Id = :recordId];
        return acc;
    }

    @AuraEnabled
    public static Account updateAccount(Account acc) {
        update acc;
        return acc;
    }
}