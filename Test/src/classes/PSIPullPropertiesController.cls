public class PSIPullPropertiesController {

    public String strRequest;
    public String responseJsonString;
    public List<String> strCredentials                  = new List<String>();
    public Map<String, Set<String>> strAccountURLs      = new Map<String, Set<String>>();
    public List<Property__c>PropertyList                = new List<Property__c>();

    public List<Property__c> getProperties() {

        List<Integration__c> searchList = [ SELECT 
                                           Account__c, Do_not_update_property_name__c, PSI_API_URL__c, PSI_Password__c, PSI_Username__c 
                                           FROM
                                           Integration__c
                                           WHERE
                                           PSI_Integration_Active__c = true
                                           AND Get_PSI_Properties__c != NULL
                                          ];
        
        if( !searchList.isEmpty() ) {
            for( Integration__c I :searchList ) {              
                strCredentials.clear();
                strCredentials.add( I.PSI_API_URL__c );
                strCredentials.add( I.PSI_Username__c );
                strCredentials.add( I.PSI_Password__c );
                strCredentials.add( I.Account__c );
                
                  if( strAccountURLs.isEmpty() || !strAccountURLs.containsKey( I.Account__c ) || ( strAccountURLs.containsKey( I.Account__c) && !strAccountURLs.get(I.Account__c).contains(I.PSI_API_URL__c) ) ) {
                
                    Set<String> tempSet = new Set<String>();
                    if( strAccountURLs.containsKey( I.Account__c) ) {
                        tempSet = strAccountURLs.get( I.Account__c );
                    } 
                    
                    tempSet.add( I.PSI_API_URL__c );
                    strAccountURLs.put( I.Account__c, tempSet );
                    
                    // Build request
                    buildRequest( strCredentials );
                    // variable 'strRequest' has request;
                    
                    // Send request
                    HttpRequest request = new HttpRequest();
                    request.setEndpoint( strCredentials.get(0) + '/properties' );
                    request.setMethod( 'POST' );
                    request.setHeader( 'Content-Type', 'application/json; charset=UTF-8' );
                    request.setTimeout( 120000 );
                    request.setBody( strRequest );
                    
                    if( !Test.isRunningTest() ) {
                        Http http                     = new Http();
                        HTTPResponse response         = http.send( request );
                        responseJsonString            =  response.getBody();
                    }
                   
                    // Parse response
                    if( null != responseJsonString ) {
                        List<Property__c> tempPropertyList  = parseJSONresponse( responseJsonString, I.Account__c, I.Do_not_update_property_name__c );
                        if( !tempPropertyList.isEmpty() )
                            PropertyList.addAll( tempPropertyList );
                    }
                }
            }
        }
        return PropertyList;
    }

    public void buildRequest( List<String>strCredentials ){

        String UserName 	= strCredentials.get(1);
        String Password  	= strCredentials.get(2);
        JSONGenerator gen 	= JSON.createGenerator(true);

            gen.writeStartObject();
                gen.writeFieldName('auth'); 
                gen.writeStartObject();
                gen.writeStringField('type', 'basic');
                gen.writeStringField('username', UserName );
                gen.writeStringField('password', Password );
            gen.writeEndObject();
            gen.writeNumberField( 'requestId', 15 );
            gen.writeFieldName('method'); 
            gen.writeStartObject();
                gen.writeStringField( 'name', 'getProperties' );
            gen.writeFieldName( 'params' ); 
                gen.writeStartObject();
                  gen.writeStringField('showAllStatus', '1' );
              	gen.writeEndObject();
            gen.writeEndObject();
            gen.writeEndObject();
        strRequest = gen.getAsString();
    }

    public List<Property__c> parseJSONresponse( String strJSON, String AccountId, Boolean DoNotUpdatePropertyName ) {

        strJSON = strJSON.replace('"@attributes":', '"attributes":');
        Map<String, Object> jsonObjectProperties			= (Map<String, Object>) JSON.deserializeUntyped( strJSON );
        jsonObjectProperties                         	 	= ( Map<String, Object> )  jsonObjectProperties.get( 'response' );
        jsonObjectProperties                         	 	= ( Map<String, Object> )  jsonObjectProperties.get( 'result' );
        jsonObjectProperties                         	 	= ( Map<String, Object> )  jsonObjectProperties.get( 'PhysicalProperty' );
        List<Object>Properties_temp                  	 	= ( List<Object> )  jsonObjectProperties.get( 'Property' );
        List<Property__c> PropertiesObjList          	 	= new List<Property__c>();
        
        if( null != Properties_temp ) {
            List<Property__c> PropList = new List<Property__c>();
            PropList = [SELECT PSI_Prop_ID__c, Id, Name, Customer_Prop_ID__c, Active__c FROM Property__c WHERE Account__c = :AccountId ];
                      
            Set<String> CustIds = new Set<String>();
            Map<String, String> PropertyCodesandIds = new Map<String, String>();
            Map<String, String> YardiCodesandIds = new Map<String, String>();
            Map<String, String> NamesandIds = new Map<String, String>();
            Map<String, String> IdsandActiveStatuses = new Map<String, String>();
            
            for( Property__c Prop: PropList ) {
                PropertyCodesandIds.put( Prop.PSI_Prop_ID__c, Prop.Id );
                YardiCodesandIds.put( Prop.Customer_Prop_ID__c, Prop.Id );
                NamesandIds.put( Prop.Name, Prop.Id );
                IdsandActiveStatuses.put( Prop.Id, Prop.Active__c );
            }
            
            for( Object Property_temp: Properties_temp ) {
                Property__c Property 					 	= new Property__c();
                Property.Account__c                      	= AccountId;
                //Address
                Map<String, Object> Address_temp         	= ( Map<String,Object> ) Property_temp;
                Map<String, Object> Address              	= ( true == Address_temp.containsKey( 'Address' ) ? ( Map<String,Object> ) Address_temp.get('Address') : NULL );
                
                if( null != Address ) {
                    Property.Address_Line_1__c           	= ( true == Address.containsKey( 'Address' ) ? ( String ) Address.get('Address') : NULL );
                    Property.City__c                     	= ( true == Address.containsKey( 'City' ) ? ( String ) Address.get('City') : NULL );
                    Property.Country__c                  	= ( true == Address.containsKey( 'Country' ) ? ( String ) Address.get('Country') : NULL );
                    Property.Zip_Code__c                 	= ( true == Address.containsKey( 'PostalCode' ) ? ( String ) Address.get('PostalCode') : NULL );
                    Property.State__c                    	= ( true == Address.containsKey( 'State' ) ? ( String ) Address.get('State') : NULL );
                    Property.Property_Email__c           	= ( true == Address.containsKey( 'Email' ) ? ( String ) Address.get('Email') : NULL );
                }
                
                //Year Built
                Property.Year_Built__c                   	= ( true == Address_temp.containsKey( 'YearBuilt' ) ? ( String ) Address_temp.get( 'YearBuilt' ) : NULL );

                //IsFeaturedProperty
                String IsFeaturedProperty        			= ( true == Address_temp.containsKey( 'IsFeaturedProperty' ) ? ( String ) Address_temp.get( 'IsFeaturedProperty' ) : NULL );

                //LongDescription
                Property.Description__c         			= ( true == Address_temp.containsKey( 'LongDescription' ) ? ( String ) Address_temp.get( 'LongDescription' ) : NULL );

                //Phone
                Map<String, Object> Phone        			= ( true == Address_temp.containsKey( 'Phone' ) ? ( Map<String, Object> ) Address_temp.get( 'Phone' ) : NULL );
                /*Map<String, Object> PhoneType1          	= ( true == Phone.containsKey( 'attributes' ) ? ( Map<String, Object> ) Phone.get( 'attributes' ) : NULL );
                String PhoneType							= ( true == PhoneType1.containsKey( 'PhoneType' ) ? ( String ) PhoneType1.get( 'PhoneType' ) : NULL );
                String PhoneNumber            				= ( true == Phone.containsKey( 'PhoneNumber' ) ? ( String ) Phone.get( 'PhoneNumber' ) : NULL );*/

                //PropertyID
                Property.PSI_Prop_ID__c         	 		= ( true == Address_temp.containsKey( 'PropertyID' ) ? '' + Integer.valueOf( Address_temp.get( 'PropertyID' ) ) : NULL );
                
                //ShortDescription
                String ShortDescription          			= ( true == Address_temp.containsKey( 'ShortDescription' ) ? ( String ) Address_temp.get( 'ShortDescription' ) : NULL );
                
                //Property Type
                //Fetched PropertyList
                Set<String> PropertyTypes = new Set<String>();
                PropertyTypes.add( 'Single Family Dwelling' );
                PropertyTypes.add( 'Condo' );
                PropertyTypes.add( 'Townhouse' );
                PropertyTypes.add( 'Apartment' );
                Property.Type_of_Property__c     		 	= ( true == PropertyTypes.contains( ( String ) Address_temp.get( 'Type' ) ) ? ( String ) Address_temp.get( 'Type' ) : NULL );
                
                //IsFeaturedProperty
                if( true == Address_temp.containsKey( 'IsFeaturedProperty' ) ) {
                    Property.Priority_Property__c    		= ( '1' == ( String ) Address_temp.get( 'IsFeaturedProperty' ) ? true : false );
                }
                String GeneralCode 							= ( true == Address_temp.containsKey( 'General_ID' ) ? '' + Address_temp.get( 'General_ID' ) : NULL );
                //CustIds
                String Id;
                if( PropertyCodesandIds.containsKey( Property.PSI_Prop_ID__c ) ) {
                    Id = PropertyCodesandIds.get( Property.PSI_Prop_ID__c );
                } else if( null != GeneralCode && YardiCodesandIds.containsKey( GeneralCode ) ) {
                    Id = YardiCodesandIds.get( GeneralCode );
                } else if( NamesandIds.containsKey( Property.Name ) ) {
                    Id = NamesandIds.get( Property.Name );
                } 
                
                //MarketingName
                if ( Id == NULL || false == DoNotUpdatePropertyName )
                	Property.Name                    			= ( true == Address_temp.containsKey( 'MarketingName' ) ? ( String ) Address_temp.get( 'MarketingName' ) : NULL );

                if( null != Id ) {
                    if( IdsandActiveStatuses.get( Id ) == 'No' ) {
                        Property.Active__c = 'Newly Active Queue';
                    }
                    Property.Id = Id;
                } else {
                    Property.Active__c  = 'New Property Queue';
                }
                
                PropertiesObjList.add(Property);
            }
        }
        return PropertiesObjList;
    }
}