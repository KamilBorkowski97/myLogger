/**
 * Created by Kamil on 30.10.2019.
 */

public with sharing class LoggerConfiguration {

    @testVisible
    public ENUM LoggingLevel {
        Verbose, Error, Off
    }

    @testVisible
    public static LoggingLevel mainLoggerLevel = LoggingLevel.Off;

    @testVisible
    static void getMainLoggerLevelFromCustomMetadata() {
        if (!Test.isRunningTest()) {
            Logger_level__mdt llm = [SELECT Level__c FROM Logger_level__mdt WHERE Label = 'MainLoggerLevel'];
            mainLoggerLevel = setCorrectLoggerValue(llm.Level__c);
        }
    }

    static LoggingLevel setCorrectLoggerValue(String customMetaDataValue) {
        for (LoggingLevel enumValue : LoggingLevel.values()) {
            if (enumValue.name() == customMetaDataValue)
                return enumValue;
        }
        return LoggingLevel.Off;
    }

    @testVisible
    static void setErrorLoggingLevelForTesting(LoggingLevel loggingLevelForTesting) {
        if (loggingLevelForTesting != null)
            mainLoggerLevel = loggingLevelForTesting;
    }
}
