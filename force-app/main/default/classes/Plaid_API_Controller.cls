public with sharing class Plaid_API_Controller {
    public Plaid_API_Controller() {

    }

    @RemoteAction
    public static void getAccessToken(String public_token, String metadata) {
        System.debug('public_token '+public_token);
        Map<String, Object> metadataMap = (Map<String, Object>)JSON.deserializeUntyped(metadata);
        System.debug('****metadataMap '+metadataMap);
        string body =  '{'  + 
                        '"client_id": "5e4210eaba7c950013d67b4f",'  + 
                        '"secret": "ab779271467b08c85e5fe2631be453",'  + 
                        '"public_token": "'+public_token+'"'  + 
                        '}' ; 
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('POST');
        httpRequest.setEndpoint('https://sandbox.plaid.com/item/public_token/exchange');
        httpRequest.setBody(body);
		httpRequest.setHeader('Content-Type','application/json');
        String response = '';
        try {
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);
            if (httpResponse.getStatusCode() == 200) {
                response = JSON.serializePretty(JSON.deserializeUntyped(httpResponse.getBody()));
                System.debug('****response '+response);
                Map<String, Object> mapResponseParams = (Map<String, Object>)JSON.deserializeUntyped(response);
                System.debug('****mapResponseParams '+mapResponseParams);
                getTransactionDetails(mapResponseParams);
            } else {
                System.debug(' httpResponse ' + httpResponse.getBody());
                throw new CalloutException(httpResponse.getBody());
            }
        } catch (System.Exception e) {
            System.debug('ERROR: ' + e);
            throw e;
        }
    }

    public static void getTransactionDetails(Map<String,Object> responseString){
        String body =  '   {  '  + 
                '"client_id": "5e4210eaba7c950013d67b4f",  '  + 
                '"secret": "ab779271467b08c85e5fe2631be453",  '  + 
                '"access_token": "'+responseString.get('access_token')+'",'  + 
                '"start_date": "2019-12-01",  '  + 
                '"end_date": "2019-12-31",  '  + 
                '"options": {  '  + 
                '"count": 250,  '  + 
                '"offset": 0  '  + 
                '}'  + 
                '}' ; 
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('POST');
        httpRequest.setEndpoint('https://sandbox.plaid.com/transactions/get');
        httpRequest.setBody(body);
        httpRequest.setHeader('Content-Type','application/json');
        String response = '';
        try {
            Http http = new Http();
            HttpResponse httpResponse = http.send(httpRequest);
            if (httpResponse.getStatusCode() == 200) {
                response = JSON.serializePretty(JSON.deserializeUntyped(httpResponse.getBody()));
                System.debug('****response '+response);
            } else {
                System.debug(' httpResponse ' + httpResponse.getBody());
                throw new CalloutException(httpResponse.getBody());
            }
        } catch (System.Exception e) {
            System.debug('ERROR: ' + e);
            throw e;
        }
    }
}