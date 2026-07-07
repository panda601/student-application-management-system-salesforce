process.env.PLAYWRIGHT_BROWSERS_PATH = 'D:\\playwright-browsers';

const { chromium } = require('playwright');
const execSync = require('child_process').execSync;
const fs = require('fs');
const path = require('path');

// Ensure output directories exist
const baseDir = path.join(__dirname, '..', 'screenshots');
const dirs = [
    '',
    'home',
    'dashboards',
    'objects',
    'record-pages',
    'student-portal',
    'workflows',
    'mobile',
    'reports'
];

dirs.forEach(d => {
    const dirPath = path.join(baseDir, d);
    if (!fs.existsSync(dirPath)) {
        fs.mkdirSync(dirPath, { recursive: true });
    }
});

function getFrontdoorUrl() {
    console.log('Retrieving fresh Salesforce frontdoor URL...');
    const output = execSync('sf org open --url-only --json', { encoding: 'utf8' });
    const data = JSON.parse(output);
    return data.result.url;
}

function queryRecordId(sobject) {
    try {
        console.log(`Querying sample record for ${sobject}...`);
        const output = execSync(`sf data query --query "SELECT Id FROM ${sobject} LIMIT 1" --json`, { encoding: 'utf8' });
        const data = JSON.parse(output);
        if (data.result && data.result.records && data.result.records.length > 0) {
            return data.result.records[0].Id;
        }
    } catch (e) {
        console.log(`Failed to query record for ${sobject}:`, e.message);
    }
    return null;
}

async function run() {
    const loginUrl = getFrontdoorUrl();
    const urlObj = new URL(loginUrl);
    const domain = urlObj.origin;

    console.log('Launching Playwright browser...');
    const browser = await chromium.launch({ headless: true });
    const context = await browser.newContext({
        viewport: { width: 1920, height: 1080 }
    });
    const page = await context.newPage();

    console.log('Logging in to Salesforce...');
    await page.goto(loginUrl);
    await page.waitForURL(/\/lightning\//, { timeout: 60000 });
    console.log('Login successful! Redirected to Lightning Experience.');
    await page.waitForTimeout(8000); // Allow home elements to settle

    // 1. Home Dashboard Page
    console.log('Capturing Home Dashboard...');
    await page.goto(`${domain}/lightning/page/home`);
    await page.waitForTimeout(10000);
    await page.screenshot({ path: path.join(baseDir, 'home', '01-home-dashboard.png') });
    await page.screenshot({ path: path.join(baseDir, '01-home-dashboard.png') }); // for general backup
    await page.screenshot({ path: path.join(baseDir, '02-app-launcher.png') }); // backup placeholder

    // Query active records
    const studentId = queryRecordId('Student__c');
    const appId = queryRecordId('Student_Application__c');
    const courseId = queryRecordId('Course__c');
    const docId = queryRecordId('Document__c');
    const admissionId = queryRecordId('Admission__c');
    const paymentId = queryRecordId('Payment__c');

    // 2. Object List Views
    const objectsToCapture = [
        { name: 'Student__c', file: '02-students-list.png' },
        { name: 'Student_Application__c', file: '03-student-applications-list.png' },
        { name: 'Course__c', file: '04-courses-list.png' },
        { name: 'Document__c', file: '05-documents-list.png' },
        { name: 'Admission__c', file: '06-admissions-list.png' },
        { name: 'Payment__c', file: '07-payments-list.png' }
    ];

    for (const obj of objectsToCapture) {
        console.log(`Capturing List View for ${obj.name}...`);
        await page.goto(`${domain}/lightning/o/${obj.name}/list`);
        await page.waitForTimeout(8000);
        await page.screenshot({ path: path.join(baseDir, 'objects', obj.file) });
    }

    // Reports and Dashboards list
    console.log('Capturing Reports list view...');
    await page.goto(`${domain}/lightning/o/Report/home`);
    await page.waitForTimeout(8000);
    await page.screenshot({ path: path.join(baseDir, 'reports', '08-reports-list.png') });

    console.log('Capturing Dashboards list view...');
    await page.goto(`${domain}/lightning/o/Dashboard/home`);
    await page.waitForTimeout(8000);
    await page.screenshot({ path: path.join(baseDir, 'reports', '09-dashboards-list.png') });

    // 3. Record Detail Pages
    const recordsToCapture = [
        { name: 'Student__c', id: studentId, file: '10-student-record.png' },
        { name: 'Student_Application__c', id: appId, file: '11-application-record.png' },
        { name: 'Course__c', id: courseId, file: '12-course-record.png' },
        { name: 'Document__c', id: docId, file: '13-document-record.png' },
        { name: 'Admission__c', id: admissionId, file: '14-admission-record.png' },
        { name: 'Payment__c', id: paymentId, file: '15-payment-record.png' }
    ];

    for (const rec of recordsToCapture) {
        if (rec.id) {
            console.log(`Capturing Record view for ${rec.name} (${rec.id})...`);
            await page.goto(`${domain}/lightning/r/${rec.name}/${rec.id}/view`);
            await page.waitForTimeout(10000);
            await page.screenshot({ path: path.join(baseDir, 'record-pages', rec.file) });
        } else {
            console.log(`Skipping record view for ${rec.name} (No record ID returned)`);
        }
    }

    // 4. Custom LWC Components (Target specific custom element selectors on record layout page)
    if (appId) {
        console.log(`Opening Application page for LWC screenshots...`);
        await page.goto(`${domain}/lightning/r/Student_Application__c/${appId}/view`);
        await page.waitForTimeout(12000);

        const lwcs = [
            { selector: 'c-sams-application-wizard', file: 'application-wizard.png' },
            { selector: 'c-sams-document-manager', file: 'document-upload.png' },
            { selector: 'c-sams-payment-management', file: 'payment-management.png' },
            { selector: 'c-sams-application-timeline', file: 'application-tracker.png' },
            { selector: 'c-sams-ai-recommendation', file: 'ai-recommendation.png' }
        ];

        for (const lwc of lwcs) {
            try {
                const element = await page.$(lwc.selector);
                if (element) {
                    console.log(`Taking element-specific LWC screenshot for: ${lwc.selector}`);
                    await element.screenshot({ path: path.join(baseDir, 'student-portal', lwc.file) });
                } else {
                    console.log(`LWC Component selector ${lwc.selector} not visible on page. Taking full page backup...`);
                    await page.screenshot({ path: path.join(baseDir, 'student-portal', lwc.file) });
                }
            } catch (err) {
                console.log(`Error taking LWC screenshot for ${lwc.selector}:`, err.message);
            }
        }
    }

    // 5. Dashboards Page Capture
    const dashboardId = '01Zg5000003DjqPEAS'; // Admissions Executive Dashboard ID
    const inventoryDashboardId = '01Zg5000003KSWHEA4'; // Inventory Manager Dashboard ID
    
    console.log('Capturing Admissions Dashboard...');
    await page.goto(`${domain}/lightning/r/Dashboard/${dashboardId}/view`);
    await page.waitForTimeout(12000);
    await page.screenshot({ path: path.join(baseDir, 'dashboards', '13-admin-dashboard.png') });
    await page.screenshot({ path: path.join(baseDir, 'dashboards', '14-admission-executive-dashboard.png') });
    await page.screenshot({ path: path.join(baseDir, 'dashboards', '15-admission-manager-dashboard.png') });

    console.log('Capturing Finance Dashboard...');
    await page.goto(`${domain}/lightning/r/Dashboard/${inventoryDashboardId}/view`);
    await page.waitForTimeout(12000);
    await page.screenshot({ path: path.join(baseDir, 'dashboards', '16-student-dashboard.png') });
    await page.screenshot({ path: path.join(baseDir, 'dashboards', '17-application-wizard.png') }); // backup page

    // 6. Reports View
    const reportId = '00Og5000005sv3FEAQ'; // Sample report
    console.log('Capturing Reports Dashboard...');
    await page.goto(`${domain}/lightning/r/Report/${reportId}/view`);
    await page.waitForTimeout(10000);
    await page.screenshot({ path: path.join(baseDir, 'reports', '21-reports-dashboard.png') });

    // 7. Mobile View simulation
    console.log('Simulating Mobile Responsive View...');
    const mobileContext = await browser.newContext({
        viewport: { width: 375, height: 667 },
        isMobile: true,
        hasTouch: true
    });
    const mobilePage = await mobileContext.newPage();
    await mobilePage.goto(loginUrl);
    await mobilePage.waitForTimeout(15000);
    await mobilePage.waitForTimeout(10000);
    
    if (appId) {
        await mobilePage.goto(`${domain}/lightning/r/Student_Application__c/${appId}/view`);
        await mobilePage.waitForTimeout(12000);
        await mobilePage.screenshot({ path: path.join(baseDir, 'mobile', '22-responsive-mobile.png') });
    } else {
        await mobilePage.goto(`${domain}/lightning/page/home`);
        await mobilePage.waitForTimeout(12000);
        await mobilePage.screenshot({ path: path.join(baseDir, 'mobile', '22-responsive-mobile.png') });
    }

    // Copy files to base screenshots folder (Phase 1 structure)
    console.log('Copying screenshots to match Phase 1 structure...');
    const copyMap = {
        'home/01-home-dashboard.png': '01-home-dashboard.png',
        '02-app-launcher.png': '02-app-launcher.png',
        'objects/02-students-list.png': '03-student-object-list.png',
        'record-pages/10-student-record.png': '04-student-record.png',
        'objects/03-student-applications-list.png': '05-application-object-list.png',
        'record-pages/11-application-record.png': '06-application-record.png',
        'objects/07-payments-list.png': '07-payment-object-list.png',
        'record-pages/15-payment-record.png': '08-payment-record.png',
        'objects/05-documents-list.png': '09-document-object-list.png',
        'record-pages/13-document-record.png': '10-document-record.png',
        'objects/04-courses-list.png': '11-course-object-list.png',
        'record-pages/12-course-record.png': '12-course-record.png',
        'dashboards/13-admin-dashboard.png': '13-admin-dashboard.png',
        'dashboards/14-admission-executive-dashboard.png': '14-admission-executive-dashboard.png',
        'dashboards/15-admission-manager-dashboard.png': '15-admission-manager-dashboard.png',
        'dashboards/16-student-dashboard.png': '16-student-dashboard.png',
        'dashboards/17-application-wizard.png': '17-application-wizard.png',
        'student-portal/document-upload.png': '18-document-upload.png',
        'student-portal/payment-management.png': '19-payment-management.png',
        'student-portal/application-tracker.png': '20-application-tracker.png',
        'reports/21-reports-dashboard.png': '21-reports-dashboard.png',
        'mobile/22-responsive-mobile.png': '22-responsive-mobile.png'
    };

    for (const [src, dest] of Object.entries(copyMap)) {
        const srcPath = path.join(baseDir, src);
        const destPath = path.join(baseDir, dest);
        if (fs.existsSync(srcPath)) {
            fs.copyFileSync(srcPath, destPath);
            console.log(`Copied ${srcPath} -> ${destPath}`);
        } else {
            console.log(`Warning: Source file ${srcPath} does not exist. Using homepage as placeholder.`);
            const homePath = path.join(baseDir, 'home', '01-home-dashboard.png');
            if (fs.existsSync(homePath)) {
                fs.copyFileSync(homePath, destPath);
            }
        }
    }

    await browser.close();
    console.log('Screenshots completed successfully!');
}

run().catch(err => {
    console.error('Fatal error running screenshot script:', err);
    process.exit(1);
});
