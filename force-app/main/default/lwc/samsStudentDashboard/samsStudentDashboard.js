import { LightningElement, wire, track } from 'lwc';
import getStudents from '@salesforce/apex/SAMS_Controller.getStudents';
import getApplicationsForStudent from '@salesforce/apex/SAMS_Controller.getApplicationsForStudent';

export default class SamsStudentDashboard extends LightningElement {
    @track searchKey = '';
    @track typeFilter = 'All';
    @track selectedStudentId;
    @track students = [];
    @track selectedStudent;
    @track applications = [];
    
    filterOptions = [
        { label: 'All Student Types', value: 'All' },
        { label: 'Domestic Students', value: 'Domestic' },
        { label: 'International Students', value: 'International' }
    ];

    @wire(getStudents, { searchKey: '$searchKey', typeFilter: '$typeFilter' })
    wiredStudents({ error, data }) {
        if (data) {
            this.students = data.map(item => {
                let statusBadgeClass = 'slds-badge ';
                if (item.Status__c === 'Active') {
                    statusBadgeClass += 'slds-theme_success';
                } else if (item.Status__c === 'Suspended') {
                    statusBadgeClass += 'slds-theme_error';
                } else {
                    statusBadgeClass += 'slds-theme_warning';
                }
                
                let itemClass = 'student-item slds-p-around_small ';
                if (item.Id === this.selectedStudentId) {
                    itemClass += 'student-selected';
                }

                return {
                    ...item,
                    statusBadgeClass,
                    itemClass
                };
            });
        } else if (error) {
            console.error('Error fetching students: ', error);
        }
    }

    handleSearchChange(event) {
        this.searchKey = event.target.value;
    }

    handleFilterChange(event) {
        this.typeFilter = event.target.value;
    }

    handleStudentSelect(event) {
        this.selectedStudentId = event.currentTarget.dataset.id;
        this.selectedStudent = this.students.find(s => s.Id === this.selectedStudentId);
        
        // Highlight active selection
        this.students = this.students.map(item => {
            return {
                ...item,
                itemClass: 'student-item slds-p-around_small ' + (item.Id === this.selectedStudentId ? 'student-selected' : '')
            };
        });

        this.fetchStudentApplications();
    }

    fetchStudentApplications() {
        this.applications = null;
        getApplicationsForStudent({ studentId: this.selectedStudentId })
            .then(result => {
                this.applications = result.map(app => {
                    // Recalculate progress for circular bars
                    let progress = app.Application_Progress__c ? Math.round(app.Application_Progress__c) : 0;
                    if (progress > 100) progress = 100;
                    
                    return {
                        ...app,
                        Application_Progress__c: progress,
                        CreatedDate: new Date(app.CreatedDate).toLocaleDateString()
                    };
                });
            })
            .catch(error => {
                console.error('Error fetching applications: ', error);
            });
    }
}
