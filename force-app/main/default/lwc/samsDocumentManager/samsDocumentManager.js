import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SamsDocumentManager extends LightningElement {
    @api recordId;

    @track documents = [
        {
            name: 'transcript',
            label: 'Academic Transcript',
            desc: 'Official copy of high school or university grades',
            status: 'Verified',
            statusClass: 'slds-badge slds-theme_success',
            hasFile: true
        },
        {
            name: 'passport',
            label: 'Passport copy',
            desc: 'Biographical page showing name and date of birth',
            status: 'Pending Verification',
            statusClass: 'slds-badge slds-theme_warning',
            hasFile: true
        },
        {
            name: 'english',
            label: 'English Proficiency Proof',
            desc: 'TOEFL, IELTS, or Duolingo English score report',
            status: 'Missing',
            statusClass: 'slds-badge slds-theme_error',
            hasFile: false
        }
    ];

    acceptedFormats = ['.pdf', '.png', '.jpg', '.jpeg'];

    handleUploadFinished(event) {
        const docName = event.target.name;
        const uploadedFiles = event.detail.files;
        
        // Update status to Pending Verification
        this.documents = this.documents.map(doc => {
            if (doc.name === docName) {
                return {
                    ...doc,
                    status: 'Pending Verification',
                    statusClass: 'slds-badge slds-theme_warning',
                    hasFile: true
                };
            }
            return doc;
        });

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Document Uploaded',
                message: uploadedFiles.length + ' file(s) uploaded successfully for evaluation.',
                variant: 'success'
            })
        );
    }

    handlePreview(event) {
        const docName = event.target.dataset.name;
        const doc = this.documents.find(d => d.name === docName);
        
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Simulating Preview',
                message: 'Opening preview viewer for: ' + doc.label,
                variant: 'info'
            })
        );
    }
}
