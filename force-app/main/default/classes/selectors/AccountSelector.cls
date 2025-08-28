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

    public static Integer getAccountsByParamsCount(AccountSelectorParams params) {
        if (params == null) {
            throw new AccountSelectorException(System.Label.ACCOUNT_ERROR_NO_SEARCH_PARAMS);
        }

        String query = 'SELECT COUNT() FROM Account';
        query += buildCondition(params);

        return Database.countQueryWithBinds(query, getBinds(params), AccessLevel.SYSTEM_MODE);
    }

    public static List<Account> getAccountsByParams(AccountSelectorParams params) {
        if (params == null) {
            throw new AccountSelectorException(System.Label.ACCOUNT_ERROR_NO_SEARCH_PARAMS);
        }

        String query = 'SELECT ' + String.join(DEFAULT_FIELDS, ',') + ' FROM Account';
        query += buildCondition(params);

        return Database.queryWithBinds(query, getBinds(params), AccessLevel.SYSTEM_MODE);
    }

    public static List<Account> searchAccountsByName(AccountSelectorParams params) {
        if (params == null || String.isBlank(params.searchTerm)) {
            throw new AccountSelectorException(System.Label.ACCOUNT_ERROR_NO_SEARCH_PARAMS);
        }

        String condition = buildCondition(params);

        String filterType = params.filterType;
        String filterIndustry = params.filterIndustry;

        String query = 'FIND {0} IN NAME FIELDS RETURNING Account(' + String.join(DEFAULT_FIELDS, ', ') + '{1})';

        String searchTerm = '\'' + String.escapeSingleQuotes(params.searchTerm) + '*\'';
        query = String.format(query, new List<String>{ searchTerm, condition });

        List<List<SObject>> searchResults = Search.query(
            query,
            AccessLevel.SYSTEM_MODE
        );

        return (List<Account>) searchResults[0];
    }

    private static Map<String, Object> getBinds(AccountSelectorParams params) {
        Map<String, Object> binds = new Map<String, Object>();

        if (String.isNotBlank(params.filterType)) {
            binds.put('filterType', params.filterType);
        }

        if (String.isNotBlank(params.filterIndustry)) {
            binds.put('filterIndustry', params.filterIndustry);
        }

        return binds;
    }

    private static String buildCondition(AccountSelectorParams params) {
        String condition = '';

        List<String> conditions = new List<String>();
        if (String.isNotBlank(params.filterType)) {
            conditions.add('Type = :filterType');
        }

        if (String.isNotBlank(params.filterIndustry)) {
            conditions.add('Industry = :filterIndustry');
        }

        if (!conditions.isEmpty()) {
            condition += ' WHERE ' + String.join(conditions, ' AND ');
        }

        if (params.recordLimit != null && params.recordOffset != null) {
            condition += ' ORDER BY Name ASC';
        }
        
        if (params.recordLimit != null) {
            condition += ' LIMIT ' + String.valueOf(params.recordLimit);
        }

        if (params.recordOffset != null) {
            condition += ' OFFSET ' + String.valueOf(params.recordOffset);
        }

        return condition;
    }
}