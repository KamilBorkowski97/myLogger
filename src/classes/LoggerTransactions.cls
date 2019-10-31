/**
 * Created by Kamil on 30.10.2019.
 */

public with sharing class LoggerTransactions {

    @future
    public static void saveLogException(String className, String methodName, Id recordId, String exMessage, String exStackTrace) {
        new ApexDebugLog().createLog(new ApexDebugLog.Error(
                className,
                methodName,
                recordId,
                exMessage,
                exStackTrace
        ));
    }

    @future
    public static void saveLogVerbose(String className, String methodName, Id recordId, String message) {
        new ApexDebugLog().createLog(new ApexDebugLog.Information(
                className,
                methodName,
                recordId,
                message
        ));
    }

}