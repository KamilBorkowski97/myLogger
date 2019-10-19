/**
 * Created by user on 16.10.2019.
 */

trigger AccountTrigger on Account (before update) {

    if (Trigger.isBefore && Trigger.isUpdate) {
        AccountTriggerHandler.preventFromLockingAccountWithOpenOpportunities2(Trigger.new);
    }

}