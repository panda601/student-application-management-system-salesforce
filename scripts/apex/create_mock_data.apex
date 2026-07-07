// Delete existing records to avoid conflicts and keep it clean
delete [SELECT Id FROM Payment__c];
delete [SELECT Id FROM Application__c];
delete [SELECT Id FROM Student__c];
delete [SELECT Id FROM Project__c];

Project__c p = new Project__c(Name = 'SAMS Project');
insert p;

// Create students
List<Student__c> students = new List<Student__c>();
students.add(new Student__c(Name = 'Alice Smith', Email__c = 'alice.smith@example.com', Date_of_Birth__c = Date.newInstance(2002, 5, 15), Student_Type__c = 'Domestic', Country__c = 'United States', Status__c = 'Active', Address__c = '123 Main St, New York, NY'));
students.add(new Student__c(Name = 'Bob Jones', Email__c = 'bob.jones@example.com', Date_of_Birth__c = Date.newInstance(2001, 9, 22), Student_Type__c = 'Domestic', Country__c = 'United States', Status__c = 'Active', Address__c = '456 Oak Ave, Boston, MA'));
students.add(new Student__c(Name = 'Carlos Rodriguez', Email__c = 'carlos.r@example.com', Date_of_Birth__c = Date.newInstance(2000, 2, 10), Student_Type__c = 'International', Country__c = 'Mexico', Status__c = 'Active', Address__c = 'Paseo de la Reforma 45, CDMX'));
students.add(new Student__c(Name = 'Diana Chen', Email__c = 'diana.chen@example.com', Date_of_Birth__c = Date.newInstance(2003, 11, 30), Student_Type__c = 'International', Country__c = 'Canada', Status__c = 'Active', Address__c = '789 Maple Rd, Vancouver, BC'));
students.add(new Student__c(Name = 'Ethan Hunt', Email__c = 'ethan.hunt@example.com', Date_of_Birth__c = Date.newInstance(1999, 7, 4), Student_Type__c = 'Domestic', Country__c = 'United States', Status__c = 'Suspended', Address__c = '101 Pine Dr, Seattle, WA'));
insert students;

// Create applications
List<Application__c> apps = new List<Application__c>();
apps.add(new Application__c(Student__c = students[0].Id, Course__c = 'Computer Science', Intake__c = 'Fall 2026', Course_Fee__c = 12000, Status__c = 'Approved', Project__c = p.Id));
apps.add(new Application__c(Student__c = students[1].Id, Course__c = 'Business Administration', Intake__c = 'Fall 2026', Course_Fee__c = 10000, Status__c = 'In Review', Project__c = p.Id));
apps.add(new Application__c(Student__c = students[2].Id, Course__c = 'Mechanical Engineering', Intake__c = 'Spring 2027', Course_Fee__c = 15000, Status__c = 'New', Project__c = p.Id));
apps.add(new Application__c(Student__c = students[3].Id, Course__c = 'Data Science', Intake__c = 'Fall 2026', Course_Fee__c = 13000, Status__c = 'New', Project__c = p.Id));
insert apps;

// Create payments
List<Payment__c> payments = new List<Payment__c>();
// Alice has paid fully to satisfy zero-balance
payments.add(new Payment__c(Application__c = apps[0].Id, Amount__c = 12000, Payment_Date__c = Date.today(), Payment_Method__c = 'Credit Card', Payment_Status__c = 'Completed'));
// Bob has paid partially
payments.add(new Payment__c(Application__c = apps[1].Id, Amount__c = 5000, Payment_Date__c = Date.today(), Payment_Method__c = 'Bank Transfer', Payment_Status__c = 'Completed'));
payments.add(new Payment__c(Application__c = apps[1].Id, Amount__c = 1000, Payment_Date__c = Date.today().addDays(-5), Payment_Method__c = 'Credit Card', Payment_Status__c = 'Completed'));
// Carlos has pending payment
payments.add(new Payment__c(Application__c = apps[2].Id, Amount__c = 2000, Payment_Date__c = Date.today(), Payment_Method__c = 'PayPal', Payment_Status__c = 'Pending'));
insert payments;
