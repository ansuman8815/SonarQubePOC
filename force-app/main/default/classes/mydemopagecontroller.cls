public with sharing class mydemopagecontroller {

    public Account Account{ get; set; }
    
    public mydemopagecontroller(){
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