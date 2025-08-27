import LightningModal from "lightning/modal";

import ACCOUNT from "@salesforce/schema/Account";

import FIELDS from "./fields";

export default class CreateAccountModal extends LightningModal {
    fields = FIELDS;
    objectApiName = ACCOUNT.objectApiName;
    showSpinner = true;

    handleCancelClick() {
        this.close();
    }

    handleSaveClick() {
        this.refs.form.submit();
    }

    handleSuccess() {
        this.close(true);
    }

    handleLoad() {
        this.showSpinner = false;
    }
}