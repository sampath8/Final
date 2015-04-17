public with sharing class HBHPullPropertiesController {
 	public String responseJsonString;
    public Set<String> PropertyCodes = new Set<String>();
    public List<Property__c> arrobjProperties = new List<Property__c>();
    public Map<String, Unit__c> arrobjUnits = new Map<String, Unit__c>();
    public void HBHPullProperties() {
        List<AggregateResult> ActiveAccountList = [SELECT
                                                   		Account__c
                                                   	FROM
                                                   		Integration__c
                                                   	WHERE
                                                       	HBH_Integration_Active__c = true AND Get_HBH_Properties__c != NULL
                                                   	GROUP BY
                                                   		Account__c]; 
         
        if( !ActiveAccountList.isEmpty() ) {
            try {
                for( AggregateResult ActiveAccount: ActiveAccountList ) {
                    Integration__c I = [ SELECT 
                                        	Id, Name, HBH_API_URL__c, Account__c, Do_not_update_property_name__c
                                        FROM
                                        	Integration__c
                                        WHERE
                                        	HBH_Integration_Active__c = true AND Get_HBH_Properties__c != NULL AND Account__c =: String.valueOf(ActiveAccount.get('Account__c'))
                                        LIMIT 1
                                       ];
                    if( null != I ) {
                        this.HBHGetProperties( I.HBH_API_URL__c );
                        if( !PropertyCodes.isEmpty() ) {
                            
                            List<Property__c> Properties = new List<Property__c>();
                            Properties = [ SELECT Id, Name, Active__c, HBH_Prop_Id__c, Account__c, ( SELECT Id, Name FROM Units__r WHERE Unit_ID__c != NULL LIMIT 1 ) FROM Property__c WHERE HBH_Prop_Id__c != NULL AND Account__c =: I.Account__c];
                        
                        	Map<String, String> PropertyCodesIds = new Map<String, String>();
                            Map<String, String> PropertyCodesActive = new Map<String, String>();
                            Map<String, Property__c> PropertyCodesObjects = new Map<String, Property__c>();
                            
                            for( Property__c Property: Properties ) {
                                PropertyCodesIds.put( Property.HBH_Prop_Id__c, Property.Id );
                                PropertyCodesObjects.put( Property.HBH_Prop_Id__c, Property );
                                PropertyCodesActive.put( Property.HBH_Prop_Id__c, Property.Active__c );
                            }
                            List<Object> JSONdeserializedResponse = (List<Object>) JSON.deserializeUntyped( responseJsonString );
                            Set<String> ProcessedPropertyCodes = new Set<String>();
                            for( Object JSONPropertyObject : JSONdeserializedResponse ) {
                                String PropertyCode;
                                try {
                                    Map<String, object> JSONPropertyObjectElements = ( Map<String, Object> ) JSONPropertyObject;
                                    if( JSONPropertyObjectElements.containsKey('property_id') ) {
                                        Property__c p = new Property__c();
                                        Unit__c Unit = new Unit__c();
                                        PropertyCode = (String)JSONPropertyObjectElements.get('property_id'); 
                                        ProcessedPropertyCodes.add(PropertyCode);
                                        
                                        if( PropertyCodesIds.containsKey( PropertyCode ) ) {
                                            p.Id 					= PropertyCodesIds.get( PropertyCode );
                                            p.Account__c     		= I.Account__c;
                                            p.HBH_Prop_Id__c 		= PropertyCode;
                                            if( PropertyCodesActive.get( PropertyCode ) == 'No' ) 
                                                p.Active__c 		= 'Newly Active Queue';
                                        } else {
                                            p.HBH_Prop_Id__c 		= PropertyCode;
                                            p.Active__c 			= 'New Property Queue';     
                                            p.Price__c 				= 1;
                                            p.Account__c     		= I.Account__c;
                                            p.Square_Footage__c 	= 1;
                                            p.Bed_Count__c 			= 1;
                                            p.Bath_Count__c 		= 1;
                                            p.Lease_Terms__c 		= 1;
                                        }
                                        
                                        if( PropertyCodesObjects.containsKey(PropertyCode) ) {
                                            if( !PropertyCodesObjects.get(PropertyCode).Units__r.isEmpty() ) {
                                                for( Unit__c u :PropertyCodesObjects.get(PropertyCode).Units__r ) {
                                                	Unit.Id = u.Id;
                                                }	
                                            }
                                        }
                                        Unit.Account__c = p.Account__c;
                                        
                                        if( ( !PropertyCodesIds.containsKey(PropertyCode) || false == I.Do_not_update_property_name__c ) && JSONPropertyObjectElements.containsKey('property_title') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('property_title') ) )
                                            p.Name = (String) JSONPropertyObjectElements.get('property_title');
                                        
                                        if( JSONPropertyObjectElements.containsKey('property_type') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('property_type') ) ) {
                                           	if( 'Single Family Home' == JSONPropertyObjectElements.get('property_type') ) {
                                                p.Type_of_Property__c = 'Single Family Dwelling';
												p.Multi_Family_Property__c = false;
                                            }
                                        } 
                                        
                                        if( JSONPropertyObjectElements.containsKey('address_1') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('address_1') ) )
                                            p.Address_Line_1__c = (String) JSONPropertyObjectElements.get('address_1');
                                        
                                        if( JSONPropertyObjectElements.containsKey('city') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('city') ) )
                                            p.City__c = (String) JSONPropertyObjectElements.get('city');
                                        
                                        if( JSONPropertyObjectElements.containsKey('state') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('state') ) )
                                            p.State__c = (String) JSONPropertyObjectElements.get('state');
                                        
                                        if( JSONPropertyObjectElements.containsKey('postal_code') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('postal_code') ) )
                                            p.Zip_Code__c = (String) JSONPropertyObjectElements.get('postal_code');
                                        
                                        if( JSONPropertyObjectElements.containsKey('description') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('description') ) )
                                            p.Description__c = (String) JSONPropertyObjectElements.get('description');
                                        
                                        if( JSONPropertyObjectElements.containsKey('approximate_square_feet') &&  null != JSONPropertyObjectElements.get('approximate_square_feet') ) {
                                            p.Square_Footage__c = (Decimal) JSONPropertyObjectElements.get('approximate_square_feet');
                                            Unit.Square_Feet__c = String.valueOf( JSONPropertyObjectElements.get('approximate_square_feet') );
                                        }
                                            
                                        if( JSONPropertyObjectElements.containsKey('bedroom_number') &&  null != JSONPropertyObjectElements.get('bedroom_number') ) {
                                            p.Bed_Count__c = (Decimal) JSONPropertyObjectElements.get('bedroom_number');
                                            Unit.Bedrooms__c  = (Decimal) JSONPropertyObjectElements.get('bedroom_number');
                                        }
                                        
                                        if( JSONPropertyObjectElements.containsKey('bathroom_number') &&  null != JSONPropertyObjectElements.get('bathroom_number') ) {
                                            p.Bath_Count__c = (Decimal) JSONPropertyObjectElements.get('bathroom_number');
                                            Unit.Bathrooms__c = (Decimal) JSONPropertyObjectElements.get('bathroom_number');
                                        }
                                            
                                        
                                        if( JSONPropertyObjectElements.containsKey('neighborhood') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('neighborhood') ) )
                                            p.Neighborhood__c = (String) JSONPropertyObjectElements.get('neighborhood');
                                            
										//'schools' on Junction Object will work later on.
										 
                                        if( JSONPropertyObjectElements.containsKey('amenities_list') ) {
                                            List<Object> JSONAmenitiesElements = ( List<Object> ) JSONPropertyObjectElements.get('amenities_list');
                                            if( !JSONAmenitiesElements.isEmpty() ) {
                                                String ListOfAmenities;
                                                for( Object Amenity: JSONAmenitiesElements ) {
                                                    ListOfAmenities = ( null == ListOfAmenities ) ? (String) Amenity : ListOfAmenities  + ', '+ (String) Amenity;
                                                }
                                                if( 255 <= ListOfAmenities.length()){
                                                	System.debug( ListOfAmenities.length() );
                                                    ListOfAmenities = ListOfAmenities.substring(0,254);
                                                } 
                                                p.Community_Amenity_Additional_Info__c = ListOfAmenities;
                                            }
                                        }
                                        
                                        if( JSONPropertyObjectElements.containsKey('top_features_list') ) {
                                            List<Object> JSONTopFeaturesElements = ( List<Object> ) JSONPropertyObjectElements.get('top_features_list');
                                            if( !JSONTopFeaturesElements.isEmpty() ) {
                                                String ListOfTopFeatures;
                                                Integer count = 1;
                                                
                                                for( Object TopFeature: JSONTopFeaturesElements ) {
                                                    if( 1 == count )
                                                        p.property_selling_feature_1__c = (String) TopFeature;
                                                    
                                                    if( 2 == count )
                                                        p.property_selling_feature_2__c = (String) TopFeature;
                                                    
                                                    if( 3 == count )
                                                        p.property_selling_feature_3__c = (String) TopFeature;
                                                    
                                                    if( 4 == count )
                                                        p.property_selling_feature_4__c = (String) TopFeature;
                                                    
                                                    if( 5 == count )
                                                        p.property_selling_feature_5__c = (String) TopFeature;
                                                    
                                                    count++;
                                                }
                                            }
                                        }
                                        
                                        if( JSONPropertyObjectElements.containsKey('owned_property_id') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('owned_property_id') ) ) {
                                            p.Customer_Prop_ID__c 	= (String)JSONPropertyObjectElements.get('owned_property_id');
                                            Unit.Name 			  	= (String)JSONPropertyObjectElements.get('owned_property_id');
                                            Unit.Unit_ID__c			= (String)JSONPropertyObjectElements.get('owned_property_id');
                                        }
                                            
                                        if( JSONPropertyObjectElements.containsKey('property_manager_email') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('property_manager_email') ) )
                                            p.Property_Email__c = (String)JSONPropertyObjectElements.get('property_manager_email');
                                        
                                        if( JSONPropertyObjectElements.containsKey('rent_per_month') &&  null != JSONPropertyObjectElements.get('rent_per_month') )
                                        	Unit.Effective_Rent__c = (Decimal)JSONPropertyObjectElements.get('rent_per_month');
                                        
                                        if( JSONPropertyObjectElements.containsKey('property_status') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('property_status') ) ) {
                                            Unit.Active__c = ( ( new Set<String>{'Available', 'Lease Pending'} ).contains( (String) JSONPropertyObjectElements.get('property_status') ) ) ? true : false;
                                        	if( !( new Set<String>{'Available', 'Lease Pending'} ).contains( (String) JSONPropertyObjectElements.get('property_status') ) )
                                            	p.Active__c = 'No';
                                        
                                        }    
                                        
                                        if( JSONPropertyObjectElements.containsKey('available_date') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('available_date') ) ) {
                                            Unit.Available_On__c = DateTime.valueOf(String.valueOf( JSONPropertyObjectElements.get('available_date') ).replaceAll( 'T', ' ' )).date();
                                        }
                                         
                                        if( JSONPropertyObjectElements.containsKey('make_ready_date') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('make_ready_date') ) ) {
                                            Unit.Made_Ready_Date__c = DateTime.valueOf(String.valueOf( JSONPropertyObjectElements.get('make_ready_date') ).replaceAll( 'T', ' ' )).date();
                                        }
                                        
                                        if( JSONPropertyObjectElements.containsKey('pets_allowed') &&  null != JSONPropertyObjectElements.get('pets_allowed') ) {
                                            p.Pet_Policy__c = ( true == Boolean.valueOf( JSONPropertyObjectElements.get('pets_allowed') ) ) ? 'Yes' : 'No';
                                            Unit.Pets_Allowed__c = ( true == Boolean.valueOf( JSONPropertyObjectElements.get('pets_allowed') ) ) ? 'Yes' : 'No';
                                        }
                                            
                                        if( JSONPropertyObjectElements.containsKey('pet_deposit') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('pet_deposit') ) )
                                            p.Pet_Deposit__c =  (String) JSONPropertyObjectElements.get('pet_deposit');
                                        
                                        if( JSONPropertyObjectElements.containsKey('breed_restrictions') &&  !String.isEmpty( (String) JSONPropertyObjectElements.get('breed_restrictions') ) )
                                            p.Breed_Restrictions__c = (String)JSONPropertyObjectElements.get('breed_restrictions');
                                        
                                        if( JSONPropertyObjectElements.containsKey('minimim_lease_terms_mo') &&  null != JSONPropertyObjectElements.get('minimim_lease_terms_mo') )
                                            p.Lease_Terms__c = (Decimal)JSONPropertyObjectElements.get('minimim_lease_terms_mo');
                                        
                                        arrobjUnits.put( PropertyCode, Unit );
                                        arrobjProperties.add(p);
                                    }
                                } catch( Exception e ) {
                                    System.debug( PropertyCode );
                                    System.debug( e.getMessage() );
                					System.debug( e.getStackTraceString() );
                                } 
                            }
                            
                            for( String PropertyCode: PropertyCodesObjects.keySet() ) {
                                if( !ProcessedPropertyCodes.contains( PropertyCode ) && !PropertyCodesObjects.get(PropertyCode).Units__r.isEmpty() ) {
                                    for( Unit__c Unit :PropertyCodesObjects.get(PropertyCode).Units__r ) {
                                        Unit.Active__c = false;
                                        arrobjUnits.put( PropertyCode, Unit );
                                    }	
                                    PropertyCodesObjects.get(PropertyCode).Active__c = 'No';
                                    arrobjProperties.add( PropertyCodesObjects.get(PropertyCode) );
                                }
                            }
                        }
                    }
                }
            } catch ( Exception e ) {
                System.debug( e.getMessage() );
                System.debug( e.getStackTraceString() );
            }
        }
    }
    
    public void HBHGetProperties( String HBHURL ) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint( HBHURL + '/PropertySearch' );
        request.setMethod( 'GET' );
        request.setCompressed(true);
        request.setTimeout( 120000 );
        
        if( !Test.isRunningTest() ) {
            Http http                     = new Http();
            HTTPResponse response         = http.send( request );
            responseJsonString            =  response.getBody();
        }
        
        PropertyCodes.clear();
        
        if( !String.isEmpty(responseJsonString) ) {
            List<Object> JSONdeserializedResponse = (List<Object>) JSON.deserializeUntyped( responseJsonString );
            if( !JSONdeserializedResponse.isEmpty() ) {
                for( Object JSONPropertyObject : JSONdeserializedResponse ) {
                    Map<String, object> JSONPropertyObjectElements = ( Map<String, Object> ) JSONPropertyObject;
                    if( JSONPropertyObjectElements.containsKey('property_id') ) {
                        PropertyCodes.add( String.valueOf( JSONPropertyObjectElements.get('property_id') ) );
                    }
                }  
            }
        }
    }
}