/** 
 * This class contains test methods for ManageRules class
 */

@isTest
public class ManageRulesTest{
    
    public static testmethod void testConstructor(){
        Rule__c rule = new Rule__c(name='Test Rule',object_type__c='Account');
        insert rule;
        ApexPages.standardController stdcon = new ApexPages.StandardController(rule);
        Test.startTest();
            ManageRules manageRules = new ManageRules(stdcon);
        Test.stopTest();
        System.assertEquals(manageRules.objOptions.size()>0,true);    
    }
    
    public static testmethod void testSaveRule(){
        Rule__c rule = new Rule__c(name='Test Rule',object_type__c='Account');
        insert rule;
        ApexPages.standardController stdcon = new ApexPages.StandardController(rule);
        Test.startTest();
            ManageRules manageRules = new ManageRules(stdcon);
            manageRules.newRule.name = 'Test Rule Edited';
            Pagereference page = manageRules.saveRule();
       Test.stopTest();
       system.assertEquals(page.getURL(),'/'+manageRules.newRule.id);   
    }
    
    public static testmethod void testSaveAndNewRule(){
        Rule__c rule = new Rule__c(name='Test Rule',object_type__c='Account');
        insert rule;
        ApexPages.standardController stdcon = new ApexPages.StandardController(rule);
        Test.startTest();
            ManageRules manageRules = new ManageRules(stdcon);
            manageRules.newRule.name = 'Test Rule Edited';
            Pagereference page = manageRules.saveAndNewRule();
       Test.stopTest();
       system.assertEquals(page.getURL(),'/apex/manageRules');   
    }
    
    public static testmethod void testSaveRuleFailure(){
        Rule__c rule = new Rule__c(name='Test Rule',object_type__c='Account');
        insert rule;
        ApexPages.standardController stdcon = new ApexPages.StandardController(rule);
        Test.startTest();
            ManageRules manageRules = new ManageRules(stdcon);
            manageRules.newRule.enabled__c= true;
            Pagereference page = manageRules.saveRule();
       Test.stopTest();
       system.assertEquals(page,null);   
    }
    
    public static testmethod void testSaveAndNewRuleFailure(){
        Rule__c rule = new Rule__c(name='Test Rule',object_type__c='Account');
        insert rule;
        ApexPages.standardController stdcon = new ApexPages.StandardController(rule);
        Test.startTest();
            ManageRules manageRules = new ManageRules(stdcon);
            manageRules.newRule.enabled__c= true;
            Pagereference page = manageRules.saveAndNewRule();
       Test.stopTest();
       system.assertEquals(page,null);   
    }

}