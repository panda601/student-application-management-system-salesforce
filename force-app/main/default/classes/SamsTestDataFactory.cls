@isTest
public class SamsTestDataFactory {
    
    public static Student__c createStudent(String name, String email, Date dob, String type) {
        Id rectTypeId = Schema.SObjectType.Student__c.getRecordTypeInfosByName().get(type == 'International' ? 'International' : 'Domestic').getRecordTypeId();
        Student__c s = new Student__c();
        s.Name = name;
        s.Email__c = email;
        s.Date_of_Birth__c = dob;
        s.Student_Type__c = type;
        s.Status__c = 'Active';
        s.Country__c = (type == 'International' ? 'Canada' : 'USA');
        s.RecordTypeId = rectTypeId;
        return s;
    }
    
    public static Application__c createApplication(Id studentId, String course, String intake, Decimal fee) {
        Project__c proj;
        List<Project__c> projects = [SELECT Id FROM Project__c LIMIT 1];
        if (!projects.isEmpty()) {
            proj = projects[0];
        } else {
            proj = new Project__c(Name = 'Test Project');
            insert proj;
        }
        
        Id rectTypeId = Schema.SObjectType.Application__c.getRecordTypeInfosByName().get('Undergraduate').getRecordTypeId();
        Application__c app = new Application__c();
        app.Student__c = studentId;
        app.Course__c = course;
        app.Intake__c = intake;
        app.Course_Fee__c = fee;
        app.Status__c = 'New';
        app.RecordTypeId = rectTypeId;
        app.Project__c = proj.Id;
        return app;
    }
    
    public static Payment__c createPayment(Id appId, Decimal amount, String method, String status) {
        Payment__c p = new Payment__c();
        p.Application__c = appId;
        p.Amount__c = amount;
        p.Payment_Method__c = method;
        p.Payment_Status__c = status;
        p.Payment_Date__c = Date.today();
        return p;
    }
}
