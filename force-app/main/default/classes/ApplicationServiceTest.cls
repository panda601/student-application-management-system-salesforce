@isTest
private class ApplicationServiceTest {
    
    @isTest
    static void testValidationOnManualApproval() {
        Student__c student = SamsTestDataFactory.createStudent('John', 'john@test.com', Date.newInstance(1998, 10, 10), 'Domestic');
        insert student;
        
        Application__c app = SamsTestDataFactory.createApplication(student.Id, 'Computer Science', 'Fall 2026', 10000.00);
        insert app;
        
        // At this point, total payments is 0, outstanding balance is 10000
        app.Status__c = 'Approved';
        
        System.Test.startTest();
        try {
            update app;
            Assert.fail('Should not be able to manually approve with outstanding balance.');
        } catch (DmlException e) {
            Assert.isTrue(e.getMessage().contains('outstanding balance'));
        }
        System.Test.stopTest();
    }
    
    @isTest
    static void testStudentStatusSyncOnApproval() {
        Student__c student = SamsTestDataFactory.createStudent('John', 'john@test.com', Date.newInstance(1998, 10, 10), 'Domestic');
        student.Status__c = 'Inactive';
        insert student;
        
        Application__c app = SamsTestDataFactory.createApplication(student.Id, 'Computer Science', 'Fall 2026', 10000.00);
        app.Status__c = 'In Review';
        insert app;
        
        // Create completed payment that covers the full course fee
        Payment__c p = SamsTestDataFactory.createPayment(app.Id, 10000.00, 'Credit Card', 'Completed');
        insert p;
        
        // Let's reload application, update status to Approved (which is valid now since balance = 0)
        app.Status__c = 'Approved';
        
        System.Test.startTest();
        update app;
        System.Test.stopTest();
        
        Student__c updatedStudent = [SELECT Status__c FROM Student__c WHERE Id = :student.Id];
        Assert.areEqual('Active', updatedStudent.Status__c);
    }
}
