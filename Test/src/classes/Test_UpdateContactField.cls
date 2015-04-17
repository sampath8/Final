@isTest
 private class Test_UpdateContactField {
 static testMethod void MyUnitTestCon()
 {  
Contact c=new Contact();
c.FirstName='Test Name'; 
c.LastName='Tst Last';
c.MobilePhone='21345684';
c.Email='manish@gmail.com';
insert c; 

Case cc=new Case(); 
cc.Status='Test Sta';
cc.ContactId=c.Id;
insert cc;
 
Contact c1=new Contact();
c1.FirstName='Test Name'; 
c1.LastName='as';
c1.MobilePhone='';
c1.Email='';
insert c1;

Case cc1=new Case(); 
cc1.Status='Test Sta';
cc1.Correct_First_Name__c='Test First';
cc1.ContactId=c1.Id;
insert cc1;

Contact c2=new Contact();
c2.FirstName=''; 
c2.LastName='as';
c2.MobilePhone='';
c2.Email='';
insert c2;

Case cc2=new Case(); 
cc2.Status='Test Sta';
cc2.Corrected_Last_Name__c='Test First';
cc2.ContactId=c2.Id;
insert cc2;
 
Contact c3=new Contact();
c3.FirstName=''; 
c3.LastName='as';
c3.MobilePhone='123456789';
c3.Email='';
insert c3;

Case cc3=new Case(); 
cc3.Status='Test Sta';
cc3.Corrected_Alt_Phone__c='123456789';
cc3.ContactId=c3.Id;
insert cc3;

Contact c4=new Contact();
c4.FirstName=''; 
c4.LastName='as';
c4.MobilePhone='';
c4.Email='manish123@gmail.com';
insert c4;

Case cc4=new Case(); 
cc4.Status='Test Sta';
cc4.Corrected_Email__c='manish123@gmail.com';
cc4.ContactId=c4.Id;
insert cc4;

Test.startTest();
Test.stopTest();
}
 }