public with sharing class BillEmailer {
    
    public static void sendEmails(Map<String, Blob> emailsWithBills) {
        //instantiate a list of Messaging.SingleEmailMessage objects
		List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        //iterate over the keyset of the emailsWithBills map and instantiate a single Messaging.SingleEmailMessage
        //object. Set the bccAddress to the email from the iteration, set a PlainTextBody, and set a Subject for the
        //Messaging.SingleEmailMessage object.

        for(String email : emailsWithBills.keySet()) {
			Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            //set bcc 
            emailMessage.setBCCAddresses(new List<String>{email});
            //set plaintext body
            emailMessage.setPlainTextBody('Your bill is ready. Please see attached');
            //set subject
            emailMessage.setSubject('This is the subject');
            
            //use the following
            //to attach the PDF blob to the email:
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.Body = emailsWithBills.get(email);
            attach.FileName = 'Bill-' + Date.Today().Month() + '-' + Date.Today().Day() + '-' + Date.Today().Year() + '.pdf';
            attach.ContentType = 'application/pdf';
			
            //*Cpop: I resolved an error here so if there's a problem down the line, check this
            emailMessage.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});

            //add the Messaging.SingleEmailMessage object to the list inside of the loop, and send the email outside of the loop.
            //*Cpop: I resolved an error here so if there's a problem down the line, check this
            emailList.add(emailMessage);

        }

        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailList);
        
        // Call a helper method to inspect the returned results
        inspectResults(results);
    }

    //this is a method that will allow you to check to see if your code works.
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results. 
        // In this class, the methods send only one email, 
        // so we should have only one result.
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        return sendResult;
    }
}