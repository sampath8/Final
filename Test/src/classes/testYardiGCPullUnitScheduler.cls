@istest
class testYardiGCPullUnitScheduler {
    static testmethod void test() {
   
        String UserName = 'anyonehome-ws';
        String Password = '56559';
        String ServerName = 'sdb17\\SQL2k8_R2';
        String strDatabase = 'afqoml_70dev';
        String Platform = 'SQL Server';
        String InterfaceEntity = 'Anyone Home';
        String InterfaceLicense = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ/pDTCM+vdmE2jXZyWqHdiASByIGuJYo/pP26ww9VIVwTzpzHWkmRhZ5fA5UboxKzWoMk+LjYDZQhy8k1ECHt0wIa/j0zE2ds5zPun+oZsWWtC7VFrHqkz2OiZs523pOG9CoJdMUaNlRi75fW/5QKM4YuiiA1XPzFTOXjTCZleymgOqN9ldyoX3/ctGOHcwIr92Wu/3PwWCqD6StAPbrAl6YB5K5tP2T4YnEjiMI4yU4TODkPdbTdgwsL8N6gcyj3+yJnzqLVZU545z3EsPkc/gOV9NPP8AZSJL3b';
        String YardiPropertyId = 'anyhome1';
        String FirstName = 'Test6';
        String LastName = 'Test6';
        String EmailAddress = '';
        String PhoneNumber = '';
        String ThirdPartyId = '00593290';
        String DateOfBirth = '';
        String FederalId = '';   
       
        List<String> strCredentials = new List<String>();
        strCredentials.add(UserName);
        strCredentials.add(Password);
        strCredentials.add(ServerName);
        strCredentials.add(strDatabase);
        strCredentials.add(Platform);
        strCredentials.add(InterfaceEntity);
        strCredentials.add(InterfaceLicense);   
      
        Test.startTest();
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Integration__c i1 = new Integration__c(); 
        i1.Yardi_ID__c = 'anyonehome-ws';
        i1.Yardi_Password__c = '56559';
        i1.Yardi_Server_Name__c = 'sdb17\\SQL2k8_R2';
        i1.Yardi_Database_Name__c = 'afqoml_70dev';
        i1.Yardi_Platform_Type__c = 'SQL Server';
        i1.Yardi_API_URL__c = 'https://www.iyardiasp.com/8223thirdparty708dev/webservices/itfilsguestcard.asmx';
        i1.Yardi_Version_Number__c = '4';
        i1.Yardi_Integration_Active__c = true;
        i1.Push_Guest_Cards_to_Yardi__c = true;
        i1.Account__c = a.Id;
        i1.Yardi_Availability_Pricing__c = 'Daily';
        i1.Last_Yardi_Pull__c = null;
        insert i1;
        
        Integration__c i2 = new Integration__c(); 
        i2.Yardi_ID__c = 'anyonehome-ws';
        i2.Yardi_Password__c = '56559';
        i2.Yardi_Server_Name__c = 'sdb17\\SQL2k8_R2';
        i2.Yardi_Database_Name__c = 'afqoml_70dev';
        i2.Yardi_Platform_Type__c = 'SQL Server';
        i2.Yardi_API_URL__c = 'https://www.iyardiasp.com/8223thirdparty708dev/webservices/itfilsguestcard20.asmx';
        i2.Yardi_Version_Number__c = '2';
        i2.Yardi_Integration_Active__c = true;
        i2.Push_Guest_Cards_to_Yardi__c = true;
        i2.Account__c = a.Id;
        i2.Yardi_Availability_Pricing__c = 'Daily';
        i2.Last_Yardi_Pull__c = null;
        insert i2;
        
        Property__c p1 = new Property__c();
        p1.Name = 'New Property';
        p1.Account__c = a.Id;
        p1.Customer_Prop_ID__c = 'anyhom5';
        p1.Address_Line_1__c = 'AAAAAAAAA';
        p1.City__c = 'Pune';
        p1.State__c = ' MH';
        p1.Zip_Code__c = '411013';
        insert p1;
        
        Floor_Plan__c f1 = new Floor_Plan__c();
        f1.Account__c = a.Id;
        f1.Property__c = p1.Id;
        f1.Floorplan_ID__c = 'anyhom5';
        insert f1;
        
        Unit__c u1 = new Unit__c();
        u1.Account__c = a.Id;
        u1.Property__c = p1.Id;
        u1.Floor_Plan__c = f1.Id;
        u1.Unit_ID__c = 'ANYHOM5';      
        insert u1;
        
        YardiGCPushwsdlToApexController.ItfILSGuestCardSoap yvn         = new YardiGCPushwsdlToApexController.ItfILSGuestCardSoap();      
        YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap yvn2   = new YardiGC20PushWsdltoApexController.ItfILSGuestCard2_0Soap();
        
        YardiGCPullUnitController controller = new YardiGCPullUnitController();
         
        controller.yvn = yvn;
        controller.yvn20 = yvn2;
        
        //controller.strUnitAvailability_Login    = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <UnitAvailability_LoginResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard20"> <UnitAvailability_LoginResult> <PhysicalProperty xsi:noNamespaceSchemaLocation="" xmlns:MITS="http://my-company.com/namespace" xmlns=""> <Property> <PropertyID> <MITS:Identification Type="other"> <MITS:PrimaryID>anyhom5</MITS:PrimaryID> <MITS:MarketingName>anyhom5 property</MITS:MarketingName> </MITS:Identification> <MITS:Address Type="property"> <MITS:Address1>anyhom5 Address 1</MITS:Address1> <MITS:Address2>anyhom5 Address 2</MITS:Address2> <MITS:City>Miami</MITS:City> <MITS:State>IN</MITS:State> <MITS:PostalCode>1234</MITS:PostalCode> </MITS:Address> </PropertyID> <ILS_Identification Type="Unspecified" RentalType="Unspecified"/> <Information> <StructureType>Unspecified</StructureType> <UnitCount>1</UnitCount> </Information> <Floorplan Id="anyhom5"> <Name>anyhom5 unit</Name> <UnitCount>1</UnitCount> <Room Type="Bedroom"> <Count>2.00</Count> <Comment/> </Room> <Room Type="Bathroom"> <Count>1.00</Count> <Comment/> </Room> <SquareFeet Min="500" Max="500"/> <MarketRent Min="300" Max="300"/> <EffectiveRent Min="300" Max="300"/> <Deposit type="deposit"> <Amount Type="Actual"> <Value>800.00</Value> </Amount> </Deposit> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> <AdminFee>0</AdminFee> <ApplicationFee>0</ApplicationFee> </Fee> </Floorplan> <ILS_Unit Id="ANYHOM5" FloorplanID=""> <Unit> <MITS:Information> <MITS:UnitID>ANYHOM5</MITS:UnitID> <MITS:UnitType>anyhom5</MITS:UnitType> <MITS:UnitBedrooms>2.00</MITS:UnitBedrooms> <MITS:UnitBathrooms>1.00</MITS:UnitBathrooms> <MITS:MinSquareFeet>500</MITS:MinSquareFeet> <MITS:MaxSquareFeet>500</MITS:MaxSquareFeet> <MITS:MarketRent>300.00</MITS:MarketRent> <MITS:UnitEconomicStatus>residential</MITS:UnitEconomicStatus> <MITS:UnitOccupancyStatus>occupied</MITS:UnitOccupancyStatus> <MITS:UnitLeasedStatus>on_notice</MITS:UnitLeasedStatus> <MITS:FloorPlanID/> <MITS:FloorplanName>anyhom5 unit</MITS:FloorplanName> </MITS:Information> <MITS:PropertyPrimaryID>anyhom5</MITS:PropertyPrimaryID> <MITS:MarketingName>anyhom5 property</MITS:MarketingName> </Unit> <Comment>RentReady=false</Comment> <EffectiveRent Min="300" Max="300"/> <Deposit type="deposit"> <Amount Type="Actual"> <Value>800.00</Value> </Amount> <Description>Deposit</Description> <PercentRefundable>100</PercentRefundable> <PortionRefundable>100</PortionRefundable> </Deposit> <Availability> <VacateDate Month="3" Day="20" Year="2014"/> <VacancyClass>Occupied</VacancyClass> <MadeReadyDate Month="3" Day="20" Year="2014"/> </Availability> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> </Fee> </ILS_Unit> </Property> </PhysicalProperty> </UnitAvailability_LoginResult> </UnitAvailability_LoginResponse> </soap:Body> </soap:Envelope>';
        controller.UnitAvailability_Login( strCredentials, 'anyhom5', '2');
        
        YardiGCPullUnitController controller2 = new YardiGCPullUnitController();
        controller2.yvn = yvn;
        controller2.yvn20 = yvn2;
        
        //controller2.strUnitAvailability_Login   = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"> <soap:Body> <UnitAvailability_LoginResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfILSGuestCard"> <UnitAvailability_LoginResult> <PhysicalProperty xsi:noNamespaceSchemaLocation="" xmlns:MITS="http://my-company.com/namespace" xmlns=""> <Property IDValue="anyhom5"> <PropertyID> <Identification IDValue="anyhom5"/> <MarketingName>anyhom5 property</MarketingName> <Address AddressType="property"> <AddressLine1>anyhom5 Address 1</AddressLine1> <AddressLine2>anyhom5 Address 2</AddressLine2> <City>Miami</City> <State>IN</State> <PostalCode>1234</PostalCode> </Address> </PropertyID> <ILS_Identification ILS_IdentificationType="Unspecified" RentalType="Unspecified"/> <Information> <StructureType>Unspecified</StructureType> <UnitCount>1</UnitCount> </Information> <Floorplan IDValue="anyhom5"> <Name>anyhom5 unit</Name> <UnitCount>1</UnitCount> <Room RoomType="Bedroom"> <Count>2.00</Count> <Comment/> </Room> <Room RoomType="Bathroom"> <Count>1.00</Count> <Comment/> </Room> <SquareFeet Min="500" Max="500"/> <MarketRent Min="300" Max="300"/> <EffectiveRent Min="300" Max="300"/> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <ValueRange Exact="800.00"/> </Amount> </Deposit> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> <AdminFee>0</AdminFee> <ApplicationFee>0</ApplicationFee> <BrokerFee>0</BrokerFee> </Fee> </Floorplan> <ILS_Unit IDValue="ANYHOM5"> <Units> <Unit> <Identification IDValue="ANYHOM5" IDType="14617"/> <UnitType>anyhom5</UnitType> <UnitBedrooms>2.00</UnitBedrooms> <UnitBathrooms>1.00</UnitBathrooms> <MinSquareFeet>500</MinSquareFeet> <MaxSquareFeet>500</MaxSquareFeet> <MarketRent>300.00</MarketRent> <UnitEconomicStatus>residential</UnitEconomicStatus> <UnitOccupancyStatus>occupied</UnitOccupancyStatus> <UnitLeasedStatus>on_notice</UnitLeasedStatus> <FloorplanName>anyhom5 unit</FloorplanName> </Unit> </Units> <Comment>RentReady=false</Comment> <EffectiveRent Min="300" Max="300"/> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <ValueRange Exact="800.00"/> </Amount> <Description>Deposit</Description> <PercentRefundable>100</PercentRefundable> <PortionRefundable>100</PortionRefundable> </Deposit> <Availability> <VacateDate Month="3" Day="20" Year="2014"/> <VacancyClass>Occupied</VacancyClass> <MadeReadyDate Month="3" Day="20" Year="2014"/> </Availability> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> </Fee> </ILS_Unit> <ILS_Unit IDValue="13234"> <Units> <Unit> <Identification IDValue="ANYHOM5" IDType="14617"/> <UnitType>anyhom5</UnitType> <UnitBedrooms>2.00</UnitBedrooms> <UnitBathrooms>1.00</UnitBathrooms> <MinSquareFeet>500</MinSquareFeet> <MaxSquareFeet>500</MaxSquareFeet> <MarketRent>300.00</MarketRent> <UnitEconomicStatus>residential</UnitEconomicStatus> <UnitOccupancyStatus>occupied</UnitOccupancyStatus> <UnitLeasedStatus>on_notice</UnitLeasedStatus> <FloorplanName>anyhom5 unit</FloorplanName> </Unit> </Units> <Comment>RentReady=false</Comment> <EffectiveRent Min="300" Max="300"/> <Deposit DepositType="deposit"> <Amount AmountType="Actual"> <ValueRange Exact="800.00"/> </Amount> <Description>Deposit</Description> <PercentRefundable>100</PercentRefundable> <PortionRefundable>100</PortionRefundable> </Deposit> <Availability> <VacateDate Month="3" Day="20" Year="2014"/> <VacancyClass>Occupied</VacancyClass> <MadeReadyDate Month="3" Day="20" Year="2014"/> </Availability> <Fee> <ProrateType>Standard</ProrateType> <LateType>% of owed</LateType> <LatePercent>0.00</LatePercent> <LateMinFee>0.00</LateMinFee> <LateFeePerDay>0.00</LateFeePerDay> <NonRefundableHoldFee>0</NonRefundableHoldFee> </Fee> </ILS_Unit> </Property> </PhysicalProperty> </UnitAvailability_LoginResult> </UnitAvailability_LoginResponse> </soap:Body> </soap:Envelope>';
        controller2.UnitAvailability_Login( strCredentials, 'anyhom5', '4');
        
        controller2.YardiGCPullUnit();
        
        YardiGCPullUnitScheduler objScheduler = new YardiGCPullUnitScheduler(5);
        objScheduler = new YardiGCPullUnitScheduler();
        
        YardiGCPullUnitBatch UnitBatch = new YardiGCPullUnitBatch();
        /*UnitBatch = new YardiGCPullUnitBatch(false);
        UnitBatch.arrobjunits = controller2.arrobjUnits;*/
        Database.executeBatch( UnitBatch, 20 );
        
        System.schedule('YardiGCPullUnitScheduler1','0 1 * * * ? ',new YardiGCPullUnitScheduler( 5));
        
        
        Test.stopTest();  
   }
}