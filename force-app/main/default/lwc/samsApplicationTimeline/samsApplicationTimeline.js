import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import STATUS_FIELD from '@salesforce/schema/Application__c.Status__c';
import PAY_FIELD from '@salesforce/schema/Application__c.Total_Payments__c';

const FIELDS = [STATUS_FIELD, PAY_FIELD];

export default class SamsApplicationTimeline extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    application;

    get status() {
        return getFieldValue(this.application.data, STATUS_FIELD);
    }

    get payments() {
        return getFieldValue(this.application.data, PAY_FIELD) || 0.00;
    }

    get step1Class() {
        return 'timeline-step step-completed'; // Submitted is always completed
    }

    get step2Class() {
        let cls = 'timeline-step ';
        if (this.payments > 0) {
            cls += 'step-completed';
        } else if (this.status === 'New') {
            cls += 'step-active';
        } else {
            cls += 'step-inactive';
        }
        return cls;
    }

    get step3Class() {
        let cls = 'timeline-step ';
        if (this.status === 'Approved' || this.status === 'Rejected') {
            cls += 'step-completed';
        } else if (this.status === 'In Review') {
            cls += 'step-active';
        } else {
            cls += 'step-inactive';
        }
        return cls;
    }

    get step4Class() {
        let cls = 'timeline-step ';
        if (this.status === 'Approved') {
            cls += 'step-completed-success';
        } else if (this.status === 'Rejected') {
            cls += 'step-completed-error';
        } else {
            cls += 'step-inactive';
        }
        return cls;
    }

    get decisionLabel() {
        if (this.status === 'Rejected') return 'Rejected';
        return 'Admissions Decision';
    }

    get decisionDetail() {
        if (this.status === 'Approved') return 'Application Accepted';
        if (this.status === 'Rejected') return 'Application Declined';
        return 'Decision pending review';
    }

    get connectionStyle() {
        let pct = 0;
        if (this.payments > 0) pct = 33;
        if (this.status === 'In Review') pct = 66;
        if (this.status === 'Approved' || this.status === 'Rejected') pct = 100;
        return 'width: ' + pct + '%;';
    }
}
