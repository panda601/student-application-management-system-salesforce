import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getPaymentsForApplication from '@salesforce/apex/SAMS_Controller.getPaymentsForApplication';
import createPaymentRecord from '@salesforce/apex/SAMS_Controller.createPaymentRecord';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import FEE_FIELD from '@salesforce/schema/Application__c.Course_Fee__c';
import PAID_FIELD from '@salesforce/schema/Application__c.Total_Payments__c';
import BALANCE_FIELD from '@salesforce/schema/Application__c.Outstanding_Balance__c';

const FIELDS = [FEE_FIELD, PAID_FIELD, BALANCE_FIELD];

export default class SamsPaymentManagement extends LightningElement {
    @api recordId;

    @track payments = [];
    @track isPosting = false;

    // Form inputs
    @track paymentAmount;
    @track paymentMethod = 'Credit Card';
    @track paymentDate = new Date().toISOString().substring(0, 10);

    paymentMethodOptions = [
        { label: 'Credit Card', value: 'Credit Card' },
        { label: 'Bank Transfer', value: 'Bank Transfer' },
        { label: 'PayPal', value: 'PayPal' },
        { label: 'Stripe', value: 'Stripe' }
    ];

    wiredPaymentsResult;

    // Fetch Application details using LDS for real-time recalculations
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    application;

    get courseFee() {
        return getFieldValue(this.application.data, FEE_FIELD) || 0.00;
    }

    get totalPaid() {
        return getFieldValue(this.application.data, PAID_FIELD) || 0.00;
    }

    get outstandingBalance() {
        return getFieldValue(this.application.data, BALANCE_FIELD) || 0.00;
    }

    // Fetch Payments
    @wire(getPaymentsForApplication, { applicationId: '$recordId' })
    wiredPayments(result) {
        this.wiredPaymentsResult = result;
        if (result.data) {
            this.payments = result.data.map(pay => {
                let statusClass = 'slds-badge ';
                if (pay.Payment_Status__c === 'Completed') statusClass += 'slds-theme_success';
                else if (pay.Payment_Status__c === 'Failed') statusClass += 'slds-theme_error';
                else statusClass += 'slds-theme_warning';

                return {
                    ...pay,
                    StatusClass: statusClass,
                    FormattedDate: new Date(pay.Payment_Date__c).toLocaleDateString()
                };
            });
        } else if (result.error) {
            console.error('Error fetching payments: ', result.error);
        }
    }

    handleAmountChange(e) { this.paymentAmount = parseFloat(e.target.value); }
    handleMethodChange(e) { this.paymentMethod = e.target.value; }
    handleDateChange(e) { this.paymentDate = e.target.value; }

    validateInputs() {
        const allValid = [
            ...this.template.querySelectorAll('.validate-payment')
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        return allValid;
    }

    handlePostPayment() {
        if (!this.validateInputs()) return;

        this.isPosting = true;
        createPaymentRecord({
            applicationId: this.recordId,
            amount: this.paymentAmount,
            method: this.paymentMethod,
            paymentDate: this.paymentDate
        })
        .then(() => {
            this.isPosting = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Payment Recorded',
                    message: 'Payment of $' + this.paymentAmount + ' has been completed.',
                    variant: 'success'
                })
            );
            this.paymentAmount = null;
            
            // Refresh wire adapters
            return refreshApex(this.wiredPaymentsResult);
        })
        .catch(error => {
            this.isPosting = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Payment Failed',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }
}
