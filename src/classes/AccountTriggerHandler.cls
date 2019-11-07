/**
 * Created by Kamil on 16.10.2019.
 */

public with sharing class AccountTriggerHandler {

    /***********
     *
     *
     *  1st solution - worst
     *
     *
     */

    public static void preventFromLockingAccountWithOpenOpportunities(List<Account> accList) {

        List<Opportunity> oppList = [
                SELECT Id,StageName, AccountId
                FROM Opportunity
                WHERE StageName NOT IN ('Closed Won', 'Closed Lost') AND AccountId IN :accList
        ];

        for (Account account : accList) {
            for (Opportunity opp : oppList) {
                if (checkIfAccountIdMatchesToOppId(account, opp) && checkAccountLockStatus(account)) {
                    oppList = removeCheckedOppsFromList(opp.Account.Id, oppList);
                    account.addError('Can not lock account with open opportunities');
                    break;
                }
            }
        }
    }

    private static List<Opportunity> removeCheckedOppsFromList(Id accountIdToRemove, List<Opportunity> oldOppList) {

        for (Integer i = 0; i < oldOppList.size(); i++) {
            if (oldOppList.get(i).AccountId == accountIdToRemove)
                oldOppList.remove(i);
        }

        return oldOppList;
    }

    private static Boolean checkIfAccountIdMatchesToOppId(Account acc, Opportunity opp) {
        return acc.Id == opp.AccountId;
    }

    private static Boolean checkAccountLockStatus(Account acc) {
        return acc.Locked_status__c;
    }


    /******************************************************************************
    *
    *       2nd solution - better
    *
    *
    * */


    public static void preventFromLockingAccountWithOpenOpportunities2(List<Account> accList) {

        AggregateResult[] tabAR = [
                SELECT COUNT(StageName), AccountId
                FROM Opportunity
                WHERE StageName
                        NOT IN('Closed Won', 'Closed Lost') AND AccountId IN :accList
                GROUP BY AccountId
        ];

        for (Account acc : accList) {

            if (acc.Locked_status__c && checkIfAccountHasOpenOpp(acc.Id, tabAR)) {
                acc.addError('Can not lock account with open opportunities');
            }

        }

    }

    private static Boolean checkIfAccountHasOpenOpp(Id accId, AggregateResult[] arTab) {
        for (AggregateResult ar : arTab) {
            if (accId == ar.get('AccountId')) { // && (Integer) ar.get('expr0') > 0 -> zbedne
                return true;
            }
        }
        return false;
    }
}