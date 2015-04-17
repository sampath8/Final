public with sharing class YardiSRController{

    public String UserName;
    public String Password;
    public String ServerName;
    public String Database;
    public String Platform;
    public String InterfaceEntity;
    public String InterfaceLicence = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQSLpy4Ro7huvEUpSSXkyhBQSByBBAui++BOHOZi6y+7e0F9P63osdEw/UekwyjUarQzRrAYpzgD93l226Ci2qWPYxqWlf8Qg8R7dNnAB/1TIx8roGlhRsUiWXrzuN7AzjGVzOXG+8LI5qLpTELb9+di/M+dOnakGuZKEhM+gOQFN60j10uPBMjeww1D/7OHNGO2JEGPqL94OLZ7yZCRKkAWQUsLlkfYECwJ0MVBzerAxP0wsQ4TEylz4A+KuXKfq7c0RfWzotMc83h0sYpHeSTC1c6vRL8xuxUZPU';
    public String YardiPropertyId;
    public String AccountName;
    public String GroupName;
    public String APIURL;
	public String PropertyConfigurationsResponseXML;
    
    public List<Integration__c> integrationObjects;
    public List<Service_Request1__c> ServiceRequestsToUpdate = new LIST<Service_Request1__c>();
    public Integer RecordCount = 0;
    
    
    
    Public Set<ID> AccountIds 			= new Set<ID>();
    Public Set<ID> ServiceRequestIds  	= new Set<ID>();
    Public Set<ID> GroupingIds    		= new Set<ID>();
    Public Map<String, Map<String, String>> AllIntegrationCredentials = new Map<String, Map<String, String>>();
    
    Public List<Service_Request1__c> arrobjServiceRequests = new List<Service_Request1__c>();
    
    
    public  YardiSRController() {}
    
    public  YardiSRController(ApexPages.StandardController stc) {}   
    
    public void pushServiceRequests() {
        arrobjServiceRequests = [ SELECT 
                                      Id, Name, Cust_Unit_ID__c, Status__c, Account__c, Case_Origin__c, Service_Request_Type__r.Name, Repair_Sub_Category__c, Request_Category__c,
                                      Permission_to_Enter__c, Entry_Notes__c, Work_Order_Notes__c, Contact_Name__r.FirstName, Contact_Phone__c,  Contact_Email__c, Create_Date__c,
                                      Final_Request_Disposition__c, Cust_Prop_ID__c, Customer_Work_Order_ID__c, Source__c, Group_Membership__c
                                  FROM 
                                      Service_Request1__c
                                  WHERE
                                 	  Id IN :ServiceRequestIds
                                ];
        
        if( !arrobjServiceRequests.isEmpty() ) {
            for( Service_Request1__c ServiceRequest : arrobjServiceRequests ) {
                Map<String, String> IntegrationCredentials = new Map<String, String>();
                
                if( null != ServiceRequest.Group_Membership__c && AllIntegrationCredentials.containsKey( ServiceRequest.Group_Membership__c ) ) {
                    IntegrationCredentials.putAll(AllIntegrationCredentials.get( ServiceRequest.Group_Membership__c ) );
                } else if(  null != ServiceRequest.Account__c ) {
                    IntegrationCredentials.putAll(AllIntegrationCredentials.get( ServiceRequest.Account__c ) );
                }
                
                if( !IntegrationCredentials.isEmpty() ) {
                 	//do the logic   
                 }
            }
            
            
        }
    }
    
	public List<Service_Request1__c> execute() {
		
		List<Service_Request1__c> ServiceRequests  = connect();	
	
        return ServiceRequests;
	}		
    
	public List<Service_Request1__c> connect() {
        
        
		List<Integration__c> arrobjIntegrations = new List<Integration__c>();
		arrobjIntegrations = [SELECT 
                              		Account__r.Name,
                              		Grouping__r.Name,
									Yardi_Password__c,
                              		Yardi_SR_API_URL__c,
                              		Yardi_SR_Database_Name__c,
                              		Yardi_SR_ID__c,
                              		Yardi_SR_Integration_Active__c,
                              		Yardi_SR_Password__c,
                              		Yardi_SR_Platform_Type__c,
                              		Yardi_SR_Server_Name__c,
                              		Yardi_SR_Version_Number__c 
                                 FROM 
                              		Integration__c
								 WHERE 
                              		Yardi_SR_Integration_Active__c = true];
		System.debug(integrationObjects);
        
		if( !arrobjIntegrations.isEmpty() ) {	
            
			for( Integration__c i : arrobjIntegrations ) {
 
        		AccountName = i.Account__r.Name;
                GroupName   = i.Grouping__r.Name;
            	
                // Need to check provided information is empty or not
                
                UserName	= i.Yardi_SR_ID__c;
                Password	= i.Yardi_SR_Password__c;
                ServerName  = i.Yardi_SR_Server_Name__c;
                Database    = i.Yardi_SR_Database_Name__c;
                Platform	= i.Yardi_SR_Platform_Type__c;
                InterfaceEntity = i.Yardi_SR_Version_Number__c;
                APIURL      = i.Yardi_SR_API_URL__c;
                
             	YardiPropertyId = 'anyonehome00';
               	
                System.debug(ServerName);
                List<Service_Request1__c> serviceRequestsObject = new LIST<Service_Request1__c>();
            	/*Set<String> PropertyCodes 						= new Set<String>();
                
				YardiSRWsdltoApexController.ItfServiceRequestsSoap yardiWsdltoApex1 = new YardiSRWsdltoApexController.ItfServiceRequestsSoap();  
            	PropertyConfigurationsResponseXML  = yardiWsdltoApex1.GetPropertyConfigurations(UserName,Password,ServerName,Database,Platform,InterfaceEntity,InterfaceLicence,APIURL);
                
                YardiSRResponseController response = new YardiSRResponseController();
	            PropertyCodes = response.getPropertyCodes(PropertyConfigurationsResponseXML);  */

                if( AccountName != null && GroupName != null ) {

                    serviceRequestsObject = [ SELECT 
                          		 Id,
                                  Name,
                                  Cust_Unit_ID__c,
                                  Status__c,
                                  Case_Origin__c,
                                  Service_Request_Type__r.Name,
                                  Repair_Sub_Category__c,
                                  Request_Category__c,
                                  Permission_to_Enter__c,
                                  Entry_Notes__c,
                                  Work_Order_Notes__c,
                                  Contact_Name__r.FirstName,
                                  Contact_Phone__c,
                                  Contact_Email__c,
                                  Create_Date__c,
                                  Final_Request_Disposition__c,
                                  Cust_Prop_ID__c,
                                  Customer_Work_Order_ID__c,
                                 Source__c
							FROM 
                          		Service_Request1__c
							WHERE 
								Service_Request_Type__r.CS_Request_Type__c = FALSE AND
                                Customer_Service_Source__c = TRUE AND
								Work_Order_Entered_in_PMS__c = FALSE AND 
								Account__c = :AccountName AND 
                                Group_Membership__c = :GroupName AND 
                                Status__c = 'Request Sent' AND 
                                Cust_Prop_ID__c != NULL
							LIMIT 25        
                            
                           ];
    //Cust_Prop_ID__c IN :PropertyCodes                        
              
                } else if( AccountName != null ) {
                
                    
                    serviceRequestsObject = [SELECT
                          		  Id,
                                  Name,
                                  Cust_Unit_ID__c,
                                  Status__c,
                                  Case_Origin__c,
                                  Service_Request_Type__r.Name,
                                  Repair_Sub_Category__c,
                                  Request_Category__c,
                                  Permission_to_Enter__c,
                                  Entry_Notes__c,
                                  Work_Order_Notes__c,
                                  Contact_Name__r.FirstName,
                                  Contact_Phone__c,
                                  Contact_Email__c,
                                  Create_Date__c,
                                  Final_Request_Disposition__c,
                                  Cust_Prop_ID__c,
                                  Customer_Work_Order_ID__c,
                                 Source__c
                             FROM 
                          		Service_Request1__c
                             WHERE 
                                Service_Request_Type__r.CS_Request_Type__c = FALSE AND
                                Customer_Service_Source__c = TRUE AND
                                Work_Order_Entered_in_PMS__c = FALSE AND 
                                Status__c = 'Request Sent' AND
                                Account__c = :AccountName AND
                                Cust_Prop_ID__c != NULL  
                              LIMIT 25                                
                         ];
                                                   //Cust_Prop_ID__c IN :PropertyCodes
                } else {
                  	System.debug('Account is not available for provided integration object');  
                }                   
                
                if( serviceRequestsObject.size() > 0 ) {
	                Boolean IsSRUpsertInYardi = upsertServiceRequestsToYardi(UserName,Password,ServerName,Database, Platform,InterfaceEntity,InterfaceLicence, serviceRequestsObject,YardiPropertyId );
    	        } else {
                    System.debug('We dont have any SR to sync with yardi for Account : ' + AccountName );  
                }                
			} // End for Loop
        } else {
            System.debug('We dont have any account to sync SR with yardi');  
        }	
	
		return ServiceRequestsToUpdate;
	}
   
    public boolean upsertServiceRequestsToYardi( String UserName, String Password, String ServerName, String Database, String Platform, String InterfaceEntity, String InterfaceLicense, LIST<Service_Request1__c> ServiceRequests, String YardiPropertyId ){
         
        String serviceResponceXML,SRXML;
        String serviceRequestSFId;     
        String YardiWorkOrderId;          

        for( Service_Request1__c sr: ServiceRequests ) {
                 
		   YardiWorkOrderId = '';
           serviceRequestSFId = sr.Id;
			
           System.debug(serviceRequestSFId);
            
           XmlStreamWriter writer = new XmlStreamWriter();
        
            writer.writeStartElement('', 'ServiceRequests', '');
            writer.writeAttribute( '', '', 'xmlns', '');
                
            writer.writeStartElement('', 'ServiceRequest', '');
            
            writer.writeStartElement('', 'ServiceRequestId', '');
                        
            if( null != sr.Customer_Work_Order_ID__c ) {
                 YardiWorkOrderId = sr.Customer_Work_Order_ID__c;
            }          
            
            writer.writeCharacters(YardiWorkOrderId);
            
            writer.writeEndElement();
            
            //Case_Origin__c
            writer.writeStartElement('', 'Origin', '');
            if( null != sr.Case_Origin__c ) {
                 writer.writeCharacters(sr.Case_Origin__c);
            } else {
                 writer.writeCharacters('');
            }             
            writer.writeEndElement();
            
            //Cust_Prop_ID__c
            writer.writeStartElement('', 'PropertyCode', 'xxxx');
             if( null != sr.Cust_Prop_ID__c ) {
                 writer.writeCharacters(sr.Cust_Prop_ID__c);
            } else {
                 writer.writeCharacters('anyhome1');
            }  
            writer.writeEndElement();
            
			//Cust_Unit_ID__c            
            writer.writeStartElement('', 'UnitCode', 'xxxx');
             if( null != sr.Cust_Unit_ID__c ) {
                 writer.writeCharacters(sr.Cust_Unit_ID__c);
            } else {
                 writer.writeCharacters('');
            }              
            writer.writeEndElement();
            
            //NULL
            writer.writeStartElement('', 'TenantCode', 'xxxx');            
            writer.writeCharacters('');
            writer.writeEndElement();
            
            //NULL
            writer.writeStartElement('', 'VendorCode', 'xxxx');
            writer.writeCharacters('');
            writer.writeEndElement();
            
            //Work_Order_Notes__c
            writer.writeStartElement('', 'ServiceRequestBriefDescription', 'xxxx'); 
            if( null != sr.Work_Order_Notes__c ) {
                 writer.writeCharacters(sr.Work_Order_Notes__c);
            } else {
                 writer.writeCharacters('sparking');
            }           
            writer.writeEndElement();
            
            //Work_Order_Notes__c Need to check
            writer.writeStartElement('', 'ServiceRequestFullDescription', '');
            if( null != sr.Work_Order_Notes__c ) {
                 writer.writeCharacters(sr.Work_Order_Notes__c);
            } else {
                 writer.writeCharacters('sparking');
            }             
            writer.writeEndElement();
            
           //Final_Request_Disposition__c But as of now High is perfect :)
           writer.writeStartElement('', 'Priority', '');
           if( null != sr.Final_Request_Disposition__c ) {
                 if( 'Emergency' == sr.Final_Request_Disposition__c ) {
                 	writer.writeCharacters('High');
                 } else {
                     writer.writeCharacters(sr.Final_Request_Disposition__c);
                 }
            } else {
                writer.writeCharacters('High');
            }    
            writer.writeEndElement();
            
            //Request_Category__c
            writer.writeStartElement('', 'Category', '');
            if( null != sr.Request_Category__c ) {
                 writer.writeCharacters(sr.Request_Category__c);
            } else {
                 writer.writeCharacters('Plumbing');
            }
            writer.writeEndElement();
            
            
            //Repair_Sub_Category__c
            writer.writeStartElement('', 'SubCategory', '');
             if( null != sr.Repair_Sub_Category__c ) {
                 writer.writeCharacters(sr.Repair_Sub_Category__c);
            } else {
                  writer.writeCharacters('');
            }            
            writer.writeEndElement();
            
            //Permission_to_Enter__c/*
            writer.writeStartElement('', 'HasPermissionToEnter', '');
             if( null != sr.Permission_to_Enter__c ) {
                 if( 'Yes' == sr.Permission_to_Enter__c ) {
                 	writer.writeCharacters('True');
                 } else {
                     writer.writeCharacters('False');
                 }
            } else {
                writer.writeCharacters('True');
            }               
            writer.writeEndElement();
            
            //Entry_Notes__c
            writer.writeStartElement('', 'AccessNotes', '');
             if( null != sr.Entry_Notes__c ) {
                 writer.writeCharacters(sr.Entry_Notes__c);
            } else {
                  writer.writeCharacters('');
            }             
            writer.writeEndElement();
            
			//Work_Order_Notes__c
            writer.writeStartElement('', 'ProblemDescriptionNotes', '');
            if( null != sr.Work_Order_Notes__c ) {
                 writer.writeCharacters(sr.Work_Order_Notes__c);
            } else {
                  writer.writeCharacters('');
            }
            writer.writeEndElement();
            
            //NULL
            writer.writeStartElement('', 'TechnicianNotes', '');
            writer.writeCharacters('');
            writer.writeEndElement();
            //NULL
            writer.writeStartElement('', 'TenantCaused', '');
            writer.writeCharacters('');
            writer.writeEndElement();
            
            /*$arrRequestorName = get_object_vars($arrServiceRequest['Contact_Name__r']);
			$strRequestorName = $arrRequestorName['FirstName'];
			*/
            writer.writeStartElement('', 'RequestorName', '');
            if( null != sr.Work_Order_Notes__c ) {
                 writer.writeCharacters(sr.Contact_Name__r.FirstName);
            } else {
                  writer.writeCharacters('');
            }
            writer.writeEndElement();
            
            //Contact_Phone__c
            writer.writeStartElement('', 'RequestorPhoneNumber', '');
            if( null != sr.Contact_Phone__c ) {
                 writer.writeCharacters(sr.Contact_Phone__c);
            } else {
                  writer.writeCharacters('');
            }
            
            writer.writeEndElement();
            
            //Contact_Email__c
            writer.writeStartElement('', 'RequestorEmail', '');
            if( null != sr.Contact_Email__c ) {
                 writer.writeCharacters(sr.Contact_Email__c);
            } else {
                  writer.writeCharacters('');
            }
            writer.writeEndElement();
            
            //NULL
            writer.writeStartElement('', 'AuthorizedBy', '');
            writer.writeCharacters('');
            writer.writeEndElement();
            //NULL
            writer.writeStartElement('', 'CurrentStatus', '');
            writer.writeCharacters('');
            writer.writeEndElement();
            
            //NULL
            writer.writeStartElement('', 'Resolution', '');
            writer.writeCharacters('');
            writer.writeEndElement();
          
            writer.writeEndElement(); 
            
            writer.writeEndElement();  
            SRXML = writer.getXmlString();
        	writer.close();                
                
            YardiSRWsdltoApexController.ItfServiceRequestsSoap yardiWsdltoApex = new YardiSRWsdltoApexController.ItfServiceRequestsSoap();  
            YardiSRWsdltoApexController.CreateOrEditServiceRequests_ServiceRequestXml_element requstXML = new YardiSRWsdltoApexController.CreateOrEditServiceRequests_ServiceRequestXml_element();

            requstXML.anyElement = SRXML;

            serviceResponceXML = yardiWsdltoApex.CreateOrEditServiceRequests_Http(UserName,Password,ServerName,Database,Platform,sr.Cust_Prop_ID__c,InterfaceEntity,InterfaceLicense,requstXML, APIURL);
          
            System.debug( 'ServiceResponceXML : ' + serviceResponceXML );
            
            XmlStreamReader reader = new XmlStreamReader(serviceResponceXML);
            YardiSRResponseController response = new YardiSRResponseController();
            YardiSRResponseController.ServiceRequest ServiceRequestResponse = response.parseServicceRequest(reader);  
                      
            Service_Request1__c srToUpdate = new Service_Request1__c();              
            
            System.debug( 'Parsed ServiceResponse XML : ' + ServiceRequestResponse );
            
            srToUpdate.Id = serviceRequestSFId;
            if( ServiceRequestResponse.srIsFailed == true ){
            	srToUpdate.Integration_Failed__c = true;
                srToUpdate.Work_Order_Entered_in_PMS__c = false;
    			srToUpdate.Integration_Fail_Success_Message__c = ServiceRequestResponse.srErrorMessage;
                srToUpdate.Customer_Work_Order_ID__c = YardiWorkOrderId;
                
                System.debug( ' SF Id : ' + serviceRequestSFId + ' Sync with yardi work order Id : ' + ServiceRequestResponse.srWorkOrderId + ' Error : ' + ServiceRequestResponse.srErrorMessage );
            } else {
                srToUpdate.Work_Order_Entered_in_PMS__c = true;
            	srToUpdate.Integration_Failed__c = false;
            	srToUpdate.Integration_Fail_Success_Message__c = 'SUCCESS';               
                srToUpdate.Customer_Work_Order_ID__c = ServiceRequestResponse.srWorkOrderId;
                                
                System.debug( ' SF Id : ' + serviceRequestSFId + ' Sync with yardi work order Id : ' + ServiceRequestResponse.srWorkOrderId );
            }                                    
         
            
            ServiceRequestsToUpdate.add(srToUpdate);           
        }         
        return true;
    }   
}