public class StudentService extends SAMS_BaseService {
    
    // Constructor calling super
    public StudentService() {
        super('StudentService');
    }
    
    // Overriding abstract method (Polymorphism)
    public override void logActivity(String message) {
        System.debug('StudentService Activity: ' + message);
    }
    
    /**
     * Generates a unique Student ID code (Format: SAMS-YYYY-XXXX)
     * Demonstrates dynamic SOQL, control statements, data types, and collections
     */
    public void generateStudentCodes(List<Student__c> newStudents) {
        try {
            Integer currentYear = Date.today().year();
            String prefix = 'SAMS-' + currentYear + '-';
            
            // Dynamic SOQL query to find the latest Student ID
            String queryStr = 'SELECT Student_ID__c FROM Student__c WHERE Student_ID__c LIKE \'' + prefix + '%\' ORDER BY Student_ID__c DESC LIMIT 1';
            List<Student__c> latestStudents = Database.query(queryStr);
            
            Integer nextSeq = 1;
            if (!latestStudents.isEmpty() && latestStudents[0].Student_ID__c != null) {
                String latestId = latestStudents[0].Student_ID__c;
                String seqStr = latestId.substringAfterLast('-');
                if (seqStr.isNumeric()) {
                    nextSeq = Integer.valueOf(seqStr) + 1;
                }
            }
            
            // Generate codes for new students
            for (Student__c s : newStudents) {
                if (String.isBlank(s.Student_ID__c)) {
                    s.Student_ID__c = prefix + String.valueOf(nextSeq).leftPad(4, '0');
                    nextSeq++;
                }
            }
            logActivity('Successfully generated Student IDs for ' + newStudents.size() + ' records.');
        } catch (Exception ex) {
            logError(ex);
            throw new AuraHandledException('Error generating student codes: ' + ex.getMessage());
        }
    }
    
    /**
     * Check duplicates and enforce validation
     * Demonstrates collections: Set, Map
     */
    public void checkDuplicateEmails(List<Student__c> newStudents) {
        Set<String> emailSet = new Set<String>();
        for (Student__c s : newStudents) {
            if (s.Email__c != null) {
                emailSet.add(s.Email__c);
            }
        }
        
        if (emailSet.isEmpty()) return;
        
        // Find existing students with these emails
        List<Student__c> existing = [SELECT Id, Email__c FROM Student__c WHERE Email__c IN :emailSet];
        Map<String, Student__c> emailMap = new Map<String, Student__c>();
        for (Student__c s : existing) {
            emailMap.put(s.Email__c, s);
        }
        
        for (Student__c s : newStudents) {
            if (s.Email__c != null && emailMap.containsKey(s.Email__c)) {
                s.Email__c.addError('A student with this email address already exists.');
            }
        }
    }
}
