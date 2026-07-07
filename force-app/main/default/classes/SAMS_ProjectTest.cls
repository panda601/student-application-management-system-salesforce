@isTest
private class SAMS_ProjectTest {
    
    @isTest
    static void testStudentCreation() {
        // Positive scenario: Create student and assert Student_ID__c is generated
        Student__c s1 = SAMS_TestDataFactory.createStudent('John Doe', 'john.doe@example.com', 'Domestic', 'USA');
        System.Test.startTest();
        insert s1;
        System.Test.stopTest();
        
        Student__c retrieved = [SELECT Student_ID__c, Age__c FROM Student__c WHERE Id = :s1.Id];
        System.assertNotEquals(null, retrieved.Student_ID__c, 'Student ID should be auto-generated.');
        System.assert(retrieved.Student_ID__c.contains('SAMS-'), 'Student ID format is incorrect.');
        
        // Negative scenario: Duplicate Email check
        Student__c s2 = SAMS_TestDataFactory.createStudent('John Duplicate', 'john.doe@example.com', 'Domestic', 'USA');
        try {
            insert s2;
            System.assert(false, 'Should throw an error on duplicate email.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('already exists'), 'Incorrect error message: ' + e.getMessage());
        }
    }
    
    @isTest
    static void testInvalidApproval() {
        Student__c stud = SAMS_TestDataFactory.createStudent('John Doe', 'john.doe@example.com', 'Domestic', 'USA');
        insert stud;
        
        Application__c app = SAMS_TestDataFactory.createApplication(stud.Id, 'Computer Science', 10000.00);
        insert app;
        
        // Try to approve application with outstanding balance (should fail via ApplicationTrigger)
        app.Status__c = 'Approved';
        
        System.Test.startTest();
        try {
            update app;
            System.assert(false, 'Should throw error when approving with outstanding balance.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('outstanding balance'), 'Incorrect error: ' + e.getMessage());
        }
        System.Test.stopTest();
    }
    
    @isTest
    static void testValidApprovalAndStudentSync() {
        Student__c stud = SAMS_TestDataFactory.createStudent('John Doe', 'john.doe@example.com', 'Domestic', 'USA');
        insert stud;
        
        Application__c app = SAMS_TestDataFactory.createApplication(stud.Id, 'Computer Science', 10000.00);
        insert app;
        
        // Add full payment
        Payment__c pay = SAMS_TestDataFactory.createPayment(app.Id, 10000.00, 'Completed');
        insert pay;
        
        // Approve application now that balance is 0
        app.Status__c = 'Approved';
        
        System.Test.startTest();
        update app;
        System.Test.stopTest();
        
        // Assert student status is updated to Active (synced by ApplicationTrigger)
        Student__c updatedStud = [SELECT Status__c FROM Student__c WHERE Id = :stud.Id];
        System.assertEquals('Active', updatedStud.Status__c);
    }
    
    @isTest
    static void testBulkStudents() {
        List<Student__c> students = new List<Student__c>();
        for (Integer i = 0; i < 100; i++) {
            students.add(new Student__c(
                Name = 'Student ' + i,
                Email__c = 'student' + i + '@example.com',
                Date_of_Birth__c = Date.today().addYears(-19),
                Student_Type__c = 'Domestic',
                Country__c = 'USA',
                Status__c = 'Active'
            ));
        }
        
        System.Test.startTest();
        insert students;
        System.Test.stopTest();
        
        List<Student__c> inserted = [SELECT Student_ID__c FROM Student__c WHERE Email__c LIKE 'student%@example.com'];
        System.assertEquals(100, inserted.size());
        for (Student__c s : inserted) {
            System.assertNotEquals(null, s.Student_ID__c);
        }
    }
    
    @isTest
    static void testServicesAndExceptionHandling() {
        // Explicitly cover NotificationService and BaseService logging
        NotificationService notif = new NotificationService();
        notif.logActivity('Activity Logging test');
        notif.logError('Test error message', 'LOW');
        
        notif.sendEmailNotification('test@example.com', 'Test Subject', 'Test Body');
        
        // Cover ApprovalService
        Student__c stud = SAMS_TestDataFactory.createStudent('John Doe', 'john.doe@example.com', 'Domestic', 'USA');
        insert stud;
        Application__c app = SAMS_TestDataFactory.createApplication(stud.Id, 'Computer Science', 10000.00);
        insert app;
        
        ApprovalService appr = new ApprovalService();
        appr.processExecution();
        
        try {
            appr.submitApplicationForApproval(app.Id, 'Test submission');
        } catch (Exception ex) {
            System.debug('Submit failed as expected in test environment: ' + ex.getMessage());
        }
    }
}
