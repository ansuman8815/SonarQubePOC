@RestResource (urlMapping='/MyAccountSvc/*')
global with sharing class MyRestResource {

@HttpDelete
    global static void deleteAccount(RestRequest req, Restresponse res){
    String accountId = req.requestURI.subString(req.requestURI.lastIndexOf('/')+1);
    Account acct = [select id, Name from Account where id = :accountId];
    delete acct;
    }

@HttpGet
    global static Account getAccount(RestRequest req, Restresponse res){
    String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
    Account result = [select id, Name, AccountNumber from Account where id = :accountId];
    return result;
    }

@HttpPost
    global static String createAccount(RestRequest req, RestResponse res,String name,String phone,String website){
    Account acct = new Account();
    acct.name = name;
    acct.phone = phone;
    acct.website = website;
    insert acct;
    return acct.id;
    }

}