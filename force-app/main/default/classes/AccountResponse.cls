public class AccountResponse {
    @AuraEnabled
    public List<Account> records = new List<Account>();
    @AuraEnabled
    public Integer totalRecords = 0;
}