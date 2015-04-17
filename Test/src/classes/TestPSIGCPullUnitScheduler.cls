@istest
class TestPSIGCPullUnitScheduler {
    static testmethod void test() {
        Test.startTest();
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Integration__c i1 = new Integration__c(); 
        i1.Account__c = a.Id;
        i1.Push_Guest_Cards_to_PSI__c = true;
        i1.PSI_API_URL__c = 'https://timepass.com';
        i1.PSI_Username__c = 'Username';
        i1.PSI_Password__c = 'Password';
        i1.Get_PSI_Unit_Availability__c = 'Hourly';
        i1.PSI_Integration_Active__c = true;
        insert i1;
        
        Integration__c i2 = new Integration__c(); 
        i2.Account__c = a.Id;
        i2.Push_Guest_Cards_to_PSI__c = true;
        i2.PSI_API_URL__c = 'https://timepass.com';
        i2.PSI_Username__c = 'Username';
        i2.PSI_Password__c = 'Password';
        i2.Get_PSI_Unit_Availability__c = 'Hourly';
        insert i2;
        
        Property__c p1 = new Property__c();
        p1.Name = 'New Property';
        p1.Account__c = a.Id;
        p1.PSI_Prop_ID__c = 'anyhom5';
        p1.Address_Line_1__c = 'AAAAAAAAA';
        p1.City__c = 'Pune';
        p1.State__c = ' MH';
        p1.Zip_Code__c = '411013';
        insert p1;
        
        Floor_Plan__c f1 = new Floor_Plan__c();
        f1.Account__c = a.Id;
        f1.Property__c = p1.Id;
        f1.PSI_Floor_Plan_ID__c = '251534';
        insert f1;
        
        Unit__c u1 = new Unit__c();
        u1.Account__c = a.Id;
        u1.Property__c = p1.Id;
        u1.Floor_Plan__c = f1.Id;
        u1.PSI_Unit_ID__c = '3191963';      
        insert u1;
         
        PSIGCPullUnitScheduler psipullUnit = new PSIGCPullUnitScheduler( 3 );
        psipullUnit = new PSIGCPullUnitScheduler();
        
        System.schedule( 'PSIGCPullUnitScheduler', '0 0 * * * ?', new PSIGCPullUnitScheduler(3) );
        
        PSIGCPullUnitBatch UnitBatch = new PSIGCPullUnitBatch();
        UnitBatch = new PSIGCPullUnitBatch();
        Database.executeBatch( UnitBatch, 4 );
       
        Test.stopTest();  
   }
}