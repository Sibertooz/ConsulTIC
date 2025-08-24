public without sharing class AccountSelector {
    private static final Set<String> DEFAULT_FIELDS = new Set<String>{
        Account.Id.getDescribe().name,
        Account.Name.getDescribe().name,
        Account.Phone.getDescribe().name,
        Account.Type.getDescribe().name,
        Account.Industry.getDescribe().name
    };

    private class AccountSelectorException extends Exception {
    }

    public static List<Account> getAccountsByParams(AccountSelectorParams params) {
        if (params == null) {
            throw new AccountSelectorException(System.Label.ACCOUNT_ERROR_NO_SEARCH_PARAMS);
        }
    }
}