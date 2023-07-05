import type { ItemView } from '$lib/database.types.short';
import { inout, iu } from '$lib/utils';
import type { Nullable } from 'vitest';
import type { ItemViewCreateTransactionDetail } from './types';

export const isValid = (valid: boolean, inputValid: boolean) => valid && inputValid;

export const getLocationCodesInputDisplay = (selected: Nullable<string>) =>
	iu(selected) ? 'Select' : selected === null ? 'Outside' : selected;
export const getLocationCodesOptionDisplay = (option: Nullable<string>) => inout(option, 'Outside');

export const mapToItemViewCreateTransactionDetail = (
	itemView: ItemView['Row'],
): ItemViewCreateTransactionDetail => {
	const { id, category_ids, location_codes, ...itemViewOmitted } = itemView;
	return {
		...itemViewOmitted,
		item_id: inout(id, 0),
		quantity: 0,
		from_location_code: undefined as any,
		to_location_code: undefined as any,
		from_location_codes: [null, ...inout(location_codes, [])],
		errors: {},
	};
};
