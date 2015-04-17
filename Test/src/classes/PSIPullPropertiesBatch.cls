global class PSIPullPropertiesBatch implements Database.Batchable<Property__c> ,Database.AllowsCallouts {

    public PSIPullPropertiesController PSIGetProperties = new PSIPullPropertiesController();
    
    public PSIPullPropertiesBatch(){}

    global Iterable<Property__c> start(Database.BatchableContext BC) {
        List<Property__c> Properties = new List<Property__c>();
        
        Properties = PSIGetProperties.getProperties(); 
        return Properties;
    }

    global void execute(Database.BatchableContext BC, List<Property__c> Scope) {
        upsert Scope;
    }

    global void finish(Database.BatchableContext BC) {
     }

}