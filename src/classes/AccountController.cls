/**
 * Created by user on 11.10.2019.
 */

public without sharing class AccountController {

    @AuraEnabled
    public static Account updateAccount2(Account acc) {
        try {
            System.debug('[myLogger][verbosed] trying to lock account' + acc.Name + ' ' + acc.Id);
            new ApexDebugLog().createLog(new ApexDebugLog.Information(
               'AccountController',
                    'updateAccount',
                    acc.Id,
                    'trying to lock account'
            ));
            update acc;
        } catch (DmlException e) {
            System.debug('[myLogger][error/exception] dml exception ' + e.getStackTraceString() + ' ' + e.getMessage());
            new ApexDebugLog().createLog(new ApexDebugLog.Error(
                    'AccountController',
                    'updateAccount',
                    acc.Id,
                    e
            )
            );
        } catch (Exception e) {
            System.debug('[myLogger][error/exception] generic exception ' + e.getStackTraceString() + ' ' + e.getMessage());
            new ApexDebugLog().createLog(new ApexDebugLog.Error(
                    'AccountController',
                    'updateAccount',
                    acc.Id,
                    e
            ));
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