@isTest
public class TestRMPullPropertiesController {

    static testMethod void testRMPullPropertiesController() {
        
        Account a = new Account();
        a.Name	= 'Test';
        insert a;

        Integration__c i 					= new Integration__c();	
        i.Account__c 						= a.Id;
        i.ResMan_API_URL__c 				= 'https://api.myresman.com/';
        i.ResMan_API_Key__c 					= 'a262bb82902b4e3491807044e0c6986e';
        i.ResMan_Integration_Partner_ID__c 	= '1076';
        i.ResMan_Account_Id__c				= '400';
        i.Get_ResMan_Properties__c			= 'Daily';
        i.ResMan_Integration_Active__c 		= true;
        insert i;

        Property__c p 			= new Property__c();
        p.Account__c 			= a.Id;
        insert p;

        Test.startTest();
        
        RMPullPropertiesController rm = new RMPullPropertiesController();
        rm.strGetProperties = '{ "Properties": [ { "PropertyID": "B342E58C-F5BA-4C63-B050-CF44439BB37D", "Name": "Property One", "StreetAddress": "123 Main St", "City": "Denver", "State": "CO", "Zip": "80202", "Phone": "(123) 456-7890", "Email": "donotreply@prop1.com", "Manager": "John Manager" } ], "MethodName": "GetProperties", "Status": "Success", "AccountID": 400 }';
        rm.strMarketing4_0 = '<ResMan><MethodName>GetMarketing4_0</MethodName><Status>Success</Status><AccountID>400</AccountID><PropertyID>b342e58c-f5ba-4c63-b050-cf44439bb37d</PropertyID><Response><?xml version="1.0" encoding="utf-16"?> <PhysicalProperty xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <Property> <Identification IDValue="b342e58c-f5ba-4c63-b050-cf44439bb37d" OrganizationName="ResMan" IDType="PropertyID" /> <Identification IDValue="400" OrganizationName="ResMan" IDType="AccountID" /> <PropertyID> <Identification IDValue="b342e58c-f5ba-4c63-b050-cf44439bb37d" OrganizationName="ResMan" IDType="PropertyID" /> <MarketingName>Frontline Fairways</MarketingName> <Address AddressType="Property"> <City>Broomfield</City> <State>CO</State> <PostalCode> </PostalCode> <Country>United States</Country> </Address> <Phone PhoneType="personal"> <PhoneNumber> </PhoneNumber> </Phone> <Phone PhoneType="fax"> <PhoneNumber> </PhoneNumber> </Phone> <Email>Info@falsewebsite.com</Email> </PropertyID> <ILS_Identification ILS_IdentificationType="Unspecified" RentalType="Unspecified"> <Latitude>29.42729</Latitude> <Longitude>-98.652874</Longitude> </ILS_Identification> <Information> <StructureType>Unspecified</StructureType> <BuildingCount>18</BuildingCount> <UnitCount>293</UnitCount> <OfficeHour> <OpenTime>8:00 AM</OpenTime> <CloseTime>10:00 AM</CloseTime> <Day>Sunday</Day> </OfficeHour> <OfficeHour> <OpenTime>2:00 PM</OpenTime> <CloseTime>4:00 PM</CloseTime> <Day>Sunday</Day> </OfficeHour> <OfficeHour> <OpenTime>8:00 AM</OpenTime> <CloseTime>6:00 PM</CloseTime> <Day>Monday</Day> </OfficeHour> <OfficeHour> <OpenTime>8:00 AM</OpenTime> <CloseTime>6:00 PM</CloseTime> <Day>Tuesday</Day> </OfficeHour> <OfficeHour> <OpenTime>8:00 AM</OpenTime> <CloseTime>6:00 PM</CloseTime> <Day>Wednesday</Day> </OfficeHour> <OfficeHour> <OpenTime>8:00 AM</OpenTime> <CloseTime>6:00 PM</CloseTime> <Day>Thursday</Day> </OfficeHour> <OfficeHour> <OpenTime>8:00 AM</OpenTime> <CloseTime>6:00 PM</CloseTime> <Day>Friday</Day> </OfficeHour> <OfficeHour> <OpenTime>10:00 AM</OpenTime> <CloseTime>4:00 PM</CloseTime> <Day>Saturday</Day> </OfficeHour> <ShortDescription>Live A Luxurious Life Style At ABC Property</ShortDescription> <LongDescription>ABC Property is a beautiful, pet friendly community.Convenient and easy access to major highways. The community features a resort style pool, access gates, car care station, pet walk courtyards,health and sports complex. ABC Property features 1, 2, and 3 bedroom apartments for rent with washer/dryer provided, tanning facility, stainless steal appliances, business center, High Speed Internet and more.</LongDescription> <LeaseLength>12 month leases</LeaseLength> <Parking ParkingType="Covered Lot"> <Assigned>false</Assigned> <AssignedFee>Paid</AssignedFee> <SpaceFee>35.00</SpaceFee> <Spaces>5</Spaces> <Comment>Only 5 Covered Parking Spaces Left Don\'t Chance It Texas Weather!</Comment> </Parking> <DrivingDirections>Driving directions to the property</DrivingDirections> <Services Nearest="true"> <Name>Elementary School</Name> <Detail>Barton Elementary </Detail> <DistanceTo>less than a mile away</DistanceTo> <Comment>Close to home</Comment> </Services> <Services Nearest="true"> <Name>Highway</Name> <Detail>Close To All Major Highways</Detail> <DistanceTo>Highway 121 1 street light from the property and 8 minutes from Highway 75 !</DistanceTo> </Services> <Services Nearest="false"> <Name>Other</Name> <Detail>Tanning Facility</Detail> <DistanceTo>Property Clubhouse</DistanceTo> <Comment>Ask an associate about all of the amenities available!</Comment> </Services> <PropertyAvailabilityURL>https://demo.myresman.com/Portal/Applicants/Availability?a=400&amp;p=b342e58c-f5ba-4c63-b050-cf44439bb37d</PropertyAvailabilityURL> </Information> <Fee> <ProrateType>Standard</ProrateType> <LateType>Flat</LateType> <LatePercent>0</LatePercent> <LateMinFee>10.0000</LateMinFee> <LateFeePerDay>50.0000</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> <AdminFee>149.0000</AdminFee> <ApplicationFee>0</ApplicationFee> <BrokerFee>0</BrokerFee> </Fee> <Amenity AmenityType="Availability24Hours"> <Description>Secure entry</Description> </Amenity> <Building> <Identification IDValue="15" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>15</Name> <Description /> <UnitCount>24</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="11" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>11</Name> <Description /> <UnitCount>12</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="8" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>8</Name> <Description /> <UnitCount>8</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="Ramiro\'s Place" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>Ramiro\'s Place</Name> <Description /> <UnitCount>1</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="17" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>17</Name> <Description /> <UnitCount>24</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="1" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>1</Name> <Description /> <UnitCount>39</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="7" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>7</Name> <Description /> <UnitCount>24</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="16" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>16</Name> <Description /> <UnitCount>24</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="5" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>5</Name> <Description /> <UnitCount>12</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="10" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>10</Name> <Description /> <UnitCount>8</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="9" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>9</Name> <Description /> <UnitCount>13</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="14" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>14</Name> <Description /> <UnitCount>12</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="2" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>2</Name> <Description /> <UnitCount>17</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="12" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>12</Name> <Description /> <UnitCount>23</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="13" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>13</Name> <Description /> <UnitCount>12</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="4" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>4</Name> <Description /> <UnitCount>8</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="3" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>3</Name> <Description /> <UnitCount>24</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="6" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>6</Name> <Description /> <UnitCount>8</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Floorplan> <Identification IDValue="B2" OrganizationName="ResMan" IDType="Name" /> <Name>Two Bedroom, Two Bath</Name> <Comment>The Savannah is our two bedroom, two bathroom apartment home. The Savannah has a spacious living room area with an island kitchen &amp; breakfast bar counter top to entertain guests when you\'re playing host/hostess. Your lovely kitchen has a pantry closet to stock up on all your favorite groceries and a tremendous amount of counter space to utilize when working on a gourmet meal. The Savannah also has a separate dining area with an window view to enjoy the outdoor scenery. This home has a built-in desk &amp; bookshelf for you to set up your office-at-home. The guest bedroom is spaciously designed and accustomed with a walk-in closet. The Savannah also has gorgeous open guest bathroom with a linen closet for your convenience. The master bedroom is tremendously large and conveniently has the master bathroom located in the bedroom, which includes a full-size linen closet and walk-in closet as well.</Comment> <UnitCount>25</UnitCount> <UnitsAvailable>0</UnitsAvailable> <Room RoomType="Bedroom"> <Count>2</Count> <Comment /> </Room> <Room RoomType="Bathroom"> <Count>2.0</Count> <Comment /> </Room> <SquareFeet Avg="954" Min="954" Max="954" /> <MarketRent Min="975" Max="1000" /> <EffectiveRent Avg="978" Min="975" Max="1000" /> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <ValueRange Exact="200.00" /> </Amount> <Description>Escrow Deposit Paid In</Description> <PercentRefundable>100</PercentRefundable> <PortionRefundable>100</PortionRefundable> </Deposit> </Floorplan> <Floorplan> <Identification IDValue="A1" OrganizationName="ResMan" IDType="Name" /> <Name>One Bedroom, One Bath</Name> <Comment>The Krista is our one bedroom, one bathroom apartment home of 587 sq ft. This gorgeous floor plan has an open concept in the living room &amp; kitchen area. There is a tremendous amount of cabinetry and counter space for you to enjoy within your kitchen. The Krista has additional storage space in the coat closet by the entrance. In your living room, you have a large window view that allows you to enjoy the outdoor scenery. The Krista also has a large walk-in closet and a beautiful vanity area in your bathroom that is located in the bedroom. </Comment> <UnitCount>79</UnitCount> <UnitsAvailable>3</UnitsAvailable> <Room RoomType="Bedroom"> <Count>1</Count> <Comment /> </Room> <Room RoomType="Bathroom"> <Count>1.0</Count> <Comment /> </Room> <SquareFeet Avg="587" Min="587" Max="587" /> <MarketRent Min="7" Max="732" /> <EffectiveRent Avg="673" Min="-23" Max="732" /> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <ValueRange Exact="100.00" /> </Amount> <Description>Escrow Deposit Paid In</Description> <PercentRefundable>100</PercentRefundable> <PortionRefundable>100</PortionRefundable> </Deposit> <File FileID="" Active="true"> <FileType>Floorplan</FileType> <Name>floorplan-krista.jpg</Name> <Format /> <Src>https://resman.blob.core.windows.net/demo-public/d6855366-63ff-4ccd-ab36-e6f15c916226.jpg</Src> <Rank /> </File> <File FileID="26978c6f-3ece-4310-a953-f184a24fdf23" Active="true"> <FileType>Photo</FileType> <Name>Inside.jpg</Name> <Format>.jpg</Format> <Src>https://resman.blob.core.windows.net/demo-public/105f5355-93fd-4a65-8f25-fa630caa7dfb.jpg</Src> <Rank>2</Rank> </File> </Floorplan> <ILS_Unit> <Identification IDValue="17308" OrganizationName="ResMan" IDType="Number" /> <Units> <Unit> <Identification IDValue="17308" OrganizationName="ResMan" IDType="Number" /> <MarketingName>17308</MarketingName> <UnitType>A1</UnitType> <UnitBedrooms>1</UnitBedrooms> <UnitBathrooms>1</UnitBathrooms> <MinSquareFeet>587</MinSquareFeet> <MaxSquareFeet>587</MaxSquareFeet> <MarketRent>695</MarketRent> <UnitEconomicStatus>residential</UnitEconomicStatus> <UnitOccupancyStatus>occupied</UnitOccupancyStatus> <UnitLeasedStatus>leased</UnitLeasedStatus> <FloorplanName>One Bedroom, One Bath</FloorplanName> <BuildingName>17</BuildingName> <Address AddressType="property"> <AddressLine1>1538 Cable Ranch Rd.</AddressLine1> <AddressLine2>17308</AddressLine2> <City>San Antonio</City> <State>TX</State> <PostalCode>78245</PostalCode> </Address> </Unit> </Units> <Pricing> <MITS-OfferTerm> <EffectiveRent>695.00</EffectiveRent> <Term>12</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>690.00</EffectiveRent> <Term>14</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>685.00</EffectiveRent> <Term>16</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>675.00</EffectiveRent> <Term>18</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>670.00</EffectiveRent> <Term>20</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>668.00</EffectiveRent> <Term>22</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>665.00</EffectiveRent> <Term>24</Term> </MITS-OfferTerm> </Pricing> <EffectiveRent Avg="678" Min="665" Max="695" /> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <ValueRange Exact="100.00" /> </Amount> <Description>Escrow Deposit Paid In</Description> <PercentRefundable>100</PercentRefundable> <PortionRefundable>100</PortionRefundable> </Deposit> <FloorLevel>3</FloorLevel> <Availability> <VacateDate Month="2" Day="12" Year="2015" /> <VacancyClass>Occupied</VacancyClass> <MadeReadyDate Month="2" Day="20" Year="2015" /> </Availability> </ILS_Unit> <ILS_Unit> <Identification IDValue="10-201" OrganizationName="ResMan" IDType="Number" /> <Units> <Unit> <Identification IDValue="10-201" OrganizationName="ResMan" IDType="Number" /> <MarketingName>10-201</MarketingName> <UnitType>B1</UnitType> <UnitBedrooms>1</UnitBedrooms> <UnitBathrooms>2</UnitBathrooms> <MinSquareFeet>881</MinSquareFeet> <MaxSquareFeet>881</MaxSquareFeet> <MarketRent>905</MarketRent> <UnitEconomicStatus>residential</UnitEconomicStatus> <UnitOccupancyStatus>occupied</UnitOccupancyStatus> <UnitLeasedStatus>leased</UnitLeasedStatus> <FloorplanName>Two Bedroom, One Bath</FloorplanName> <BuildingName>1</BuildingName> <Address AddressType="property"> <AddressLine1>2636 Grand Ave 201</AddressLine1> <City>San Diego</City> <State>CA</State> <PostalCode>92109</PostalCode> <Country /> </Address> </Unit> </Units> <Pricing> <MITS-OfferTerm> <EffectiveRent>905.00</EffectiveRent> <Term>12</Term> </MITS-OfferTerm> </Pricing> <EffectiveRent Avg="905" Min="905" Max="905" /> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <ValueRange Exact="200.00" /> </Amount> <Description>Escrow Deposit Paid In</Description> <PercentRefundable>100</PercentRefundable> <PortionRefundable>100</PortionRefundable> </Deposit> <FloorLevel>1</FloorLevel> <Availability> <VacateDate Month="2" Day="12" Year="2015" /> <VacancyClass>Occupied</VacancyClass> <MadeReadyDate Month="2" Day="20" Year="2015" /> </Availability> </ILS_Unit> <Utility> <AirCon>false</AirCon> <BroadbandInternet>true</BroadbandInternet> <Cable>false</Cable> <Electric>false</Electric> <Gas>false</Gas> <Heat>false</Heat> <HotWater>false</HotWater> <Satellite>false</Satellite> <Sewer>false</Sewer> <Telephone>false</Telephone> <Trash>false</Trash> <Water>false</Water> <UtilityPortionIncluded>0.00</UtilityPortionIncluded> </Utility> <File FileID="71fe9d37-17f3-49ef-9df1-1d4b19ee65ad" Active="true"> <FileType>Photo</FileType> <Name>IMG_1090.jpg</Name> <Format>.jpg</Format> <Src>https://resman.blob.core.windows.net/demo-public/f112e064-c35e-4495-a327-34a4cee895d3.jpg</Src> <Rank>12</Rank> </File> <File FileID="5e3c45b9-d6a7-4e80-a11c-311f194c937a" Active="true"> <FileType>Photo</FileType> <Name>12 Ext-3.jpg</Name> <Format>.jpg</Format> <Src>https://resman.blob.core.windows.net/demo-public/f3ba2d00-440a-4624-9ba7-1ebdf188d4f1.jpg</Src> <Rank>12</Rank> </File> </Property> </PhysicalProperty></Response></ResMan>';
 		rm.RMGetProperties( i.ResMan_API_URL__c , i.ResMan_Account_Id__c );
        rm.RMGetMarketing4_0( i.ResMan_API_URL__c, i.ResMan_Account_Id__c, 'B342E58C-F5BA-4C63-B050-CF44439BB37D');
       	
      	rm.strMarketing4_0 = '<ResMan><MethodName>GetMarketing4_0</MethodName><Status>Success</Status><AccountID>400</AccountID><PropertyID>b342e58c-f5ba-4c63-b050-cf44439bb37d</PropertyID><Response><?xml version="1.0" encoding="utf-16"?> <PhysicalProperty xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> <Property> <Identification IDValue="b342e58c-f5ba-4c63-b050-cf44439bb37d" OrganizationName="ResMan" IDType="PropertyID" /> <Identification IDValue="400" OrganizationName="ResMan" IDType="AccountID" /> <PropertyID> <Identification IDValue="b342e58c-f5ba-4c63-b050-cf44439bb37d" OrganizationName="ResMan" IDType="PropertyID" /> <MarketingName>Frontline Fairways</MarketingName> <Address AddressType="Property"> <City>Broomfield</City> <State>CO</State> <PostalCode> </PostalCode> <Country>United States</Country> </Address> <Phone PhoneType="personal"> <PhoneNumber> </PhoneNumber> </Phone> <Phone PhoneType="fax"> <PhoneNumber> </PhoneNumber> </Phone> <Email>Info@falsewebsite.com</Email> </PropertyID> <ILS_Identification ILS_IdentificationType="Unspecified" RentalType="Unspecified"> <Latitude>29.42729</Latitude> <Longitude>-98.652874</Longitude> </ILS_Identification> <Information> <StructureType>Unspecified</StructureType> <BuildingCount>18</BuildingCount> <UnitCount>293</UnitCount> <OfficeHour> <OpenTime>8:00 AM</OpenTime> <CloseTime>10:00 AM</CloseTime> <Day>Sunday</Day> </OfficeHour> <OfficeHour> <OpenTime>2:00 PM</OpenTime> <CloseTime>4:00 PM</CloseTime> <Day>Sunday</Day> </OfficeHour> <OfficeHour> <OpenTime>8:00 AM</OpenTime> <CloseTime>6:00 PM</CloseTime> <Day>Monday</Day> </OfficeHour> <OfficeHour> <OpenTime>8:00 AM</OpenTime> <CloseTime>6:00 PM</CloseTime> <Day>Tuesday</Day> </OfficeHour> <OfficeHour> <OpenTime>8:00 AM</OpenTime> <CloseTime>6:00 PM</CloseTime> <Day>Wednesday</Day> </OfficeHour> <OfficeHour> <OpenTime>8:00 AM</OpenTime> <CloseTime>6:00 PM</CloseTime> <Day>Thursday</Day> </OfficeHour> <OfficeHour> <OpenTime>8:00 AM</OpenTime> <CloseTime>6:00 PM</CloseTime> <Day>Friday</Day> </OfficeHour> <OfficeHour> <OpenTime>10:00 AM</OpenTime> <CloseTime>4:00 PM</CloseTime> <Day>Saturday</Day> </OfficeHour> <ShortDescription>Live A Luxurious Life Style At ABC Property</ShortDescription> <LongDescription>ABC Property is a beautiful, pet friendly community.Convenient and easy access to major highways. The community features a resort style pool, access gates, car care station, pet walk courtyards,health and sports complex. ABC Property features 1, 2, and 3 bedroom apartments for rent with washer/dryer provided, tanning facility, stainless steal appliances, business center, High Speed Internet and more.</LongDescription> <LeaseLength>12 month leases</LeaseLength> <Parking ParkingType="Covered Lot"> <Assigned>false</Assigned> <AssignedFee>Paid</AssignedFee> <SpaceFee>35.00</SpaceFee> <Spaces>5</Spaces> <Comment>Only 5 Covered Parking Spaces Left Don\'t Chance It Texas Weather!</Comment> </Parking> <DrivingDirections>Driving directions to the property</DrivingDirections> <Services Nearest="true"> <Name>Elementary School</Name> <Detail>Barton Elementary </Detail> <DistanceTo>less than a mile away</DistanceTo> <Comment>Close to home</Comment> </Services> <Services Nearest="true"> <Name>Highway</Name> <Detail>Close To All Major Highways</Detail> <DistanceTo>Highway 121 1 street light from the property and 8 minutes from Highway 75 !</DistanceTo> </Services> <Services Nearest="false"> <Name>Other</Name> <Detail>Tanning Facility</Detail> <DistanceTo>Property Clubhouse</DistanceTo> <Comment>Ask an associate about all of the amenities available!</Comment> </Services> <PropertyAvailabilityURL>https://demo.myresman.com/Portal/Applicants/Availability?a=400&amp;p=b342e58c-f5ba-4c63-b050-cf44439bb37d</PropertyAvailabilityURL> </Information> <Fee> <ProrateType>Standard</ProrateType> <LateType>Flat</LateType> <LatePercent>0</LatePercent> <LateMinFee>10.0000</LateMinFee> <LateFeePerDay>50.0000</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> <AdminFee>149.0000</AdminFee> <ApplicationFee>0</ApplicationFee> <BrokerFee>0</BrokerFee> </Fee> <Amenity AmenityType="Availability24Hours"> <Description>Secure entry</Description> </Amenity> <Amenity AmenityType="CarWashArea"> <Description>Free Car Wash</Description> </Amenity> <Amenity AmenityType="Pool"> <Description>Community Pool</Description> </Amenity> <Amenity AmenityType="BusinessCenter"> <Description>24 Hour Business Center</Description> </Amenity> <Amenity AmenityType="VolleyballCourt"> <Description>Volleyball Court</Description> </Amenity> <Building> <Identification IDValue="15" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>15</Name> <Description /> <UnitCount>24</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="11" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>11</Name> <Description /> <UnitCount>12</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="8" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>8</Name> <Description /> <UnitCount>8</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="Ramiro\'s Place" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>Ramiro\'s Place</Name> <Description /> <UnitCount>1</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="17" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>17</Name> <Description /> <UnitCount>24</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="1" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>1</Name> <Description /> <UnitCount>39</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="7" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>7</Name> <Description /> <UnitCount>24</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="16" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>16</Name> <Description /> <UnitCount>24</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="5" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>5</Name> <Description /> <UnitCount>12</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="10" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>10</Name> <Description /> <UnitCount>8</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="9" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>9</Name> <Description /> <UnitCount>13</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="14" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>14</Name> <Description /> <UnitCount>12</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="2" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>2</Name> <Description /> <UnitCount>17</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="12" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>12</Name> <Description /> <UnitCount>23</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="13" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>13</Name> <Description /> <UnitCount>12</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="4" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>4</Name> <Description /> <UnitCount>8</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="3" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>3</Name> <Description /> <UnitCount>24</UnitCount> <SquareFeet>0</SquareFeet> </Building> <Building> <Identification IDValue="6" OrganizationName="ResMan" IDType="Name" /> <BuildingType>Unspecified</BuildingType> <Name>6</Name> <Description /> <UnitCount>8</UnitCount> <SquareFeet>0</SquareFeet> </Building><Utility> <AirCon>false</AirCon> <BroadbandInternet>true</BroadbandInternet> <Cable>false</Cable> <Electric>false</Electric> <Gas>false</Gas> <Heat>false</Heat> <HotWater>false</HotWater> <Satellite>false</Satellite> <Sewer>false</Sewer> <Telephone>false</Telephone> <Trash>false</Trash> <Water>false</Water> <UtilityPortionIncluded>0.00</UtilityPortionIncluded> </Utility> <File FileID="71fe9d37-17f3-49ef-9df1-1d4b19ee65ad" Active="true"> <FileType>Photo</FileType> <Name>IMG_1090.jpg</Name> <Format>.jpg</Format> <Src>https://resman.blob.core.windows.net/demo-public/f112e064-c35e-4495-a327-34a4cee895d3.jpg</Src> <Rank>12</Rank> </File> <File FileID="5e3c45b9-d6a7-4e80-a11c-311f194c937a" Active="true"> <FileType>Photo</FileType> <Name>12 Ext-3.jpg</Name> <Format>.jpg</Format> <Src>https://resman.blob.core.windows.net/demo-public/f3ba2d00-440a-4624-9ba7-1ebdf188d4f1.jpg</Src> <Rank>12</Rank> </File> </Property> </PhysicalProperty></Response></ResMan>';
       	rm.RMGetMarketing4_0( i.ResMan_API_URL__c, i.ResMan_Account_Id__c, 'B342E58C-F5BA-4C63-B050-CF44439BB37D');
        
        System.schedule( 'RMPullPropertiesScheduler', '00 01 12 14 1 ?', new RMPullPropertiesScheduler( 5 ) );
        RMPullPropertiesScheduler scheduler = new RMPullPropertiesScheduler( 5 );
        scheduler = new RMPullPropertiesScheduler();
        
        RMPullPropertiesBatch objBatch = new RMPullPropertiesBatch( );
        objBatch.RMPullProperties = rm;
        Database.executeBatch( objBatch, 5);
        
        p.ResMan_Property_Id__c = 'B342E58C-F5BA-4C63-B050-CF44439BB37D';
        update p;
        
        rm.RMPullProperties();
        
        Test.stopTest();

    }
}