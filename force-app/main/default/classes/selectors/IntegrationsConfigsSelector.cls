public inherited sharing class IntegrationsConfigsSelector {
    private static Map<String, Integrations_Configs__mdt> integrationsConfigsMap;

    static {
        if (integrationsConfigsMap == null) {
            integrationsConfigsMap = getAllMap();
        }
    }

    private static Map<String, Integrations_Configs__mdt> getAllMap() {
        Map<String, Integrations_Configs__mdt> result = new Map<String, Integrations_Configs__mdt>();
        for (Integrations_Configs__mdt setting : [
        SELECT
            Id,
            DeveloperName,
            Value__c,
            MasterLabel
        FROM Integrations_Configs__mdt
        WITH SYSTEM_MODE
        ]) {
            result.put(setting.DeveloperName, setting);
        }
        return result;
    }

    static Integrations_Configs__mdt getInstance(String developerName) {
        return integrationsConfigsMap.get(developerName);
    }

    public static Integrations_Configs__mdt getCBEEndpoint() {
        return getInstance(IntegrationsConfigsNames.CBE_ENDPOINT);
    }
}