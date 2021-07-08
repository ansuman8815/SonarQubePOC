/** 
 * This class contains test methods for ManageRuleActions class
 */

@isTest

public class ManageRuleActionsTest{

    public static testMethod void testConstructor(){
        RuleAction__c ruleA = setupData();
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleA);
        Test.startTest();
            ManageRuleActions manageRA = new ManageRuleActions(stdcon);
        Test.stopTest();
        system.assertNotEquals(manageRA.objType,null);
        
    }
    
    public static testMethod void testConstructorNew(){
        Rule__c rule = new Rule__c(name='Test Rule',object_type__c='Account');
        insert rule; 
        RuleAction__c ruleAction = new RuleAction__c(rule__c=rule.id);
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleAction);
        Test.startTest();
            ManageRuleActions manageRA = new ManageRuleActions(stdcon);
        Test.stopTest();
        system.assertNotEquals(manageRA.objType,null);
        
    }
    
    public static testMethod void testGetFieldNames(){
        RuleAction__c ruleA = setupData();
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleA);
        ManageRuleActions manageRA = new ManageRuleActions(stdcon);
        ApexPages.currentPage().getParameters().put('parentName','Account');
        Test.startTest();
            manageRA.getFieldNames();
        Test.stopTest();
        system.assertEquals(manageRA.fieldOption.size()>0,true);
    }
    
    
    public static testMethod void testSaveRuleAction(){
        RuleAction__c ruleA = setupData();
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleA);
        ManageRuleActions manageRA = new ManageRuleActions(stdcon);
        manageRA.fieldType = 'Name';
        Test.startTest();
        PageReference page = manageRA.saveRuleAction();
        Test.stopTest();
        system.assertEquals(page.getURL(),'/'+ruleA.id);
    }
    
    public static testMethod void testSaveAndNewRuleAction(){
        RuleAction__c ruleA = setupData();
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleA);
        ManageRuleActions manageRA = new ManageRuleActions(stdcon);
        manageRA.fieldType = 'Name';
        Test.startTest();
        PageReference page = manageRA.saveAndNewRuleAction();
        Test.stopTest();
        system.assertEquals(page.getURL(),'/apex/ManageRuleActions');
    }
    
    /*public static testMethod void testSaveRuleActionFailure(){
        RuleAction__c ruleA = setupData();
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleA);
        ManageRuleActions manageRA = new ManageRuleActions(stdcon);
        manageRA.newRuleAction.rule__c = null;
        Test.startTest();
        PageReference page = manageRA.saveRuleAction();
        Test.stopTest();
        system.assertEquals(page,null);
    }
    
    public static testMethod void testSaveAndNewRuleActionFailure(){
        RuleAction__c ruleA = setupData();
        ApexPages.StandardController stdcon = new ApexPages.StandardController(ruleA);
        ManageRuleActions manageRA = new ManageRuleActions(stdcon);
        manageRA.fieldType = null;
        Test.startTest();
        PageReference page = manageRA.saveAndNewRuleAction();
        Test.stopTest();
        system.assertEquals(page,null);
    }*/
    
    public static RuleAction__c setupData(){
        Rule__c rule = new Rule__c(name='Test Rule',object_type__c='Account');
        insert rule;
        RuleAction__c ruleAction = new RuleAction__c(rule__c=rule.id,related_object__c='Account',
                                                            field_name__c='Name',Type__c='Update Field',Value__c='Test');
        insert ruleAction ;
        return ruleAction ;
    }
}