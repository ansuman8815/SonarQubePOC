/** 
 * This class contains test methods for ManageRulesCriteria class
 */

@isTest

public class ManageRulesCriteriaTest{

    public static testMethod void testConstructor(){
        RuleCriteria__c ruleC = setupData();
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleC);
        Test.startTest();
            ManageRulesCriteria manageRC = new ManageRulesCriteria(stdcon);
        Test.stopTest();
        system.assertNotEquals(manageRC.objType,null);
        
    }
    
    public static testMethod void testConstructorNew(){
        Rule__c rule = new Rule__c(name='Test Rule',object_type__c='Account');
        insert rule; 
        RuleCriteria__c ruleCriteria = new RuleCriteria__c(rule__c=rule.id);
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleCriteria);
        Test.startTest();
            ManageRulesCriteria manageRC = new ManageRulesCriteria(stdcon);
        Test.stopTest();
        system.assertNotEquals(manageRC.objType,null);
        
    }
    
    public static testMethod void testGetFieldNames(){
        RuleCriteria__c ruleC = setupData();
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleC);
        ManageRulesCriteria manageRC = new ManageRulesCriteria(stdcon);
        ApexPages.currentPage().getParameters().put('parentName','Account');
        Test.startTest();
            manageRC.getFieldNames();
        Test.stopTest();
        system.assertEquals(manageRC.fieldOption.size()>0,true);
    }
    
    public static testMethod void testSetFieldAPIName(){
        RuleCriteria__c ruleC = setupData();
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleC);
        ManageRulesCriteria manageRC = new ManageRulesCriteria(stdcon);
        ApexPages.currentPage().getParameters().put('fieldName','Name');
        Test.startTest();
            manageRC.setFieldApiName();
        Test.stopTest();
        system.assertEquals(manageRC.newRuleCriteria.field_API_name__c,'Name');
    }
    
    public static testMethod void testSaveRuleCriteria(){
        RuleCriteria__c ruleC = setupData();
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleC);
        ManageRulesCriteria manageRC = new ManageRulesCriteria(stdcon);
        manageRC.fieldType = 'Name';
        Test.startTest();
        PageReference page = manageRC.saveRuleCriteria();
        Test.stopTest();
        system.assertEquals(page.getURL(),'/'+ruleC.id);
    }
    
    public static testMethod void testSaveAndNewRuleCriteria(){
        RuleCriteria__c ruleC = setupData();
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleC);
        ManageRulesCriteria manageRC = new ManageRulesCriteria(stdcon);
        manageRC.fieldType = 'Name';
        Test.startTest();
        PageReference page = manageRC.saveAndNewRuleCriteria();
        Test.stopTest();
        system.assertEquals(page.getURL(),'/apex/ManageRulesCriteria');
    }
    
    public static testMethod void testSaveRuleCriteriaFailure(){
        RuleCriteria__c ruleC = setupData();
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleC);
        ManageRulesCriteria manageRC = new ManageRulesCriteria(stdcon);
        manageRC.fieldType = null;
        Test.startTest();
        PageReference page = manageRC.saveRuleCriteria();
        Test.stopTest();
        system.assertEquals(page,null);
    }
    
    public static testMethod void testSaveAndNewRuleCriteriaFailure(){
        RuleCriteria__c ruleC = setupData();
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleC);
        ManageRulesCriteria manageRC = new ManageRulesCriteria(stdcon);
        manageRC.fieldType = null;
        Test.startTest();
        PageReference page = manageRC.saveAndNewRuleCriteria();
        Test.stopTest();
        system.assertEquals(page,null);
    }
    public static RuleCriteria__c setupData(){
        Rule__c rule = new Rule__c(name='Test Rule',object_type__c='Account');
        insert rule;
        RuleCriteria__c ruleCriteria = new RuleCriteria__c(rule__c=rule.id,related_object__c='Account',
                                                            field_name__c='Name',field_API_Name__c='Name',Field_Type__c='Text');
        insert ruleCriteria ;
        return ruleCriteria ;
    }
}