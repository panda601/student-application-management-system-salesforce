public class PaymentService extends SAMS_BaseService {
    
    public PaymentService() {
        super('PaymentService');
    }
    
    public override void logActivity(String message) {
        System.debug('PaymentService Activity: ' + message);
    }
    
    /**
     * Custom logging and alerts for payments
     */
    public void processPaymentAlerts(List<Payment__c> payments) {
        for (Payment__c p : payments) {
            if (p.Payment_Status__c == 'Completed') {
                logActivity('Logged completed payment of $' + p.Amount__c + ' for Application ID: ' + p.Application__c);
            }
        }
    }
}
