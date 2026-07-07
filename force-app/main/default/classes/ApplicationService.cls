public class ApplicationService extends SAMS_BaseService {
    
    public ApplicationService() {
        super('ApplicationService');
    }
    
    public override void logActivity(String message) {
        System.debug('ApplicationService Activity: ' + message);
    }
    
    /**
     * Prevents setting Status to Approved if Outstanding Balance > 0.
     * Fulfills ApplicationTrigger requirements
     */
    public void validateApprovals(List<Application__c> apps, Map<Id, Application__c> oldMap) {
        for (Application__c app : apps) {
            Application__c oldApp = oldMap != null ? oldMap.get(app.Id) : null;
            if (app.Status__c == 'Approved' && (oldApp == null || oldApp.Status__c != 'Approved')) {
                Decimal balance = app.Course_Fee__c - (app.Total_Payments__c != null ? app.Total_Payments__c : 0);
                if (balance > 0) {
                    app.addError('Cannot approve application with an outstanding balance of $' + balance + '. Please complete payment first.');
                }
            }
        }
    }
    
    /**
     * Updates Student status when Application is approved
     * Demonstrates DML operations, collections
     */
    public void updateStudentStatusOnApproval(List<Application__c> apps, Map<Id, Application__c> oldMap) {
        Set<Id> studentIds = new Set<Id>();
        for (Application__c app : apps) {
            Application__c oldApp = oldMap != null ? oldMap.get(app.Id) : null;
            if (app.Status__c == 'Approved' && (oldApp == null || oldApp.Status__c != 'Approved') && app.Student__c != null) {
                studentIds.add(app.Student__c);
            }
        }
        
        if (studentIds.isEmpty()) return;
        
        List<Student__c> studentsToUpdate = new List<Student__c>();
        for (Student__c s : [SELECT Id, Status__c FROM Student__c WHERE Id IN :studentIds]) {
            if (s.Status__c != 'Active') {
                s.Status__c = 'Active';
                studentsToUpdate.add(s);
            }
        }
        
        if (!studentsToUpdate.isEmpty()) {
            try {
                update studentsToUpdate;
                logActivity('Updated status to Active for ' + studentsToUpdate.size() + ' students.');
            } catch (Exception ex) {
                logError(ex);
                throw new AuraHandledException('Error updating student status: ' + ex.getMessage());
            }
        }
    }
}
