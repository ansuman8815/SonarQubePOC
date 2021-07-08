/** 
 * This class is used to create and edit Rule Criteria
 */
public with sharing class ManageRulesCriteria{

    public RuleCriteria__c newRuleCriteria{get;set;}
    public Rule__c rule ;
    public String objType {get;set;}
    public boolean edit {get;set;}
    /*public String getObjType(){
     system.debug('---in getter---'+this.objType);
     return this.objType;
    }
    public void setObjType(String s){
     this.objType = s;
    }*/
    public String fieldType {get;set;}
    public List<SelectOption> objOptions    {get;set;}
    public List<SelectOption> fieldOption   {get;set;} 
    public string parentName {get;set;}
    public string fieldApiName {get;set;}
    String ruleCriteriaId;
    Map<String, Schema.SObjectField> mapField;
    public String ruleObjType {get;set;}
    
    public ManageRulesCriteria(Apexpages.StandardController stdcon){
        ruleCriteriaId = stdcon.getId();
        newRuleCriteria = (RuleCriteria__c)stdcon.getRecord();
        objOptions = new List<SelectOption>();
        if(ruleCriteriaId!=null){
	          /** 
	          * Edit existing Record
	          */ 
	          edit=true;
	          newRuleCriteria = [select name,field_API_Name__c,Field_Name__c,Field_Relation__c,Field_Type__c,Matching_Type__c,Rule__c,Matching_Value__c,
	                                Maximum_Value__c,Minimum_Value__c,Related_Object__c,RuleObjectType__c
	                                from RuleCriteria__c where id=:ruleCriteriaId];
	                                
	          objType = newRuleCriteria.Related_Object__c;
	          ruleObjType=newRuleCriteria.RuleObjectType__c;
	            
         }
        else{
          /**
          * New Record
          */
	          edit=false;
	          rule = [select object_type__c from Rule__c where id=:newRuleCriteria.rule__c];
	          if(rule!=null){
		            newRuleCriteria.related_object__c = rule.object_type__c;
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
         fieldOption.add(new SelectOption('',''));
         for(String fieldname:mapField.keySet()){
            Schema.SObjectField sfield = mapField.get(fieldname);
            Schema.DescribeFieldResult descResField = sfield.getDescribe();
            String fieldLabel = descResField.getLabel();
            fieldOption.add(new SelectOption(descResField.getName(),fieldLabel));
            
        }
        fieldType= newRuleCriteria.field_name__c;
       
    }
    
    public PageReference setFieldApiName(){
        fieldType = Apexpages.currentPage().getParameters().get('fieldName');
        if(fieldType != '' && fieldType != null){
	        newRuleCriteria.field_API_name__c = fieldType;
	        Schema.sObjectField sobjField = mapField.get(fieldType);
	        newRuleCriteria.field_type__c =  String.valueOf(sobjField.getDescribe().getType());
	     }else{
            newRuleCriteria.field_API_name__c='';
            newRuleCriteria.field_type__c ='';  
        }
        return null;
    }
    
    public PageReference saveRuleCriteria(){
            newRuleCriteria.Related_Object__c = objtype;
            newRuleCriteria.Field_Name__c =  fieldType;
            try{
                Database.upsert(newRuleCriteria);
                return(new PageReference('/'+newRuleCriteria.id));
            }
            catch(Exception e){
                ApexPages.Message msg;
                msg = new ApexPages.Message(ApexPages.severity.Error,e.getDMLMessage(0));
                ApexPages.addMessage(msg);
                return null;
            }   
    }
     
     public PageReference saveAndNewRuleCriteria(){
            newRuleCriteria.Related_Object__c = objtype;
            newRuleCriteria.Field_Name__c =  fieldType;
             edit=false;
            try{
                Database.upsert(newRuleCriteria);
                newRuleCriteria = new RuleCriteria__c(rule__c=newRuleCriteria.rule__c);
                objType = ruleObjType;
                populateFields(objType);
                return(new PageReference('/apex/ManageRulesCriteria'));
                
            }
            catch(Exception e){
                ApexPages.Message msg;
                msg = new ApexPages.Message(ApexPages.severity.Error,e.getDMLMessage(0));
                ApexPages.addMessage(msg);
                return null;
            }
        
        
    }
}