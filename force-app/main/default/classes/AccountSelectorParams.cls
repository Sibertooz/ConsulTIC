public class AccountSelectorParams {
    @AuraEnabled
    public Integer recordLimit { get; set; }
    @AuraEnabled
    public Integer recordOffset { get; set; }
    @AuraEnabled
    public String filterType { get; set; }
    @AuraEnabled
    public String filterIndustry { get; set; }
    @AuraEnabled
    public String searchTerm { get; set; }
}