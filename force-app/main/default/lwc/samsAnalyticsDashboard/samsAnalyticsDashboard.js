import { LightningElement, wire, track } from 'lwc';
import getDashboardMetrics from '@salesforce/apex/SAMS_Controller.getDashboardMetrics';
import getApplicationStatusCounts from '@salesforce/apex/SAMS_Controller.getApplicationStatusCounts';

export default class SamsAnalyticsDashboard extends LightningElement {
    @track metrics = {
        totalStudents: 0,
        totalApps: 0,
        approvedApps: 0,
        revenueCollected: 0.00
    };

    @track chartData = {
        newOffset: 439.8,
        reviewOffset: 439.8,
        approvedOffset: 439.8
    };

    @track newPercent = 25;
    @track reviewPercent = 35;
    @track approvedPercent = 30;
    @track rejectedPercent = 10;

    get formattedRevenue() {
        return this.metrics.revenueCollected ? this.metrics.revenueCollected.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) : '0.00';
    }

    @wire(getDashboardMetrics)
    wiredMetrics({ error, data }) {
        if (data) {
            this.metrics = data;
        } else if (error) {
            console.error('Error fetching metrics: ', error);
        }
    }

    @wire(getApplicationStatusCounts)
    wiredStatusCounts({ error, data }) {
        if (data) {
            let totalCount = 0;
            let statusMap = {
                'New': 0,
                'In Review': 0,
                'Approved': 0,
                'Rejected': 0
            };

            data.forEach(item => {
                let status = item.status;
                if (status) {
                    statusMap[status] = item.count;
                    totalCount += item.count;
                }
            });

            if (totalCount > 0) {
                this.newPercent = Math.round((statusMap['New'] / totalCount) * 100);
                this.reviewPercent = Math.round((statusMap['In Review'] / totalCount) * 100);
                this.approvedPercent = Math.round((statusMap['Approved'] / totalCount) * 100);
                this.rejectedPercent = Math.round((statusMap['Rejected'] / totalCount) * 100);

                // Math calculations for SVG dashboard circular charts (Circumference = 439.8)
                const c = 439.8;
                this.chartData.newOffset = c - (this.newPercent / 100 * c);
                this.chartData.reviewOffset = c - ((this.newPercent + this.reviewPercent) / 100 * c);
                this.chartData.approvedOffset = c - ((this.newPercent + this.reviewPercent + this.approvedPercent) / 100 * c);
            }
        } else if (error) {
            console.error('Error fetching status counts: ', error);
        }
    }
}
