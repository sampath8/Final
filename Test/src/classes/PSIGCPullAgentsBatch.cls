global class PSIGCPullAgentsBatch implements Database.Batchable<Contact>, Database.AllowsCallouts{
	List<Contact> arrobjContacts;
    
    public Boolean isPSIGCPullAgentsScheduler = true;
    public PSIGCPullAgentsController psi = new PSIGCPullAgentsController();
    
    public PSIGCPullAgentsBatch( Boolean isPSIGCPullAgentsScheduler ) {
        this.isPSIGCPullAgentsScheduler = isPSIGCPullAgentsScheduler;
    }
    
    global Iterable<Contact> start(Database.BatchableContext BC) {
      	
        
		psi.pullPSIAgents( isPSIGCPullAgentsScheduler );
        arrobjContacts = psi.arrobjContacts;
        
        return arrobjContacts;
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
       	upsert scope;     
    }//execute loop
    
    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
}