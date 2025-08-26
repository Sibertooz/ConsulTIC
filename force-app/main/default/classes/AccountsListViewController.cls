public with sharing class AccountsListViewController {

    @AuraEnabled
    public static AccountResponse getAccountsByParams(AccountSelectorParams params) {
        return AccountsListViewService.getAccountsByParams(params);
    }

    @AuraEnabled
    public static AccountResponse searchAccountsByName(AccountSelectorParams params) {
        return AccountsListViewService.searchAccountsByName(params);
    }
}