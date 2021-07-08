public with sharing class MemberLoginController {

public string useremail{set;get;}{useremail='';}
public string password{set;get;}{password='';}
public string name{set;get;}{name='';}

public pagereference loginuser(){
List<Member__c> lstMember=new List<Member__c>();
    try{
    lstMember=[select m.name from Member__c m where m.email__c=:useremail and m.password__c=:password];
    name=lstMember[0].name;
    Pagereference p = Page.TransactionDetails;
    p.setRedirect(true);
    p.getParameters().put('id',lstMember[0].id);
    //return new Pagereference('/apex/TransactionDetails?id='+lstMember[0].id);
    return p;
    
    }
    catch (Exception e){
    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops..Bhai!!! Khusi Nai ki Bhai'));
    return null;
    }

}


}