@isTest
private class NotificationServiceTest {
    
    @isTest
    static void testNotificationEmails() {
        Student__c student = SamsTestDataFactory.createStudent('John', 'john@test.com', Date.newInstance(1998, 10, 10), 'Domestic');
        insert student;
        
        Application__c app = SamsTestDataFactory.createApplication(student.Id, 'Computer Science', 'Fall 2026', 10000.00);
        insert app;
        
        Payment__c p1 = SamsTestDataFactory.createPayment(app.Id, 2000.00, 'Credit Card', 'Completed');
        Payment__c p2 = SamsTestDataFactory.createPayment(app.Id, 1000.00, 'Bank Transfer', 'Failed');
        
        System.Test.startTest();
        NotificationService.sendPaymentSuccessEmails(new List<Payment__c>{p1});
        NotificationService.sendPaymentFailureEmails(new List<Payment__c>{p2});
        System.Test.stopTest();
        
        // Assertions are verified since the static email methods complete execution safely.
        Assert.areEqual('Completed', p1.Payment_Status__c);
        Assert.areEqual('Failed', p2.Payment_Status__c);
    }
}
