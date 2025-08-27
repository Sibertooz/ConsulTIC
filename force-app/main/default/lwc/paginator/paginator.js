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

    get paginationButtons() {
        return getPagination(this.pageNumber, this.totalPages);
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

    handleButtonPageClick(event) {
        const index = event.currentTarget.dataset.index;
        const button = this.paginationButtons[index];

        this.dispatchEvent(new CustomEvent("gotopage", { detail: { pageNumber: button.pageNumber }}));
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

const getPagination = (currentPageNumber, totalPageNumber, maxButtons = 10) => {
  const total = Math.max(0, Number(totalPageNumber) || 0);
  if (total <= 1) {
    return [{ label: '1', variant: 'brand', index: 0, pageNumber: 1 }];
  }

  const max = Math.max(5, Number(maxButtons) || 10);
  const current = Math.min(Math.max(1, Number(currentPageNumber) || 1), total);

  if (total <= max) {
    return Array.from({ length: total }, (_, i) => ({
      label: String(i + 1),
      variant: (i + 1) === current ? 'brand' : 'neutral',
      index: i,
      pageNumber: i + 1,
    }));
  }

  const needLeftDots = current > 4;
  const needRightDots = current < total - 3;

  const coreSlots = max - 2 - (needLeftDots ? 1 : 0) - (needRightDots ? 1 : 0);
  const half = Math.floor(coreSlots / 2);

  let left = current - half;
  let right = current + (coreSlots - 1 - half);

  if (left < 2) {
    right += 2 - left;
    left = 2;
  }
  if (right > total - 1) {
    left -= right - (total - 1);
    right = total - 1;
  }

  left = Math.max(2, left);
  right = Math.min(total - 1, right);

  const items = [];

  const push = (label, pageNumber, isCurrent = false) => {
    items.push({
      label: String(label),
      variant: isCurrent ? 'brand' : 'neutral',
      index: items.length,
      pageNumber,
    });
  };

  push(1, 1, current === 1);

  if (left > 2) {
    push('...', left - 1, false);
  } else if (left === 2) {
    push(2, 2, current === 2);
  }

  for (let n = Math.max(3, left); n <= Math.min(total - 2, right); n++) {
    push(n, n, n === current);
  }

  if (right === total - 1) {
    push(total - 1, total - 1, current === total - 1);
  } else if (right < total - 1) {
    push('...', right + 1, false);
  }

  push(total, total, current === total);

  return items.map((it, i) => ({ ...it, index: i }));
};