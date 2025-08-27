import { LightningElement, wire } from 'lwc';

import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import CreateAccountModal from "c/createAccountModal";

import getAccountsByParams from "@salesforce/apex/AccountsListViewController.getAccountsByParams";
import searchAccountsByName from "@salesforce/apex/AccountsListViewController.searchAccountsByName";

import ACCOUNT from "@salesforce/schema/Account";

import FIELDS from "./fields";
import CONSTANTS from "./constants";
export default class AccountsListView extends LightningElement {
    _accountDefaultRecordTypeId;
    _fields = {};

    typeOptions = [];
    industryOptions = [];
    records = [];
    paginatedRecords = [];

    totalRecords = 0;
    pageSize = 25;
    currentPage = 1;
    isFirstPage = true;
    isLastPage = false;
    previousLocationValue;
    previousFilterValue;

    searchTerm;
    selectedType;
    selectedIndustry;
    showSpinner = true;

    get columns() {
        return [
            { 
                label: this._fields[FIELDS.NAME.fieldApiName]?.label, 
                fieldName: CONSTANTS.RECORD_URL_FIELD, 
                type: 'url',
                typeAttributes: {
                    label: { fieldName: FIELDS.NAME.fieldApiName },
                    target: '_blank'
                }
            },
            { 
                label: this._fields[FIELDS.PHONE.fieldApiName]?.label, 
                fieldName: FIELDS.PHONE.fieldApiName 
            },
            { 
                label: this._fields[FIELDS.TYPE.fieldApiName]?.label, 
                fieldName: FIELDS.TYPE.fieldApiName 
            },
            { 
                label: this._fields[FIELDS.INDUSTRY.fieldApiName]?.label, 
                fieldName: FIELDS.INDUSTRY.fieldApiName 
            }
        ];
    }

    get showNoDataMessage() {
        return this.records?.length === 0;
    }
    
    @wire(getObjectInfo, { objectApiName: ACCOUNT })
    getAccountObjectInfo({ data, error }) {
        if (data) {
            this._accountDefaultRecordTypeId = data.defaultRecordTypeId;
            this._fields = data.fields;
        } else if (error) {
            this._showToastError(error.message);
        }
    }

    @wire(getPicklistValues, { recordTypeId: "$_accountDefaultRecordTypeId", fieldApiName: FIELDS.TYPE })
    getPicklistValuesType({ data, error}) {
        if (data) {
            this.typeOptions = [ CONSTANTS.ALL_OPTION, ...data.values.map(option => ({
                label: option.label,
                value: option.value
            }))];
        } else if (error) {
            this._showToastError(error.message);
        }
    }

    @wire(getPicklistValues, { recordTypeId: "$_accountDefaultRecordTypeId", fieldApiName: FIELDS.INDUSTRY })
    getPicklistValuesIndustry({ data, error}) {
        if (data) {
            this.industryOptions = [ CONSTANTS.ALL_OPTION, ...data.values.map(option => ({
                label: option.label,
                value: option.value
            }))];
        } else if (error) {
            this._showToastError(error.message);
        }
    }

    connectedCallback() {
        this._findAccounts();
    }

    handlePageSizeChange(event) {
        this.pageSize = parseInt(event.detail.value, 10);
        this.currentPage = 1;
        this._findAccounts();
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage -= 1;
            this._findAccounts();
        }
    }

    handleNext() {
        if (this.currentPage * this.pageSize < this.totalRecords) {
            this.currentPage += 1;
            this._findAccounts();
        }
    }

    handleFirst() {
        this.currentPage = 1;
        this._findAccounts();
    }

    handleLast() {
        this.currentPage = Math.ceil(this.totalRecords / this.pageSize);
        this._findAccounts();
    }

    handleGoToPage(event) {
        this.currentPage = event.detail.pageNumber;
        this._findAccounts();
    }

    handleChangeType(event) {
        this.selectedType = event.detail.value === CONSTANTS.ALL_VALUE ? null : event.detail.value;
        this.currentPage = 1;
        this._findAccounts();
    }

    handleChangeIndustry(event) {
        this.selectedIndustry = event.detail.value === CONSTANTS.ALL_VALUE ? null : event.detail.value;
        this.currentPage = 1;
        this._findAccounts();
    }

    handleSearch(event) {
        const searchTerm = event.detail.value;
        const input = this.refs.search;

        let self = this;
        const func = () => {
            self._findAccounts();
        };
        const debounceSearch = debounce(func, 250);

        if (searchTerm.length === 0) {
            this.searchTerm = null;
            input.setCustomValidity("");
            input.reportValidity();

            debounceSearch();
        } else if (searchTerm.length < 3) {
            this.searchTerm = null;
            input.setCustomValidity("Input must be at least 3 characters long.");
        } else {
            input.setCustomValidity("");
            input.reportValidity();
            this.searchTerm = searchTerm;

            debounceSearch();
        }
    }

    async handleNewAccount() {
        const result = await CreateAccountModal.open({
            size: "small",
            label: "Create Account"
        });

        if (result) {
            const event = new ShowToastEvent({
                title: 'Success!',
                message: 'Account created successfully.',
                variant: 'success',
                mode: 'dismissible'
            });

            this.dispatchEvent(event);
            this._findAccounts();
        }
    }

    async _findAccounts() {
        this.showSpinner = true;
        const params = {
            recordLimit: this.pageSize,
            recordOffset: (this.currentPage - 1) * this.pageSize,
            filterType: this.selectedType,
            filterIndustry: this.selectedIndustry,
            searchTerm: this.searchTerm
        };

        try {
            const apexMethod = this.searchTerm ? searchAccountsByName : getAccountsByParams;
            const response = await apexMethod({ params });

            this.records = response.records.map(record => ({ ...record, [CONSTANTS.RECORD_URL_FIELD]: '/' + record[FIELDS.ID.fieldApiName] }));
            this.totalRecords = response.totalRecords;
            
            this.showSpinner = false;
        } catch (error) {
            this._showToastError(error.message);
            this.showSpinner = false;
        }
    }

    _showToastError(errorMessage) {
        const event = new ShowToastEvent({
            title: 'Error!',
            message: errorMessage,
            variant: 'error',
            mode: 'dismissible'
        });

        this.dispatchEvent(event);
    }
}

const debounce = (callback, wait) => {
  let timeoutId = null;
  return (...args) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => {
      callback(...args);
    }, wait);
  };
}