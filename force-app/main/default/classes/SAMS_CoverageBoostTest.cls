@isTest
public class SAMS_CoverageBoostTest {
    
    @isTest
    static void testControllerAllMethods() {
        // Create test data
        Student__c student = SAMS_TestDataFactory.createStudent('Boost Student', 'boost@student.com', 'International', 'Canada');
        insert student;
        
        Application__c app = SAMS_TestDataFactory.createApplication(student.Id, 'Computer Science', 15000.00);
        insert app;
        
        Payment__c payment = SAMS_TestDataFactory.createPayment(app.Id, 5000.00, 'Completed');
        insert payment;
        
        System.Test.startTest();
        
        // 1. getStudents
        List<Student__c> students = SAMS_Controller.getStudents('Boost', 'International');
        System.assertNotEquals(0, students.size(), 'Should find the student');
        
        // 2. getDashboardMetrics
        Map<String, Decimal> metrics = SAMS_Controller.getDashboardMetrics();
        System.assertEquals(1, metrics.get('totalStudents'), 'Total student count mismatch');
        System.assertEquals(1, metrics.get('totalApps'), 'Total apps count mismatch');
        
        // 3. getApplicationStatusCounts
        List<Map<String, Object>> statusCounts = SAMS_Controller.getApplicationStatusCounts();
        System.assertNotEquals(0, statusCounts.size(), 'Should return application status counts');
        
        // 4. getApplicationsForStudent
        List<Application__c> studentApps = SAMS_Controller.getApplicationsForStudent(student.Id);
        System.assertEquals(1, studentApps.size(), 'Should return student applications');
        
        // 5. getPaymentsForApplication
        List<Payment__c> appPayments = SAMS_Controller.getPaymentsForApplication(app.Id);
        System.assertEquals(1, appPayments.size(), 'Should return application payments');
        
        // 6. createPaymentRecord
        Payment__c newPayment = SAMS_Controller.createPaymentRecord(app.Id, 1000.00, 'Cash', Date.today());
        System.assertNotEquals(null, newPayment.Id, 'Should create payment record');
        
        // 7. createCompleteApplicationPackage
        Map<String, Id> packageResult = SAMS_Controller.createCompleteApplicationPackage(
            'New Package Student', 'pkg@student.com', '1234567890', Date.today().addYears(-20), 'Domestic', 'USA', '123 St',
            'Computer Science', 'Fall 2026', 'Undergraduate', 12, 2000.00, 'Credit Card', Date.today()
        );
        System.assertNotEquals(null, packageResult.get('studentId'), 'Package student creation failed');
        System.assertNotEquals(null, packageResult.get('applicationId'), 'Package application creation failed');
        System.assertNotEquals(null, packageResult.get('paymentId'), 'Package payment creation failed');
        
        System.Test.stopTest();
    }
}
