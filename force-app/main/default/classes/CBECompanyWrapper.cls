@SuppressWarnings('PMD.FieldNamingConventions')
public class CBECompanyWrapper {

    public class ErrorResponse {
        public List<CBEError> errors = new List<CBEError>();
    }

    public class CBEError {
        public String message;
    }

    public class Response {
        public List<Company> data = new List<Company>();
    }

    public class SingleResponse {
        public Company data;
    }

    public class Company {
        public String cbe_number;
        public String cbe_number_formatted;
        public String denomination;
        public String abbreviation;
        public String commercial_name;
        public String branch_name;
        public String denomination_with_legal_form;

        public Address address;
        public List<EstablishmentResource> establishments;

        public String juridical_form;
        public String juridical_form_code;
        public String juridical_form_short;

        public String status;

        public String juridical_situation;
        public String juridical_situation_code;

        public String type;
        public String pretty_type;
        public String start_date;

        public ContactInfos contact_infos;

        public List<NaceActivity> nace_activities;
    }

    public class NaceActivity {
        public String code;
        public String description;
        public String classification;
        public String nace_version;
    }

    public class Address {
        public String street;
        public String street_number;
        public String box;
        public String post_code;
        public String city;
        public String country_code;
        public String full_address;
    }

    public class EstablishmentResource {
        public String cbe_number;
        public String establishment_number;

        public String street;
        public String post_code;
        public String city;
        public String house_number;
        public String box;
        public String country_code;
        public String full_address;
        public String type_of_address;
    }

    public class ContactInfos {
        public String email;
        public String phone;
        public String web;
    }
}