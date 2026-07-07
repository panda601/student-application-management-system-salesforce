@isTest
private class StudentServiceTest {
    
    @isTest
    static void testGenerateStudentIds() {
        List<Student__c> students = new List<Student__c>{
            SamsTestDataFactory.createStudent('Alice', 'alice@test.com', Date.newInstance(2000, 1, 1), 'Domestic'),
            SamsTestDataFactory.createStudent('Bob', 'bob@test.com', Date.newInstance(1999, 5, 5), 'International')
        };
        
        System.Test.startTest();
        insert students;
        System.Test.stopTest();
        
        List<Student__c> results = [SELECT Student_ID__c, Age__c FROM Student__c ORDER BY Student_ID__c ASC];
        Assert.areEqual(2, results.size());
        Assert.isTrue(results[0].Student_ID__c.contains('SAMS-'));
        Assert.isTrue(results[1].Student_ID__c.contains('SAMS-'));
        Assert.areNotEqual(results[0].Student_ID__c, results[1].Student_ID__c);
    }
    
    @isTest
    static void testDuplicateEmailPrevention() {
        Student__c s1 = SamsTestDataFactory.createStudent('Alice', 'duplicate@test.com', Date.newInstance(2000, 1, 1), 'Domestic');
        insert s1;
        
        Student__c s2 = SamsTestDataFactory.createStudent('Bob', 'duplicate@test.com', Date.newInstance(1999, 5, 5), 'International');
        
        System.Test.startTest();
        try {
            insert s2;
            Assert.fail('Should have failed due to duplicate email validation.');
        } catch (DmlException e) {
            Assert.isTrue(e.getMessage().contains('already exists'));
        }
        System.Test.stopTest();
    }
}
