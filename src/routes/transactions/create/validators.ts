import { inou, iu, ninou } from '$lib/utils';
import type { Nullable } from 'vitest';
import type { Author, ItemViewCreateTransactionDetail } from './types';

export const validateAuthor = (author: Author): Author => {
	author.error = inou(author.value) || author.value === '' ? 'Required' : null;
	return author;
};

export const authorHasNoError = (author: Author) => inou(author.error);

export const itemViewCreateTransactionDetailHasNoError = (
	itemViewCreateTransactionDetail: ItemViewCreateTransactionDetail,
): boolean => {
	return Object.values(itemViewCreateTransactionDetail.errors).every(inou);
};

const validateItemViewCreateTransactionDetailField = (
	itemViewCreateTransactionDetail: ItemViewCreateTransactionDetail,
	errorKey: keyof ItemViewCreateTransactionDetail['errors'],
	getError: (v: any) => Nullable<string>,
) => {
	itemViewCreateTransactionDetail.errors[errorKey] = getError(
		itemViewCreateTransactionDetail[errorKey],
	);
	return itemViewCreateTransactionDetail;
};

export const validateItemViewCreateTransactionDetailFieldRequired = (
	itemViewCreateTransactionDetail: ItemViewCreateTransactionDetail,
	errorKey: keyof ItemViewCreateTransactionDetail['errors'],
	isEmpty: (v: any) => boolean,
) => {
	return validateItemViewCreateTransactionDetailField(
		itemViewCreateTransactionDetail,
		errorKey,
		(v) => (isEmpty(v) ? 'Required' : null),
	);
};

export const validateItemViewCreateTransactionDetail = (
	itemViewCreateTransactionDetail: ItemViewCreateTransactionDetail,
): ItemViewCreateTransactionDetail => {
	validateItemViewCreateTransactionDetailFieldRequired(
		itemViewCreateTransactionDetail,
		'from_location_code',
		iu,
	);
	validateItemViewCreateTransactionDetailFieldRequired(
		itemViewCreateTransactionDetail,
		'to_location_code',
		iu,
	);
	validateItemViewCreateTransactionDetailFieldRequired(
		itemViewCreateTransactionDetail,
		'quantity',
		inou,
	);
	return itemViewCreateTransactionDetail;
};
