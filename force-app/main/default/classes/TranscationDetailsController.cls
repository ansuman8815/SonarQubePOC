public class TranscationDetailsController {

    public List<Payment_Due__c> lstDuePayments { get; set; } {lstDuePayments = new List<Payment_Due__c>();}
    public List<Payment_Due__c> lstDueApproval { get; set; } {lstDueApproval = new List<Payment_Due__c>();}
    public ID id;
    
    public TranscationDetailsController(){
    Id = Apexpages.currentPage().getParameters().get('id');
    lstDuePayments=[select p.id,p.Amount__c,p.cleared__c,p.To__c,p.from__c,p.From__r.First_Name__c ,p.To__r.First_Name__c,p.comment__c from Payment_Due__c p where p.from__c=:id and p.cleared__c=False];
    lstDueApproval=[select p.id,p.Amount__c,p.cleared__c,p.Approve__c,p.To__c,p.from__c,p.From__r.First_Name__c ,p.To__r.First_Name__c,p.comment__c from Payment_Due__c p where p.To__c=:id and p.cleared__c=True and p.approve__c=False];
    }
    
    public pagereference save(){
    update lstDuePayments;
    lstDuePayments=[select p.id,p.Amount__c,p.cleared__c,p.To__c,p.from__c,p.From__r.First_Name__c ,p.To__r.First_Name__c,p.comment__c from Payment_Due__c p where p.from__c=:id and p.cleared__c=False];
    return null;
    }
    public pagereference save1(){
    update lstDueApproval;
    lstDueApproval=[select p.id,p.Amount__c,p.cleared__c,p.Approve__c,p.To__c,p.from__c,p.From__r.First_Name__c ,p.To__r.First_Name__c,p.comment__c from Payment_Due__c p where p.To__c=:id and p.cleared__c=True and p.approve__c=False];
    return null;
    }
    
    public pagereference logout(){
    return new Pagereference('/apex/MemberLogin');
    }
 }