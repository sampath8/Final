//Generated by wsdl2apex
public class YardiSRWsdltoApexController {
       public class CreateOrEditServiceRequests_ServiceRequestXml_element {
       
        public String anyElement;
        private String[] anyElement_type_info = new String[]{'anyElement','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','List<DOM.XmlNode>','0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','true','false'};
        private String[] field_order_type_info = new String[]{'anyElement'};
        public CreateOrEditServiceRequests_ServiceRequestXml_element(){
        }

         public void populateXmlNode(Dom.XmlNode outerNode){
            System.debug('Outer Node : ' + outerNode );
            Dom.Xmlnode ServiceRequests = outerNode.addCommentNode(this.anyElement);              
        }
    }

     public class GetPropertyConfigurations_element {
        
        public String UserName;
        public String Password;
        public String ServerName;
        public String Database;
        public String Platform;
        public String InterfaceEntity;
        public String InterfaceLicense;
        private String[] UserName_type_info = new String[]{'UserName','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests',null,'0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests',null,'0','1','false'};
        private String[] ServerName_type_info = new String[]{'ServerName','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests',null,'0','1','false'};
        private String[] Database_type_info = new String[]{'Database','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests',null,'0','1','false'};
        private String[] Platform_type_info = new String[]{'Platform','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests',null,'0','1','false'};
        private String[] InterfaceEntity_type_info = new String[]{'InterfaceEntity','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests',null,'0','1','false'};
        private String[] InterfaceLicense_type_info = new String[]{'InterfaceLicense','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','true','false'};
        private String[] field_order_type_info = new String[]{'UserName','Password','ServerName','Database','Platform','InterfaceEntity','InterfaceLicense'};
    
        public GetPropertyConfigurations_element() {} 
        
        public GetPropertyConfigurations_element( String UserName, String Password, String ServerName, String Database, String Platform, String InterfaceEntity, String InterfaceLicense ) {
            
            this.UserName 			= UserName;
            this.Password 			= Password;
            this.ServerName 		= ServerName;
            this.Database 			= Database;
            this.Platform 			= Platform;
            this.InterfaceEntity 	= InterfaceEntity;
            this.InterfaceLicense 	= InterfaceLicense;
        }
        
        public void populateXmlNode( Dom.XmlNode outerNode ){
   
            Dom.XmlNode UserNameNode 			= outerNode.addChildElement( 'itf:UserName', null, null );
            Dom.XmlNode PasswordNode 			= outerNode.addChildElement( 'itf:Password', null, null );
            Dom.XmlNode ServerNameNode 			= outerNode.addChildElement( 'itf:ServerName', null, null );
            Dom.XmlNode DatabaseNode 			= outerNode.addChildElement( 'itf:Database', null, null );
            Dom.XmlNode PlatformNode 			= outerNode.addChildElement( 'itf:Platform', null, null );
            Dom.XmlNode InterfaceEntityNode 	= outerNode.addChildElement( 'itf:InterfaceEntity', null, null );
            Dom.XmlNode InterfaceLicenseNode 	= outerNode.addChildElement( 'itf:InterfaceLicense', null, null );
            
            UserNameNode.addTextNode( ( this.UserName == null ) ? '' : this.UserName );
            PasswordNode.addTextNode( ( this.Password == null ) ? '' : this.Password );
            ServerNameNode.addTextNode( ( this.ServerName == null ) ? '' : this.ServerName );
			DatabaseNode.addTextNode( ( this.Database == null ) ? '' : this.Database );
            PlatformNode.addTextNode( ( this.Platform == null ) ? '' : this.Platform );
			InterfaceEntityNode.addTextNode( ( this.InterfaceEntity == null) ? '' : this.InterfaceEntity );
            InterfaceLicenseNode.addTextNode( ( this.InterfaceLicense == null ) ? '' : this.InterfaceLicense );
		}    
    }
 public class CreateOrEditServiceRequests_element {
        public String UserName;
        public String Password;
        public String ServerName;
        public String Database;
        public String Platform;
        public String YardiPropertyId;
        public String InterfaceEntity;
        public String InterfaceLicense;
        public YardiSRWsdltoApexController.CreateOrEditServiceRequests_ServiceRequestXml_element ServiceRequestXml;
        private String[] UserName_type_info = new String[]{'UserName','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','string','0','1','false'};
        private String[] Password_type_info = new String[]{'Password','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','string','0','1','false'};
        private String[] ServerName_type_info = new String[]{'ServerName','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','string','0','1','false'};
        private String[] Database_type_info = new String[]{'Database','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','string','0','1','false'};
        private String[] Platform_type_info = new String[]{'Platform','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','string','0','1','false'};
        private String[] YardiPropertyId_type_info = new String[]{'YardiPropertyId','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','string','0','1','false'};
        private String[] InterfaceEntity_type_info = new String[]{'InterfaceEntity','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','string','0','1','false'};
        private String[] InterfaceLicense_type_info = new String[]{'InterfaceLicense','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','string','0','1','false'};
        private String[] ServiceRequestXml_type_info = new String[]{'ServiceRequestXml','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','true','false'};
        private String[] field_order_type_info = new String[]{'UserName','Password','ServerName','Database','Platform','YardiPropertyId','InterfaceEntity','InterfaceLicense','ServiceRequestXml'};


        public CreateOrEditServiceRequests_element(){
        }
        public CreateOrEditServiceRequests_element(String UserName,String Password,String ServerName,String Database,String Platform,String YardiPropertyId,String InterfaceEntity,String InterfaceLicense,YardiSRWsdltoApexController.CreateOrEditServiceRequests_ServiceRequestXml_element ServiceRequestXml){
            this.UserName = UserName;
            this.Password = Password;
            this.ServerName = ServerName;
            this.Database = Database;
            this.Platform = Platform;
            this.YardiPropertyId = YardiPropertyId;
            this.InterfaceEntity = InterfaceEntity;
            this.InterfaceLicense = InterfaceLicense;
            this.ServiceRequestXml = ServiceRequestXml;
        }
        public void populateXmlNode(Dom.XmlNode outerNode){

    
            Dom.XmlNode UserNameNode = outerNode.addChildElement('UserName', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests', '');
            UserNameNode.addTextNode((this.UserName == null) ? '' : this.UserName);
            Dom.XmlNode PasswordNode = outerNode.addChildElement('Password', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests', '');
            PasswordNode.addTextNode((this.Password == null) ? '' : this.Password);
            Dom.XmlNode ServerNameNode = outerNode.addChildElement('ServerName', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests', '');
            ServerNameNode.addTextNode((this.ServerName == null) ? '' : this.ServerName);
            Dom.XmlNode DatabaseNode = outerNode.addChildElement('Database', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests', '');
            DatabaseNode.addTextNode((this.Database == null) ? '' : this.Database);
            Dom.XmlNode PlatformNode = outerNode.addChildElement('Platform', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests', '');
            PlatformNode.addTextNode((this.Platform == null) ? '' : this.Platform);
            Dom.XmlNode YardiPropertyIdNode = outerNode.addChildElement('YardiPropertyId', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests', '');
            YardiPropertyIdNode.addTextNode((this.YardiPropertyId == null) ? '' : this.YardiPropertyId);
            Dom.XmlNode InterfaceEntityNode = outerNode.addChildElement('InterfaceEntity', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests', '');
            InterfaceEntityNode.addTextNode((this.InterfaceEntity == null) ? '' : this.InterfaceEntity);
            Dom.XmlNode InterfaceLicenseNode = outerNode.addChildElement('InterfaceLicense', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests', '');
            InterfaceLicenseNode.addTextNode((this.InterfaceLicense == null) ? '' : this.InterfaceLicense);
		
            YardiSRWsdltoApexController.CreateOrEditServiceRequests_ServiceRequestXml_element ServiceRequestXmlObj = this.ServiceRequestXml;
            Dom.XmlNode ServiceRequestXmlNode = outerNode.addChildElement('ServiceRequestXml', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests', '');
            if(ServiceRequestXmlObj != null){
                ServiceRequestXmlObj.populateXmlNode(ServiceRequestXmlNode);
            }
    
        }
    }

    public class CreateOrEditServiceRequestsResponse_element {
        public YardiSRWsdltoApexController.CreateOrEditServiceRequestsResponse_CreateOrEditServiceRequestsResult_element CreateOrEditServiceRequestsResult;
        private String[] CreateOrEditServiceRequestsResult_type_info = new String[]{'CreateOrEditServiceRequestsResult','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','true','false'};
        private String[] field_order_type_info = new String[]{'CreateOrEditServiceRequestsResult'};
        public CreateOrEditServiceRequestsResponse_element(){
        }
        public CreateOrEditServiceRequestsResponse_element(DOM.XmlNode responseNode){
          
            //System.assertEquals('CreateOrEditServiceRequestsResponse', responseNode.getName());
            DOM.XmlNode CreateOrEditServiceRequestsResultNode = responseNode.getChildElement('CreateOrEditServiceRequestsResult', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests');
            if(CreateOrEditServiceRequestsResultNode == null){
                this.CreateOrEditServiceRequestsResult = null;
            } else{
                 System.debug('Result :' + CreateOrEditServiceRequestsResultNode);
                YardiSRWsdltoApexController.CreateOrEditServiceRequestsResponse_CreateOrEditServiceRequestsResult_element CreateOrEditServiceRequestsResultObj = new YardiSRWsdltoApexController.CreateOrEditServiceRequestsResponse_CreateOrEditServiceRequestsResult_element(CreateOrEditServiceRequestsResultNode);
               	this.CreateOrEditServiceRequestsResult = CreateOrEditServiceRequestsResultObj;
            }
            System.debug('Result :' + this.CreateOrEditServiceRequestsResult);         
        }
    }

   public class CreateOrEditServiceRequestsResponse_CreateOrEditServiceRequestsResult_element {
        public Set<DOM.XmlNode> nodesParsed = new Set<DOM.XmlNode>();
        //private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','true','false'};
       // private String[] field_order_type_info = new String[]{};
        public CreateOrEditServiceRequestsResponse_CreateOrEditServiceRequestsResult_element(DOM.XmlNode responseNode){
        
            nodesParsed.add(responseNode);
        }
    }

  
    public class GetVersionNumber_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class GetVersionNumberResponse_element {
        public String GetVersionNumberResult;
        private String[] GetVersionNumberResult_type_info = new String[]{'GetVersionNumberResult','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','true','false'};
        private String[] field_order_type_info = new String[]{'GetVersionNumberResult'};
    }
     public class Ping_element {
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','true','false'};
        private String[] field_order_type_info = new String[]{};
    }
    public class PingResponse_element {
        public String PingResult;
        private String[] PingResult_type_info = new String[]{'PingResult','http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests','true','false'};
        private String[] field_order_type_info = new String[]{'PingResult'};
    }
    public class ItfServiceRequestsSoap {
       // public String endpoint_x = 'https://www.iyardiasp.com/8223thirdparty708dev/webservices/itfservicerequests.asmx';
        public String endpoint_x = 'https://www.iyardiasp.com/8223thirdqa/webservices/itfservicerequests.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests', 'YardiSRWsdltoApexController'};
       
        public String Ping(String endpoint_x ) {
            YardiSRWsdltoApexController.Ping_element request_x = new YardiSRWsdltoApexController.Ping_element();
            YardiSRWsdltoApexController.PingResponse_element response_x;
            Map<String, YardiSRWsdltoApexController.PingResponse_element> response_map_x = new Map<String, YardiSRWsdltoApexController.PingResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests/Ping',
              'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests',
              'Ping',
              'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests',
              'PingResponse',
              'YardiSRWsdltoApexController.PingResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.PingResult;
        }
    
        public String GetVersionNumber( String endpoint_x) {
            YardiSRWsdltoApexController.GetVersionNumber_element request_x = new YardiSRWsdltoApexController.GetVersionNumber_element();
            YardiSRWsdltoApexController.GetVersionNumberResponse_element response_x;
            Map<String, YardiSRWsdltoApexController.GetVersionNumberResponse_element> response_map_x = new Map<String, YardiSRWsdltoApexController.GetVersionNumberResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests/GetVersionNumber',
              'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests',
              'GetVersionNumber',
              'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests',
              'GetVersionNumberResponse',
              'YardiSRWsdltoApexController.GetVersionNumberResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.GetVersionNumberResult;
        }
     

        public String GetPropertyConfigurations( String UserName,String Password,String ServerName,String Database,String Platform,String InterfaceEntity,String InterfaceLicense, String endpoint_x ) {
        	
            String responseXMLString;
            DOM.Document Doc = new DOM.Document();
            DOM.XmlNode envelope = Doc.createRootElement('Envelope', 'http://schemas.xmlsoap.org/soap/envelope/', 'soapenv');
            envelope.setNameSpace( 'itf', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests' ); 
            
            DOM.XmlNode header 		= envelope.addChildElement('soapenv:Header', null, null );
            DOM.XmlNode body 		= envelope.addChildElement('soapenv:Body', null, null );
            DOM.XmlNode methodNode 	= body.addChildElement('itf:GetPropertyConfigurations', null, null);
            
            YardiSRWsdltoApexController.GetPropertyConfigurations_element request_x = new YardiSRWsdltoApexController.GetPropertyConfigurations_element( UserName, Password, ServerName, Database, Platform, InterfaceEntity, InterfaceLicense );
			
            request_x.populateXmlNode(methodNode);
			System.Debug( Doc.toXmlString() );
            HttpRequest request = new HttpRequest();
            request.setEndpoint( endpoint_x );
            request.setMethod( 'POST' );
            request.setHeader( 'Content-Type', 'text/xml; charset=UTF-8' );
            request.setHeader( 'SOAPAction', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests/GetPropertyConfigurations' );
            request.setBodyDocument( Doc );
            
            Http http 				= new Http();
            HTTPResponse response 	= http.send( request );
            responseXMLString 		=  response.getBody();
            
            return responseXMLString;            
        } 
        
        public String CreateOrEditServiceRequests_Http(String UserName,String Password,String ServerName,String Database,String Platform,String YardiPropertyId,String InterfaceEntity,String InterfaceLicense,YardiSRWsdltoApexController.CreateOrEditServiceRequests_ServiceRequestXml_element ServiceRequestXml,  String endpoint_x) {            
            
            String env = 'http://schemas.xmlsoap.org/soap/envelope/';
            String xsi = 'http://www.w3.org/2001/XMLSchema-instance';
            String xsd = 'http://www.w3.org/2001/XMLSchema';      
            
           
            DOM.Document doc = new DOM.Document();
            DOM.XmlNode envelope = doc.createRootElement('Envelope', env, 'env');
            
            envelope.setNamespace('xsd', xsd);
            envelope.setNamespace('xsi', xsi);
            
            DOM.XmlNode header = envelope.addChildElement('Header', env, '');
          //  AddHeader(header);
       
            DOM.XmlNode body = envelope.addChildElement('Body', env, '');
            DOM.XmlNode methodNode = body.addChildElement('CreateOrEditServiceRequests', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests', '');          
            YardiSRWsdltoApexController.CreateOrEditServiceRequests_element request_x = new YardiSRWsdltoApexController.CreateOrEditServiceRequests_element(UserName,Password,ServerName,Database,Platform,YardiPropertyId,InterfaceEntity,InterfaceLicense,ServiceRequestXml);

            request_x.populateXmlNode(methodNode);
			
            String SRFinalXML = doc.toXmlString();
            SRFinalXML = SRFinalXML.replace('<!--', '');
			SRFinalXML = SRFinalXML.replace('-->', '');
            
             DOM.Document doc1 = new DOM.Document();	
            doc1.load(SRFinalXML);
            System.debug('SRFinalXML : ' + SRFinalXML);
						
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint_x);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'text/xml; charset=UTF-8');
            req.setHeader('SOAPAction', 'http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests/CreateOrEditServiceRequests');
            req.setBodyDocument(doc1);
            System.debug('req.getBody : ' + req);
            Http http = new Http();
            HTTPResponse res = http.send(req);
            String xmlSRResponse =  res.getBody();
            System.debug('res.getBody : ' + xmlSRResponse);
            return xmlSRResponse;
        }
    }
}