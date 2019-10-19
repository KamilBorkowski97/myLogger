/**
 * Created by Kamil on 13.10.2019.
 */
({

    clickAction: function (component, event, helper) {
        component.set("v.acc.Locker_Status__c", "v.locked");

        /*var action = component.get("c.updateAccount");
        action.setParam({
            acc: component.get("v.acc"),
        });

        action.setCallback(this, function (response) {

            var response = response.getReturnValue();
            component.set("v.acc", response);

        });
        $A.enqueueAction(action);*/
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

    /*handleSaveRecord: function (component, event, helper) {
        //nie działa saveRecord - pokazuje ze nie zna takiej metody
        component.find("recordEditor").saveRecord($A.getCallback(function (saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully2.");
            }
        }));
    },

    recordUpdated: function (component, event, helper) {
        var eventParams = event.getParams();
        if (eventParams.changeType === "CHANGED") {
            // get the fields that are changed for this record
            var changedFields = eventParams.changedFields;
            console.log('Fields that are changed: ' + JSON.stringify(changedFields));
            // record is changed so refresh the component (or other component logic)
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Saved",
                "message": "The record was updated."
            });
            resultsToast.fire();
        } else if (eventParams.changeType === "LOADED") {
            console.log("Record is loaded successfully.");
        } else if (eventParams.changeType === "REMOVED") {
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "title": "Deleted",
                "message": "The record was deleted."
            });
            resultsToast.fire();
        } else if (eventParams.changeType === "ERROR") {
            console.log('Error: ' + component.get("v.error"));
        }
    }*/

});