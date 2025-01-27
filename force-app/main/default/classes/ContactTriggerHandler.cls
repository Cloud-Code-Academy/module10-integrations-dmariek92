public class ContactTriggerHandler {
    @future(callout=true)
    public static void makeInsertCallout(String contactDummyId) {
        DummyJSONCallout.getDummyJSONUserFromId(contactDummyId);
    }
    
   @future(callout=true)
   public static void makeUpdateCallout(String contactId){
        DummyJSONCallout.postCreateDummyJSONUser(contactId);
   }
}