import type { ItemView } from '$lib/database.types.short';
import { inout, iu } from '$lib/utils';
import type {
	Author,
	CreateNewTransactionArgs,
	ItemViewCreateTransactionDetail,
	LocationCodeQuantity,
} from './types';
import type { Database } from '$lib/database.types';
import type { SupabaseClient } from '@supabase/supabase-js';

export const formatLocationCodeQuantity = ({ code, quantity }: LocationCodeQuantity): string =>
	`${code} (${quantity})`;

export const getLocationCodesInputDisplay = (selected?: LocationCodeQuantity) => {
	return iu(selected)
		? 'Select'
		: selected.code === null
		? 'Outside'
		: formatLocationCodeQuantity(selected);
};
export const getLocationCodesOptionDisplay = (option?: LocationCodeQuantity) => {
	return iu(option)
		? 'select'
		: option.code === null
		? 'Outside'
		: formatLocationCodeQuantity(option);
};

export const mapToItemViewCreateTransactionDetail = (
	itemView: ItemView['Row'],
	fromLocationCode?: LocationCodeQuantity,
	toLocationCode?: LocationCodeQuantity,
): ItemViewCreateTransactionDetail => {
	let { id, category_ids, location_codes, location_quantities, ...itemViewOmitted } = itemView;

	location_codes ??= [];
	location_quantities ??= [];

	const locationCodeQuantities: LocationCodeQuantity[] = [{ code: null, quantity: null }];
	for (let i = 0; i < location_codes.length; i++) {
		locationCodeQuantities.push({ code: location_codes[i], quantity: location_quantities[i] });
	}

	return {
		...itemViewOmitted,
		item_id: inout(id, 0),
		quantity: 0,
		fromLocationCodeQuantity: fromLocationCode as any,
		toLocationCodeQuantity: toLocationCode as any,
		locationCodeQuantities: locationCodeQuantities,
		errors: {},
	};
};

const mapToCreateNewTransactionArgs = (
	author: Required<Author>,
	itemViewCreateTransactionDetails: ItemViewCreateTransactionDetail[],
): CreateNewTransactionArgs => ({
	_author: author.value,
	create_transaction_details: itemViewCreateTransactionDetails.map(
		({ item_id, quantity, fromLocationCodeQuantity, toLocationCodeQuantity }) => ({
			item_id,
			quantity,
			from_location_code: fromLocationCodeQuantity?.code as any,
			to_location_code: toLocationCodeQuantity?.code as any,
		}),
	),
});

export const createTransaction = async (
	supabase: SupabaseClient<Database>,
	author: Required<Author>,
	itemViewCreateTransactionDetails: ItemViewCreateTransactionDetail[],
) => {
	return await supabase.rpc(
		'create_new_transaction',
		mapToCreateNewTransactionArgs(author, itemViewCreateTransactionDetails),
	);
};
