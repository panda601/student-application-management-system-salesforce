public with sharing class StudentTriggerHandler {
    private StudentService studentServ;
    
    public StudentTriggerHandler() {
        this.studentServ = new StudentService();
    }
    
    public void onBeforeInsert(List<Student__c> newStudents) {
        studentServ.generateStudentCodes(newStudents);
        studentServ.checkDuplicateEmails(newStudents);
    }
}
