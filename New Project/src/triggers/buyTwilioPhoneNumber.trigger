trigger buyTwilioPhoneNumber on Contact (before insert, before update) {
	Contact c = trigger.new[0];
    
    Map<String,String> message = new Map<String,String>{
        'AreaCode' => '310'
    };
        
    Twilio.send(JSON.serialize(message));
}