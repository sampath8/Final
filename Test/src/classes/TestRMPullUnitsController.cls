@istest
class TestRMPullUnitsController {
	static testmethod void testPullUnitsController() {
   		Test.startTest();
        
        Account a = new Account();
       	a.Name = 'Test Account';
       	insert a;
        
        Integration__c i 					= new Integration__c();	
        i.Account__c 						= a.Id;
        i.ResMan_API_URL__c 				= 'https://api.myresman.com/';
        i.ResMan_API_Key__c 				= 'a262bb82902b4e3491807044e0c6986e';
        i.ResMan_Integration_Partner_ID__c 	= '1076';
        i.ResMan_Account_Id__c				= '400';
        i.Get_ResMan_Unit_Availability__c	= 'Daily';
        i.ResMan_Integration_Active__c 		= true;
        i.LRO_Integration__c				= false;
        insert i;
        
        Integration__c i1 					= new Integration__c();	
        i1.Account__c 						= a.Id;
        i1.ResMan_API_URL__c 				= 'https://api.myresman.com/';
        i1.ResMan_API_Key__c 				= 'a262bb82902b4e3491807044e0c6986e';
        i1.ResMan_Integration_Partner_ID__c = '1076';
        i1.ResMan_Account_Id__c				= '400';
        i1.Get_ResMan_Unit_Availability__c	= 'Daily';
        i1.ResMan_Integration_Active__c 	= true;
        i1.LRO_Integration__c				= false;
        insert i1;
        
        Account b = new Account();
       	b.Name = 'Test Account';
       	insert b;
        
        Integration__c i2 					= new Integration__c();	
        i2.Account__c 						= b.Id;
        i2.ResMan_API_URL__c 				= 'https://api.myresman.com/';
        i2.ResMan_API_Key__c 				= 'a262bb82902b4e3491807044e0c6986e';
        i2.ResMan_Integration_Partner_ID__c = '1076';
        i2.ResMan_Account_Id__c				= '400';
        i2.Get_ResMan_Unit_Availability__c	= 'Daily';
        i2.ResMan_Integration_Active__c 	= true;
        i2.LRO_Integration__c				= false;
        insert i2;
        
        Integration__c i3 					= new Integration__c();	
        i3.Account__c 						= b.Id;
        i3.ResMan_API_URL__c 				= 'https://api.myresman.com/';
        i3.ResMan_API_Key__c 				= 'a262bb82902b4e3491807044e0c6986e';
        i3.ResMan_Integration_Partner_ID__c = '1076';
        i3.ResMan_Account_Id__c				= '400';
        i3.Get_ResMan_Unit_Availability__c	= 'Daily';
        i3.ResMan_Integration_Active__c 	= true;
        i3.LRO_Integration__c				= true;
        insert i3;
        
        Property__c p 			= new Property__c();
        p.Account__c 			= a.Id;
        p.ResMan_Property_Id__c = 'B342E58C-F5BA-4C63-B050-CF44439BB37D';
        insert p;
        
        Property__c p2 			= new Property__c();
        p2.Account__c 			= b.Id;
        p2.ResMan_Property_Id__c = 'B342E58C-F5BA-4C63-B050-CF44439BB37D';
        insert p2;

        Floor_Plan__c f1 = new Floor_Plan__c();
        f1.Account__c = a.Id;
        f1.Property__c = p.Id;
        f1.ResMan_Floor_Plan_ID__c = 'A2';
        insert f1;
        
        Floor_Plan__c f2 = new Floor_Plan__c();
        f2.Account__c = b.Id;
        f2.Property__c = p2.Id;
        f2.ResMan_Floor_Plan_ID__c = 'A2';
        insert f2;
		
		Unit__c u1 = new Unit__c();
		u1.Account__c = a.Id;
		u1.Property__c = p.Id;
		u1.Floor_Plan__c = f1.Id;
		u1.ResMan_Unit_ID__c = '13103';      
        insert u1;
         
        
        RMPullUnitsScheduler scheduler = new RMPullUnitsScheduler( 3 );
        scheduler = new RMPullUnitsScheduler();
        
        System.schedule( 'RMPullUnitsScheduler', '0 0 * * * ?', new RMPullUnitsScheduler(3) );
        
        /*RMPullUnitsController rm = new RMPullUnitsController();
        rm.strMarketing4_0 = '<ILS_Unit> <Identification IDValue="7306" OrganizationName="ResMan" IDType="Number" /> <Units> <Unit> <Identification IDValue="7306" OrganizationName="ResMan" IDType="Number" /> <MarketingName>7306</MarketingName> <UnitType>A2</UnitType> <UnitBedrooms>1</UnitBedrooms> <UnitBathrooms>1</UnitBathrooms> <MinSquareFeet>734</MinSquareFeet> <MaxSquareFeet>734</MaxSquareFeet> <MarketRent>780</MarketRent> <UnitEconomicStatus>residential</UnitEconomicStatus> <UnitOccupancyStatus>occupied</UnitOccupancyStatus> <UnitLeasedStatus>leased</UnitLeasedStatus> <FloorplanName>One Bedroom, One Bath</FloorplanName> <BuildingName>7</BuildingName> <Address AddressType="property"> <AddressLine1>1538 Cable Ranch Rd.</AddressLine1> <AddressLine2>7306</AddressLine2> <City>San Antonio</City> <State>TX</State> <PostalCode>78245</PostalCode> </Address> </Unit> </Units> <Pricing> <MITS-OfferTerm> <EffectiveRent>780.00</EffectiveRent> <Term>1</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>780.00</EffectiveRent> <Term>2</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>780.00</EffectiveRent> <Term>3</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>780.00</EffectiveRent> <Term>4</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>780.00</EffectiveRent> <Term>5</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>780.00</EffectiveRent> <Term>6</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>780.00</EffectiveRent> <Term>7</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>780.00</EffectiveRent> <Term>8</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>780.00</EffectiveRent> <Term>9</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>780.00</EffectiveRent> <Term>10</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>780.00</EffectiveRent> <Term>11</Term> </MITS-OfferTerm>  <MITS-OfferTerm> <EffectiveRent>780.00</EffectiveRent> <Term>12</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>775.00</EffectiveRent> <Term>13</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>775.00</EffectiveRent> <Term>14</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>775.00</EffectiveRent> <Term>15</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>770.00</EffectiveRent> <Term>16</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>765.00</EffectiveRent> <Term>18</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>760.00</EffectiveRent> <Term>20</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>755.00</EffectiveRent> <Term>22</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>753.00</EffectiveRent> <Term>24</Term> </MITS-OfferTerm> </Pricing> <EffectiveRent Avg="765" Min="753" Max="780" /> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <ValueRange Exact="300.00" /> </Amount> <Description>Escrow Deposit</Description> <PercentRefundable>1300</PercentRefundable> <PortionRefundable>1100</PortionRefundable> </Deposit> <FloorLevel>3</FloorLevel> <Availability> <VacateDate Month="2" Day="17" Year="2015" /> <VacancyClass>Occupied</VacancyClass> <MadeReadyDate Month="2" Day="25" Year="2015" /> </Availability> </ILS_Unit> <ILS_Unit> <Identification IDValue="13103" OrganizationName="ResMan" IDType="Number" /> <Units> <Unit> <Identification IDValue="13103" OrganizationName="ResMan" IDType="Number" /> <MarketingName>13103</MarketingName> <UnitType>A2</UnitType> <UnitBedrooms>1</UnitBedrooms> <UnitBathrooms>1</UnitBathrooms> <MinSquareFeet>587</MinSquareFeet> <MaxSquareFeet>587</MaxSquareFeet> <MarketRent>695</MarketRent> <UnitEconomicStatus>residential</UnitEconomicStatus> <UnitOccupancyStatus>occupied</UnitOccupancyStatus> <UnitLeasedStatus>leased</UnitLeasedStatus> <FloorplanName>One Bedroom, One Bath</FloorplanName> <BuildingName>13</BuildingName> <Address AddressType="property"> <AddressLine1>1538 Cable Ranch Rd.</AddressLine1> <AddressLine2>13103</AddressLine2> <City>San Antonio</City> <State>TX</State> <PostalCode>78245</PostalCode> </Address> </Unit> </Units> <Pricing> <MITS-OfferTerm> <EffectiveRent>695.00</EffectiveRent> <Term>12</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>690.00</EffectiveRent> <Term>14</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>685.00</EffectiveRent> <Term>16</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>675.00</EffectiveRent> <Term>18</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>670.00</EffectiveRent> <Term>20</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>668.00</EffectiveRent> <Term>22</Term> </MITS-OfferTerm> <MITS-OfferTerm> <EffectiveRent>665.00</EffectiveRent> <Term>24</Term> </MITS-OfferTerm> </Pricing> <EffectiveRent Avg="678" Min="665" Max="695" /> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <ValueRange Exact="100.00" /> </Amount> <Description>Escrow Deposit Paid In</Description> <PercentRefundable>100</PercentRefundable> <PortionRefundable>100</PortionRefundable> </Deposit> <FloorLevel>1</FloorLevel> <Availability> <VacateDate Month="2" Day="17" Year="2015" /> <VacancyClass>Occupied</VacancyClass> <MadeReadyDate Month="2" Day="25" Year="2015" /> </Availability> </ILS_Unit>';
        
        rm.RMPullUnits();*/
        
        RMPullUnitsBatch UnitBatch = new RMPullUnitsBatch();
        UnitBatch = new RMPullUnitsBatch();
        Database.executeBatch( UnitBatch, 6 );
       
        Test.stopTest();  
   }
}