global class HBHPullPropertiesBatch implements Database.Batchable<Property__c>, Database.AllowsCallouts, Database.Stateful{
	public List<Property__c> arrobjProperties = new List<Property__c>();
    public Map<String, Unit__c> arrobjUnits = new Map<String, Unit__c>();
    public HBHPullPropertiesController HBHPullProperties = new HBHPullPropertiesController();
    
    global HBHPullPropertiesBatch() {}
    
    global Iterable<Property__c> start(Database.BatchableContext BC) {
        
        HBHPullProperties.HBHPullProperties();
        this.arrobjProperties = HBHPullProperties.arrobjProperties;
        this.arrobjUnits = HBHPullProperties.arrobjUnits;
        System.debug( HBHPullProperties.arrobjUnits.size() );
        return this.arrobjProperties;
    }
    
    global void execute(Database.BatchableContext BC, List<Property__c> scope){
       	upsert scope; 
        System.debug( arrobjUnits.size() );
        List<Unit__c> Units = new List<Unit__c>();
        
        for( Property__c Property: scope ) {
            if( arrobjUnits.containsKey(Property.HBH_Prop_Id__c) ) {
                Unit__c u = arrobjUnits.get( Property.HBH_Prop_Id__c );
                u.Property__c = Property.Id;
                u.Account__c = Property.Account__c;
                Units.add( u );   
            }
        }
        upsert Units;
        
    }//execute loop
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
}