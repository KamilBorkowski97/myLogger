/**
 * Created by user on 11.10.2019.
 */

public without sharing class AccountController {

    @AuraEnabled
    public static Account updateAccount2(Account acc) {
        try {
            System.debug('[myLogger][verbosed] trying to lock account' + acc.Name + ' ' + acc.Id);
            update acc;
        } catch (DmlException e) {
            System.debug('[myLogger][error] dml exception ' + e.getStackTraceString() + ' ' + e.getMessage());
        } catch (Exception e) {
            System.debug('[myLogger][error/exception] generic exception ' + e.getStackTraceString() + ' ' + e.getMessage());
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