global class HBHGCPushBatch implements Database.Batchable<Case>, Database.AllowsCallouts {

    public Boolean isShowProUser 			= false;
    
    public List<Case> arrobjCases 			= new List<Case>();
    
    public HBHGCPushBatch( Boolean isShowProUser ) {
        this.isShowProUser = isShowProUser;
    }
    
    global Iterable<Case> start(Database.BatchableContext BC) {
		arrobjCases = [ SELECT 
                       		Id, CaseNumber, Property_of_Interest__r.HBH_Prop_Id__c 
                        FROM 
                       		Case
                       	WHERE 
                       		ResMan_GC_Entered__c = false 
                       		AND Guest_Card_Status__c = 'Sent via Workflow'
                       		AND ResMan_Integration_Failed__c = false 
                       		AND Property_of_Interest__r.HBH_Prop_Id__c != null 
                       		AND LastModifiedDate = LAST_N_DAYS:5
                       		AND Account1__c  = ''
                       	ORDER BY 
                       		LastModifiedDate DESC
                      ];
        
        return arrobjCases;
    }
    
    global void execute(Database.BatchableContext BC, List<Case> Cases){
        Set<String> PropertyIds = new Set<String>();
        Set<ID> CaseIds			= new Set<ID>();
        
        for( Case objCase : Cases )	{
            PropertyIds.add( objCase.Property_of_Interest__r.HBH_Prop_Id__c );
            CaseIds.add( objCase.Id );
        }	
        
        HBHGCPushController HBH = new HBHGCPushController();
        HBH.PropertyIds = PropertyIds;
        HBH.CaseIds = CaseIds;
        
    }

    global void finish(Database.BatchableContext info){
        //global void finish loop
    }
    
    
}