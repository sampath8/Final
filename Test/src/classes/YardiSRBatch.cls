global class YardiSRBatch implements Database.Batchable<Service_Request1__c>, Database.AllowsCallouts, Database.Stateful {
    
    Map<String,Map<String, String>> AllIntegrationCredentials = new Map<String, Map<String, String>>();
        
    public YardiSRBatch() {}
    
    global Iterable<Service_Request1__c> start(Database.BatchableContext BC) {
        List<Service_Request1__c> arrobjSeriveRequests = new List<Service_Request1__c>();
        
        List<Integration__c> arrobjIntegrations  = [SELECT 
                                                        Account__c, Grouping__c, Yardi_Password__c, Yardi_SR_API_URL__c, Yardi_SR_Database_Name__c, Yardi_SR_ID__c,
                                                        Yardi_SR_Integration_Active__c, Yardi_SR_Password__c, Yardi_SR_Platform_Type__c, Yardi_SR_Server_Name__c, Yardi_SR_Version_Number__c 
                                                    FROM 
                                                    	Integration__c
                                                    WHERE 
                                                    	Yardi_Integration_Active__c = true 
                                                		AND Yardi_SR_Integration_Active__c = true];
        
        Set<String> AccountIds = new Set<String>();
        Set<String> GroupingIds = new Set<String>();
        
        if( !arrobjIntegrations.isEmpty() ) {
            for( Integration__c I :arrobjIntegrations ) { 
                if( null != I.Grouping__c && !GroupingIds.contains( I.Grouping__c ) ) {
                    GroupingIds.add( I.Grouping__c );
                    AllIntegrationCredentials.put( I.Grouping__c, new Map<String, String>{ 'UserName' => I.Yardi_SR_ID__c, 'Password' => I.Yardi_SR_Password__c, 'ServerName' => I.Yardi_SR_Server_Name__c, 'Database' => I.Yardi_SR_Database_Name__c, 'Platform' => I.Yardi_SR_Platform_Type__c, 'VersionNumber' => I.Yardi_SR_Version_Number__c, 'APIURL' => I.Yardi_SR_API_URL__c } );
                } else if( !AccountIds.contains( I.Account__c ) ) {
                    AccountIds.add( I.Account__c );
                    AllIntegrationCredentials.put( I.Account__c, new Map<String, String>{ 'UserName' => I.Yardi_SR_ID__c, 'Password' => I.Yardi_SR_Password__c, 'ServerName' => I.Yardi_SR_Server_Name__c, 'Database' => I.Yardi_SR_Database_Name__c, 'Platform' => I.Yardi_SR_Platform_Type__c, 'VersionNumber' => I.Yardi_SR_Version_Number__c, 'APIURL' => I.Yardi_SR_API_URL__c } );
                }         
            }
            
            arrobjSeriveRequests = [ SELECT 
                                    	Id, Name, Account__c, Group_Membership__c
	 								FROM 
                                    	Service_Request1__c
                                    WHERE 
                                    	Service_Request_Type__r.CS_Request_Type__c = FALSE AND
                                    	Customer_Service_Source__c = TRUE AND
                                    	Work_Order_Entered_in_PMS__c = FALSE AND 
                                    	Status__c = 'Request Sent' AND
                                    	Cust_Prop_ID__c != NULL AND
                                    	( ( Group_Membership__c IN : GroupingIds ) OR ( Account__c IN : AccountIds AND Group_Membership__c = NULL ) ) 
                                    ];
        }
        
        return arrobjSeriveRequests;
    }
    
    global void execute( Database.BatchableContext BC, List<Service_Request1__c> arrobjServiceRequests ){
      	Set<ID> AccountIds 		= new Set<ID>();
        Set<ID> ServiceRequestIds  	= new Set<ID>();
		Set<ID> GroupingIds    = new Set<ID>();
        
		Map<String, Map<String, String>> IntegrationCredentials = new Map<String, Map<String, String>>();
        
        //Instead of Putting AccountIds, ServiceRequestIds and IntegrationInfo in new Variables, Direct assign these values to Class variable
        for( Service_Request1__c ServiceRequest : arrobjServiceRequests ) {
            if( null != ServiceRequest.Group_Membership__c && !AllIntegrationCredentials.containsKey( ServiceRequest.Group_Membership__c ) ) {
                IntegrationCredentials.put( ServiceRequest.Group_Membership__c, AllIntegrationCredentials.get( ServiceRequest.Group_Membership__c ) );
                GroupingIds.add( ServiceRequest.Group_Membership__c );
            } else if( !AllIntegrationCredentials.containsKey( ServiceRequest.Account__c ) ) {
                IntegrationCredentials.put( ServiceRequest.Account__c, AllIntegrationCredentials.get( ServiceRequest.Account__c )  );
            }  
            
            AccountIds.add( ServiceRequest.Account__c );
            ServiceRequestIds.add( ServiceRequest.Id );
        }
        
        
        //update arrobjServiceRequests; 
    }

    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
}