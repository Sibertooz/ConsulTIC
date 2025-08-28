public without sharing class CBECompanyService {
    private CBEApiService apiService;

    public CBECompanyService() {
        apiService = new CBEApiService();
    }

    public List<CBECompanyWrapper.Company> searchCompanies(String name, String postalCode) {
        String nameParam = String.isBlank(name) ? 'ACME' : name;
        String postalCodeParam = String.isBlank(postalCode) ? '1000' : postalCode;

        Map<String, String> params = new Map<String, String>{
            CBEApiConstants.NAME_PARAM => nameParam,
            CBEApiConstants.POSTAL_CODE_PARAM => postalCodeParam
        };

        List<CBECompanyWrapper.Company> result = apiService.searchCompanies(params);
        System.debug('search companies result: ' + result);
        System.debug(JSON.serializePretty(result));

        return result;
    }

    public CBECompanyWrapper.Company getCompanyByBCE(String cbeNumber) {
        String cbeNumberParam = String.isBlank(cbeNumber) ? '0200882050' : cbeNumber;

        CBECompanyWrapper.Company result = apiService.getCompanyByBCE(cbeNumberParam);
        System.debug('get company by BCE result: ' + result);
        System.debug(JSON.serializePretty(result));

        return result;
    }
}