public with sharing class mysecondpagecontroller {

    public Account Account { get; set; }
    
    public mysecondpagecontroller(){
        account = new Account();
    
    } 
   
    public PageReference cancel() {
        return null;
    }


    public PageReference save() {
        insert account;
        
        PageReference nextPage = new PageReference('/003/o');
        return nextPage;

    }


}