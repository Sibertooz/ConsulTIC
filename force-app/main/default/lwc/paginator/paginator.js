import { LightningElement, api } from 'lwc';

export default class Paginator extends LightningElement {
    @api pageNumber;
    @api pageSize;
    @api totalItemCount;
    @api buttonSize = "medium";
    _itemsOnPage;

    @api get itemsOnPage() {
        return this._itemsOnPage;
    }

    set itemsOnPage(value) {
        this._itemsOnPage = value;
    }

    get pageCounterInfo() {
        return `Page ${this.currentPageNumber} of ${this.totalPages} • ${this.itemsOnPage} items per page`; 
    }

    handlePrevious() {
        this.dispatchEvent(new CustomEvent("previous"));
    }

    handleNext() {
        this.dispatchEvent(new CustomEvent("next"));
    }

    handleGoToFirst() {
        this.dispatchEvent(new CustomEvent("gotofirst"));
    }

    handleGoToLast() {
        this.dispatchEvent(new CustomEvent("gotolast"));
    }

    get currentPageNumber() {
        return this.totalItemCount === 0 ? 0 : this.pageNumber;
    }

    get isFirstPage() {
        return this.pageNumber <= 1;
    }

    get isLastPage() {
        return !this.totalPages || this.pageNumber === this.totalPages;
    }

    get totalPages() {
        return Math.ceil(this.totalItemCount / this.pageSize);
    }

    handleItemsOnPageChange(event) {
        this._itemsOnPage = event.detail.value;
        this.dispatchEvent(
            new CustomEvent("itemsonpagechanged", {
                detail: {
                    value: this._itemsOnPage
                }
            })
        );
    }
}