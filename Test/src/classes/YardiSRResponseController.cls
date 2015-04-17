public class YardiSRResponseController {

    // Create a class ServiceRequestForProcessing for processing
    public class ServiceRequest {
       public String srWorkOrderId;
       public String propId;
       public String srErrorMessage;
       public Boolean srIsFailed;
    }

    public ServiceRequest parseServicceRequest(XmlStreamReader reader) {
        
        ServiceRequest sr = new ServiceRequest();        
        
        boolean isSafeToGetNextXmlElement = true;
        
        sr.srIsFailed  = false;
        
        //Outer Loop : This loop will iterate whol XML which we sent from controller
        while(isSafeToGetNextXmlElement) {               
           if (reader.getEventType() == XmlTag.START_ELEMENT) {  
               if ('Error' == reader.getLocalName()) {
               		 sr.srErrorMessage = XMLElementParser(reader);
                     sr.srIsFailed  = true;
               } else if ('ServiceRequestId' == reader.getLocalName()) {
               		 sr.srWorkOrderId = XMLElementParser(reader);
               } else if ('PropertyCode' == reader.getLocalName()) {
               		sr.propId = XMLElementParser(reader);            	        
               } 
               //We can check flag condition for srIsFailed. If false then no need to collect other information.
               
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return sr;
    }
    
    public String XMLElementParser( XmlStreamReader reader) {
        String XMLElementValue;
        
		 boolean isSafeToGetNextXmlElement1 = true;
                   
        //Inner Loop : Iterate tag eventes ( Event Types :  Start , Character , End )
        while(isSafeToGetNextXmlElement1) {
            
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                XMLElementValue = reader.getText();                           	
            }
            
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement1 = false;
                break;
            }
        }         
        
        return XMLElementValue;
    }  
    
      public Set<String> getPropertyCodes( String strPropertiesXml ) {
                
        XmlStreamReader reader = new XmlStreamReader( strPropertiesXml );
        
        boolean isSafeToGetNextXmlElement = true;
        
        Set<String> PropertyCodes = new Set<String>();
        
        while( isSafeToGetNextXmlElement ) {               
           if ( reader.getEventType() == XmlTag.START_ELEMENT ) {  
               if ( 'Code' == reader.getLocalName() ) {
       				
                   	XmlStreamReader reader1;
                   	boolean isSafeToGetNextXmlElement1 = true;
                    reader1 = reader;
                   
                   	//Inner Loop : Iterate tag eventes ( Event Types :  Start , Character , End )
                   	while(isSafeToGetNextXmlElement1) {
                        
                    	if (reader1.getEventType() == XmlTag.END_ELEMENT) {
                            break;
                        } else if (reader1.getEventType() == XmlTag.CHARACTERS) {
                            PropertyCodes.add( String.valueOf( reader1.getText() ) );                           	
                        }
                        
                        // Always use hasNext() before calling next() to confirm 
                        // that we have not reached the end of the stream
                        if (reader1.hasNext()) {
                            reader1.next();
                        } else {
                            isSafeToGetNextXmlElement1 = false;
                            break;
                        }
                    }
               	}
            }
            
            if ( reader.hasNext() ) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        
        return PropertyCodes;
    }     
}