public with sharing class AccountsListViewService {

    public static AccountResponse getAccountsByParams(AccountSelectorParams params) {
        List<Account> records = AccountSelector.getAccountsByParams(params);

        params.recordLimit = null;
        params.recordOffset = null;

        Integer totalRecords = AccountSelector.getAccountsByParamsCount(params);

        AccountResponse response = new AccountResponse();
        response.records = records;
        response.totalRecords = totalRecords;

        return response;
    }

    public static AccountResponse searchAccountsByName(AccountSelectorParams params) {
        List<Account> records = AccountSelector.searchAccountsByName(params);

        params.recordLimit = null;
        params.recordOffset = null;

        Integer totalRecords = AccountSelector.searchAccountsByName(params).size();

        AccountResponse response = new AccountResponse();
        response.records = records;
        response.totalRecords = totalRecords;

        return response;
    }
}