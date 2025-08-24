public class AccountSelectorParams {
    @AuraEnabled
    public Integer recordLimit;
    @AuraEnabled
    public Integer recordOffset;
    @AuraEnabled
    public String filterType;
    @AuraEnabled
    public String filterIndustry;
    @AuraEnabled
    public String searchValue;
}