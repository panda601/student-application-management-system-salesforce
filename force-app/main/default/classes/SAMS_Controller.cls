public with sharing class SAMS_Controller {
    /**
     * Retrieve students filtered by name prefix and type.
     */
    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudents(String namePrefix, String studentType) {
        String nameFilter = namePrefix != null ? namePrefix + '%' : '%';
        return [SELECT Id, Name, Email__c, Student_Type__c, Country__c, Status__c
                FROM Student__c
                WHERE Name LIKE :nameFilter
                AND Student_Type__c = :studentType];
    }

    /**
     * Return simple dashboard metrics.
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Decimal> getDashboardMetrics() {
        Map<String, Decimal> metrics = new Map<String, Decimal>();
        metrics.put('totalStudents', (Decimal)[SELECT COUNT() FROM Student__c]);
        metrics.put('totalApps', (Decimal)[SELECT COUNT() FROM Application__c]);
        return metrics;
    }

    /**
     * Get application status counts as a list of maps.
     */
    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getApplicationStatusCounts() {
        List<AggregateResult> agg = [SELECT Status__c, COUNT(Id) cnt FROM Application__c GROUP BY Status__c];
        List<Map<String, Object>> results = new List<Map<String, Object>>();
        for (AggregateResult ar : agg) {
            Map<String, Object> m = new Map<String, Object>();
            m.put('status', (String)ar.get('Status__c'));
            m.put('count', (Integer)ar.get('cnt'));
            results.add(m);
        }
        return results;
    }

    /**
     * Retrieve applications for a given student.
     */
    @AuraEnabled(cacheable=true)
    public static List<Application__c> getApplicationsForStudent(Id studentId) {
        return [SELECT Id, Course__c, Status__c, Application_Date__c
                FROM Application__c
                WHERE Student__c = :studentId];
    }

    /**
     * Retrieve payments for a given application.
     */
    @AuraEnabled(cacheable=true)
    public static List<Payment__c> getPaymentsForApplication(Id appId) {
        return [SELECT Id, Amount__c, Payment_Date__c, Payment_Status__c
                FROM Payment__c
                WHERE Application__c = :appId];
    }

    /**
     * Create a payment record and return the new record.
     */
    @AuraEnabled
    public static Payment__c createPaymentRecord(Id appId, Decimal amount, String method, Date paymentDate) {
        Payment__c p = new Payment__c(
            Application__c = appId,
            Amount__c = amount,
            Payment_Method__c = method,
            Payment_Date__c = paymentDate,
            Payment_Status__c = 'Pending'
        );
        insert p;
        return p;
    }

    /**
     * Create a full package: student, application, payment.
     * Returns a map of created record IDs.
     */
    @AuraEnabled
    public static Map<String, Id> createCompleteApplicationPackage(
        String studentName, String studentEmail, String studentPhone, Date dob,
        String studentType, String country, String address,
        String course, String intake, String appRecordType,
        Integer creditHours, Decimal fee, String paymentMethod, Date paymentDate) {
        Map<String, Id> result = new Map<String, Id>();
        // 1. Student
        Id stuRecTypeId = Schema.SObjectType.Student__c.getRecordTypeInfosByName().get(studentType).getRecordTypeId();
        Student__c stu = new Student__c(
            Name = studentName,
            Email__c = studentEmail,
            Phone__c = studentPhone,
            Date_of_Birth__c = dob,
            Student_Type__c = studentType,
            Country__c = country,
            Address__c = address,
            RecordTypeId = stuRecTypeId,
            Status__c = 'Active'
        );
        insert stu;
        result.put('studentId', stu.Id);
        // 2. Application
        Id appRecTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get(appRecordType).getRecordTypeId();
        Application__c app = new Application__c(
            Student__c = stu.Id,
            Course__c = course,
            Intake__c = intake,
            Course_Fee__c = fee,
            Status__c = 'New',
            Application_Date__c = Date.today(),
            RecordTypeId = appRecTypeId
        );
        insert app;
        result.put('applicationId', app.Id);
        // 3. Payment
        Payment__c pay = new Payment__c(
            Application__c = app.Id,
            Amount__c = fee,
            Payment_Method__c = paymentMethod,
            Payment_Date__c = paymentDate,
            Payment_Status__c = 'Pending'
        );
        insert pay;
        result.put('paymentId', pay.Id);
        return result;
    }
}
