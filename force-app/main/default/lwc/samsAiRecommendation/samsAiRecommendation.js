import { LightningElement, api, wire, track } from 'lwc';
import getAiRecommendation from '@salesforce/apex/SamsDashboardController.getAiRecommendation';

export default class SamsAiRecommendation extends LightningElement {
    @api recordId;
    @track score = 75;
    @track risk = 'Low';
    @track missingDocs = [];
    @track isLoaded = false;

    @wire(getAiRecommendation, { recordId: '$recordId' })
    wiredScorecard({ error, data }) {
        if (data) {
            this.score = data.approvalLikelihood;
            this.risk = data.riskLevel;
            this.missingDocs = data.missingDocs || [];
            this.isLoaded = true;
        } else if (error) {
            console.error('Error fetching AI recommendation', error);
        }
    }

    get scoreColorClass() {
        if (this.score >= 80) return 'text-green';
        if (this.score >= 50) return 'text-orange';
        return 'text-red';
    }

    get riskClass() {
        return `risk-badge risk-${this.risk.toLowerCase()}`;
    }
}
