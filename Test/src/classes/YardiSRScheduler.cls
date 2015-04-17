global class YardiSRScheduler implements Schedulable {    
   Integer intervalMinutes = 1;
   
   public YardiSRScheduler(Integer intervalMinutes) {
  		this.intervalMinutes = intervalMinutes;
   } 
    
   global void execute(SchedulableContext sc) {       
        
       	Id SchedulerId, jobId;
        String cronString, schedulerName;
        DateTime now  = DateTime.now();
       	schedulerName = YardiSRScheduler.class.getName();
        
        try {
            if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND Status = 'Holding' ] < 100 ){
            	DateTime nextRunTime = now.addMinutes(this.intervalMinutes);
            	cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
               	 
                if( !Test.isRunningTest() ) {
                    SchedulerId = System.schedule( schedulerName, cronString, new YardiSRScheduler(this.intervalMinutes) );
                   
                    YardiSRBatch ObjBatch = new YardiSRBatch();
                    Database.executeBatch( ObjBatch, 50 ); 
                } 
            } else {
               	//schedule this same schedulable class again in 3 mins
                DateTime nextRunTime = now.addMinutes(3);
            	cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + nextRunTime.month() + ' ? ' + nextRunTime.year(); 
            
                SchedulerId = System.schedule( schedulerName, cronString, new YardiSRScheduler(this.intervalMinutes) );
            }
            
            jobId = sc.getTriggerId();
            System.abortJob(jobId);
             
        } catch ( Exception e ) {
            System.Debug( e.getMessage() );
            System.Debug( e.getStackTraceString() );
        }
   }
}