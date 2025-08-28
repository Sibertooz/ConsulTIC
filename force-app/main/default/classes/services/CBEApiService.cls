public without sharing class CBEApiService {
    private String endpoint;

    public class CBEApiServiceException extends Exception {
        public Integer statusCode;

        public CBEApiServiceException(String message, Integer statusCode) {
            this.setMessage(message);
            this.statusCode = statusCode;
        }
    }
    
    public CBEApiService() {
        endpoint = IntegrationsConfigsSelector.getCBEEndpoint()?.Value__c;
    }

    public List<CBECompanyWrapper.Company> searchCompanies(Map<String, String> params) {
        if (String.isBlank(endpoint)) {
            throw new CBEApiServiceException('CBE auth settings not configured');
        }

        if (params == null || params.isEmpty()) {
            throw new CBEApiServiceException('Params must not be empty');
        }

        String url = CBEApiConstants.COMPANY_SEARCH_URL;
        url = generateUrlWithParams(url, params);

        HttpResponse response = sendRequest(url, 'GET');
        if (response.getStatusCode() == 200) {
            CBECompanyWrapper.Response apiResponse = (CBECompanyWrapper.Response) JSON.deserialize(
                response.getBody(),
                CBECompanyWrapper.Response.class
            );

            return apiResponse.data;
        }

        throw getException(response);
    }

    public CBECompanyWrapper.Company getCompanyByBCE(String cbeNumber) {
        if (String.isBlank(endpoint)) {
            throw new CBEApiServiceException('CBE auth settings not configured');
        }

        if (String.isBlank(cbeNumber)) {
            throw new CBEApiServiceException('BCE number must not be empty');
        }

        String url = CBEApiConstants.COMPANY_CBE_URL + cbeNumber;

        HttpResponse response = sendRequest(url, 'GET');
        if (response.getStatusCode() == 200) {
            CBECompanyWrapper.SingleResponse apiResponse = (CBECompanyWrapper.SingleResponse) JSON.deserialize(
                response.getBody(),
                CBECompanyWrapper.SingleResponse.class
            );

            return apiResponse.data;
        }

        throw getException(response);
    }

    @SuppressWarnings('PMD.ApexSuggestUsingNamedCred')
    public HttpResponse sendRequest(String url, String method) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint + url);
        request.setTimeout(120 * 1000);
        request.setMethod(method);

        return new Http().send(request);
    }

    private String generateUrlWithParams(String baseUrl, Map<String, String> paramsMap) {
        if (paramsMap == null || paramsMap.isEmpty()) {
            return baseUrl;
        }

        String url = baseUrl + '?';
        for (String key : paramsMap.keySet()) {
            url += key + paramsMap.get(key) + '&';
        }

        url = url.substring(0, url.length() - 1);
        return url;
    }

    private CBEApiServiceException getException(HttpResponse httpResponse) {
        try {
            CBECompanyWrapper.ErrorResponse error = (CBECompanyWrapper.ErrorResponse) JSON.deserialize(
                httpResponse.getBody(),
                CBECompanyWrapper.ErrorResponse.class
            );
            return new CBEApiServiceException(
                error.errors[0].message,
                httpResponse.getStatusCode()
            );
        } catch (Exception ex) {
            return new CBEApiServiceException(
                httpResponse.getBody(),
                httpResponse.getStatusCode()
            );
        }
    }
}