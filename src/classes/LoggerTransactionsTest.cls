/**
 * Created by user on 30.10.2019.
 */

@isTest
private with sharing class LoggerTransactionsTest {

    @isTest
    private static void testLoggerErrorSaveMethod() {

        String className = 'MyTestClass';
        String methodName = 'MyTestMethod';

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Exception e = new DmlException();

        LoggerConfiguration.setErrorLoggingLevelForTesting(LoggerConfiguration.LoggingLevel.Error);

        Test.startTest();
        LoggerTransactions.saveLogException(className, methodName, acc.Id, e.getMessage(), e.getStackTraceString());
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM ApexDebugLog__c WHERE Type__c = 'Error']);

    }

    @isTest
    private static void testLoggerInformationSaveMethod() {

        String className = 'MyTestClass';
        String methodName = 'MyTestMethod';

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        String msg = 'Trying to lock an account';

        LoggerConfiguration.setErrorLoggingLevelForTesting(LoggerConfiguration.LoggingLevel.Verbose);

        Test.startTest();
        LoggerTransactions.saveLogVerbose(className, methodName, acc.Id, msg);
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM ApexDebugLog__c WHERE Type__c = 'Information']);

    }

}