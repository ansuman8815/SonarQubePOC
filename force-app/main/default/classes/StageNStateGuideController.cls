Public class StageNStateGuideController{
    Public List<Portfolio_StagenState_Guide__c> lstSteps {set;get;}{lstSteps= new List<Portfolio_StagenState_Guide__c>();}
    public map<Decimal,Portfolio_StagenState_Guide__c> mapSnSOrderDetail{set;get;}{mapSnSOrderDetail= new map<Decimal,Portfolio_StagenState_Guide__c>();}
    public List<Decimal> lstOrder {set;get;}{lstOrder = new List<Decimal>();}
    public StageNStateGuideController(ApexPages.StandardController controller){
    
        lstSteps = [select order__c, Stage__c,State__c,What_does_this_mean__c, What_s_next__c from Portfolio_StagenState_Guide__c];
        lstSteps.sort();
        
        for(integer i=0;i<lstSteps.size();i++)
        {
            lstOrder.add(i);
        }
        
        Portfolio_StagenState_Guide__c  pssg = new Portfolio_StagenState_Guide__c();
        pssg.Stage__c = 'Stage';
        pssg.State__c = 'State';
        pssg.What_does_this_mean__c = 'What does this mean?';
        pssg.What_s_next__c = 'What is next?';
        
        mapSnSOrderDetail.put(0,pssg);
        for(Portfolio_StagenState_Guide__c temp: lstSteps)
        {
            mapSnSOrderDetail.put(temp.order__c,temp);
        }
    }

}