import { inou, iu, ninou } from '$lib/utils';
import type { Nullable } from 'vitest';
import type { ValidateText, ItemViewCreateTransactionDetail } from './types';

export const validateText = (validateText: ValidateText): ValidateText => {
	validateText.error = inou(validateText.value) || validateText.value === '' ? 'Required' : null;
	return validateText;
};

export const validateTextHasNoError = (validateText: ValidateText) => inou(validateText.error);

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
		'fromLocationCodeQuantity',
		iu,
	);
	validateItemViewCreateTransactionDetailFieldRequired(
		itemViewCreateTransactionDetail,
		'toLocationCodeQuantity',
		iu,
	);
	validateItemViewCreateTransactionDetailFieldRequired(
		itemViewCreateTransactionDetail,
		'quantity',
		inou,
	);
	return itemViewCreateTransactionDetail;
};
