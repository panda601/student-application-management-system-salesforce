public abstract class SAMS_BaseService {
    // Encapsulation: Private member variable with public getter
    private String serviceName;
    
    // Constructor
    public SAMS_BaseService(String name) {
        this.serviceName = name;
    }
    
    public String getServiceName() {
        return this.serviceName;
    }
    
    // Abstract method demonstrating Polymorphism (overridden by child services)
    public abstract void logActivity(String message);
    
    // Virtual method demonstrating Polymorphism
    public virtual void processExecution() {
        System.debug('Executing base service: ' + this.serviceName);
    }
    
    // Method overloading demonstrating Polymorphism
    public void logError(Exception ex) {
        logError(ex.getMessage(), 'HIGH');
    }
    
    public void logError(String errorMsg, String severity) {
        System.debug('Error logged in ' + this.serviceName + ': [' + severity + '] ' + errorMsg);
    }
}
