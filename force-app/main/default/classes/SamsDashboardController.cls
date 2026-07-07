public with sharing class SamsDashboardController {
    
    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudents(String searchKey, String statusFilter) {
        String query = 'SELECT Id, Name, Student_ID__c, Email__c, Phone__c, Date_of_Birth__c, Age__c, Student_Type__c, Status__c, Country__c ' +
                       'FROM Student__c';
        List<String> conditions = new List<String>();
        
        if (String.isNotBlank(searchKey)) {
            String key = '%' + String.escapeSingleQuotes(searchKey) + '%';
            conditions.add('(Name LIKE :key OR Student_ID__c LIKE :key OR Email__c LIKE :key)');
        }
        
        if (String.isNotBlank(statusFilter) && statusFilter != 'All') {
            conditions.add('Status__c = :statusFilter');
        }
        
        if (!conditions.isEmpty()) {
            query += ' WHERE ' + String.join(conditions, ' AND ');
        }
        
        query += ' ORDER BY CreatedDate DESC LIMIT 100';
        
        return Database.query(query);
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getSamsAnalytics() {
        Map<String, Object> result = new Map<String, Object>();
        
        // Total Students
        result.put('totalStudents', [SELECT COUNT() FROM Student__c]);
        result.put('activeStudents', [SELECT COUNT() FROM Student__c WHERE Status__c = 'Active']);
        
        // Applications
        result.put('totalApplications', [SELECT COUNT() FROM Application__c]);
        result.put('newApplications', [SELECT COUNT() FROM Application__c WHERE Status__c = 'New']);
        result.put('inReviewApplications', [SELECT COUNT() FROM Application__c WHERE Status__c = 'In Review']);
        result.put('approvedApplications', [SELECT COUNT() FROM Application__c WHERE Status__c = 'Approved']);
        result.put('rejectedApplications', [SELECT COUNT() FROM Application__c WHERE Status__c = 'Rejected']);
        
        // Payments
        AggregateResult[] paymentAggs = [
            SELECT SUM(Amount__c) amt 
            FROM Payment__c 
            WHERE Payment_Status__c = 'Completed'
        ];
        Decimal revenue = 0;
        if (paymentAggs[0].get('amt') != null) {
            revenue = (Decimal)paymentAggs[0].get('amt');
        }
        result.put('totalRevenue', revenue);
        
        AggregateResult[] outstandingAggs = [
            SELECT SUM(Outstanding_Balance__c) bal 
            FROM Application__c
        ];
        Decimal outstanding = 0;
        if (outstandingAggs[0].get('bal') != null) {
            outstanding = (Decimal)outstandingAggs[0].get('bal');
        }
        result.put('totalOutstanding', outstanding);
        
        return result;
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getAiRecommendation(Id recordId) {
        Map<String, Object> scorecard = new Map<String, Object>();
        
        // Generate mock Einstein AI metrics based on application/student details
        if (recordId == null) {
            scorecard.put('approvalLikelihood', 75);
            scorecard.put('riskLevel', 'Low');
            scorecard.put('missingDocs', new List<String>{'Passport Copy', 'English Proficiency Certificate'});
            return scorecard;
        }
        
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        if (sObjName == 'Application__c') {
            Application__c app = [
                SELECT Outstanding_Balance__c, Course__c, Student__r.Student_Type__c, Student__r.Age__c 
                FROM Application__c 
                WHERE Id = :recordId
            ];
            
            Integer score = 85;
            String risk = 'Low';
            List<String> docs = new List<String>();
            
            if (app.Student__r.Student_Type__c == 'International') {
                score -= 15;
                docs.add('Visa Copy');
                docs.add('Financial Guarantee Proof');
            }
            if (app.Outstanding_Balance__c > 5000) {
                score -= 10;
                risk = 'Medium';
            }
            if (app.Student__r.Age__c < 18) {
                score -= 5;
                docs.add('Parental Consent Form');
            }
            
            scorecard.put('approvalLikelihood', score);
            scorecard.put('riskLevel', risk);
            scorecard.put('missingDocs', docs);
        } else {
            scorecard.put('approvalLikelihood', 80);
            scorecard.put('riskLevel', 'Low');
            scorecard.put('missingDocs', new List<String>{'Transcripts', 'Passport Copy'});
        }
        
        return scorecard;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Payment__c> getPayments(Id applicationId) {
        return [
            SELECT Id, Name, Amount__c, Payment_Date__c, Payment_Status__c, Payment_Method__c 
            FROM Payment__c 
            WHERE Application__c = :applicationId 
            ORDER BY Payment_Date__c DESC
        ];
    }
    
    @AuraEnabled
    public static Payment__c createPaymentRecord(Id applicationId, Decimal amount, String method) {
        Payment__c p = new Payment__c();
        p.Application__c = applicationId;
        p.Amount__c = amount;
        p.Payment_Method__c = method;
        p.Payment_Status__c = 'Completed';
        p.Payment_Date__c = Date.today();
        insert p;
        return p;
    }
    
    @AuraEnabled
    public static Map<String, Object> createQuickEnrollment(String name, String email, String type, Date dob, String course, Decimal amount, String method) {
        Savepoint sp = Database.setSavepoint();
        try {
            Student__c s = new Student__c(
                Name = name,
                Email__c = email,
                Student_Type__c = type,
                Date_of_Birth__c = dob,
                Status__c = 'Active'
            );
            insert s;
            
            Application__c app = new Application__c(
                Student__c = s.Id,
                Course__c = course,
                Intake__c = 'Fall 2026',
                Course_Fee__c = 10000.00,
                Status__c = 'In Review'
            );
            insert app;
            
            Payment__c p = new Payment__c(
                Application__c = app.Id,
                Amount__c = amount,
                Payment_Method__c = method,
                Payment_Status__c = 'Completed',
                Payment_Date__c = Date.today()
            );
            insert p;
            
            Map<String, Object> ids = new Map<String, Object>();
            ids.put('studentId', s.Id);
            ids.put('applicationId', app.Id);
            ids.put('paymentId', p.Id);
            return ids;
        } catch (Exception e) {
            Database.rollback(sp);
            throw new AuraHandledException(e.getMessage());
        }
    }
}
