/**
 * ContactTrigger Trigger Description:
 * 
 * The ContactTrigger is designed to handle various logic upon the insertion and update of Contact records in Salesforce. 
 * 
 * Key Behaviors:
 * 1. When a new Contact is inserted and doesn't have a value for the DummyJSON_Id__c field, the trigger generates a random number between 0 and 100 for it.
 * 2. Upon insertion, if the generated or provided DummyJSON_Id__c value is less than or equal to 100, the trigger initiates the getDummyJSONUserFromId API call.
 * 3. If a Contact record is updated and the DummyJSON_Id__c value is greater than 100, the trigger initiates the postCreateDummyJSONUser API call.
 * 
 * Best Practices for Callouts in Triggers:
 * 
 * 1. Avoid Direct Callouts: Triggers do not support direct HTTP callouts. Instead, use asynchronous methods like @future or Queueable to make the callout.
 * 2. Bulkify Logic: Ensure that the trigger logic is bulkified so that it can handle multiple records efficiently without hitting governor limits.
 * 3. Avoid Recursive Triggers: Ensure that the callout logic doesn't result in changes that re-invoke the same trigger, causing a recursive loop.
 * 
 * Optional Challenge: Use a trigger handler class to implement the trigger logic.
 */
trigger ContactTrigger on Contact(before insert, before update) {
	
	if(Trigger.isInsert){
		for(Contact cont : Trigger.new) {
			// if DummyJSON_Id__c is null, generate a random number between 0 and 100 and set this as the contact's DummyJSON_Id__c value
			if(cont.DummyJSON_Id__c == null) {
				Integer randomNumber = Integer.valueOf((Math.random() * 100));
				cont.DummyJSON_Id__c = String.valueOf(randomNumber);
			}
			// if DummyJSON_Id__c is less than or equal to 100, call the getDummyJSONUserFromId API
			else if(Integer.valueOf(cont.DummyJSON_Id__c) <= 100){
				ContactTriggerHandler.makeInsertCallout(cont.DummyJSON_Id__c);
			}
		}
	}

	if(Trigger.isUpdate){
		for(Contact cont : Trigger.new) {
			// if DummyJSON_Id__c is greater than 100, call the postCreateDummyJSONUser API
			if(Integer.valueOf(cont.DummyJSON_Id__c) > 100) {
				ContactTriggerHandler.makeUpdateCallout(cont.id);
			}
		}
	}
}