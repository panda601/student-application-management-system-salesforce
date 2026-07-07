import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createCompleteApplicationPackage from '@salesforce/apex/SAMS_Controller.createCompleteApplicationPackage';

export default class SamsApplicationWizard extends LightningElement {
    @track currentStep = '1';
    @track isLoading = false;

    // Track step data
    @track studentData = {
        name: '',
        email: '',
        phone: '',
        dob: '',
        type: 'Domestic',
        country: 'United States',
        address: ''
    };

    @track appData = {
        course: 'Computer Science',
        intake: 'Fall 2026',
        level: 'Undergraduate',
        fee: 10000.00
    };

    @track payData = {
        amount: 2500.00,
        method: 'Credit Card',
        date: new Date().toISOString().substring(0, 10)
    };

    // Picklist options
    studentTypeOptions = [
        { label: 'Domestic Student', value: 'Domestic' },
        { label: 'International Student', value: 'International' }
    ];

    courseOptions = [
        { label: 'Computer Science', value: 'Computer Science' },
        { label: 'Business Administration', value: 'Business Administration' },
        { label: 'Data Science', value: 'Data Science' },
        { label: 'Mechanical Engineering', value: 'Mechanical Engineering' },
        { label: 'Electrical Engineering', value: 'Electrical Engineering' }
    ];

    intakeOptions = [
        { label: 'Fall 2026', value: 'Fall 2026' },
        { label: 'Spring 2027', value: 'Spring 2027' },
        { label: 'Summer 2027', value: 'Summer 2027' }
    ];

    levelOptions = [
        { label: 'Undergraduate Program', value: 'Undergraduate' },
        { label: 'Postgraduate Program', value: 'Postgraduate' }
    ];

    paymentMethodOptions = [
        { label: 'Credit Card', value: 'Credit Card' },
        { label: 'Bank Transfer', value: 'Bank Transfer' },
        { label: 'PayPal', value: 'PayPal' },
        { label: 'Stripe', value: 'Stripe' }
    ];

    // Getters for step visibility
    get isStep1() { return this.currentStep === '1'; }
    get isStep2() { return this.currentStep === '2'; }
    get isStep3() { return this.currentStep === '3'; }
    get isStep4() { return this.currentStep === '4'; }

    get isFirstStep() { return this.currentStep === '1'; }
    get isLastStep() { return this.currentStep === '4'; }

    // Input Handlers - Step 1
    handleStudentName(e) { this.studentData.name = e.target.value; }
    handleStudentEmail(e) { this.studentData.email = e.target.value; }
    handleStudentPhone(e) { this.studentData.phone = e.target.value; }
    handleStudentDob(e) { this.studentData.dob = e.target.value; }
    handleStudentType(e) { this.studentData.type = e.target.value; }
    handleStudentCountry(e) { this.studentData.country = e.target.value; }
    handleStudentAddress(e) { this.studentData.address = e.target.value; }

    // Input Handlers - Step 2
    handleAppCourse(e) { this.appData.course = e.target.value; }
    handleAppIntake(e) { this.appData.intake = e.target.value; }
    handleAppLevel(e) { this.appData.level = e.target.value; }
    handleAppFee(e) { this.appData.fee = parseFloat(e.target.value); }

    // Input Handlers - Step 3
    handlePayAmount(e) { this.payData.amount = parseFloat(e.target.value); }
    handlePayMethod(e) { this.payData.method = e.target.value; }
    handlePayDate(e) { this.payData.date = e.target.value; }

    // Validation
    validateStepFields(stepClass) {
        const allValid = [
            ...this.template.querySelectorAll(stepClass)
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        return allValid;
    }

    handleNext() {
        if (this.currentStep === '1') {
            if (!this.validateStepFields('.validate-step-1')) return;
            this.currentStep = '2';
        } else if (this.currentStep === '2') {
            if (!this.validateStepFields('.validate-step-2')) return;
            this.currentStep = '3';
        } else if (this.currentStep === '3') {
            if (!this.validateStepFields('.validate-step-3')) return;
            this.currentStep = '4';
        }
    }

    handlePrevious() {
        if (this.currentStep === '2') this.currentStep = '1';
        else if (this.currentStep === '3') this.currentStep = '2';
        else if (this.currentStep === '4') this.currentStep = '3';
    }

    handleSubmit() {
        this.isLoading = true;
        createCompleteApplicationPackage({
            studentName: this.studentData.name,
            email: this.studentData.email,
            phone: this.studentData.phone,
            dob: this.studentData.dob,
            studentType: this.studentData.type,
            country: this.studentData.country,
            address: this.studentData.address,
            course: this.appData.course,
            intake: this.appData.intake,
            level: this.appData.level,
            fee: this.appData.fee,
            depositAmount: this.payData.amount,
            payMethod: this.payData.method,
            payDate: this.payData.date
        })
        .then(result => {
            this.isLoading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Admissions Package Submitted',
                    message: 'Student, application, and deposit payment created successfully.',
                    variant: 'success'
                })
            );
            
            // Reset Wizard
            this.currentStep = '1';
            this.studentData = { name: '', email: '', phone: '', dob: '', type: 'Domestic', country: 'United States', address: '' };
            this.appData = { course: 'Computer Science', intake: 'Fall 2026', level: 'Undergraduate', fee: 10000.00 };
            this.payData = { amount: 2500.00, method: 'Credit Card', date: new Date().toISOString().substring(0, 10) };
        })
        .catch(error => {
            this.isLoading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Submission Failed',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }
}
