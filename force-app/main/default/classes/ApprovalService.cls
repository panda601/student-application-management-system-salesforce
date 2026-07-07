public class ApprovalService extends SAMS_BaseService {
    
    public ApprovalService() {
        super('ApprovalService');
    }
    
    public override void logActivity(String message) {
        System.debug('ApprovalService Activity: ' + message);
    }
    
    /**
     * Programmatically submits an Application record for approval
     */
    public void submitApplicationForApproval(Id applicationId, String comment) {
        try {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments(comment);
            req.setObjectId(applicationId);
            req.setSubmitterId(UserInfo.getUserId());
            req.setProcessDefinitionNameOrId('Application_Approval_Process');
            
            Approval.ProcessResult result = Approval.process(req);
            
            if (result.isSuccess()) {
                logActivity('Application submitted for approval successfully. Record ID: ' + applicationId);
            } else {
                logActivity('Failed to submit application: ' + result.getErrors()[0].getMessage());
            }
        } catch (Exception ex) {
            logError(ex);
            throw new AuraHandledException('Error submitting application for approval: ' + ex.getMessage());
        }
    }
}
