/**
 * Created by Kamil on 13.10.2019.
 */
({

    clickAction: function (component, event, helper) {
        component.set("v.acc.Locker_Status__c", "v.locked");
    },

    doInit: function (component, event, helper) {
        var action = component.get("c.getAccount");
        action.setParams({
            recordId: component.get("v.recordId"),
        });
        action.setCallback(this, function (response) {
            var response = response.getReturnValue();
            component.set("v.acc", response);
        });
        $A.enqueueAction(action);
    },

    updateAccount: function (component, event, helper) {
        try {
            var action = component.get("c.updateAccount2");
            action.setParams({
                acc: component.get("v.acc"),
            });
            action.setCallback(this, function (response) {
                var response = response.getReturnValue();
                component.set("v.acc", response);
            });
            $A.enqueueAction(action);
        } catch (e) {
            component.set("v.msg", "Can not lock account that has opportunity stage set to open");
        }

    },

});