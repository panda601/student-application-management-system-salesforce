@isTest
private class PaymentServiceTest {
    
    @isTest
    static void testPaymentValidations() {
        Student__c student = SamsTestDataFactory.createStudent('John', 'john@test.com', Date.newInstance(1998, 10, 10), 'Domestic');
        insert student;
        
        Application__c app = SamsTestDataFactory.createApplication(student.Id, 'Computer Science', 'Fall 2026', 10000.00);
        insert app;
        
        // 1. Negative amount validation
        Payment__c p1 = SamsTestDataFactory.createPayment(app.Id, -500.00, 'Credit Card', 'Completed');
        
        // 2. Exceeds outstanding balance validation
        Payment__c p2 = SamsTestDataFactory.createPayment(app.Id, 12000.00, 'Credit Card', 'Completed');
        
        System.Test.startTest();
        try {
            insert p1;
            Assert.fail('Negative amount payment should fail.');
        } catch (DmlException e) {
            Assert.isTrue(e.getMessage().contains('greater than zero'));
        }
        
        try {
            insert p2;
            Assert.fail('Overpayment should fail.');
        } catch (DmlException e) {
            Assert.isTrue(e.getMessage().contains('exceeds the outstanding balance'));
        }
        System.Test.stopTest();
    }
    
    @isTest
    static void testPaymentStatusChangeAlerts() {
        Student__c student = SamsTestDataFactory.createStudent('John', 'john@test.com', Date.newInstance(1998, 10, 10), 'Domestic');
        insert student;
        
        Application__c app = SamsTestDataFactory.createApplication(student.Id, 'Computer Science', 'Fall 2026', 10000.00);
        insert app;
        
        Payment__c p = SamsTestDataFactory.createPayment(app.Id, 1000.00, 'Credit Card', 'Pending');
        insert p;
        
        // Change status to trigger email notifications
        p.Payment_Status__c = 'Completed';
        
        System.Test.startTest();
        update p;
        System.Test.stopTest();
        
        Payment__c updatedPayment = [SELECT Payment_Status__c FROM Payment__c WHERE Id = :p.Id];
        Assert.areEqual('Completed', updatedPayment.Payment_Status__c);
    }
}
