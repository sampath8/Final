@isTest(SeeAllData=true) 
public class SendReminderEmailOnLeadEventTest {
 public static String CRON_EXP = '0 0 0 3 9 ? 2022';
	static testMethod void validateSendReminderEmailOnLeadEvent() {
         Test.startTest();
        
         Account a=new Account();
         a.Name ='TEST';
         a.Phone='9999999';
         a.Type='Test Surgaya';
         insert a;
        
         Property__c p = new Property__c();
         p.Account__c = a.Id;
         insert p;
         
         Contact c = new Contact();
         c.FirstName = 'Surgaya';
         c.LastName = 'Khundrakpam'; 
         c.Email = 'surgaya.khundrakpam@anyonehome.com';
         c.AccountId = a.Id;
         insert c;
        
         Contact c1 = new Contact();
         c1.FirstName = 'Test';
         c1.LastName = 'User'; 
         c1.Email = 'test@test.com';
         c1.AccountId = a.Id;
         c1.Agent_Assigned__c = c.Id;
         insert c1; 
        
         Lead_Event__c le = new Lead_Event__c();
         le.Name = 'Lead Event';
         le.Agent__c = c.Id;
         le.Prospect__c = c1.Id;
         le.Comments__c ='Testing';
         le.Send_Reminder_Email__c = true;
         le.Status__c = 'Open';
         le.Date__c =  Date.today();
         le.Type__c  = 'Email';
         le.Time__c  = '6:00 PM'; 
         insert le;
        
        
        List<String> sendTo = new List<String>();
        List<EmailMessageWrapper> listEmailMessageWrapper = new List<EmailMessageWrapper>();
        List<Messaging.SingleemailMessage> listSingleEmailMessages = new List<Messaging.SingleemailMessage>();
    
        if( null != c.Email ) { 
				
            Map<String, String> mapSubjectParams = new Map<String, String> { 
                '{!Lead_Event__c.Agent__c}' => c.Name 
        	};
							
           Map<String, String> mapBodyParams = new Map<String, String> { 
				   '{!Lead_Event__c.Type__c}' => le.Type__c, 
				   '{!Lead_Event__c.Date__c}' => '2014-11-25',  
				   '{!Lead_Event__c.Time__c}' => le.Time__c, 
				   '{!Lead_Event__c.Prospect__c}' => 'Sur Khund', 
				   '{!Lead_Event__c.Comments__c}' => le.Comments__c,
				   '{!Lead_Event__c.ProspectId__c}' => le.Prospect__c
  			};
										
 			listEmailMessageWrapper.add(new EmailMessageWrapper('customercare@anyonehome.com', c.Email, null, null, null, mapSubjectParams, null, mapBodyParams));
 		}  
        if(listEmailMessageWrapper.size() > 0) {
    
			UtilityClass.sendEmail(listEmailMessageWrapper, 'showpro_new_reminder_task');  
        }
          
         String jobId = System.schedule('sendEmailSchedule',
      									 SendEmailReminderScheduler.CRON_EXP, 
         								 new SendEmailReminderScheduler());

      	// Get the information from the CronTrigger API object
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
             NextFireTime
             FROM CronTrigger WHERE id = :jobId];
       
         System.assertEquals('2022-09-03 00:00:00', 
         String.valueOf(ct.NextFireTime));
        
         Test.stopTest();

     }
}