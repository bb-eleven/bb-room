import type { ItemView, Location } from '$lib/database.types.short';
import type { Errors, Result } from '$lib/types';
import { inou, inout, iu } from '$lib/utils';
import type { Nullable } from 'vitest';
import type { Database } from '../../database.types';
type ArrayElement<ArrayType extends readonly unknown[]> = ArrayType extends readonly (infer T)[]
	? T
	: never;

type CreateNewTransactionArgs = Database['public']['Functions']['create_new_transaction']['Args'];
export type CreateTransactionDetail = ArrayElement<
	CreateNewTransactionArgs['create_transaction_details']
>;
type IV = Omit<ItemView['Row'], 'id' | 'category_ids' | 'location_codes'>;
export type ItemViewCreateTransactionDetail = IV &
	CreateTransactionDetail & { from_location_codes: Nullable<string>[] };

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
	};
};

// TODO: update CTD from_location_code and to_location_code types to be nullable
const mapToCreateTransactionDetail = (
	itemId?: number,
	quantity?: number,
	fromLocationCode?: string,
	toLocationCode?: string,
): Result<CreateTransactionDetail> => {
	let errors: Errors = [];

	if (inou(itemId)) {
		errors.push({ message: 'Item cannot be empty!' });
	}
	if (inou(quantity)) {
		errors.push({ message: 'Quantity cannot be empty!' });
	}
	if (iu(fromLocationCode)) {
		errors.push({ message: 'From Location cannot be empty!' });
	}
	if (iu(toLocationCode)) {
		errors.push({ message: 'To Location cannot be empty!' });
	}

	if (errors.length > 0) {
		return { errors };
	} else {
		return {
			result: {
				item_id: itemId as number,
				quantity: quantity as number,
				from_location_code: fromLocationCode as string,
				to_location_code: toLocationCode as string,
			},
		};
	}
};
function iut(selected: Nullable<string>, arg1: string) {
	throw new Error('Function not implemented.');
}
