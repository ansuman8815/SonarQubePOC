/**
 * This class is used for creating and editing Rule Actions
 */

public with sharing class ManageRuleActions{

    public RuleAction__c newRuleAction{get;set;}
    public Rule__c rule ;
    public String objType   {get;set;}
    public String fieldType {get;set;}
    public List<SelectOption> objOptions    {get;set;}
    public List<SelectOption> fieldOption   {get;set;} 
    String ruleActionId;
    public boolean edit {get;set;}
    Map<String, Schema.SObjectField> mapField;
    String ruleObjType;
    
    public ManageRuleActions(Apexpages.StandardController stdcon){
        ruleActionId = stdcon.getId();
        newRuleAction = (RuleAction__c)stdcon.getRecord();
        objOptions = new List<SelectOption>();
        edit=false;
        
        if(ruleActionId!=null){
         /** 
          * Edit existing Record
          */ 
            edit=true;
            newRuleAction = [select Name,Field_Name__c,Type__c,Related_Object__c,Rule__c,Value__c,Enabled__c,rule__r.object_type__c
                                from RuleAction__c where id=:ruleActionId];
                                
            objType = newRuleAction.Related_Object__c;
            ruleObjType=newRuleAction.rule__r.object_type__c;
           
         }
        else{
         /**
          * New Record
          */
	         edit=false;
	         rule = [select object_type__c from Rule__c where id=:newRuleAction.rule__c];
	         if(rule!=null){
	            newRuleAction.related_object__c = rule.object_type__c;
	            objType = rule.object_type__c;
	            ruleObjType = objType;
          	}
         } 
         if(objType!= null){
         
            populateFields(objType);
            /**
             * Get list of child objects of object on which rule is defined
             **/
            Map<String, Schema.SObjectType> mapObj = Schema.getGlobalDescribe();
            Schema.SObjectType sobj = mapObj.get(objType);
            List<Schema.ChildRelationship> listChild = sobj.getDescribe().getChildRelationships();
            for(Schema.ChildRelationship child: listChild){
                Schema.DescribeSObjectResult descRes = child.getChildSObject().getDescribe();
                objOptions.add(new SelectOption(descRes.getName(),descRes.getLabel()));
            }
        }
     }
  
    public PageReference  getFieldNames(){
         objType= Apexpages.currentPage().getParameters().get('parentName');
         populateFields(objType);
         return null;
    }
    
    /** 
     * This method is used to populate the fields of given Object
     */
    public void populateFields(String objType){
         fieldOption= new List<SelectOption>();
         Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
         string parent = objType;
         Schema.SObjectType sobjTypeParent = gd.get(parent);
         Schema.DescribeSObjectResult parentObjFields= sobjTypeParent.getDescribe();
         mapField = parentObjFields.fields.getMap();
         for(String fieldname:mapField.keySet()){
            Schema.SObjectField sfield = mapField.get(fieldname);
            Schema.DescribeFieldResult descResField = sfield.getDescribe();
            String fieldLabel = descResField.getLabel();
            fieldOption.add(new SelectOption(descResField.getName(),fieldLabel));
            
        }
        fieldType= newRuleAction.field_name__c;
       
    }
    
    public PageReference saveRuleAction(){
            newRuleAction.Related_Object__c = objtype;
            newRuleAction.Field_Name__c =  fieldType;
            try{
                Database.upsert(newRuleAction);
                return(new PageReference('/'+newRuleAction.id));
            }
            catch(Exception e){
                return null;
            }   
    }
    public PageReference saveAndNewRuleAction(){
            newRuleAction.Related_Object__c = objtype;
            newRuleAction.Field_Name__c =  fieldType;
            edit=false;
            try{
                Database.upsert(newRuleAction);
                newRuleAction = new RuleAction__c(rule__c=newRuleAction.rule__c,type__c='Update Field',enabled__c=true);
                objType = ruleObjType;
                return(new PageReference('/apex/ManageRuleActions'));
                
            }
            catch(Exception e){
                return null;
            }
        
    }
}