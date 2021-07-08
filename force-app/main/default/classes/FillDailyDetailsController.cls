public with sharing class FillDailyDetailsController {

    public List<Transaction__c> lstTrans{set;get;}{lstTrans = new List<Transaction__c>();}
    public List<Payment_Due__c> lstPayments{set;get;}{lstPayments = new List<Payment_Due__c>();}
    public String comment{set;get;}{comment='';}
    public date transactionDate{set;get;}
    public List<Payment_Due__c> lstRecentPayments{set;get;}{lstRecentPayments = new List<Payment_Due__c>();}

    public List<CurrentTransaction> lstCT {set;get;}{lstCT= new List<CurrentTransaction>();}
    public integer totalspent{set;get;}
    public String name { get; set; }
    public List<Transaction__c> allTrans;

      
    public class CurrentTransaction{
    public boolean isSelect{set;get;}
    public string Name{set;get;}
    public integer OntheSpotSpent{set;get;}
    public string comments{set;get;}{comments='';}
    public id Id{set;get;}
    public CurrentTransaction(){}
    }
    
    public FillDailyDetailsController(){
        lstRecentPayments=[select id,Comment__c,From__c,To__c,Amount__c from Payment_Due__c order by From__c limit 10];
    
        List<Member__c> lstMembers = [select id,Name from Member__c order by Name];
        for(Member__c member:lstMembers){
            CurrentTransaction crt = new CurrentTransaction();
            crt.Name=member.name;
            crt.id=member.id;
            lstCT.add(crt);
        }
    }
    public pagereference updateDetails(){
    system.debug('+++++lstCT+++++++'+lstCT);
    decimal total =0;
//creating the list of CurrentTranaction object after getting the details from the front end
    for(CurrentTransaction ct:lstCT){
        if(ct.isSelect == True && ct.OntheSpotSpent!=null){
            Transaction__c trans = new Transaction__c();
            trans.On_the_spot_spent__c=ct.OntheSpotSpent;
            trans.Date__c=Date.Today();
            trans.Member__c=ct.id;
            trans.Comments__c=comment;
            System.debug('=====trans==='+trans);
            lstTrans.add(trans);
System.debug('------lstTrans[i]----'+lstTrans);
            }
    }
//Calculate the total spent...
    for(Transaction__c tr:lstTrans)
        total+=tr.On_the_spot_spent__c;
//calculate perhead spent...
    for(Transaction__c tr:lstTrans){
        tr.Per_head_spent__c = (total/lstTrans.size());
    }
    
//insert record to Transaction table...
    insert lstTrans;
    
    System.debug('------FinallstTrans-------'+lstTrans);
    updatepayments();
    return new Pagereference('/apex/FillDailyDetails');
    }
    
//create payments for individuals 
    public void updatepayments(){
    
    List<Transaction__c> a=new List<Transaction__c>();
    List<decimal> receive=new List<decimal>();
    List<decimal> pay=new List<decimal>();
    
    a.addAll(lstTrans);
System.debug('--a'+a);    
       
//calculate the payment and receive amount for individual...
    for(integer i=0;i<a.size();i++)
    {
        if(a[i].On_the_spot_spent__c>a[i].Per_head_spent__c){
            receive.add(a[i].On_the_spot_spent__c - a[i].Per_head_spent__c);
            pay.add(0.0);
        }
        if(a[i].On_the_spot_spent__c<a[i].Per_head_spent__c){
            pay.add(a[i].Per_head_spent__c - a[i].On_the_spot_spent__c);
            receive.add(0.0);
        }
        if(a[i].On_the_spot_spent__c==a[i].Per_head_spent__c){
            pay.add(0.0);
            receive.add(0.0);
        }
    }
System.debug('--receive'+receive);        
System.debug('--pay'+pay);        
    
//calculate who to pay what amount to whom...  
    for(integer i=0;i<a.size();i++){
        if(pay[i]>0.0){
            for(integer j=0;j<a.size();j++){
                if(receive[j]>0.0 && receive[j]>=pay[i]){
                    Payment_Due__c temp=new Payment_Due__c();
                    temp.From__c=a[i].Member__c;
                    temp.To__c=a[j].Member__c;
                    temp.Amount__c=Math.ceil(pay[i]);
                    lstPayments.add(temp);
                    receive[j]-=pay[i];
                    pay[i]=0.0;
                    }
                else if(receive[j]>0.0 && receive[j]<pay[i]){
                    Payment_Due__c temp1=new Payment_Due__c();
                    temp1.From__c=a[i].Member__c;
                    temp1.To__c=a[j].Member__c;
                    temp1.Amount__c=Math.ceil(receive[j]);
                    lstPayments.add(temp1);
                    pay[i]-=receive[j];
                    receive[j]=0.0;
                    }
            }
        }
    }
// writing the date value to the record list  
    for(Payment_Due__c temp:lstPayments) 
    {
        temp.Date__c=Date.Today();
        temp.comment__c=comment;
    }
    
//insert the record    
    insert lstPayments;
System.debug('--receive'+receive);        
System.debug('--pay'+pay);        
    }
 
}