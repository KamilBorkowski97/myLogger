/**
 * Created by user on 18.10.2019.
 */

@isTest
private class AccountTriggerHandlerTest {

    @isTest
    private static void happyFlow() {

        //given

        List<Account> accList = generateAccounts();
        List<Opportunity> oppList = generateOnlyClosedOpportunities();

        System.debug(accList);
        System.debug(oppList);

        insert accList;
        insert oppList;

        for (Integer i = 0; i < 4; i++) {
            oppList.get(i).AccountId = accList.get(i).Id;
        }

        update oppList;

        //when

        Test.startTest();
        for (Account acc : accList) {
            acc.Locked_status__c = !acc.Locked_status__c;
        }

        update accList;

        Test.stopTest();

        //then

        Integer lockNumber = [SELECT COUNT() FROM Account WHERE Locked_status__c = true];
        Integer unlockNumber = [SELECT COUNT() FROM Account WHERE Locked_status__c = false];
        System.assertEquals(2, lockNumber);
        System.assertEquals(2, unlockNumber);

    }

    @isTest
    private static void unhappyFlow() {

        //given

        List<Account> accList = generateAccounts();
        List<Opportunity> oppList = generateOpportunities();

        System.debug(accList);
        System.debug(oppList);

        insert accList;
        insert oppList;

        for (Integer i = 0; i < 4; i++) {
            oppList.get(i).AccountId = accList.get(i).Id;
        }

        update oppList;

        //when

        Test.startTest();

        for (Account acc : accList) {
            acc.Locked_status__c = !acc.Locked_status__c;
        }
        try {
            update accList;
        } catch (DmlException e) {
            //then
            Boolean expectedExceptionThrown = e.getMessage().contains('Can not lock');
            System.assertEquals(expectedExceptionThrown, true);
        }

        Test.stopTest();

    }

    private static List<Account> generateAccounts() {
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < 4; i++) {
            Boolean isLocked = false;
            if (math.mod(i, 2) == 0) {
                isLocked = true;
            }
            accList.add(new Account(Name = 'AccountNo' + i, Locked_status__c = isLocked));
        }
        return accList;
    }

    private static List<Opportunity> generateOpportunities() {
        List<Opportunity> oppList = new List<Opportunity>();
        for (Integer i = 0; i < 4; i++) {
            String stageName = 'Closed Lost';
            if (i < 2) {
                stageName = 'Needs Analysis';
            }

            oppList.add(new Opportunity(Name = 'OpportunityNo' + i, CloseDate = system.today(), StageName = stageName));
        }
        return oppList;
    }

    private static List<Opportunity> generateOnlyClosedOpportunities() {
        List<Opportunity> oppList = new List<Opportunity>();
        for (Integer i = 0; i < 4; i++) {
            oppList.add(new Opportunity(Name = 'OpportunityNo' + i, CloseDate = system.today(), StageName = 'Closed Won'));
        }
        return oppList;
    }

}