@isTest
public class SAMS_TestDataFactory {
    public static Student__c createStudent(String name, String email, String type, String country) {
        Id rectTypeId = Schema.SObjectType.Student__c.getRecordTypeInfosByName().get(type == 'International' ? 'International' : 'Domestic').getRecordTypeId();
        return new Student__c(
            Name = name,
            Email__c = email,
            Date_of_Birth__c = Date.today().addYears(-20),
            Student_Type__c = type,
            Country__c = country,
            Status__c = 'Active',
            RecordTypeId = rectTypeId
        );
    }
    
    public static Application__c createApplication(Id studentId, String course, Decimal fee) {
        Project__c proj;
        List<Project__c> projects = [SELECT Id FROM Project__c LIMIT 1];
        if (!projects.isEmpty()) {
            proj = projects[0];
        } else {
            proj = new Project__c(Name = 'Test Project');
            insert proj;
        }
        
        Id rectTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get('Undergraduate').getRecordTypeId();
        return new Application__c(
            Student__c = studentId,
            Course__c = course,
            Intake__c = 'Fall 2026',
            Course_Fee__c = fee,
            Status__c = 'New',
            RecordTypeId = rectTypeId,
            Application_Date__c = Date.today(),
            Project__c = proj.Id
        );
    }
    
    public static Payment__c createPayment(Id appId, Decimal amount, String status) {
        return new Payment__c(
            Application__c = appId,
            Amount__c = amount,
            Payment_Date__c = Date.today(),
            Payment_Status__c = status,
            Payment_Method__c = 'Credit Card'
        );
    }
}
