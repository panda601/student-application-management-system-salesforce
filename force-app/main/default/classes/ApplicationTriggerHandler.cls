public with sharing class ApplicationTriggerHandler {
    private ApplicationService appServ;
    private NotificationService notifServ;
    
    public ApplicationTriggerHandler() {
        this.appServ = new ApplicationService();
        this.notifServ = new NotificationService();
    }
    
    public void onBeforeInsert(List<Application__c> newApps) {
        appServ.validateApprovals(newApps, null);
    }
    
    public void onBeforeUpdate(List<Application__c> newApps, Map<Id, Application__c> oldMap) {
        appServ.validateApprovals(newApps, oldMap);
    }
    
    public void onAfterUpdate(List<Application__c> newApps, Map<Id, Application__c> oldMap) {
        appServ.updateStudentStatusOnApproval(newApps, oldMap);
        sendApprovalEmails(newApps, oldMap);
    }
    
    private void sendApprovalEmails(List<Application__c> newApps, Map<Id, Application__c> oldMap) {
        Set<Id> studentIds = new Set<Id>();
        List<Application__c> approvedApps = new List<Application__c>();
        
        for (Application__c app : newApps) {
            Application__c oldApp = oldMap != null ? oldMap.get(app.Id) : null;
            if (app.Status__c == 'Approved' && (oldApp == null || oldApp.Status__c != 'Approved') && app.Student__c != null) {
                approvedApps.add(app);
                studentIds.add(app.Student__c);
            }
        }
        
        if (approvedApps.isEmpty()) return;
        
        Map<Id, Student__c> studentMap = new Map<Id, Student__c>([SELECT Id, Name, Email__c FROM Student__c WHERE Id IN :studentIds]);
        
        for (Application__c app : approvedApps) {
            Student__c stud = studentMap.get(app.Student__c);
            if (stud != null && stud.Email__c != null) {
                String subject = 'SAMS Application Approved - ' + app.Name;
                String body = 'Dear ' + stud.Name + ',\n\nWe are pleased to inform you that your application for the course ' + app.Course__c + ' has been approved.\n\nBest Regards,\nSAMS Admissions Team';
                notifServ.sendEmailNotification(stud.Email__c, subject, body);
            }
        }
    }
}
