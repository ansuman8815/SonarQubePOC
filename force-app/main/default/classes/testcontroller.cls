public with sharing class testcontroller {

    public Account Account { get; set; }
    
    public testcontroller(){
        account = new Account();
    
    }
    
    public PageReference cancel() {
        return null;
    }


    public PageReference save() {
        insert account;
        
        PageReference nextpage = new PageReference('/003/o');
        return nextpage;
    }



}