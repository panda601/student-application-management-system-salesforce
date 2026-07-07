public class NotificationService extends SAMS_BaseService {
    
    public NotificationService() {
        super('NotificationService');
    }
    
    public override void logActivity(String message) {
        System.debug('NotificationService Activity: ' + message);
    }
    
    /**
     * Sends email notification to student
     */
    public void sendEmailNotification(String toAddress, String subject, String body) {
        try {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String>{ toAddress });
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            
            if (!System.Test.isRunningTest()) {
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
            }
            logActivity('Email notification sent successfully to: ' + toAddress);
        } catch (Exception ex) {
            logError(ex);
        }
    }

    public static void sendPaymentSuccessEmails(List<Payment__c> payments) {
        Set<Id> appIds = new Set<Id>();
        for (Payment__c p : payments) {
            if (p.Application__c != null) {
                appIds.add(p.Application__c);
            }
        }
        if (appIds.isEmpty()) return;
        Map<Id, Application__c> appMap = new Map<Id, Application__c>([
            SELECT Id, Student__r.Name, Student__r.Email__c, Course__c 
            FROM Application__c 
            WHERE Id IN :appIds
        ]);
        
        NotificationService service = new NotificationService();
        for (Payment__c p : payments) {
            Application__c app = appMap.get(p.Application__c);
            if (app != null && app.Student__r.Email__c != null) {
                String subject = 'Payment Received - SAMS';
                String body = 'Dear ' + app.Student__r.Name + ',\n\nWe have received your payment of $' + p.Amount__c + ' for the course ' + app.Course__c + '.\n\nBest Regards,\nSAMS Team';
                service.sendEmailNotification(app.Student__r.Email__c, subject, body);
            }
        }
    }
    
    public static void sendPaymentFailureEmails(List<Payment__c> payments) {
        Set<Id> appIds = new Set<Id>();
        for (Payment__c p : payments) {
            if (p.Application__c != null) {
                appIds.add(p.Application__c);
            }
        }
        if (appIds.isEmpty()) return;
        Map<Id, Application__c> appMap = new Map<Id, Application__c>([
            SELECT Id, Student__r.Name, Student__r.Email__c, Course__c 
            FROM Application__c 
            WHERE Id IN :appIds
        ]);
        
        NotificationService service = new NotificationService();
        for (Payment__c p : payments) {
            Application__c app = appMap.get(p.Application__c);
            if (app != null && app.Student__r.Email__c != null) {
                String subject = 'Payment Failed - SAMS';
                String body = 'Dear ' + app.Student__r.Name + ',\n\nYour payment of $' + p.Amount__c + ' for the course ' + app.Course__c + ' has failed. Please contact admissions.\n\nBest Regards,\nSAMS Team';
                service.sendEmailNotification(app.Student__r.Email__c, subject, body);
            }
        }
    }
}
