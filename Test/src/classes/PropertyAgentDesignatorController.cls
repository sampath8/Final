public class PropertyAgentDesignatorController {
   public  PropertyAgentDesignatorController() {  

    }
    
    public  PropertyAgentDesignatorController(ApexPages.StandardController stc) {

    }   
    
    @RemoteAction 
     public static List<Property__c> getAllPropertyNamesForAccount( String accountId ) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        } 
        
         List<Property__c> properties = [ SELECT 
                                         Id, Active__c, Name, Group_Membership1__c, Group_Membership__c, Zip_Code__c,City__c 
                                         FROM Property__c 
                                         WHERE Account__c =: accountId 
                                         ORDER BY Name ASC  ];
         
         return properties;        
    }
    @RemoteAction
    public static List<Property__c> getAllActivePropertiesForAccount( String accountId, Integer total_count, Integer offset_start ) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        } 
        
        List<Property__c> properties = [ SELECT 
                                        Active__c, Id, Name, Group_Membership1__c, Group_Membership__c, Zip_Code__c,City__c 
                                        FROM Property__c 
                                        WHERE Account__c =: accountId 
                                        ORDER BY Name ASC 
                                        LIMIT :total_count OFFSET :offset_start];
        
        return properties;         
    }
    
    
    @RemoteAction
    public static List<PropertyGroup> getAllGroupings( String accountId ) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        }  
        
        List<Grouping__c> groupings = [ SELECT Id, Name FROM Grouping__c WHERE Account__c =: accountId ORDER BY Name ASC]; 
        
        List<PropertyGroup> lst_prop_group = new List<PropertyGroup>();
        for( Grouping__c group_lst : groupings ) {
            List<Property__c> properties = [ SELECT 
                                               Id, Name 
                                            FROM Property__c 
                                            WHERE Group_Membership__c =: group_lst.Id 
                                            ORDER BY Name ASC];
            PropertyGroup lst_prop  = new  PropertyGroup();
            lst_prop.Id = group_lst.Id;
            lst_prop.Name = group_lst.Name; 
            if( properties != null ) {
              lst_prop.properties = properties;   
            } else
            {
                lst_prop.properties = null;
            } 
            lst_prop_group.add( lst_prop ); 
        } 
        return lst_prop_group;        
    } 
    
     @RemoteAction
    public static List<Contact> getAllAgents( String accountId, Integer total_count, Integer offset_start ) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        } 
           
        List<Contact> agents = [ SELECT Id,Name 
                                FROM Contact 
                                WHERE Anyone_Home_Type__c = 'Agent' 
                                AND AccountId =: accountId 
                                ORDER BY NAME ASC ];
        return agents;
    }
    
    @RemoteAction
    public static  List<Agents> getAssignedPropertyAgents( String accountId, Integer total_count, Integer offset_start ) {
        if( accountId == null || accountId == '' ) {
            //throw new Exception('Please pass correct Account to get Newly active properties');
            return null;
        } 
        
        List<String> property_ids = new List<String>();  
        List<Property__c> properties = [ SELECT 
                                         Id 
                                        FROM Property__c 
                                        WHERE Account__c =: accountId 
                                        ORDER BY Name ASC 
                                        LIMIT :total_count OFFSET :offset_start];
        if(properties.size() > 0){
            for( Property__c p : properties ){
                System.debug( p.Id );
                property_ids.add(p.Id );
            }
            
        }
        
        
        List<Contact> agents = [ SELECT Id,Name 
                                         FROM Contact 
                                         WHERE Anyone_Home_Type__c = 'Agent' 
                                         AND AccountId =: accountId 
                                         ORDER BY NAME ASC
                                         LIMIT :total_count OFFSET :offset_start];
        List<Agents> lstAgent = new List<Agents>();
        List<Property_Agent__c> pa = new List<Property_Agent__c>();
        for( Contact ca : agents ){
            if(property_ids.size() > 0) {
                System.debug(property_ids);
                pa = [ SELECT Contact__c, Name, Roles__c, Property__r.Group_Membership__r.Name, Property__r.Zip_Clean__c , Property_ID__c, Zip_Code__c 
                      FROM  Property_Agent__c
                      WHERE Contact__c =: ca.Id AND Property__r.Id IN :property_ids ORDER BY Name ASC
                     ];
            } else{
                pa = [ SELECT Contact__c, Name, Roles__c, Property__r.Group_Membership__r.Name, Property__r.Zip_Clean__c , Property_ID__c, Zip_Code__c 
                                              FROM  Property_Agent__c
                                              WHERE Contact__c =: ca.Id ORDER BY Name ASC
                                             ];
            }
            
            /*SELECT Contact__c,Contact__r.Name, Contact__r.Anyone_Home_Type__c,Id,Property__c FROM Property_Agent__c WHERE Property__c IN ('a00i000000Us3o1AAB','a00i000000Us3oBAAR','a00i000000Us3oQAAR','a00i000000Us3okAAB', 'a00i000000Us3ofAAB','a00i000000Us3m0AAB','a00i000000Us3mFAAR','a00i000000Us3oLAAR', 'a00i000000Us3lbAAB','a00i000000Us3lvAAB', 'a00i000000Us3o6AAB' ,'a00i000000Us3oGAAR')
AND Contact__r.Anyone_Home_Type__c = 'Agent'
*/
            Agents agent = new Agents();
            agent.Id = ca.Id;
            agent.Name = ca.Name; 
            if( pa != null ) {
              agent.properties = pa;   
            } else
            {
                agent.properties = null;
            } 
            lstAgent.add( agent ); 
        }
          
       // System.debug(lstAgent); 
    	return lstAgent;        
    }
       
    @RemoteAction 
   public static void updatePropertyAgents( String accountId, String propertyAgentJson ) {
 // public static List<Property_Agent__c> updatePropertyAgents( String accountId, String propertyAgentJson ) {
          
        JSONParser parser =  JSON.createParser( propertyAgentJson );
        List<PropertyAgentNames> propertyAgentsList = new List<PropertyAgentNames>();
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        PropertyAgentNames pa = (PropertyAgentNames)parser.readValueAs(PropertyAgentNames.class);
                        propertyAgentsList.add(pa); 
                    }
                }
            } 
        } 
         String sql  = '';
         List<Property_Agent__c> agents = new List<Property_Agent__c>();
         
        List<String> prop_ids = new List<String> ();
        for ( PropertyAgentNames pa:  propertyAgentsList ) {  
            prop_ids.add( pa.property_id );
        } 
       List<Property_Agent__c> prop_agent_records = [
                   SELECT Id, Property_ID__c 
                   FROM  Property_Agent__c
                   WHERE Property_ID__c IN: prop_ids ORDER BY Property_ID__c
               ]; 
        
        if( prop_agent_records.size() > 0 ) {
            for( Property_Agent__c prop_agent_lst : prop_agent_records ) {
                delete prop_agent_lst; 
            }
        }
        for ( PropertyAgentNames pa:  propertyAgentsList ) {    
                
            if('' !=  pa.first_agent){
                Property_Agent__c tmpAgent = new Property_Agent__c();
                tmpAgent.Contact__c = pa.first_agent;
                tmpAgent.Property__c = pa.property_id;
                tmpAgent.Roles__c = null; 
                insert tmpAgent;
            }   
            if( '' !=  pa.second_agent ) {
                
                Property_Agent__c tmpAgent = new Property_Agent__c();
                tmpAgent.Contact__c = pa.second_agent;
                tmpAgent.Property__c = pa.property_id;
                tmpAgent.Roles__c = 'Primary Agent'; 
                insert tmpAgent;
            }
            if( '' !=  pa.third_agent ) {
                
                Property_Agent__c tmpAgent = new Property_Agent__c();
                tmpAgent.Contact__c = pa.third_agent;
                tmpAgent.Property__c = pa.property_id;
                tmpAgent.Roles__c = 'Secondary Agent'; 
                insert tmpAgent;
            }
          /*  if( '' !=  pa.fourth_agent ) { 
                Property_Agent__c tmpAgent = new Property_Agent__c();
                tmpAgent.Contact__c = pa.fourth_agent;
                tmpAgent.Property__c = pa.property_id;
                tmpAgent.Roles__c = 'Secondary Agent'; 
                insert tmpAgent;
            }
           */  
        }
    }
    public class PropertyGroup {
        public String Id;
        public String Name; 
        public List<Property__c> properties;
       /* public PropertyGroup(String property_id, String group_id) {
           this.property_id = property_id; 
           this.group_id = group_id;
        }
*/
  } 
    
    public class PropertyAgent {
        public String id;
        public String property_id;
        public Integer role;
       
        public PropertyAgent(String id, String property_id, Integer role) {
            this.id = id;
            this.property_id = property_id;
            this.role = role;
        }
  } 
    
   public class Agents {
        public String id;
        public String name;
        public List<Property_Agent__c> properties;
       // public Integer role;
       
       /* public Agents(String id, String name, String property, Integer role) {
            this.id = id;
            this.property_id = property_id;
            this.role = role;
        }*/
  } 
     public class PropertyAgentNames { 
         public String property_id; 
         public String first_agent; 
         public String second_agent; 
         public String third_agent; 
        // public String fourth_agent;
      
  } 
   
}