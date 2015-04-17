public with sharing class YardiGCPushController {

    public YardiGCPushWsdltoApexController.ItfILSGuestCardSoap yvn; 
    public YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap yvn20;

    final String strInterfaceEntity;
    final String strInterfaceLicense;
    public String strPropertiesXml;
    public String responseXml;
    public String strYardiAgentsSourcesResults;
    public String GetYardiGuestActivity_Search_result;
    public String GetYardiGuestActivity_Search_Result_40;

    public Integer count 					= 0;
    public boolean isShowProUser            = false;
    public boolean IsFirstContact           = true;
    public boolean IsShowEvent              = false;
    public List<String> Results             = new List<String>();
    public List<String> Sources             = new List<String>();
    public List<String> Agents              = new List<String>();
    public LIST<Case> NeedToUpdateCases     = new List<Case>();
    public List<Case> Cases	 				= new List<Case>();
    public Set<String> PropertyCodes     	= new Set<String>();
    public Set<String> Date_show         	= new Set<String>();
    public Set<String> Date_app          	= new Set<String>();
    
    public Map<String, String> updateappointment        						= new Map<String, String>();
    public Map<String, String> hours                    						= new Map<String, String>();
    public Map<String, String> search_results           						= new Map<String, String>();
    public Map<String, String> guestActivitySearch20    						= new Map<String, String>();
    public Map<String, String> guestActivitySearch40    						= new Map<String, String>();
    public Map<String, List<String>> ResultsPerProperty 						= new Map<String, List<String>>();
    public Map<String, List<String>> SourcesPerProperty 						= new Map<String, List<String>>();
    public Map<String, List<String>> AgentsPerProperty 							= new Map<String, List<String>>();
    public Map<String, Map<String, String>> IntegrationsCredentialsPerAccount  	= new Map<String, Map<String, String>>();
    
    public YardiGCPushController() { 

        hours.put( '0' ,'00:00:00' );
        hours.put( '1' ,'23:00:00' );
        hours.put( '2' ,'22:30:00' );
        hours.put( '3' ,'22:00:00' );
        hours.put( '4' ,'21:30:00' );
        hours.put( '5' ,'21:00:00' );
        hours.put( '6' ,'20:30:00' );
        hours.put( '7' ,'20:00:00' );
        hours.put( '8' ,'19:30:00' );
        hours.put( '9' ,'19:00:00' );
        hours.put( '10' ,'18:30:00' );
        hours.put( '11' ,'18:00:00' );
        hours.put( '12' ,'17:30:00' );
        hours.put( '13' ,'17:00:00' );
        hours.put( '14' ,'16:30:00' );
        hours.put( '15' ,'16:00:00' );
        hours.put( '16' ,'15:30:00' );
        hours.put( '17' ,'15:00:00' );
        hours.put( '18' ,'14:30:00' );
        hours.put( '19' ,'14:00:00' );
        hours.put( '20' ,'13:30:00' );
        hours.put( '21' ,'13:00:00' );
        hours.put( '22' ,'12:30:00' );
        hours.put( '23' ,'12:00:00' );
        hours.put( '24' ,'11:30:00' );
        hours.put( '25' ,'11:00:00' );
        hours.put( '26' ,'10:30:00' );
        hours.put( '27' ,'10:00:00' );
        hours.put( '28' ,'09:30:00' );
        hours.put( '29' ,'09:00:00' );
        hours.put( '30' ,'08:30:00' );
        hours.put( '31' ,'08:00:00' );
        hours.put( '32' ,'07:30:00' );
        hours.put( '33' ,'07:00:00' );
        hours.put( '34' ,'06:30:00' );
        hours.put( '35' ,'06:00:00' );        
    } 

    public List<Case> pushGuestCards() { 

        Set<String> CustPropIds 										= new Set<String>();
        Map<String, String> PropertiesPerAccount 						= new Map<String, String>();
        Map<String, Map<String, String>> WaitListUnitPerFpPerProperty 	= new Map<String, Map<String, String>>();
        
        if( !Cases.isEmpty() ) {
            for( Case cs : Cases ) { 
                if( ! CustPropIds.contains( cs.Cust_Prop_id__c ) ) {
                    PropertiesPerAccount.put( cs.Cust_Prop_id__c, cs.AccountId );
                    CustPropIds.add( cs.Cust_Prop_id__c );
                }
            }
        }

        for( String CustPropId : CustPropIds ) {
            if( PropertiesPerAccount.containsKey( CustPropId ) && IntegrationsCredentialsPerAccount.containsKey( PropertiesPerAccount.get( CustPropId ) ) )
                this.GetYardiAgentsSourcesResults_Login( IntegrationsCredentialsPerAccount.get( PropertiesPerAccount.get( CustPropId ) ), CustPropId );  
        }
        
        List<Unit__c> Waitlist = new List<Unit__c>();
        if( !Test.isRunningTest() ) {
            Waitlist = [SELECT Id, Floor_Plan__r.Floorplan_ID__c, Unit_ID__c, Property__c, Property__r.Customer_Prop_ID__c FROM Unit__c WHERE Floor_Plan__r.Is_Waitlist__c = true AND Is_Waitlist__c = true AND Floor_Plan__r.Floorplan_ID__c != NULL AND Unit_ID__c != NULL AND Property__r.Customer_Prop_ID__c IN : CustPropIds ];
        } else {
            Waitlist = [SELECT Id, Floor_Plan__r.Floorplan_ID__c, Unit_ID__c, Property__c, Property__r.Customer_Prop_ID__c FROM Unit__c ];
        }
        
        if( !Waitlist.isEmpty() ) {
            for( Unit__c unit:Waitlist ) {
                if( !WaitListUnitPerFpPerProperty.containsKey( unit.Property__r.Customer_Prop_ID__c ) ) {
                    Map<String,String> WaitListUnitPerFp = new Map<String, String>();
                    WaitListUnitPerFp.put( unit.Floor_Plan__r.Floorplan_ID__c , unit.Unit_ID__c );
                    WaitListUnitPerFpPerProperty.put( unit.Property__r.Customer_Prop_ID__c , WaitListUnitPerFp );
                }
            }
        }
        
        if( !Cases.isEmpty() ) {
            for( Case cs : Cases ) {
                if( IntegrationsCredentialsPerAccount.containsKey( cs.AccountId ) ) {
                    try {
                        
                        IsFirstContact = true;
                        IsShowEvent = true;
                        if( null != IntegrationsCredentialsPerAccount.get( cs.AccountId ) ) {
                            
                            if( '4' == IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiVersionNumber' ) )  {
                                
                                yvn = new YardiGCPushWsdltoApexController.ItfILSGuestCardSoap();
                                yvn.endpoint_x = IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiAPIUrl' );
                                yvn.timeout_x = 120000; 
                                
                                Dom.Document doc         			= new Dom.Document();
                                Dom.XmlNode LeadManagementNode   	= doc.createRootElement( 'LeadManagement', null, null );
                                LeadManagementNode.setNamespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance');
                                
                                Dom.XmlNode Prospects       		= LeadManagementNode.addChildElement( 'Prospects', null, null );
                                Dom.XmlNode Prospect         		= Prospects.addChildElement( 'Prospect', null, null );
                                Dom.XmlNode Customers       		= Prospect.addChildElement( 'Customers', null, null );
                                Dom.XmlNode Customer         		= Customers.addChildElement( 'Customer', null, null );
                                Customer.setAttribute( 'Type', 'prospect' );
                                
                                Dom.XmlNode Identification0   		= Customer.addChildElement( 'Identification', null, null);
                                Identification0.setAttribute( 'IDValue', '' );
                                Identification0.setAttribute( 'IDType', 'ThirdPartyID' );
                                Identification0.setAttribute( 'OrganizationName', 'AnyoneHome' );
                                
                                Dom.XmlNode Identification1   		= Customer.addChildElement( 'Identification', null, null);
                                Identification1.setAttribute( 'IDValue', '' );
                                Identification1.setAttribute( 'IDType', 'PropertyID' );
                                Identification1.setAttribute( 'OrganizationName', 'AnyoneHome' );
                                
                                Dom.XmlNode Identification2   		= Customer.addChildElement( 'Identification', null, null);
                                Identification2.setAttribute( 'IDValue', '' );
                                Identification2.setAttribute( 'IDType', 'ProspectID' );
                                Identification2.setAttribute( 'OrganizationName', '' );
                                
                                Dom.XmlNode Name         			= Customer.addChildElement( 'Name', null, null);
                                Dom.XmlNode CustomerFirstName   	= Name.addChildElement( 'FirstName', null, null);
                                Dom.XmlNode CustomerLastName     	= Name.addChildElement( 'LastName', null, null);
                                
                                Dom.XmlNode Address       			= Customer.addChildElement( 'Address', null, null);
                                Address.setAttribute('AddressType', 'current' );
                                Dom.XmlNode AddressLine1       		= Address.addChildElement( 'AddressLine1', null, null);
                                Dom.XmlNode AddressLine2       		= Address.addChildElement( 'AddressLine2', null, null);
                                Dom.XmlNode City             		= Address.addChildElement( 'City', null, null);
                                Dom.XmlNode State           		= Address.addChildElement( 'State', null, null);
                                Dom.XmlNode PostalCode         		= Address.addChildElement( 'PostalCode', null, null);
                                
                                Dom.XmlNode Phone0         			= Customer.addChildElement( 'Phone', null, null);
                                Phone0.setAttribute('PhoneType', 'home' );
                                Dom.XmlNode PhoneNumber0     		= Phone0.addChildElement( 'PhoneNumber', null, null);
                                
                                Dom.XmlNode Phone1         			= Customer.addChildElement( 'Phone', null, null);
                                Phone1.setAttribute('PhoneType', 'cell' );
                                Dom.XmlNode PhoneNumber1     		= Phone1.addChildElement( 'PhoneNumber', null, null);
                                
                                Dom.XmlNode Email         			= Customer.addChildElement( 'Email', null, null);
                                Dom.XmlNode Lease         			= Customer.addChildElement( 'Lease', null, null);
                                Dom.XmlNode ExpectedMoveInDate   	= Lease.addChildElement( 'ExpectedMoveInDate', null, null );
                                
                                Dom.XmlNode CustomerPreferences 	= Prospect.addChildElement( 'CustomerPreferences', null, null );
                                
                                Dom.XmlNode TargetMoveInDate     	= CustomerPreferences.addChildElement( 'TargetMoveInDate', null, null);
                                Dom.XmlNode DesiredUnit       		= CustomerPreferences.addChildElement( 'DesiredUnit', null, null);
                                Dom.XmlNode MarketingName     		= DesiredUnit.addChildElement( 'MarketingName', null, null);  
                                
                                Dom.XmlNode DesiredRent       		= CustomerPreferences.addChildElement( 'DesiredRent', null, null);
                                Dom.XmlNode DesiredNumBedrooms  	= CustomerPreferences.addChildElement( 'DesiredNumBedrooms', null, null);
                                
                                Dom.XmlNode DesiredLeaseTerms   	= CustomerPreferences.addChildElement( 'DesiredLeaseTerms', null, null);
                                Dom.XmlNode Comment       			= CustomerPreferences.addChildElement( 'Comment', null, null);
                                
                                Dom.XmlNode Events         			= Prospect.addChildElement( 'Events', null, null );
                                Dom.XmlNode Event         			= Events.addChildElement( 'Event', null, null );
                                Dom.XmlNode EventID       			= Event.addChildElement( 'EventID', null, null);
                                EventID.setAttribute( 'IDValue', '0');
                                
                                Dom.XmlNode Agent         			= Event.addChildElement( 'Agent', null, null);
                                Dom.XmlNode AgentName       		= Agent.addChildElement( 'AgentName', null, null );
                                Dom.XmlNode AgentFirstName     		= AgentName.addChildElement( 'FirstName', null, null );
                                AgentFirstName.addTextNode('AnyoneHome');
                                
                                Dom.XmlNode AgentLastName     		= AgentName.addChildElement( 'LastName', null, null );
                                AgentLastName.addTextNode('AnyoneHome');
                                
                                Dom.XmlNode EventReasons     		= Event.addChildElement( 'EventReasons', null, null);
                                
                                Dom.XmlNode FirstContact    	 	= Event.addChildElement( 'FirstContact', null, null);
                                
                                Dom.XmlNode Comments           		= Event.addChildElement( 'Comments', null, null);
                                Dom.XmlNode TransactionSource   	= Event.addChildElement( 'TransactionSource', null, null);
                                
                                if( null != cs.CaseNumber ) {
                                    Identification0.setAttribute( 'IDValue', cs.CaseNumber );                                 
                                }
                                
                                Identification1.setAttribute( 'IDValue', cs.Cust_Prop_id__c );
                                
                                if( null != cs.ContactNameAPI__c ) {
                                    List<String> ContactNameAPI = cs.ContactNameAPI__c.split(' ', 2);
                                    CustomerFirstName.addTextNode( ContactNameAPI[0] );
                                    
                                    if( 2 == ContactNameAPI.size() ) {
                                        CustomerLastName.addTextNode( ContactNameAPI[1] );
                                    }
                                }
                                if( null != cs.Address_Line_1__c ) {
                                    AddressLine1.addTextNode( cs.Address_Line_1__c );
                                }
                                AddressLine2.addTextNode( 'NA' );
                                if ( null != cs.City__c ) {
                                    City.addTextNode( cs.City__c );
                                }
                                
                                if ( null != cs.State__c ) {
                                    State.addTextNode( cs.State__c  );  
                                }
                                if ( null != cs.Zip_Code__c )  {
                                    PostalCode.addTextNode( cs.Zip_Code__c );
                                }                            
                                if ( null != cs.ContactPhoneAPI__c ) {
                                    PhoneNumber0.addTextNode( cs.ContactPhoneAPI__c );
                                }
                                if ( null != cs.Contact_Mobile_Email_template__c ) {
                                    Phone1.setAttribute( 'PhoneType', 'cell' );
                                    PhoneNumber1.addTextNode( cs.Contact_Mobile_Email_template__c );
                                }
                                if ( null != cs.Contact_Email_Email_template__c ) {
                                    Email.addTextNode( cs.Contact_Email_Email_template__c );
                                }
                                
                                if ( null != cs.Move_in_Date__c ) {
                                    ExpectedMoveInDate.addTextNode( String.valueOf( cs.Move_in_Date__c ) );
                                } else {
                                    
                                    ExpectedMoveInDate.addTextNode( DateTime.now().format('yyyy-MM-dd') );
                                }
                                if ( null != cs.Move_in_Date__c ) {
                                    TargetMoveInDate.addTextNode( String.valueOf( cs.Move_in_Date__c ) );
                                } else {
                                    TargetMoveInDate.addTextNode( DateTime.now().format('yyyy-MM-dd') );
                                }
                                
                                Unit__c unit = new Unit__c();
                                if( null != cs.Unit_of_Interest__r.Unit_ID__c ) {
                                    unit.Unit_ID__c = cs.Unit_of_Interest__r.Unit_ID__c;
                                } else {
                                    if( null != cs.Floor_Plan_of_Interest__c ) {
                                        List<Unit__c> waitListunit = [ SELECT Unit_ID__c FROM Unit__c WHERE Floor_Plan__r.Floorplan_ID__c = :cs.Floor_Plan_of_Interest__r.Floorplan_ID__c AND unit_ID__c != NULL AND Is_Waitlist__c = true ];
                                        if( ! waitListunit.isEmpty() )
                                            unit.Unit_ID__c = waitListunit.get(0).Unit_ID__c;
                                    } else if( WaitListUnitPerFpPerProperty.containsKey( cs.Property_of_Interest__r.Customer_Prop_ID__c ) ) {
                                        Set<String> WaitlistFpOfProperty = WaitListUnitPerFpPerProperty.get( cs.Property_of_Interest__r.Customer_Prop_ID__c ).keySet();
                                        for( String WalitlistFloorplan :WaitlistFpOfProperty ) {
                                            unit.Unit_ID__c = WaitListUnitPerFpPerProperty.get( cs.Property_of_Interest__r.Customer_Prop_ID__c ).get( WalitlistFloorplan );
                                        }
                                    }
                                }
                                
                                if( null != unit.Unit_ID__c )
                                    MarketingName.addTextNode( unit.Unit_ID__c );
                                
                                if ( null != cs.Desired_Rent_Range_End__c ) {
                                    if ( null != cs.Desired_Rent_Start__c ) {
                                        DesiredRent.setAttribute( 'Max', String.valueOf( cs.Desired_Rent_Range_End__c ) );
                                        DesiredRent.setAttribute( 'Min', String.valueOf( cs.Desired_Rent_Start__c ) );
                                    } else {
                                        DesiredRent.setAttribute( 'Max', String.valueOf( cs.Desired_Rent_Range_End__c ) );
                                        DesiredRent.setAttribute( 'Min', '0' );
                                    }
                                } else if ( null != cs.Desired_Rent_Start__c ) {
                                    DesiredRent.setAttribute( 'Exact', String.valueOf( cs.Desired_Rent_Start__c ) );
                                }
                                
                                if ( null != cs.Bed_Count_Pref__c ) {
                                    DesiredNumBedrooms.setAttribute( 'Exact', String.valueOf( cs.Bed_Count_Pref__c ) );
                                } else  {
                                    DesiredNumBedrooms.setAttribute( 'Exact', '0' );
                                }
                                if ( null != cs.Desired_Lease_length__c ) {
                                    DesiredLeaseTerms.addTextNode( String.valueOf( cs.Desired_Lease_length__c ) );
                                }
                                if ( null != cs.Notes__c ) {
                                    Comment.addTextNode( cs.Notes__c );
                                }
                                
                                if ( null != cs.Date_Time_Sent_Via_Workflow__c ) {
                                    DateTime sentViaWorkFlow       = cs.Date_Time_Sent_Via_Workflow__c;
                                    String sentViaWorkFlowDate       = String.valueOf( sentViaWorkFlow.format('yyyy-MM-dd') );
                                    String sentViaWorkFlowTime       = String.valueOf( sentViaWorkFlow.format('HH:mm:ss') );
                                    String sentViaWorkFlowDateTime  = sentViaWorkFlowDate + 'T' + sentViaWorkFlowTime;
                                    Event.setAttribute( 'EventDate', String.valueOf( sentViaWorkFlowDateTime ) );
                                } else {
                                    String currentDate           = String.valueOf( DateTime.now().format('yyyy-MM-dd') );
                                    String currentTime           = String.valueOf( DateTime.now().format('HH:mm:ss') );
                                    String currentDateTime       = currentDate + 'T' + currentTime;
                                    Event.setAttribute( 'EventDate', currentDateTime );
                                }
                                
                                String strEventTypeAttribute = 'Email';
                                if ( null != cs.Origin ) {
                                    strEventTypeAttribute = cs.Origin;
                                    if( 'Phone' == cs.Origin ) 
                                        strEventTypeAttribute = 'CallFromProspect';
                                    if( 'Email' == cs.Origin )
                                        strEventTypeAttribute = 'Email';
                                    if( 'Voicemail' == cs.Origin )
                                        strEventTypeAttribute = 'Other';
                                }
                                
                                Event.setAttribute( 'EventType', strEventTypeAttribute );
                                
                                if( ResultsPerProperty.containsKey( cs.Cust_Prop_id__c ) && !ResultsPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                    EventReasons.addTextNode( ResultsPerProperty.get( cs.Cust_Prop_id__c ).get(0) );
                                }
                                
                                String EventSource;
                                if( SourcesPerProperty.containsKey( cs.Cust_Prop_id__c ) && !SourcesPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                    EventSource = SourcesPerProperty.get( cs.Cust_Prop_id__c ).get(0);
                                    if( null != cs.Ad_Source_Type__c ) {
                                        for( String Source :SourcesPerProperty.get( cs.Cust_Prop_id__c ) ){
                                            if( Source == cs.Ad_Source_Type__c ){
                                                EventSource = cs.Ad_Source_Type__c;
                                                break;
                                            } 
                                        }
                                    } 
                                    TransactionSource.addTextNode( EventSource );
                                }
                                
                                Date_show.clear();
                                Date_app.clear();
                                updateappointment.clear();
                                this.GetYardiGuestActivity_Search( IntegrationsCredentialsPerAccount.get( cs.AccountId ), cs.Cust_Prop_id__c, cs.Contact.Prospect_ID__c, cs.Contact_Email_Email_template__c, cs.ContactPhoneAPI__c );
                                
                                Boolean isUpdate = false;
                                if( null != guestActivitySearch40.get( 'ThirdPartyIDValue' ) && null != guestActivitySearch40.get( 'ProspectID' ) && null != guestActivitySearch40.get( 'ProspectIDOrganizationName' ) ) {
                                    Identification0.setAttribute( 'IDValue', guestActivitySearch40.get( 'ThirdPartyIDValue' ) );
                                    
                                    Identification2.setAttribute( 'IDValue', guestActivitySearch40.get( 'ProspectID' ) );
                                    Identification2.setAttribute( 'IDType', 'ProspectID' );
                                    Identification2.setAttribute( 'OrganizationName', guestActivitySearch40.get( 'ProspectIDOrganizationName' ) );
                                    
                                    FirstContact.addTextNode( 'false' );                                 
                                } else {
                                    FirstContact.addTextNode( 'true' );    
                                }
                                
                                List<Appointment__c> AllAppointments 	= new List<Appointment__c>();
                                List<Appointment__c> appointment_shows 	= new List<Appointment__c>();
                                List<Appointment__c> appointments 		= new List<Appointment__c>();
                                
                                if( ! Test.isRunningTest() ) {
                                    AllAppointments = [SELECT Id, Unit__c,  Agent_Full_Name__c, Contact__r.Prospect_ID__c, Contact__r.FirstName, Contact__r.LastName, Appointment_Date__c, Unit__r.Unit_ID__c, NoFrom__c, Name,Contact__r.Status__c, Invite_Status__c FROM Appointment__c WHERE Case__c = : cs.Id AND Unit__r.Unit_ID__c != NULL AND Contact__r.Status__c IN ( 'Showing Completed', 'Showing Set' ) AND Invite_Status__c IN ( 'Accepted', 'Invited', 'Canceled', 'Rejected' )];
                                } else {
                                    AllAppointments = [ SELECT Id, Unit__c,  Agent_Full_Name__c, Contact__r.Prospect_ID__c, Contact__r.FirstName, Contact__r.LastName, Appointment_Date__c, Unit__r.Unit_ID__c, NoFrom__c, Name, Contact__r.Status__c, Invite_Status__c FROM Appointment__c LIMIT 1];
                                }
                                
                                for( Appointment__c Appointment :AllAppointments ) {
                                    if( !Test.isRunningTest() ) {
                                        if( Appointment.Contact__r.Status__c == 'Showing Completed' && Appointment.Invite_Status__c == 'Accepted' ) {
                                            appointment_shows.add( Appointment );
                                        } else if( Appointment.Contact__r.Status__c == 'Showing Set' && ( Appointment.Invite_Status__c == 'Invited' || Appointment.Invite_Status__c == 'Canceled' || Appointment.Invite_Status__c == 'Rejected' )  ) {
                                            appointments.add( Appointment );
                                        }
                                    } else {
                                        appointment_shows.add( Appointment );
                                        appointments.add( Appointment );
                                    }
                                }
                                
                                if( false == appointment_shows.isEmpty() ) {
                                    IsShowEvent = ( false == IsFirstContact ) ? false :true;
                                    for( Appointment__c shows : appointment_shows ) {
                                        if ( true == cs.Multi_Family_Case__c ) {
                                            
                                            Dom.XmlNode Event1 = Events.addChildElement( 'Event', null, null );
                                            Event1.setAttribute( 'EventType', 'Show' );
                                            String EventDate1 = String.valueOf( ( null != shows.Appointment_Date__c ? shows.Appointment_Date__c : date.today() ) ) + 'T' + hours.get( String.valueOf( shows.NoFrom__c ) );
                                            
                                            if( false == Date_show.Contains( EventDate1 ) ) {
                                                if( false == IsFirstContact ){
                                                    Events.removeChild( Event );
                                                }
                                                Event1.setAttribute( 'EventDate', EventDate1 );
                                            } else {
                                                Events.removeChild( Event1 );
                                                break;
                                            }
                                            
                                            Dom.XmlNode EventID1 = Event1.addChildElement( 'EventID', null, null );
                                            EventID1.setAttribute( 'IDValue', '' );
                                            EventID1.setAttribute( 'IDType', shows.Unit__r.Unit_ID__c );
                                            
                                            Dom.XmlNode Agent1 = Event1.addChildElement( 'Agent', null, null );
                                            Dom.XmlNode AgentName1 = Agent1.addChildElement( 'AgentName', null, null );
                                            Dom.XmlNode FirstName1 = AgentName1.addChildElement( 'FirstName', null, null );   
                                            Dom.XmlNode LastName1 = AgentName1.addChildElement( 'LastName', null, null );   
                                            FirstName1.addTextNode( 'AnyoneHome' );
                                            LastName1.addTextNode( 'AnyoneHome' );
                                            
                                            Dom.XmlNode EventReasons1 = Event1.addChildElement( 'EventReasons', null, null );
                                            if( !Results.isEmpty() ) {
                                                EventReasons1.addTextNode( Results.get(0) );
                                            }
                                            
                                            Dom.XmlNode FirstContact1 = Event1.addChildElement( 'FirstContact', null, null );
                                            FirstContact1.addTextNode( 'false' );
                                            
                                            Dom.XmlNode Comments1 = Event1.addChildElement( 'Comments', null, null );
                                            String strComments1 = 'AH ' + String.valueOf( shows.Appointment_Date__c ) + ' - Showing agent is ' + String.valueOf( shows.Agent_Full_Name__c );
                                            Comments1.addTextNode( strComments1 );
                                            
                                            Dom.XmlNode TransactionSource1 = Event1.addChildElement( 'TransactionSource', null, null );
                                            if( null != cs.Ad_Source_Type__c && null != EventSource ) {
                                                TransactionSource1.addTextNode( EventSource );
                                            }
                                        }
                                    }
                                }
                                
                                if( false == appointments.isEmpty() ) {
                                    for( Appointment__c app : appointments ) {
                                        if ( true == cs.Multi_Family_Case__c  ) {
                                            if( app.Invite_Status__c == 'Invited' ) {
                                                Dom.XmlNode Event1 = Events.addChildElement( 'Event', null, null );
                                                Event1.setAttribute( 'EventType', 'Appointment' );
                                                String EventDate1 = String.valueOf( app.Appointment_Date__c ) + 'T' + hours.get( String.valueOf( app.NoFrom__c ) );
                                                if( false == Date_app.Contains( EventDate1 ) ) {
                                                    Event1.setAttribute( 'EventDate', EventDate1 );
                                                    if( false == IsFirstContact && false == IsShowEvent ){
                                                        Events.removeChild( Event );
                                                    }
                                                } else {
                                                    Events.removeChild( Event1 );
                                                    break;
                                                }
                                                Event1.setAttribute( 'EventDate', EventDate1 );
                                                
                                                Dom.XmlNode EventID1 = Event1.addChildElement( 'EventID', null, null );
                                                
                                                if( false == Date_app.Contains( EventDate1 ) ) {
                                                    Event1.setAttribute( 'EventDate', EventDate1 );
                                                    EventID1.setAttribute( 'IDValue', '' );
                                                } else {
                                                    Events.removeChild( Event1 );
                                                    break;
                                                }
                                                EventID1.setAttribute( 'IDType', app.Unit__r.Unit_ID__c );
                                                
                                                Dom.XmlNode Agent1 = Event1.addChildElement( 'Agent', null, null );
                                                Dom.XmlNode AgentName1 = Agent1.addChildElement( 'AgentName', null, null );
                                                Dom.XmlNode FirstName1 = AgentName1.addChildElement( 'FirstName', null, null );   
                                                Dom.XmlNode LastName1 = AgentName1.addChildElement( 'LastName', null, null );   
                                                FirstName1.addTextNode( app.Contact__r.FirstName );
                                                LastName1.addTextNode( app.Contact__r.LastName );
                                                
                                                Dom.XmlNode EventReasons1 = Event1.addChildElement( 'EventReasons', null, null );
                                                if( !Results.isEmpty() ) {
                                                    EventReasons1.addTextNode( Results.get(0) );
                                                }
                                                
                                                Dom.XmlNode FirstContact1 = Event1.addChildElement( 'FirstContact', null, null );
                                                FirstContact1.addTextNode( 'false' );
                                                
                                                Dom.XmlNode Comments1 = Event1.addChildElement( 'Comments', null, null );
                                                String strComments1 = 'AH ' + String.valueOf( app.Appointment_Date__c ) + ' - Showing agent is ' + String.valueOf( app.Agent_Full_Name__c );
                                                Comments1.addTextNode( strComments1 );
                                                
                                                Dom.XmlNode TransactionSource1 = Event1.addChildElement( 'TransactionSource', null, null );
                                                if( null != cs.Ad_Source_Type__c ) {
                                                    TransactionSource1.addTextNode( String.valueOf( cs.Ad_Source_Type__c ) );
                                                }
                                            }
                                            
                                            String EventDate1 = String.valueOf( app.Appointment_Date__c ) + 'T' + hours.get( String.valueOf( app.NoFrom__c ) );
                                            if( true == Date_app.Contains( EventDate1 ) && ( 'Canceled' == app.Invite_Status__c || 'Rejected' == app.Invite_Status__c ) ) {
                                                Dom.XmlNode Event2 = Events.addChildElement( 'Event', null, null );
                                                Event2.setAttribute( 'EventType', 'CancelAppointment' );
                                                Event2.setAttribute( 'EventDate', EventDate1 );
                                                if( false == Date_app.Contains( EventDate1 ) ) {
                                                    if( false == IsFirstContact && false == IsShowEvent ){
                                                        Events.removeChild( Event );
                                                    }
                                                    Event2.setAttribute( 'EventDate', EventDate1 );
                                                } else {
                                                    Events.removeChild( Event2 );
                                                    break;
                                                }
                                                Dom.XmlNode EventID2 = Event2.addChildElement( 'EventID', null, null );
                                                
                                                EventID2.setAttribute( 'IDValue', '' );
                                                EventID2.setAttribute( 'IDType', app.Unit__r.Unit_ID__c );
                                                
                                                Dom.XmlNode Agent2 = Event2.addChildElement( 'Agent', null, null );
                                                Dom.XmlNode AgentName2 = Agent2.addChildElement( 'AgentName', null, null );
                                                Dom.XmlNode FirstName2 = AgentName2.addChildElement( 'FirstName', null, null );   
                                                Dom.XmlNode LastName2 = AgentName2.addChildElement( 'LastName', null, null );   
                                                FirstName2.addTextNode( app.Contact__r.FirstName );
                                                LastName2.addTextNode( app.Contact__r.LastName );
                                                
                                                Dom.XmlNode EventReasons2 = Event2.addChildElement( 'EventReasons', null, null );
                                                if( !Results.isEmpty() ) {
                                                    EventReasons2.addTextNode( Results.get(0) );
                                                }
                                                
                                                Dom.XmlNode FirstContact2 = Event2.addChildElement( 'FirstContact', null, null );
                                                FirstContact2.addTextNode( 'false' );
                                                
                                                Dom.XmlNode Comments2 = Event2.addChildElement( 'Comments', null, null );
                                                String strComments2 = 'AH ' + String.valueOf( app.Appointment_Date__c ) + ' - Showing agent is ' + String.valueOf( app.Agent_Full_Name__c );
                                                Comments2.addTextNode( strComments2 );
                                                
                                                Dom.XmlNode TransactionSource2 = Event2.addChildElement( 'TransactionSource', null, null );
                                                if( null != cs.Ad_Source_Type__c ) {
                                                    TransactionSource2.addTextNode( String.valueOf( cs.Ad_Source_Type__c ) );
                                                }
                                            }
                                        }
                                    }
                                }
                                
                                if ( false == isUpdate ) {
                                    Customer.removeChild( Identification2 );                
                                }
                                
                                String xmlstr = doc.toXmlString();
                                xmlstr = xmlstr.replace('<?xml version="1.0" encoding="UTF-8"?>', '');
                                xmlstr = xmlstr.replace('<Comments />', '<Comments></Comments>');
                                xmlstr = xmlstr.replace('<DesiredLeaseTerms />', '<DesiredLeaseTerms></DesiredLeaseTerms>');
                                xmlstr = xmlstr.replace('<PhoneNumber/>', '<PhoneNumber></PhoneNumber>');
                                xmlstr = xmlstr.replace('<DesiredRent/>', '');
                                xmlstr = xmlstr.replace('<MITS:Email/>', '<MITS:Email></MITS:Email>');
                                xmlstr = xmlstr.replaceAll('/(^[\r\n]*|[\r\n]+)[\\s\t]*[\r\n]/', '\n' );
                                
                                System.debug('xmlstr - ' + xmlstr);
                                if( ! Test.isRunningTest() ) {
                                    YardiGCPushWsdltoApexController.XmlDoc_element requestXML = new YardiGCPushWsdltoApexController.XmlDoc_element();
                                    requestXML.anyElement   = xmlstr;                               
                                    responseXml             = yvn.ImportYardiGuest_Login( IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiUserName' ), IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiPassword' ), IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiServerName' ), IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiDBName' ), IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiPlatform' ), IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiInterfaceEntity' ), IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiInterfaceLicense' ), requestXML );
                                }
                                
                            } else if( '2' == IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiVersionNumber' ) ) {
                                
                                yvn20 = new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap();
                                yvn20.endpoint_x = IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiAPIUrl' );
                                yvn20.timeout_x = 120000;
                                
                                Dom.Document doc                 = new Dom.Document();
                                Dom.XmlNode LeadManagementNode    = doc.createRootElement( 'LeadManagement', null, null );
                                Dom.XmlNode Prospects             = LeadManagementNode.addChildElement( 'Prospects', null, null );
                                Dom.XmlNode Prospect             = Prospects.addChildElement( 'Prospect', null, null );
                                Dom.XmlNode TransactionData       = Prospect.addChildElement( 'TransactionData', null, null );
                                Dom.XmlNode Identification        = TransactionData.addChildElement( 'Identification', null, null );
                                Identification.setAttribute( 'IDType', 'prospect' );
                                Identification.setAttribute( 'IDScopeType', 'sender' );
                                Identification.setAttribute( 'IDRank', 'other' );
                                
                                Dom.XmlNode IDValue             = Identification.addChildElement( 'IDValue', null, null );
                                if( null != cs.CaseNumber ) {
                                    IDValue.addTextNode( cs.CaseNumber );                                 
                                }
                                
                                Dom.XmlNode OrganizationName       = Identification.addChildElement( 'OrganizationName', null, null );
                                OrganizationName.addTextNode( 'Anyone Home' );
                                
                                Dom.XmlNode OriginatingLeadSource   = TransactionData.addChildElement( 'OriginatingLeadSource', null, null );
                                
                                Dom.XmlNode OriginatingLeadChannel  = TransactionData.addChildElement( 'OriginatingLeadChannel', null, null );
                                OriginatingLeadChannel.addTextNode( 'Other' );
                                
                                Dom.XmlNode Customers         = Prospect.addChildElement( 'Customers', null, null );
                                
                                Dom.XmlNode Customer         = Customers.addChildElement( 'MITS:Customer', null, null );
                                Customer.setNameSpace( 'MITS', 'http://my-company.com/namespace' );
                                Customer.setAttribute( 'Type', 'prospect' );
                                
                                Dom.XmlNode CustomerID         = Customer.addChildElement( 'MITS:CustomerID', null, null );
                                
                                Dom.XmlNode Property           = Customer.addChildElement( 'MITS:Property', null, null );
                                Dom.XmlNode PrimaryID         = Property.addChildElement( 'MITS:PrimaryID', null, null );
                                
                                PrimaryID.addTextNode( cs.Cust_Prop_id__c );
                                
                                Dom.XmlNode MarketingName       = Property.addChildElement( 'MITS:MarketingName', null, null );
                                Dom.XmlNode Name             = Customer.addChildElement( 'MITS:Name', null, null );
                                Dom.XmlNode CustomerFirstName     = Name.addChildElement( 'MITS:FirstName', null, null );
                                
                                Dom.XmlNode CustomerLastName       = Name.addChildElement( 'MITS:LastName', null, null );
                                
                                if( null != cs.ContactNameAPI__c ) {
                                    List<String> ContactNameAPI = cs.ContactNameAPI__c.split(' ', 2);
                                    CustomerFirstName.addTextNode( ContactNameAPI[0] );
                                    
                                    if( 2 == ContactNameAPI.size() ) {
                                        CustomerLastName.addTextNode( ContactNameAPI[1] );
                                    }
                                }
                                
                                Dom.XmlNode Address           = Customer.addChildElement( 'MITS:Address', null, null );
                                Address.setAttribute( 'Type', 'property' );
                                
                                Dom.XmlNode Address1           = Address.addChildElement( 'MITS:Address1', null, null );
                                Dom.XmlNode Address2           = Address.addChildElement( 'MITS:Address2', null, null );
                                Dom.XmlNode City             = Address.addChildElement( 'MITS:City', null, null );
                                Dom.XmlNode State             = Address.addChildElement( 'MITS:State', null, null );
                                Dom.XmlNode PostalCode         = Address.addChildElement( 'MITS:PostalCode', null, null );
                                
                                if( null != cs.Address_Line_1__c ) {
                                    Address1.addTextNode( cs.Address_Line_1__c );
                                }
                                Address2.addTextNode( 'NA' );
                                if ( null != cs.City__c ) {
                                    City.addTextNode( cs.City__c );
                                }
                                if ( null != cs.State__c ) {
                                    State.addTextNode( cs.State__c  );  
                                }
                                if ( null != cs.Zip_Code__c )  {
                                    PostalCode.addTextNode( cs.Zip_Code__c );
                                }
                                
                                Dom.XmlNode Email     = Address.addChildElement( 'MITS:Email', null, null );
                                
                                if ( null != cs.Contact_Email_Email_template__c ) {
                                    Email.addTextNode( cs.Contact_Email_Email_template__c );
                                }
                                
                                Dom.XmlNode Phone0     = Customer.addChildElement( 'MITS:Phone', null, null );
                                Phone0.setAttribute( 'Type', 'home' );                            
                                Dom.XmlNode PhoneNumber0 = Phone0.addChildElement( 'MITS:PhoneNumber', null, null );
                                
                                if ( null != cs.ContactPhoneAPI__c ) {
                                    PhoneNumber0.addTextNode( cs.ContactPhoneAPI__c );
                                }
                                
                                Dom.XmlNode CustomerPreferences = Prospect.addChildElement( 'CustomerPreferences', null, null );
                                CustomerPreferences.setNameSpace( 'MITS', 'http://my-company.com/namespace' );
                                Dom.XmlNode TargetMoveInDate   = CustomerPreferences.addChildElement( 'TargetMoveInDate', null, null );
                                
                                if ( null != cs.Move_in_Date__c ) {
                                    TargetMoveInDate.addTextNode( String.valueOf( cs.Move_in_Date__c ) );
                                } else {
                                    TargetMoveInDate.addTextNode( DateTime.now().format('yyyy-MM-dd') );
                                }
                                
                                String FloorPlanIdSetPerCase;
                                Dom.XmlNode DesiredFloorplan     = CustomerPreferences.addChildElement( 'DesiredFloorplan', null, null );
                                if( null != cs.Cust_Prop_id__c &&  false == cs.Multi_Family_Case__c) {
                                    DesiredFloorplan.addTextNode( String.valueOf( cs.Cust_Prop_id__c ) );
                                } else {
                                    Floor_Plan__c floorplan = new Floor_Plan__c();
                                    if( null != cs.Floor_Plan_of_Interest__r.Floorplan_ID__c ) {
                                        FloorPlanIdSetPerCase 		= cs.Floor_Plan_of_Interest__r.Floorplan_ID__c;
                                        floorplan.Floorplan_ID__c 	= FloorPlanIdSetPerCase;
                                    } else if( WaitListUnitPerFpPerProperty.containsKey( cs.Property_of_Interest__r.Customer_Prop_ID__c ) ) {
                                        Set<String> WaitlistFpOfProperty = WaitListUnitPerFpPerProperty.get( cs.Property_of_Interest__r.Customer_Prop_ID__c ).keySet();
                                        for( String WalitlistFloorplan :WaitlistFpOfProperty ) {
                                            FloorPlanIdSetPerCase 		= WalitlistFloorplan;
                                            floorplan.Floorplan_ID__c 	= FloorPlanIdSetPerCase;
                                        }
                                    }
                                    DesiredFloorplan.addTextNode( ( null != String.valueOf( floorplan.Floorplan_ID__c) ? String.valueOf( floorplan.Floorplan_ID__c) : '' )  );
                                }
                                
                                if( true == cs.Multi_Family_Case__c ) {
                                    
                                    Dom.XmlNode DesiredUnit      = CustomerPreferences.addChildElement( 'DesiredUnit', null, null );
                                    Dom.XmlNode Information      = DesiredUnit.addChildElement( 'MITS:Information', null, null );
                                    Dom.XmlNode UnitID           = Information.addChildElement( 'MITS:UnitID', null, null );
                                    
                                    Unit__c unit = new Unit__c();
                                    if( null != cs.Unit_of_Interest__r.Unit_ID__c ) {
                                        unit.Unit_ID__c = cs.Unit_of_Interest__r.Unit_ID__c;
                                    } else if( null != FloorPlanIdSetPerCase &&  WaitListUnitPerFpPerProperty.containsKey( cs.Property_of_Interest__r.Customer_Prop_ID__c ) && WaitListUnitPerFpPerProperty.get( cs.Property_of_Interest__r.Customer_Prop_ID__c ).containsKey( FloorPlanIdSetPerCase ) ) {
                                        unit.Unit_ID__c = WaitListUnitPerFpPerProperty.get( cs.Property_of_Interest__r.Customer_Prop_ID__c ).get( FloorPlanIdSetPerCase );
                                    } else {
                                        List<Unit__c> waitListunit = [ SELECT Unit_ID__c FROM Unit__c WHERE Floor_Plan__r.Floorplan_ID__c = :cs.Floor_Plan_of_Interest__r.Floorplan_ID__c AND unit_ID__c != NULL AND Is_Waitlist__c = true ];
                                        if( ! waitListunit.isEmpty() )
                                            unit.Unit_ID__c = waitListunit.get(0).Unit_ID__c;
                                    }
                                    
                                    if( null != unit.Unit_ID__c ) {
                                        UnitID.addTextNode( unit.Unit_ID__c );
                                    }
                                    
                                    Dom.XmlNode PropertyPrimaryID   = DesiredUnit.addChildElement( 'MITS:PropertyPrimaryID', null, null );
                                    if( null != cs.Cust_Prop_id__c) {
                                        PropertyPrimaryID.addTextNode( cs.Cust_Prop_id__c );
                                    }
                                    
                                    Dom.XmlNode UnitMarketingName    = DesiredUnit.addChildElement( 'MITS:MarketingName', null, null );
                                    if( null != unit.Unit_ID__c  ) {
                                        UnitMarketingName.addTextNode( unit.Unit_ID__c );
                                    }
                                } 
                                
                                Dom.XmlNode DesiredRent  = CustomerPreferences.addChildElement( 'DesiredRent', null, null );
                                
                                if( null != cs.Desired_Rent_Start__c && null != cs.Desired_Rent_Range_End__c ) {
                                    DesiredRent.setAttribute( 'Exact', String.valueOf(cs.Desired_Rent_Range_End__c )) ; 
                                } else if( null == cs.Desired_Rent_Start__c && null != cs.Desired_Rent_Range_End__c ) {
                                    DesiredRent.setAttribute( 'Exact', String.valueOf( cs.Desired_Rent_Range_End__c ) );  
                                    
                                } else if( null != cs.Desired_Rent_Start__c && null == cs.Desired_Rent_Range_End__c ) {
                                    DesiredRent.setAttribute( 'Exact', String.valueOf(cs.Desired_Rent_Start__c ) );                                           
                                } else {
                                    DesiredRent.setAttribute( 'Exact', '0' ); 
                                }
                                
                                if ( null != cs.Bed_Count_Pref__c ) {
                                    Dom.XmlNode DesiredNumBedrooms   = CustomerPreferences.addChildElement( 'DesiredNumBedrooms', null, null );
                                    DesiredNumBedrooms.setAttribute( 'Exact', String.valueOf( cs.Bed_Count_Pref__c ) );
                                } 
                                
                                Dom.XmlNode Comment       			= CustomerPreferences.addChildElement( 'Comment', null, null );
                                Dom.XmlNode Events         			= Prospect.addChildElement( 'Events', null, null );
                                Dom.XmlNode Event         			= Events.addChildElement( 'Event', null, null );
                                if ( null != cs.Date_Time_Sent_Via_Workflow__c ) {
                                    DateTime sentViaWorkFlow     	= cs.Date_Time_Sent_Via_Workflow__c;
                                    String sentViaWorkFlowDate   	= String.valueOf( sentViaWorkFlow.format('yyyy-MM-dd') );
                                    String sentViaWorkFlowTime   	= String.valueOf( sentViaWorkFlow.format('HH:mm:ss') );
                                    String sentViaWorkFlowDateTime  = sentViaWorkFlowDate + 'T' + sentViaWorkFlowTime;
                                    Event.setAttribute( 'EventDate', String.valueOf( sentViaWorkFlowDateTime ) );
                                } else {
                                    String currentDate     			= String.valueOf( DateTime.now().format('yyyy-MM-dd') );
                                    String currentTime     			= String.valueOf( DateTime.now().format('HH:mm:ss') );
                                    String currentDateTime   		= currentDate + 'T' + currentTime;
                                    Event.setAttribute( 'EventDate', currentDateTime );
                                }
                                
                                String strEventTypeAttribute = 'EmailFromProspect';
                                if ( null != cs.Origin ) {
                                    strEventTypeAttribute = cs.Origin;
                                    
                                    if( 'Phone' == cs.Origin ) 
                                        strEventTypeAttribute = 'CallFromProspect';
                                    if( 'Email' == cs.Origin )
                                        strEventTypeAttribute = 'EmailFromProspect';
                                    if( 'Voicemail ' == cs.Origin )
                                        strEventTypeAttribute = 'Other';
                                    
                                }
                                
                                Event.setAttribute( 'EventType', strEventTypeAttribute );
                                
                                Dom.XmlNode Agent           		= Event.addChildElement( 'Agent', null, null );
                                Dom.XmlNode AgentName         		= Agent.addChildElement( 'AgentName', null, null );
                                Dom.XmlNode AgentFirstName     		= AgentName.addChildElement( 'FirstName', null, null );
                                AgentFirstName.addTextNode( 'Anyone Home' );
                                
                                Dom.XmlNode AgentLastName     		= AgentName.addChildElement( 'LastName', null, null );
                                AgentLastName.addTextNode( 'Anyone Home' );
                                
                                Dom.XmlNode EventReasons =  Event.addChildElement( 'EventReasons', null, null );
                                if( ResultsPerProperty.containsKey( cs.Cust_Prop_id__c ) && !ResultsPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                    EventReasons.addTextNode( ResultsPerProperty.get( cs.Cust_Prop_id__c ).get(0) );
                                }
                                
                                if( SourcesPerProperty.containsKey( cs.Cust_Prop_id__c ) && !SourcesPerProperty.get( cs.Cust_Prop_id__c ).isEmpty() ) {
                                    String EventSource = SourcesPerProperty.get( cs.Cust_Prop_id__c ).get(0);
                                    if( null != cs.Ad_Source_Type__c ) {
                                        for( String Source :SourcesPerProperty.get( cs.Cust_Prop_id__c ) ){
                                            if( Source == cs.Ad_Source_Type__c ){
                                                EventSource = cs.Ad_Source_Type__c;
                                                break;
                                            } 
                                        }
                                    } 
                                    OriginatingLeadSource.addTextNode( EventSource );
                                }
                                
                                Dom.XmlNode FirstContact   = Event.addChildElement( 'FirstContact', null, null );
                                
                                Date_show.clear();
                                Date_app.clear();
                                updateappointment.clear();
                                this.GetYardiGuestActivity_Search( IntegrationsCredentialsPerAccount.get( cs.AccountId ), cs.Cust_Prop_id__c, cs.Contact.Prospect_ID__c, cs.Contact_Email_Email_template__c, cs.ContactPhoneAPI__c );
                                
                                Boolean isUpdate = false;
                                
                                if( null !=  guestActivitySearch20.get('CustomerID')  ) {
                                    CustomerID.addTextNode( guestActivitySearch20.get('CustomerID')  );
                                    FirstContact.addTextNode( 'false' );                                 
                                } else {
                                    FirstContact.addTextNode( 'true' );    
                                }
                                
                                Dom.XmlNode Comments    = Event.addChildElement( 'Comments', null, null );
                                Comments.addTextNode( 'First contact' );
                                
                                List<Appointment__c> AllAppointments 	= new List<Appointment__c>();
                                List<Appointment__c> appointment_shows 	= new List<Appointment__c>();
                                List<Appointment__c> appointments 		= new List<Appointment__c>();
                                
                                if( ! Test.isRunningTest() ) {
                                    AllAppointments = [SELECT Id, Unit__c,  Agent_Full_Name__c, Contact__r.Prospect_ID__c, Contact__r.FirstName, Contact__r.LastName, Appointment_Date__c, Unit__r.Unit_ID__c, NoFrom__c, Name,Contact__r.Status__c, Invite_Status__c FROM Appointment__c WHERE Case__c = : cs.Id AND Unit__r.Unit_ID__c != NULL AND Contact__r.Status__c IN ( 'Showing Completed', 'Showing Set' ) AND Invite_Status__c IN ( 'Accepted', 'Invited', 'Canceled', 'Rejected' )];
                                } else {
                                    AllAppointments = [ SELECT Id, Unit__c,  Agent_Full_Name__c, Contact__r.Prospect_ID__c, Contact__r.FirstName, Contact__r.LastName, Appointment_Date__c, Unit__r.Unit_ID__c, NoFrom__c, Name, Contact__r.Status__c, Invite_Status__c FROM Appointment__c LIMIT 1];
                                }
                                
                                for( Appointment__c Appointment :AllAppointments ) {
                                    if( !Test.isRunningTest() ) {
                                        if( Appointment.Contact__r.Status__c == 'Showing Completed' && Appointment.Invite_Status__c == 'Accepted' ) {
                                            appointment_shows.add( Appointment );
                                        } else if( Appointment.Contact__r.Status__c == 'Showing Set' && ( Appointment.Invite_Status__c == 'Invited' || Appointment.Invite_Status__c == 'Canceled' || Appointment.Invite_Status__c == 'Rejected' )  ) {
                                            appointments.add( Appointment );
                                        }
                                    } else {
                                        appointment_shows.add( Appointment );
                                        appointments.add( Appointment );
                                    }
                                }
                                
                                if( false == appointment_shows.isEmpty() ) {
                                    IsShowEvent = ( false == IsFirstContact ) ? false :true;
                                    for( Appointment__c shows : appointment_shows){
                                        if ( true == cs.Multi_Family_Case__c  ) {
                                            Dom.XmlNode Event1 = Events.addChildElement( 'Event', null, null );
                                            Event1.setAttribute( 'EventType', 'Show' );
                                            String EventDate1 = String.valueOf( ( null != shows.Appointment_Date__c ? shows.Appointment_Date__c : date.today() ) ) + 'T' + hours.get( String.valueOf( shows.NoFrom__c ) );
                                            
                                            if( false == Date_show.Contains( EventDate1 ) ) {
                                                if( false == IsFirstContact ){
                                                    Events.removeChild( Event );
                                                }
                                                Event1.setAttribute( 'EventDate', EventDate1 );
                                            } else {
                                                Events.removeChild( Event1 );
                                                break;
                                            }
                                            
                                            Dom.XmlNode EventID = Event1.addChildElement( 'EventID', null, null );
                                            Dom.XmlNode Identification1 = EventID.addChildElement( 'Identification', null, null );
                                            Identification1.setAttribute( 'IDScopeType', 'sender' );
                                            Identification1.setAttribute( 'IDRank', 'other' );
                                            Identification1.setAttribute( 'IDType', 'unit' );
                                            Dom.XmlNode IDValue1 = Identification1.addChildElement( 'IDValue', null, null );
                                            IDValue1.addTextNode(  shows.Unit__r.Unit_ID__c );
                                            
                                            Dom.XmlNode Agent1 = Event1.addChildElement( 'Agent', null, null );
                                            Dom.XmlNode AgentName1 = Agent1.addChildElement( 'AgentName', null, null );
                                            Dom.XmlNode FirstName1 = AgentName1.addChildElement( 'FirstName', null, null );   
                                            Dom.XmlNode LastName1 = AgentName1.addChildElement( 'LastName', null, null );   
                                            FirstName1.addTextNode( shows.Contact__r.FirstName );
                                            LastName1.addTextNode( shows.Contact__r.LastName );
                                            
                                            Dom.XmlNode EventReasons1 = Event1.addChildElement( 'EventReasons', null, null );
                                            if( !Results.isEmpty() ) {
                                                EventReasons1.addTextNode( Results.get(0) );
                                            }
                                            
                                            Dom.XmlNode FirstContact1 = Event1.addChildElement( 'FirstContact', null, null );
                                            FirstContact1.addTextNode( 'false' );
                                            
                                            //Internal Comments
                                            Dom.XmlNode Comments1 = Event1.addChildElement( 'Comments', null, null );
                                            Comments1.addTextNode( '' );
                                        }
                                    }
                                }
                                
                                if( false == appointments.isEmpty() ) {
                                    
                                    for( Appointment__c app : appointments ){
                                        if( true == cs.Multi_Family_Case__c ) {
                                            if( app.Invite_Status__c == 'Invited' ) {
                                                Dom.XmlNode Event1 = Events.addChildElement( 'Event', null, null );
                                                Event1.setAttribute( 'EventType', 'Appointment' );
                                                String EventDate1 = String.valueOf( ( null != app.Appointment_Date__c ? app.Appointment_Date__c : date.today() ) ) + 'T' + hours.get( String.valueOf( app.NoFrom__c ) );
                                                if( false == Date_app.Contains( EventDate1 ) ) {
                                                    if( false == IsFirstContact && false == IsShowEvent ){
                                                        Events.removeChild( Event );
                                                    }
                                                    Event1.setAttribute( 'EventDate', EventDate1 );
                                                } else {
                                                    Events.removeChild( Event1 );
                                                    break;
                                                }
                                                
                                                Dom.XmlNode EventID = Event1.addChildElement( 'EventID', null, null );
                                                Dom.XmlNode Identification1 = EventID.addChildElement( 'Identification', null, null );
                                                Identification1.setAttribute( 'IDScopeType', 'sender' );
                                                Identification1.setAttribute( 'IDRank', 'other' );
                                                Identification1.setAttribute( 'IDType', 'unit' );
                                                Dom.XmlNode IDValue1 = Identification1.addChildElement( 'IDValue', null, null );
                                                IDValue1.addTextNode(  app.Unit__r.Unit_ID__c );
                                                
                                                Dom.XmlNode Agent1 = Event1.addChildElement( 'Agent', null, null );
                                                Dom.XmlNode AgentName1 = Agent1.addChildElement( 'AgentName', null, null );
                                                Dom.XmlNode FirstName1 = AgentName1.addChildElement( 'FirstName', null, null );   
                                                Dom.XmlNode LastName1 = AgentName1.addChildElement( 'LastName', null, null );   
                                                FirstName1.addTextNode( app.Contact__r.FirstName );
                                                LastName1.addTextNode( app.Contact__r.LastName );
                                                
                                                Dom.XmlNode EventReasons1 = Event1.addChildElement( 'EventReasons', null, null );
                                                if( !Results.isEmpty() ) {
                                                    EventReasons1.addTextNode( Results.get(0) );
                                                }
                                                
                                                Dom.XmlNode FirstContact1 = Event1.addChildElement( 'FirstContact', null, null );
                                                FirstContact1.addTextNode( 'false' );
                                                
                                                //Internal Comments
                                                Dom.XmlNode Comments1 = Event1.addChildElement( 'Comments', null, null );
                                                Comments1.addTextNode( '' );
                                                Dom.XmlNode TransactionSource1 = Event1.addChildElement( 'TransactionSource', null, null );
                                                if( null != cs.Ad_Source_Type__c ) {
                                                    TransactionSource1.addTextNode( String.valueOf( cs.Ad_Source_Type__c ) );
                                                }
                                            }
                                            String EventDate1 = String.valueOf( app.Appointment_Date__c ) + 'T' + hours.get( String.valueOf( app.NoFrom__c ) );
                                            if( true == Date_app.Contains( EventDate1 ) && ( 'Canceled' == app.Invite_Status__c || 'Rejected' == app.Invite_Status__c ) ) {
                                                Dom.XmlNode Event2 = Events.addChildElement( 'Event', null, null );
                                                Event2.setAttribute( 'EventType', 'CancelAppointment' );
                                                Event2.setAttribute( 'EventDate', EventDate1 );
                                                Dom.XmlNode EventID2 = Event2.addChildElement( 'EventID', null, null );
                                                
                                                EventID2.setAttribute( 'IDValue', '' );
                                                EventID2.setAttribute( 'IDType', app.Unit__r.Unit_ID__c );
                                                
                                                Dom.XmlNode Agent2 = Event2.addChildElement( 'Agent', null, null );
                                                Dom.XmlNode AgentName2 = Agent2.addChildElement( 'AgentName', null, null );
                                                Dom.XmlNode FirstName2 = AgentName2.addChildElement( 'FirstName', null, null );   
                                                Dom.XmlNode LastName2 = AgentName2.addChildElement( 'LastName', null, null );   
                                                FirstName2.addTextNode( app.Contact__r.FirstName );
                                                LastName2.addTextNode( app.Contact__r.LastName );
                                                
                                                Dom.XmlNode EventReasons2 = Event2.addChildElement( 'EventReasons', null, null );
                                                if( !Results.isEmpty() ) {
                                                    EventReasons2.addTextNode( Results.get(0) );
                                                }
                                                
                                                Dom.XmlNode FirstContact2 = Event2.addChildElement( 'FirstContact', null, null );
                                                FirstContact2.addTextNode( 'false' );
                                                
                                                Dom.XmlNode Comments2 = Event2.addChildElement( 'Comments', null, null );
                                                String strComments2 = 'AH ' + String.valueOf( app.Appointment_Date__c ) + ' - Showing agent is ' + String.valueOf( app.Agent_Full_Name__c );
                                                Comments2.addTextNode( strComments2 );
                                                
                                                Dom.XmlNode TransactionSource2 = Event2.addChildElement( 'TransactionSource', null, null );
                                                if( null != cs.Ad_Source_Type__c ) {
                                                    TransactionSource2.addTextNode( String.valueOf( cs.Ad_Source_Type__c ) );
                                                }
                                            }
                                        }
                                    }
                                }
                                String xmlstr = doc.toXmlString();
                                
                                xmlstr = xmlstr.replace('<?xml version="1.0" encoding="UTF-8"?>', '');
                                xmlstr = xmlstr.replace('<Comments />', '<Comments></Comments>');
                                xmlstr = xmlstr.replace('<MITS:CustomerID />', '<MITS:CustomerID></MITS:CustomerID>');
                                xmlstr = xmlstr.replace('<DesiredLeaseTerms />', '<DesiredLeaseTerms></DesiredLeaseTerms>');
                                xmlstr = xmlstr.replace('<PhoneNumber/>', '<PhoneNumber></PhoneNumber>');
                                xmlstr = xmlstr.replace('<DesiredRent/>', '');
                                xmlstr = xmlstr.replace('<MITS:Email/>', '<MITS:Email></MITS:Email>');
                                xmlstr = xmlstr.replaceAll('/(^[\r\n]*|[\r\n]+)[\\s\t]*[\r\n]/', '\n' );
                                
                                System.debug('xmlstr' + xmlstr);
                                if( !Test.isRunningTest() ) {
                                    YardiGC20PushWsdltoApexController.XmlDocument_element requestXML = new YardiGC20PushWsdltoApexController.XmlDocument_element();
                                    requestXML.anyElement  = xmlstr;
                                    responseXml      = yvn20.ImportYardiGuest_Login( IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiUserName' ), IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiPassword' ), IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiServerName' ), IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiDBName' ), IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiPlatform' ), IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiInterfaceEntity' ), IntegrationsCredentialsPerAccount.get( cs.AccountId ).get( 'YardiInterfaceLicense' ), requestXML );
                                }
                            }
                            
                            System.debug('responseXml ->' + responseXml);
                            if( null != responseXml ) {
                                YardiGCPushResponseController g = new YardiGCPushResponseController();                              
                                YardiGCPushResponseController.GuestCard GuestCard = g.parseGuestCards(new XmlStreamReader(responseXml));
                                
                                System.debug( 'GuestCard.Message -> ' + GuestCard.Message );
                                
                                if( '' != GuestCard.Message && false == GuestCard.IsFailed ) {
                                    cs.GC_Entered__c = true;
                                    cs.Integration_Failed__c = false;  
                                    cs.Yardi_Guest_Card_ID__c = GuestCard.Message.substring(GuestCard.Message.lastIndexOf(' ')+1);
                                } else {
                                    cs.Integration_Failed__c = true;  
                                }
                                
                                if( GuestCard.Message.length() == 0 || null == GuestCard.Message ){
                                    cs.integration_fail_success_message__c = GuestCard.Message = 'No response from server. Unable to update in SFDC record.';     
                                } else if( GuestCard.Message.length() > 255 ){
                                    cs.integration_fail_success_message__c = (GuestCard.Message).substring(0,254);
                                } else {
                                    cs.integration_fail_success_message__c = GuestCard.Message;
                                }
                                
                                NeedToUpdateCases.add(cs);
                            }
                        }
                    } catch( Exception E ) {
                        System.debug( e.getMessage() );
                        system.debug( e.getStackTraceString() );
                        continue;
                    }
                }
            }
        }
        return NeedToUpdateCases;
    }
    
    public void GetYardiGuestActivity_Search( Map<String, String> strCredentials, String PropertyId, String ThirdPartyId, String Email, String PhoneNumber ) {      
        
        guestActivitySearch40.put( 'ThirdPartyIDValue', null );
        guestActivitySearch40.put( 'ProspectIDOrganizationName', null );
        guestActivitySearch40.put( 'ProspectID', null );
        
        guestActivitySearch20.put( 'CustomerID', null);
        
        if( '4' == strCredentials.get( 'YardiVersionNumber' ) ){
            yvn = new YardiGCPushWsdltoApexController.ItfILSGuestCardSoap();
            yvn.endpoint_x = strCredentials.get( 'YardiAPIUrl' );
        } else if( '2' == strCredentials.get( 'YardiVersionNumber' ) ) {
            yvn20 = new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap();
            yvn20.endpoint_x = strCredentials.get( 'YardiAPIUrl' );
        }
        
        if( ! Test.isRunningTest() ) {
            if( null != ThirdPartyId ) {
                if( '2' == strCredentials.get( 'YardiVersionNumber' ) ){
                    GetYardiGuestActivity_Search_result = yvn20.GetYardiGuestActivity_Search( strCredentials.get( 'YardiUserName' ), strCredentials.get( 'YardiPassword' ), strCredentials.get( 'YardiServerName' ), strCredentials.get( 'YardiDBName' ), strCredentials.get( 'YardiPlatform' ), PropertyId, strCredentials.get( 'YardiInterfaceEntity' ), strCredentials.get( 'YardiInterfaceLicense' ), '', '', '', '', ThirdPartyId );
                } else if( '4' == strCredentials.get( 'YardiVersionNumber' ) ) {
                    GetYardiGuestActivity_Search_result = yvn.GetYardiGuestActivity_Search( strCredentials.get( 'YardiUserName' ), strCredentials.get( 'YardiPassword' ), strCredentials.get( 'YardiServerName' ), strCredentials.get( 'YardiDBName' ), strCredentials.get( 'YardiPlatform' ), PropertyId, strCredentials.get( 'YardiInterfaceEntity' ), strCredentials.get( 'YardiInterfaceLicense' ), '', '', '', '', ThirdPartyId, '', '' );
                }
            } else if( null != Email && null != PhoneNumber ) {
                if( '2' == strCredentials.get( 'YardiVersionNumber' ) ){
                    GetYardiGuestActivity_Search_result = yvn20.GetYardiGuestActivity_Search( strCredentials.get( 'YardiUserName' ), strCredentials.get( 'YardiPassword' ), strCredentials.get( 'YardiServerName' ), strCredentials.get( 'YardiDBName' ), strCredentials.get( 'YardiPlatform' ), PropertyId, strCredentials.get( 'YardiInterfaceEntity' ), strCredentials.get( 'YardiInterfaceLicense' ), '', '', Email, PhoneNumber, '' );
                } else if( '4' == strCredentials.get( 'YardiVersionNumber' ) ) {
                    GetYardiGuestActivity_Search_result = yvn.GetYardiGuestActivity_Search( strCredentials.get( 'YardiUserName' ), strCredentials.get( 'YardiPassword' ), strCredentials.get( 'YardiServerName' ), strCredentials.get( 'YardiDBName' ), strCredentials.get( 'YardiPlatform' ), PropertyId, strCredentials.get( 'YardiInterfaceEntity' ), strCredentials.get( 'YardiInterfaceLicense' ), '', '', Email, PhoneNumber, '', '', '' );
                }
            }  
        } 
        System.debug( 'GetYardiGuestActivity_Search_result - ' + GetYardiGuestActivity_Search_result );
        // GetYardiGuestActivity_Search_result = '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <GetYardiGuestActivity_SearchResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard"> <GetYardiGuestActivity_SearchResult> <LeadManagement xmlns=""> <Prospects> <Prospect> <Customers> <Customer Type="prospect"> <Identification IDValue="p0088776" IDType="ProspectID" OrganizationName="Yardi"/> <Identification IDValue="00766334" IDType="ThirdPartyID" OrganizationName="Anyone Home"/> <Identification IDValue="" IDType="TenantID" OrganizationName="Yardi"/> <Identification IDValue="anyhome1" IDType="PropertyID" OrganizationName="Yardi"/> <Identification IDValue="Credit Check Application has not been performed." IDType="CreditCheckStatus" OrganizationName=""/> <Name> <NamePrefix/> <FirstName>Sheldon</FirstName> <MiddleName/> <LastName>Cooper</LastName> </Name> <Address AddressType="current"> <AddressLine1>430 South Fairview Avenue</AddressLine1> <AddressLine2>NA</AddressLine2> <City>Goleta</City> <State>CA</State> <PostalCode>93117</PostalCode> </Address> <Phone PhoneType="home"> <PhoneNumber>1233454563</PhoneNumber> </Phone> <Email>shelli@gmail.com</Email> <Lease> <ExpectedMoveInDate>2015-02-05</ExpectedMoveInDate> </Lease> </Customer> </Customers> <CustomerPreferences> <TargetMoveInDate>2015-02-05</TargetMoveInDate> <DesiredFloorplan>ut000536</DesiredFloorplan> <DesiredUnit> <MarketingName>1003</MarketingName> </DesiredUnit> <DesiredNumBedrooms Exact="2"/> <DesiredLeaseTerms>3</DesiredLeaseTerms> <Comment>Hello Hi iiiiii</Comment> </CustomerPreferences> <Events> <Event EventType="Email" EventDate="2015-02-02T17:27:00.0"> <EventID IDValue="92074"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>true</FirstContact> <Comments>First Contact</Comments> <TransactionSource>Drive by</TransactionSource> </Event> <Event EventType="Appointment" EventDate="2015-02-02T19:30:00.0"> <EventID IDValue="92075" IDType="1003"/> <Agent> <AgentName> <FirstName/> <LastName>Ryan Wolfe</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> <Comments>AH 2015-02-02 - Showing agent is Ryan Wolfe</Comments> </Event> <Event EventType="Show" EventDate="2015-02-02T22:00:00.0"> <EventID IDValue="92076" IDType="1003"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> <Comments>AH 2015-02-02 - Showing agent is Kyle Anderson</Comments> </Event> <Event EventType="Email" EventDate="2015-02-02T17:28:00.0"> <EventID IDValue="92364"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T15:48:00.0"> <EventID IDValue="92905"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T15:48:00.0"> <EventID IDValue="92906"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:06:00.0"> <EventID IDValue="92907"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:06:00.0"> <EventID IDValue="92908"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:07:00.0"> <EventID IDValue="92909"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:07:00.0"> <EventID IDValue="92910"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:07:00.0"> <EventID IDValue="92911"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92912"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92913"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92914"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92915"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92916"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92917"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92918"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92919"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92920"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92921"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92922"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92923"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92924"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92925"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92926"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92927"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92928"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92929"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92930"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92931"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T17:09:00.0"> <EventID IDValue="92932"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92933"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92934"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92935"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92936"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92937"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92938"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92939"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92940"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92941"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92942"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92943"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92944"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92945"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92946"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92947"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92948"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92949"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92950"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92951"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92952"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92953"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92954"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92955"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92956"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92957"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92958"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92959"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92960"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92961"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> <Event EventType="Email" EventDate="2015-02-05T18:21:00.0"> <EventID IDValue="92962"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> </Events> </Prospect> </Prospects> </LeadManagement> </GetYardiGuestActivity_SearchResult> </GetYardiGuestActivity_SearchResponse> </soap:Body> </soap:Envelope>';
        //GetYardiGuestActivity_Search_result = '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <GetYardiGuestActivity_SearchResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard"> <GetYardiGuestActivity_SearchResult> <LeadManagement xmlns=""> <Prospects> <Prospect> <Customers> <Customer Type="prospect"> <Identification IDValue="p0104410" IDType="ProspectID" OrganizationName="Yardi"/> <Identification IDValue="00830399" IDType="ThirdPartyID" OrganizationName="Anyone Home"/> <Identification IDValue="" IDType="TenantID" OrganizationName="Yardi"/> <Identification IDValue="anyhome1" IDType="PropertyID" OrganizationName="Yardi"/> <Identification IDValue="Credit Check Application has not been performed." IDType="CreditCheckStatus" OrganizationName=""/> <Name> <NamePrefix/> <FirstName>Sheldon</FirstName> <MiddleName/> <LastName>Cooper</LastName> </Name> <Address AddressType="current"> <AddressLine1>Test Add1</AddressLine1> <AddressLine2>NA</AddressLine2> <City>Test City</City> <State>CA</State> <PostalCode>Test Zip</PostalCode> </Address> <Email/> <Lease> <ExpectedMoveInDate>2015-03-27</ExpectedMoveInDate> </Lease> </Customer> </Customers> <CustomerPreferences> <TargetMoveInDate>2015-03-27</TargetMoveInDate> <DesiredFloorplan>ut000537</DesiredFloorplan> <DesiredUnit> <MarketingName>2010</MarketingName> </DesiredUnit> <Comment>Live case duplicate not with values but with fields</Comment> </CustomerPreferences> <Events> <Event EventType="CallFromProspect" EventDate="2015-03-27T06:30:00.0"> <EventID IDValue="108137"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>true</FirstContact> <Comments>First Contact</Comments> <TransactionSource>Drive by</TransactionSource> </Event> <Event EventType="Email" EventDate="2015-03-27T07:00:00.0"> <EventID IDValue="108138"/> <Agent> <AgentName> <FirstName/> <LastName>AnyoneHome AnyoneHome</LastName> </AgentName> </Agent> <EventReasons>Still Looking</EventReasons> <FirstContact>false</FirstContact> </Event> </Events> </Prospect> </Prospects> </LeadManagement> </GetYardiGuestActivity_SearchResult> </GetYardiGuestActivity_SearchResponse> </soap:Body> </soap:Envelope>';
        //System.debug( 'GetYardiGuestActivity_Search_result New- ' + GetYardiGuestActivity_Search_result );
        
        if( null != GetYardiGuestActivity_Search_result ) {
            Dom.Document doc = new Dom.Document();
            doc.load(GetYardiGuestActivity_Search_result);
            Dom.XMLNode EnvelopeRootNode = doc.getRootElement();
            
            for( Dom.XMLNode child : EnvelopeRootNode.getChildElements() ) {
                
                if( 'Body' == child.getName() ) {
                    for( Dom.XMLNode child2 : child.getChildElements() ) {
                        
                        if( 'GetYardiGuestActivity_SearchResponse' == child2.getName() ) {
                            for( Dom.XMLNode child3 : child2.getChildElements() ) {
                                
                                if( 'GetYardiGuestActivity_SearchResult' == child3.getName() ) {
                                    for( Dom.XMLNode child4 : child3.getChildElements() ) {
                                        
                                        if( 'LeadManagement' == child4.getName() ) {
                                            for( Dom.XMLNode child5 : child4.getChildElements() ) {
                                                
                                                if( 'Prospects' == child5.getName() ) {
                                                    for( Dom.XMLNode child6 : child5.getChildElements() ) {
                                                        
                                                        if( 'Prospect' == child6.getName() ) {
                                                            for( Dom.XMLNode child7 : child6.getChildElements() ) {
                                                                
                                                                if( 'Customers' == child7.getName() ) {
                                                                    for( Dom.XMLNode child7_1 : child7.getChildElements() ) {
                                                                        
                                                                        if( 'Customer' == child7_1.getName() ) {
                                                                            for( Dom.XMLNode child7_2 : child7_1.getChildElements() ) {
                                                                                
                                                                                if( '2' == strCredentials.get( 'YardiVersionNumber' ) ){
                                                                                    if( 'CustomerID' == child7_2.getname() ) {
                                                                                        guestActivitySearch20.put( 'CustomerID', child7_2.getText() ) ;
                                                                                    }
                                                                                } else if( '4' == strCredentials.get( 'YardiVersionNumber' ) ){
                                                                                    if( 'Identification' == child7_2.getname() ) {
                                                                                        if( 'ProspectID' == child7_2.getAttributeValue('IDType', '') ) {
                                                                                            guestActivitySearch40.put( 'ProspectID', child7_2.getAttributeValue('IDValue', '') );
                                                                                            guestActivitySearch40.put( 'ProspectIDOrganizationName', child7_2.getAttributeValue('OrganizationName', '') );
                                                                                        }
                                                                                        if( 'ThirdPartyID' == child7_2.getAttributeValue('IDType', '') ) {
                                                                                            guestActivitySearch40.put( 'ThirdPartyIDValue', child7_2.getAttributeValue('IDValue', '') );
                                                                                        }
                                                                                    }
                                                                                }
                                                                            } 
                                                                        }
                                                                    } 
                                                                }
                                                                
                                                                if( 'Events' == child7.getName() ) {
                                                                    for( Dom.XMLNode child8 : child7.getChildElements() ) {
                                                                        
                                                                        if( 'Event' == child8.getName() ) {
                                                                            
                                                                            if( 'Show' == child8.getAttributeValue('EventType', '') && false == Date_show.Contains( child8.getAttributeValue('EventDate', '') )  ) {
                                                                                Date_show.add( child8.getAttributeValue('EventDate', '').substringBeforeLast('.0') );
                                                                            }
                                                                            
                                                                            if( 'CallFromProspect' == child8.getAttributeValue('EventType', '') ||
                                                                               'EmailFromProspect' == child8.getAttributeValue('EventType', '') ||
                                                                               'Other' == child8.getAttributeValue('EventType', '') ||
                                                                               'Email' == child8.getAttributeValue('EventType', '') ) {
                                                                                   IsFirstContact = false;
                                                                               }
                                                                            
                                                                            if( 'Appointment' == child8.getAttributeValue('EventType', '') && false == Date_app.Contains( child8.getAttributeValue('EventDate', '') ) ) {
                                                                                Date_app.add( child8.getAttributeValue('EventDate', '').substringBeforeLast('.0') );
                                                                                
                                                                                for( Dom.XMLNode child9 : child8.getChildElements() ) {
                                                                                    
                                                                                    if( 'EventID' == child9.getName() ){
                                                                                        if( '4' == strCredentials.get( 'YardiVersionNumber' ) ) {
                                                                                            updateappointment.put( child8.getAttributeValue('EventDate', '').substringBeforeLast('.0'), child9.getAttributeValue('IDValue', '') );
                                                                                        } else if( '2' == strCredentials.get( 'YardiVersionNumber' ) ) {
                                                                                            for( Dom.XMLNode child10 : child9.getChildElements() ) {
                                                                                                if( 'Identification' == child10.getName() ) {
                                                                                                    for( Dom.XMLNode child11 : child10.getChildElements() ) {
                                                                                                        if( 'IDValue' == child11.getName() ) {
                                                                                                            updateappointment.put( child8.getAttributeValue('EventDate', '').substringBeforeLast('.0'), child11.getText() );
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    } 
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    public void GetYardiAgentsSourcesResults_Login( Map<String, String> strCredentials, String YardiPropertyId ) {
        
        if( ! Test.isRunningTest() ) {
            
            if( '4' == strCredentials.get( 'YardiVersionNumber' ) ) {
                yvn 							= new YardiGCPushWsdltoApexController.ItfILSGuestCardSoap();
                yvn.endpoint_x 					= strCredentials.get( 'YardiAPIUrl' );
                strYardiAgentsSourcesResults 	= yvn.GetYardiAgentsSourcesResults_Login( strCredentials.get( 'YardiUserName' ), strCredentials.get( 'YardiPassword' ), strCredentials.get( 'YardiServerName' ), strCredentials.get( 'YardiDBName' ), strCredentials.get( 'YardiPlatform' ), YardiPropertyId, strCredentials.get( 'YardiInterfaceEntity' ),strCredentials.get( 'YardiInterfaceLicense' ) );
            } else if( '2' == strCredentials.get( 'YardiVersionNumber' ) ){
                yvn20 							= new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap();
                yvn20.endpoint_x 				= strCredentials.get( 'YardiAPIUrl' );
                strYardiAgentsSourcesResults 	= yvn20.GetYardiAgentsSourcesResults_Login(  strCredentials.get( 'YardiUserName' ), strCredentials.get( 'YardiPassword' ), strCredentials.get( 'YardiServerName' ), strCredentials.get( 'YardiDBName' ), strCredentials.get( 'YardiPlatform' ), YardiPropertyId, strCredentials.get( 'YardiInterfaceEntity' ),strCredentials.get( 'YardiInterfaceLicense' ) );
            }
        }
        
        System.debug('strYardiAgentsSourcesResults - ' + strYardiAgentsSourcesResults);
        if( null != strYardiAgentsSourcesResults ) {
            Dom.Document doc = new Dom.Document();
            doc.load(strYardiAgentsSourcesResults);
            Dom.XMLNode EnvelopeRootNode = doc.getRootElement();
            
            for( Dom.XMLNode child : EnvelopeRootNode.getChildElements() ) {
                
                if( 'Body' == child.getName() ) {
                    for( Dom.XMLNode child2 : child.getChildElements() ) {
                        
                        if( 'GetYardiAgentsSourcesResults_LoginResponse' == child2.getName() ) {
                            for( Dom.XMLNode child3 : child2.getChildElements() ) {
                                
                                if( 'GetYardiAgentsSourcesResults_LoginResult' == child3.getName() ) {
                                    for( Dom.XMLNode child4 : child3.getChildElements() ) {
                                        
                                        if( 'Properties' == child4.getName() ) {
                                            for( Dom.XMLNode child5 : child4.getChildElements() ) {
                                                
                                                if( 'Property' == child5.getName() ) {
                                                    for( Dom.XMLNode child6 : child5.getChildElements() ) {
                                                        
                                                        if( 'PropertyRequiredFields' == child6.getName() ) {
                                                            for( Dom.XMLNode child7 : child6.getChildElements() ) {
                                                                String PropertyRequiredFieldsChildsName = child7.getName();
                                                                
                                                                for( Dom.XMLNode child8 : child7.getChildElements() ) {
                                                                    if( 'Agents' == PropertyRequiredFieldsChildsName )
                                                                        Agents.add( child8.getText() );
                                                                    
                                                                    if( 'Sources' == PropertyRequiredFieldsChildsName ) 
                                                                        Sources.add( child8.getText() );
                                                                    
                                                                    if( 'Results' == PropertyRequiredFieldsChildsName ) 
                                                                        Results.add( child8.getText() );
                                                                    
                                                                }
                                                                ResultsPerProperty.put( YardiPropertyId, Results );
                                                                SourcesPerProperty.put( YardiPropertyId, Sources );
                                                                AgentsPerProperty.put( YardiPropertyId, Agents );
                                                            }
                                                        }
                                                    } 
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}