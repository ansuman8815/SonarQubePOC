/**
 * This class is used for creating and editing Rule
 **/

public with sharing class ManageRules{
    public Rule__c newrule     {get;set;}  
    public String objType   {get;set;}
    public List<SelectOption> objOptions    {get;set;}
    public boolean edit {get;set;}
    String ruleId;
    
    public ManageRules(Apexpages.StandardController stdcon){
        ruleId = stdcon.getId();
        newrule = new Rule__c();
        objOptions = new List<SelectOption>();
        edit=false;
        /** 
         * Add standard Objects
         */
         objOptions.add(new SelectOption('',''));
         objOptions.add(new SelectOption('Account','Account'));
         objOptions.add(new SelectOption('Contact','Contact'));
         objOptions.add(new SelectOption('Opportunity','Opportunity'));
         objOptions.add(new SelectOption('Case','Case'));
         objOptions.add(new SelectOption('Lead','Lead'));
         objOptions.add(new SelectOption('Campaign','Campaign'));
         objOptions.add(new SelectOption('Quote','Quote'));
         objOptions.add(new SelectOption('Product2','Product'));
         //objOptions.add(new SelectOption('ForeCast','Forecast'));
          
        Map<String, Schema.SObjectType> mapObj = Schema.getGlobalDescribe();
        for(String objname:mapObj.keySet()){
            Schema.SObjectType sobj = mapObj.get(objname);
            Schema.DescribeSObjectResult descRes = sobj.getDescribe();
            /** 
             * Add custom objects
             */
            if(descRes.isCustom() && !descRes.isCustomSetting()){
                String objLabel = descRes.getLabel();
                objOptions.add(new SelectOption(objName,objLabel));
            }
        }
        
        /* Edit Rule */
        if(ruleId!=null){
            edit=true;
            newrule = [select name,object_Type__c,enabled__c from rule__c where id=:ruleId];
            if(newrule!=null){
                objtype=newrule.object_Type__c;
            }
        }
        
        
    }
   
    
    public PageReference saveRule(){
        newrule.object_type__c = objtype;
        try{
            Database.upsert(newrule);
            return(new PageReference('/'+newrule.id));
        }
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getDMLMessage(0));
            ApexPages.addMessage(msg);
            return null;
        }
        
    }
    
    public PageReference saveAndNewRule(){
        newrule.object_type__c = objtype;
         edit=false;
        try{
            Database.upsert(newrule);
            newrule = new Rule__c();
            return(new PageReference('/apex/manageRules'));
        }
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.severity.Error,e.getDMLMessage(0));
            ApexPages.addMessage(msg);
            return null;
        }
        
    }    
    
    
}