/**
 * Created by Kamil on 18.10.2019.
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

    @isTest
    private static void testVerboseLoggerLevel() {
        List<Account> accList = generateAccounts();
        List<Opportunity> oppList = generateOpportunities();

        insert accList;
        insert oppList;

        matchOpportunityWithAccounts(oppList, accList);

        update oppList;

        LoggerConfiguration.mainLoggerLevel = LoggerConfiguration.LoggingLevel.Verbose;

        //when (dml operations)
        try {
            update accList;
        } catch (DmlException e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('Can not lock');
            System.assertEquals(expectedExceptionThrown, true);
        }

        Test.startTest();

        for (Account acc : accList) {
            acc.Locked_status__c = !acc.Locked_status__c;
            acc = AccountController.updateAccount2(acc);
        }

        Test.stopTest();
    }

    @isTest
    private static void testErrorLoggerLevel() {
        List<Account> accList = generateAccounts();
        List<Opportunity> oppList = generateOpportunities();

        insert accList;
        insert oppList;

        matchOpportunityWithAccounts(oppList, accList);

        update oppList;

        LoggerConfiguration.mainLoggerLevel = LoggerConfiguration.LoggingLevel.Error;

        //when (dml operations)
        try {
            update accList;
        } catch (DmlException e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('Can not lock');
            System.assertEquals(expectedExceptionThrown, true);
        }

        Test.startTest();

        for (Account acc : accList) {
            acc.Locked_status__c = !acc.Locked_status__c;
            acc = AccountController.updateAccount2(acc);
        }

        Test.stopTest();
    }

    @isTest
    private static void testLoggerLevel() {
        // test go
        // test scenario: Depends on the logging level we want to verify that relevant informations have been logged

        //given: Account list, Opportunity list
        List<Account> accList = generateAccounts();
        List<Opportunity> oppList = generateOpportunities();

        insert accList;
        insert oppList;

        matchOpportunityWithAccounts(oppList, accList);

        update oppList; //end of given

        // do not required above configuration becouse of default value
        //LoggerConfiguration.mainLoggerLevel = LoggerConfiguration.LoggingLevel.Off;

        //when (dml operations)
        try {
            update accList;
        } catch (DmlException e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('Can not lock');
            System.assertEquals(expectedExceptionThrown, true);
        }

        Test.startTest();

        for (Account acc : accList) {
            acc.Locked_status__c = !acc.Locked_status__c;
            acc = AccountController.updateAccount2(acc);
        }

        Test.stopTest();
        //then relevant information is locked
        // refactor -> extract method
        /*List<Logger_level__mdt> customMetadataLogger_level = [SELECT Level__c FROM Logger_level__mdt WHERE Label = 'MainLoggerLevel'];
        String level = customMetadataLogger_level.get(0).Level__c;
        switch on level {
            when 'off' {
                Integer count = database.countQuery('select count() from ApexDebugLog__c');
                System.assertEquals(0, count);
            }
            when 'error' {
                Integer count = [SELECT COUNT() FROM ApexDebugLog__c WHERE Type__c = 'Error'];
                System.assertEquals(1, count);
            }
            when 'verbosed' {
                Integer count = [SELECT COUNT() FROM ApexDebugLog__c WHERE Type__c = 'Information'];
                System.assertEquals(4, count);
            }

        }*/
    }

    private static void matchOpportunityWithAccounts(List<Opportunity> oppList, List<Account> accList) {
        for (Integer i = 0; i < 4; i++) {
            oppList.get(i).AccountId = accList.get(i).Id;
        }
    }
}