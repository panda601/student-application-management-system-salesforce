@isTest
private class SamsDashboardControllerTest {
    
    @isTest
    static void testControllerQueries() {
        Student__c s = SamsTestDataFactory.createStudent('Alice', 'alice@test.com', Date.newInstance(2000, 1, 1), 'Domestic');
        insert s;
        
        Application__c app = SamsTestDataFactory.createApplication(s.Id, 'Computer Science', 'Fall 2026', 10000.00);
        app.Status__c = 'In Review';
        insert app;
        
        Payment__c p = SamsTestDataFactory.createPayment(app.Id, 2000.00, 'Credit Card', 'Completed');
        insert p;
        
        System.Test.startTest();
        List<Student__c> students = SamsDashboardController.getStudents('Alice', 'Active');
        Map<String, Object> analytics = SamsDashboardController.getSamsAnalytics();
        Map<String, Object> aiRec = SamsDashboardController.getAiRecommendation(app.Id);
        List<Payment__c> payments = SamsDashboardController.getPayments(app.Id);
        
        // Quick enrollment test
        Map<String, Object> enroll = SamsDashboardController.createQuickEnrollment(
            'Bob', 'bob@test.com', 'International', Date.newInstance(1999, 1, 1), 'Data Science', 1000.00, 'PayPal'
        );
        System.Test.stopTest();
        
        Assert.areEqual(1, students.size());
        Assert.areEqual(1, (Integer)analytics.get('totalStudents'));
        Assert.areNotEqual(null, aiRec.get('approvalLikelihood'));
        Assert.areEqual(1, payments.size());
        Assert.areNotEqual(null, enroll.get('studentId'));
    }
}
