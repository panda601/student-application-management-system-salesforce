public with sharing class PaymentTriggerHandler {
    private PaymentService paymentServ;
    
    public PaymentTriggerHandler() {
        this.paymentServ = new PaymentService();
    }
    
    public void onAfterInsert(List<Payment__c> newPayments) {
        paymentServ.processPaymentAlerts(newPayments);
    }
}
